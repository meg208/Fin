/************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Access Handler
 * @description Class is created for Active Deals on Home page component.
 ****************************************************************************************/
public with sharing class FNS_ApplicationService {

    public static FNS_ErrorLog logger = new FNS_ErrorLog();
    public static List<String> oppPickListValues;

    Static{
            Set<String> restrictedDispositionSet  = new FNS_ApplicationSelector().getRestrictedDispositionValues();
            oppPickListValues = FNS_ApplicationSelector.getDispositionValues();
    }

    /***********************************************************************************
     * @description Method to update data from SFDC.
     * @param Application
     *            External ID.
     * @return List of fields that are not accessible
     **************************************************************************************/
    /*@AuraEnabled
    public static void updateDataFromFFDC(String appExtId) {
        FNS_ApplicationDomain.getApplicationDataFromFFDC(appExtId);
    }*/

    /***********************************************************************************
     * @description Method to display pending deals info as JSON.
     * @Params      null
     * @Returns     Wrapper class JSON string as PendingDealsWrapper.
     ***********************************************************************************/ 
    @AuraEnabled
    public static String getPendingDealsWithTask(){
        PendingDealsWrapper pendingDealObj = new PendingDealsWrapper();
        try {
            User loggedInUser = new FNS_UserSelector().selectById(UserInfo.getUserId());
            //FNS_QueueActivityDomain.getActiveDealsSummaryForRM(loggedInUser.FNS_UserExternalId__c);
            //changes to invoke Application summary on page load
            FNS_QueueActivityDomain.fetchActiveDealsSummaryForRM(loggedInUser.FNS_UserExternalId__c);
            pendingDealObj.errorCode = '0';
            pendingDealObj.oppStagePickListValues = oppPickListValues ;
            pendingDealObj.message = FNS_Constants.STR_SUCCESS;
            pendingDealObj.isFilterSave = false;
            Map<String, List<OppWrapper>> oppCategoryMap = activeDealsWithCategory();
            if(oppCategoryMap != null){
            	pendingDealObj.opportunityRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(FNS_Constants.OPPORTUNITY_EDITABLERECORDTYPE).RecordTypeId ;
                pendingDealObj.oppDetails =  (oppCategoryMap.containsKey(FNS_Constants.STR_ACTIVE_DEALS))?oppCategoryMap.get(FNS_Constants.STR_ACTIVE_DEALS) : new List<OppWrapper>() ;
                pendingDealObj.oppList =  (oppCategoryMap.containsKey(FNS_Constants.STR_ACTIVE_DEALS))?oppCategoryMap.get(FNS_Constants.STR_ACTIVE_DEALS ) :new List<OppWrapper>() ;
                pendingDealObj.opportunityDetailsRed = (oppCategoryMap.containsKey(FNS_Constants.NEED_UREGENT_COLOR_CODE))?oppCategoryMap.get(FNS_Constants.NEED_UREGENT_COLOR_CODE) :new List<OppWrapper>();
                pendingDealObj.opportunityDetailsYellow =(oppCategoryMap.containsKey(FNS_Constants.PAST_DUE_COLOR_CODE))? oppCategoryMap.get(FNS_Constants.PAST_DUE_COLOR_CODE ):new List<OppWrapper>() ;
                pendingDealObj.opportunityDetailsGreen = (oppCategoryMap.containsKey(FNS_Constants.PAST_DUE_COLOR_CODE)) ?oppCategoryMap.get(FNS_Constants.ON_SCHEDULE_COLOR_CODE) :new List<OppWrapper>()  ;
                pendingDealObj.opportunityDetailsGrey = (oppCategoryMap.containsKey(FNS_Constants.CLOSING_SOON_COLOR_CODE))?oppCategoryMap.get(FNS_Constants.CLOSING_SOON_COLOR_CODE) : new List<OppWrapper>();
                pendingDealObj.opportunityRed = (pendingDealObj.opportunityDetailsRed != null )?pendingDealObj.opportunityDetailsRed.size(): 0;
                pendingDealObj.opportunityOrange = (pendingDealObj.opportunityDetailsYellow != null) ? (pendingDealObj.opportunityDetailsYellow.size()): 0;
                pendingDealObj.opportunityGreen =(pendingDealObj.opportunityDetailsGreen != null )? (pendingDealObj.opportunityDetailsGreen.size()):0;
                pendingDealObj.opportunityGrey = (pendingDealObj.opportunityDetailsGrey  != null) ? (pendingDealObj.opportunityDetailsGrey.size()) : 0;
                pendingDealObj.totalOppCount =  (pendingDealObj.oppList != null) ? pendingDealObj.oppList.size(): 0;
            }
            pendingDealObj.opportunityDetailsProposal = getProposalRecords();
            pendingDealObj.opportunityProposal = (pendingDealObj.opportunityDetailsProposal != null) ? (pendingDealObj.opportunityDetailsProposal.size()):0;

            pendingDealObj.filterAttList =  setFilterAttribute();
            system.debug( '@@@@ ' + JSON.serialize(pendingDealObj,true));
        }catch(DMLException ex){
            logger.addLogRecord('FNS_ApplicationService', 'getPendingDealsWithTask', ex.getMessage() + ex.getStackTraceString());
            pendingDealObj.error=ex.getMessage();
        }catch(Exception ex){
            logger.addLogRecord('FNS_ApplicationService', 'getPendingDealsWithTask', ex.getMessage() + ex.getStackTraceString()); 
			pendingDealObj.error=ex.getMessage();        
		}

        return JSON.serialize(pendingDealObj,true);
    }

    /***********************************************************************************
     * @description Method is used to restore the default filter.
     * @Params JSON for filter value.
     * @Returns Wrapper class JSON string,
     **************************************************************************************/
    @AuraEnabled
    public static String restoreDefaults(String inputFilter) {
        String activeDealJSONStr = getPendingDealsWithTask();
        return activeDealJSONStr;
    }

    /***********************************************************************************
     * @description Method to display pending deals info with the related task.
     * @Params null
     * @Returns Map based on color key(SLA Status) with the list of opportunity.
     **************************************************************************************/
    public static Map<String, List<OppWrapper>> activeDealsWithCategory() {
        List<Opportunity> oppList = new FNS_ApplicationSelector().selectPendingDealsWithTasks(null, true,
                userinfo.getUserId(), false);
        List<Opportunity> oppAllList = new List<Opportunity>();
        List<Opportunity> oppAttentionList = new List<Opportunity>();
        List<Opportunity> oppNeedsCautionList = new List<Opportunity>();
        List<Opportunity> oppOnTrackList = new List<Opportunity>();
        List<Opportunity> oppClosingSoonList = new List<Opportunity>();
        List<Opportunity> oppProposalList = new List<Opportunity>();
        Map<String, List<OppWrapper>> oppWrapperMap = new Map<String, List<OppWrapper>>();
        if (oppList != null & !oppList.isEmpty()) {
            for (Opportunity opp : oppList) {
                if (opp.FNS_SLAStatus__c == FNS_Constants.NEED_UREGENT_COLOR_CODE) {
                    oppAttentionList.add(opp);
                } else if (opp.FNS_SLAStatus__c == FNS_Constants.PAST_DUE_COLOR_CODE) {
                    oppNeedsCautionList.add(opp);
                } else {
                    oppOnTrackList.add(opp);
                }

                Integer noOfDays = System.today().daysBetween(opp.CloseDate);
                Integer numberOfDays;
                FNS_AdminConfiguration__c adminConfig = FNS_AdminConfiguration__c.getOrgDefaults();
                if(adminConfig != null){
                    if(adminConfig.FNS_ClosingSoonNoOfDays__c != null ){
                        numberOfDays =(Integer) adminConfig.FNS_ClosingSoonNoOfDays__c;
                    } else {
                        numberOfDays = 15;
                    }
                }
                if ((noOfDays < numberOfDays) && (noOfDays >= 0)) {
                    oppClosingSoonList.add(opp);
                }
                oppAllList.add(opp);
            }
            oppWrapperMap.put(FNS_Constants.NEED_UREGENT_COLOR_CODE, createOppTaskWrapper(oppAttentionList));
            oppWrapperMap.put(FNS_Constants.PAST_DUE_COLOR_CODE, createOppTaskWrapper(oppNeedsCautionList));
            oppWrapperMap.put(FNS_Constants.ON_SCHEDULE_COLOR_CODE, createOppTaskWrapper(oppOnTrackList));
            oppWrapperMap.put(FNS_Constants.CLOSING_SOON_COLOR_CODE, createOppTaskWrapper(oppClosingSoonList));
            oppWrapperMap.put(FNS_Constants.STR_ACTIVE_DEALS, createOppTaskWrapper(oppAllList));
        }
        return oppWrappermap;
    }

    /***********************************************************************************
     * @description  Method to display pending deals info with the related task.
     * @Params    null
     * @Returns   List of wrapper class of given opportunity.
     **************************************************************************************/ 
    public static List<OppWrapper> createOppTaskWrapper(List<Opportunity> oppList){
        List<OppWrapper> oppWrapperList = new List<OppWrapper>();
        system.debug('@@@@ oppList ' + oppList);
        if(oppList != null){
            try{
                OppWrapper wrapperObj;
                for(Opportunity opp : oppList){
                    wrapperObj = new OppWrapper();
                    wrapperObj.oppId = opp.Id;
                    wrapperObj.oppExtId = opp.FNS_ApplicationExtId__c;
                    wrapperObj.name = opp.name;
                    wrapperObj.stage = opp.StageName;
                    wrapperObj.accountId = opp.AccountId;
                    wrapperObj.borrower = opp.Account.Name;
                    wrapperObj.closeDate = opp.CloseDate;
                    wrapperObj.closingApplication = false;
                    wrapperObj.closingApplication = true;
                    wrapperObj.amount = opp.Amount;
                    wrapperObj.slaStatus = opp.FNS_SLAStatus__c;

                    if(FNS_Util.checkMCEnabled()){
                        wrapperObj.CurrencySymbol = FNS_Util.convertCurrencyNameToSymbol((String) opp.get('CurrencyIsoCode'));
                    }
                    if(opp.FNS_SLAStatus__c == FNS_Constants.NEED_UREGENT_COLOR_CODE){
                        wrapperObj.taskMessage = system.label.FNS_NEEDS_ACTION;
                    } else if(opp.FNS_SLAStatus__c == FNS_Constants.PAST_DUE_COLOR_CODE){
                        wrapperObj.taskMessage = system.label.FNS_PAST_DUE;
                    } else {
                        wrapperObj.taskMessage = system.label.FNS_ON_SCHEDULE;
                    }
                    oppWrapperList.add(wrapperObj);
                }
                system.debug('@@@@ oppWrapperList' +  oppWrapperList);

            }catch(Exception ex){
                logger.addLogRecord('FNS_OpportunityService', 'pendingDealsWithTask', ex.getMessage() + ex.getStackTraceString());
            }
        }
        return oppWrapperList;
    }

    /***********************************************************************************
     * @description Inner wrapper class to store values and labels.
     * @Params null
     * @Returns null
     **************************************************************************************/
    public with sharing class ValuesWrapper {
        @AuraEnabled
        public String strValue
        {get;set;}
        @AuraEnabled
        public String strLabel
        {get;set;}

        public valuesWrapper(String strValue, String strLabel) {
            this.strValue = strValue;
            this.strLabel = strLabel;
        }
    }

    /***********************************************************************************
     * @description Method to get all the stage name from opportunity object
     * @Params null
     * @Returns List of wrapper class with name and value.
     **************************************************************************************/
    @AuraEnabled
    public static List<valuesWrapper> getStageName() {
        List<valuesWrapper> stageNameList = new List<valuesWrapper>();
        List<String> oppPickListValues = FNS_ApplicationSelector.getDispositionValues();
        for (String stageNamePicklistValues : oppPickListValues) {
            stageNameList.add(new valuesWrapper(stageNamePicklistValues, stageNamePicklistValues));
        }
        return stageNameList;
    }

    /***********************************************************************************
     * @description  Method to get all the stage name from opportunity object
     * @Params    null
     * @Returns   List of wrapper class with name and value.
     **************************************************************************************/ 
    @AuraEnabled
    public static List<OppWrapper> getProposalRecords(){
        Boolean isNumberOfLoan = false;
        String queryString = '';
        FNS_ApplicationSelector fnsOpp = new FNS_ApplicationSelector();
        List<Opportunity> oppList = fnsOpp.selectByApplicationtage(FNS_Constants.STR_PROPOSAL_STAGE_VALUE , userinfo.getUserId());
        PendingDealsWrapper pendingDealObj = new PendingDealsWrapper();
        pendingDealObj.errorCode = '0';
        pendingDealObj.message = FNS_Constants.STR_SUCCESS;
        List<OppWrapper> oppProposalList = createOppTaskWrapper(oppList);
        return oppProposalList  ;
    }

    /***********************************************************************************
     * @description  Method to identify the list view on given object.
     * @Params       null
     * @Returns      List<ListView> on a given object.
     **************************************************************************************/ 
    @AuraEnabled
    public static List<ListView> getListViews() {
        List<ListView> listviews; 
        try {
            listviews = new FNS_ListViewsSelector().selectByName('Opportunity', new Set<String>{'FNS_ActiveDeals'});
        }catch(Exception ex){
            logger.addLogRecord('FNS_OpportunityService', 'getListViews', ex.getMessage() + ex.getStackTraceString());
        }
        return listviews;
    }

    /***********************************************************************************
     * @description  Method to get all opportunities as per the filter value.
     * @Params       null
     * @Returns      JSON string 
     **************************************************************************************/ 
    @AuraEnabled
    public static string getFilterRecords(String inputFilter){
        system.debug('@@@@ inputFilter :: ' + inputFilter);
        Boolean isNumberOfLoan = false;
        PendingDealsWrapper pendingDealObj = new PendingDealsWrapper();
        try{
            PendingDealsWrapper inputJsonWrapper = (PendingDealsWrapper)JSON.deserialize(inputFilter, PendingDealsWrapper.class);        
            String queryString = '';
            FNS_ApplicationSelector fnsOpp = new FNS_ApplicationSelector();
            List<Opportunity> oppList;
            if(inputJsonWrapper.savedUserFilter.fieldApi == FNS_Constants.NUMBER_OF_LOAN ){
                isNumberOfLoan = true;
                oppList = numberOfLoanFilter(Integer.valueof(inputJsonWrapper.savedUserFilter.value.trim()), inputJsonWrapper.savedUserFilter.operator);
            } else {
                List<FNS_InputWrapper.FilterParam> filterList = new List<FNS_InputWrapper.FilterParam>();
                filterList.add(inputJsonWrapper.savedUserFilter);
                List<String> filterCondition = getFilterCondition(filterList);
                oppList = fnsOpp.pendingDealsWithTasksByFilter(String.join(filterCondition, ' AND '),true, userinfo.getUserId());
            }
            pendingDealObj.errorCode = '0';
            pendingDealObj.message = FNS_Constants.STR_SUCCESS;
            pendingDealObj.oppList = createOppTaskWrapper(oppList);
            system.debug( '@@@@ response to filter records ' + JSON.serialize(pendingDealObj,true));
        } 
        catch(DMLException ex){
            logger.addLogRecord('FNS_ApplicationService', 'getFilterRecords', ex.getMessage() + ex.getStackTraceString());
            pendingDealObj.error=ex.getMessage();
        }
        catch(Exception ex){
            logger.addLogRecord('FNS_ApplicationService', 'getFilterRecords', ex.getMessage() + ex.getStackTraceString());
            pendingDealObj.error=ex.getMessage();
        }
        
        return JSON.serialize(pendingDealObj,true);
    }

    /***********************************************************************************
     * @description  Method to create filter condition for selected filter value.
     * @Params       null
     * @Returns      List of string for filter condition.
     **************************************************************************************/ 
    public static List<String> getFilterCondition(List<FNS_InputWrapper.FilterParam> filterList){
        system.debug('@@ getFilterCondition :: ' + filterList);
        List<String> filterCondition = new List<String>();
        Set<String> numericFieldSet = new Set<String>();
        numericFieldSet.add(FNS_Constants.DATA_TYPE_CURRENCY );
        numericFieldSet.add(FNS_Constants.DATA_TYPE_PERCENT );
        numericFieldSet.add(FNS_Constants.DATA_TYPE_NUMBER);
        for(FNS_InputWrapper.FilterParam filterObj : filterList){
            if(numericFieldSet.contains(filterObj.fieldType)){
                    filterCondition.add(filterObj.fieldApi + ' ' +filterObj.operator +' '+ filterObj.value );
            } else {
                filterCondition.add(filterObj.fieldApi + ' ' +filterObj.operator +' \''+ filterObj.value + '\'' );
            }
        }
        system.debug('@@ filterCondition :: ' + filterCondition);
        return filterCondition;
    }

    /***********************************************************************************
     * @description  Method to set the filter option shown in filter options
     * @Params       null
     * @Returns      List of filter parameter.
     **************************************************************************************/ 
    public static List<FNS_InputWrapper.FilterParam> setFilterAttribute(){
        List<FNS_InputWrapper.FilterParam> filterAttList = new List<FNS_InputWrapper.FilterParam>();
        //To add number of Loan filter attribute 
        FNS_InputWrapper.FilterParam customerNameFilter = new FNS_InputWrapper.FilterParam();
        customerNameFilter.fieldApi = FNS_Constants.ACCOUNT_NAME;
        customerNameFilter.fieldType = FNS_Constants.DATA_TYPE_STRING ;
        customerNameFilter.fieldName = system.label.FNS_STR_CUSTOMER;
        filterAttList.add(customerNameFilter);

        //To add number of Loan filter attribute 
        FNS_InputWrapper.FilterParam dispositionFilter = new FNS_InputWrapper.FilterParam();
        dispositionFilter.fieldApi = FNS_Constants.STAGE_NAME ;
        dispositionFilter.fieldType =  FNS_Constants.DATA_TYPE_STRING ;
        dispositionFilter.fieldName =  system.label.FNS_DISPOSITION;
        filterAttList.add(dispositionFilter);

        //To add number of Loan filter attribute 
        FNS_InputWrapper.FilterParam numberOfLoan = new FNS_InputWrapper.FilterParam();
        numberOfLoan.fieldApi = FNS_Constants.NUMBER_OF_LOAN;
        numberOfLoan.fieldType = FNS_Constants.DATA_TYPE_NUMBER;
        numberOfLoan.fieldName =  system.label.FNS_NO_OF_LOANS;
        filterAttList.add(numberOfLoan);

        return filterAttList;
    }

    /***********************************************************************************
     * @description  Method for No. of Loan as per selected filter option.
     * @Params       null
     * @Returns      List of opportunities.
     **************************************************************************************/ 
    public static List<Opportunity> numberOfLoanFilter(Integer numberOFLoan, String operator){
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        Boolean isFilterValueZero = false;
        List<Opportunity> oppWithLoan;
        List<Opportunity> oppWithoutLoan;
        FNS_ApplicationSelector fnsOpp = new FNS_ApplicationSelector();

        // Create list of Opp with the filter parameter.
        List<sObject> loanList = new FNS_LoansSelector().getLoanDetailsWithFilter(numberOFLoan, operator); 
        Set<ID> oppIdSet; 
        if(loanList != null){
            oppIdSet = new set<ID>();
            for(sObject loanObj : loanList){
                oppIdSet.add((String)loanObj.get(namespace+'FNS_Application__c'));
            }
        }

        if(!oppIdSet.isEmpty()){
            oppWithLoan = fnsOpp.selectPendingDealsWithTasks(oppIdSet,true, userinfo.getUserId(),false);
        }

        // Create list of Opp with no loan.
        List<sObject> loanList1 = new FNS_LoansSelector().getLoanDetailsWithFilter(1,'>='); 
        Set<ID> opptyIdSet;
        if(loanList1 != null){
            opptyIdSet = new set<ID>();
            for(sObject loanObj : loanList1){
                opptyIdSet.add((String)loanObj.get(namespace+'FNS_Application__c'));
            }
        }
        oppWithoutLoan = fnsOpp.selectPendingDealsWithTasks(opptyIdSet,true, userinfo.getUserId(),true);

        if(numberOFLoan != 0 && (operator == '=' ||  operator == '>') ){
            return oppWithLoan;
        } else if (numberOFLoan == 0 && operator == '='){
            return oppWithoutLoan;
        } else if( ((operator == '<' || operator == '<=' ||  operator == '!=' ) && numberOFLoan > 0) || (operator == '>=' && numberOFLoan == 0)){
            List<Opportunity> optyList = new List<Opportunity>(oppWithLoan);
            optyList.addAll(oppWithoutLoan);
            return optyList;
        } else {
            return oppWithLoan;
        }
    }

    /***********************************************************************************
     * @description Wrapper class used in home page component.
     * @Params null
     * @Returns null
     **************************************************************************************/
    public class PendingDealsWrapper {
        String errorCode;
        String message;
        Boolean isFilterSave;
        List<String> oppStagePickListValues;
        List<OppWrapper> oppDetails;
        List<OppWrapper> oppList;
        List<OppWrapper> opportunityDetailsRed;
        List<OppWrapper> opportunityDetailsYellow;
        List<OppWrapper> opportunityDetailsGreen;
        List<OppWrapper> opportunityDetailsGrey;
        List<OppWrapper> opportunityDetailsProposal;
        List<OppWrapper> opportunityDetails;
        Integer opportunityRed;
        Integer opportunityOrange;
        Integer opportunityGreen;
        Integer opportunityGrey;
        Integer opportunityProposal;
        Integer totalOppCount;
        ID opportunityRecordTypeID;
        List<FNS_InputWrapper.FilterParam> filterAttList;
        FNS_InputWrapper.FilterParam savedUserFilter;
        @AuraEnabled public String error{get;set;}
    }

    /***********************************************************************************
     * @description Wrapper class used to display Opportunity and related task
     *              records detail with some additional parametes.
     * @Params null
     * @Returns null
     **************************************************************************************/
    public class OppWrapper {
        String oppId;
        String oppExtId;
        String accountId;
        String name;
        Decimal amount;
        String borrower;
        String stage;
        Date closeDate;
        String slaStatus;
        String taskMessage;
        String currencySymbol;
        Boolean closingApplication;

    }
    // Kavya - to update opportunity record with Stage name 
    public void updateRecord(Opportunity applicationRecord){
        try{
            fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
                new List<Schema.SObjectType>{
                    Opportunity.sObjectType
                        }
            );
            uow.registerDirty(applicationRecord);
            FNS_ObjectAccessContainer.checkOpportunityAccess(FNS_AccessController.DML_OPERATION_UPDATE);
            uow.commitWork();
        }catch(Exception ex){
            logger.addLogRecord('FNS_OpportunityService', 'updateRecord', ex.getMessage() + ex.getStackTraceString());
        }
    }
    
    // Vishal - to update opportunity record with Stage name 
    public void updateRecords(List<Opportunity> applicationRecords){
        try{
            fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
                new List<Schema.SObjectType>{
                    Opportunity.sObjectType
				}
            );
            uow.registerDirty(applicationRecords);
            FNS_ObjectAccessContainer.checkOpportunityAccess(FNS_AccessController.DML_OPERATION_UPDATE);
            uow.commitWork();
        }catch(Exception ex){
            logger.addLogRecord('FNS_OpportunityService', 'updateRecords', ex.getMessage() + ex.getStackTraceString());
        }
    }

}