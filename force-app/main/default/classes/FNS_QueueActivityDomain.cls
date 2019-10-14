/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Domain Class
* @description This class acts as domain class for Home Page API call 
****************************************************************************/
public with sharing class FNS_QueueActivityDomain {
    /***********************************************************************
    * @description This method gets active deals summary for logged in user 
    * @param External Id of user
    * @return none 
    ************************************************************************/
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    public static void fetchActiveDealsSummaryForRM(String usrEXtID )
    {
        System.debug('>>>fetchActiveDealsSummaryForRM' + usrEXtID);
        if(String.isNotBlank(usrEXtID))
        {
            HttpResponse jsonResponse = getActiveDealsSummaryForRM(usrEXtID );
            if(jsonResponse.getStatusCode() == 200)
                {
                    if (!String.isEmpty(jsonResponse.getBody()))
                    {
                        // Changes for APi 1.0
                        // List<FNS_ObjectContainer.FNS_ApplicationSummary> applicationSummary = (List<FNS_ObjectContainer.FNS_ApplicationSummary>)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_ApplicationSummary>.class);
                           List<FNS_ObjectContainer.FNS_ApplicationSummary> applicationSummary ;
                           FNS_ObjectContainer listApplicationSummary = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);
                           if(listApplicationSummary != null && listApplicationSummary.applicationSummariesList != null )
                            {
                                applicationSummary =  listApplicationSummary.applicationSummariesList;
                                handleResponse(applicationSummary);
                            }
                    } 
                }
        }

    }
    public static HttpResponse getActiveDealsSummaryForRM(String usrEXtID ){
         HttpResponse jsonResponse ;
       
            if(String.isNotEmpty(usrEXtID)) {
                Map<String, String> headerMap = new Map<String, String>();
                headerMap.put('accept', 'application/json');               
                FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
                param.objectName = FNS_Constants.CLASS_QUEUE_ACTIVITIES;
                param.endPoint = FNS_Constants.URL_APPLICATION;
                param.methodName = FNS_Constants.METHOD_GET;
                param.headerMap = headerMap;
                //changes for API 1.0 URL
                //param.extendedAPIUrl= usrEXtID +FNS_Constants.URL_ACTIVE_DEAL_API_EXTENSION;                
                //param.extendedAPIUrl= 'summary?officerId=' + usrEXtID;
                 param.extendedAPIUrl= FNS_Constants.URL_ACTIVE_DEAL_API_EXTENSION + usrEXtID;
                 FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
                 jsonResponse = router.getPostRequest(param);
                 System.debug('jsonResponse from FNS_QueueActivityDomain -::: '+jsonResponse);
                 
            }

        return jsonResponse ;
     
    }
    
    /***********************************************************************
    * @description This method gets active deals summary for logged in user 
    * @param List of FNS_ObjectContainer.FNS_QueueActivity class
    * @return none 
    ************************************************************************/
    public static void handleResponse(List<FNS_ObjectContainer.FNS_ApplicationSummary> applicationSummary) {
        System.debug('>>>applicationSummary' + applicationSummary);
        Map<String,String> dispositionMap = new Map<String,String>();
        List<FNS_ConfigurationType__c> configTypeList ;        
        Set<String> appIDSet = new Set<String>();
        List<Opportunity> applicationsList = new List<Opportunity>();
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] {Account.SObjectType, Opportunity.SObjectType});
        FNS_UpsertUnitOfWorkHelper upsertApplications = new FNS_UpsertUnitOfWorkHelper();
        uow.registerWork(upsertApplications);

        Set<String> oppExtIDSet = new Set<String>();
        Set<String> bankExtIDSet = new Set<String>();
        Set<String> customerExtIDSet = new Set<String>();

        configTypeList  = new FNS_ConfigurationTypeSelector().getConfigTypeRecordsByType(FNS_Constants.DISPOSITION);
       
        if(configTypeList != null  && !configTypeList.isEmpty())
        {
            for(FNS_ConfigurationType__c config   : configTypeList)
            {
                dispositionMap.put(config.FNS_ConfigurationId__c ,config.FNS_Description__c);
            }
            
        }
        if (applicationSummary != null && !applicationSummary.isEmpty()) 
        {
             for(FNS_ObjectContainer.FNS_ApplicationSummary summary : applicationSummary)
            {
                if(!String.isEmpty(summary.applicationId))
                {
                    oppExtIDSet.add(String.valueof(summary.applicationId));
                }
                if(!String.isEmpty(summary.bankId))
                {
                    bankExtIDSet.add(String.valueof(summary.bankId));
                }
                if(!String.isEmpty(summary.borrowerId))
                {
                    customerExtIDSet.add(String.valueof(summary.borrowerId));
                }
               
            }
        }
        if(!customerExtIDSet.isEmpty())
        {
            FNS_OrganizationDomain.fetchCustomersFromCME(customerExtIDSet);
        }
        
        List<Opportunity> oppList ;
        Map<String,Opportunity> oppMap = new Map<String,Opportunity>();               

        if(!oppExtIDSet.isEmpty())
        {
            oppList = new FNS_ApplicationSelector().selectByExternalId(oppExtIDSet);
        }
        System.debug('oppList >>>' + oppList );
        if (oppList != null && !oppList.isEmpty()) 
        {
            for (Opportunity opp : oppList)
            {
                 oppMap.put(opp.FNS_ApplicationExtId__c,opp);
            }  

        }

        List<FNS_Bank__c>  bankList ;
        Map<String,FNS_Bank__c> bankMap = new Map<String,FNS_Bank__c>(); 
        if(!bankExtIDSet.isEmpty())
        {
            bankList = new FNS_BanksSelector().selectByBankId(bankExtIDSet);
        }
        if(bankList != null && !bankList.isEmpty())
        {
            for(FNS_Bank__c bank :bankList )
            {
                bankMap.put(bank.FNS_BankExternalId__c ,bank);
            }

        }

        List<Account> customerList ;
        Map<String,Account> customerMap = new Map<String,Account>(); 

        if(!customerExtIDSet.isEmpty())
        {
            customerList = new FNS_AccountSelector().selectByExternalId(customerExtIDSet);
        } 
        if (customerList != null && !customerList.isEmpty())
        {
            for(Account customer : customerList)
            {
                customerMap.put(customer.FNS_CustomerExtId__c,customer);
            }

        }
        System.debug('oppMap>>>- '+ oppMap);
        Set<String> oppFilterSet = new Set<String>();        
        if (applicationSummary != null && !applicationSummary.isEmpty())
         {
            for(FNS_ObjectContainer.FNS_ApplicationSummary summary : applicationSummary)
             {
                 if(!String.isEmpty(summary.applicationId))
                 {
                    System.debug('oppFilterSet >>>- '+ oppFilterSet + '>>>>>>>' + summary.applicationId);
                    if(oppFilterSet.contains(summary.applicationId))
                        {
                            continue;
                        }
                    Opportunity application ;
                    
                    if(oppMap.containskey(summary.applicationId))
                    {
                        application = oppMap.get(summary.applicationId);
                        System.debug('ZZZZ --Vish - '+ application);
                        if(summary.applicationAmount != null)
                        {
                            application.amount = summary.applicationAmount.amount; 
                           if (UserInfo.isMultiCurrencyOrganization())
                            {
                                application.put('CurrencyIsoCode',summary.applicationAmount.currencyCode);
                            }
                            
                        }                        
                        if(String.isNotBlank(summary.applicationId))
                        {
                            application.FNS_ApplicationExtId__c = String.valueof( summary.applicationId);
                        }
                        
                        if(dispositionMap.containskey(String.valueof(summary.dispositionId)))
                        {
                            application.StageName = dispositionMap.get(String.valueof(summary.dispositionId));
                        }
                        System.debug('ZZZZ --Vish - '+application.StageName);
                        if (customerMap.containskey(summary.borrowerId))
                        {
                            application.AccountID = customerMap.get(summary.borrowerId).ID; 
                        }
                        if (bankMap.containskey(summary.bankId))
                        {
                            application.FNS_Bank__c = bankMap.get(summary.bankId).ID; 
                        }
                        if (String.isNotBlank(summary.startDate))
                        {
                            application.FNS_StartDateTime__c = Datetime.valueof (FNS_Util.convertStringToDateTime(summary.startDate) );
                        }
                        application.FNS_SLAStatus__c = summary.activitySLA; 
                        if(String.isNotBlank(summary.closingDate))
                        {
                            application.CloseDate =  Date.valueof(FNS_Util.convertStringToDateTime(summary.closingDate));
                        }
                        application.FNS_BypassValidation__c = ! application.FNS_BypassValidation__c ;
                        
                        mappRecordType(application, configTypeList);
                        
                        if(!oppFilterSet.contains(summary.applicationId))
                        {
                            uow.registerdirty(application);
                            oppFilterSet.add(summary.applicationId);
                        }
                        
                    }
                    else
                    {
                        application = new Opportunity();
                        application.Name = FNS_Constants.DEAL_NAME + ' '+   String.valueof(summary.applicationId);
                        application.FNS_ApplicationExtId__c = String.valueof( summary.applicationId);
                        if(summary.applicationAmount != null)
                        {
                            application.amount = summary.applicationAmount.amount;
                            if (UserInfo.isMultiCurrencyOrganization())
                            {
                                 application.put('CurrencyIsoCode',summary.applicationAmount.currencyCode);
                            }
                        }
                        
                        
                        if(dispositionMap.containskey(String.valueof(summary.dispositionId)))
                        {
                            application.StageName = dispositionMap.get(String.valueof(summary.dispositionId));
                        }
                        if (customerMap.containskey(summary.borrowerId))
                        {
                            application.AccountID = customerMap.get(summary.borrowerId).ID; 
                        }
                        if (bankMap.containskey(summary.bankId))
                        {
                            application.FNS_Bank__c = bankMap.get(summary.bankId).ID; 
                        }
                        if(String.isNotBlank(summary.startDate))
                        {
                            application.FNS_StartDateTime__c = Datetime.valueof (FNS_Util.convertStringToDateTime(summary.startDate) );
                        }
                        application.FNS_SLAStatus__c = summary.activitySLA; 
                        mappRecordType(application, configTypeList);
                        if(!String.isEmpty(summary.closingDate))
                        {
                            application.CloseDate =  Date.valueof(FNS_Util.convertStringToDateTime(summary.closingDate));
                        }
                        else
                        {
                            application.CloseDate =  System.today() + 30 ;
                        }
                        if(!String.isEmpty(application.StageName))
                        {
                            
                            if(!oppFilterSet.contains(summary.applicationId) )
                            {
                               
                                uow.registerNew(application);
                                System.debug('>>>>uow' + uow);
                                oppFilterSet.add(summary.applicationId);
                            }
                            
                        }
                        
                        
                    }                   
                   
                   }
                }
            }
            FNS_ObjectAccessContainer.checkOpportunityAccess(FNS_AccessController.DML_OPERATION_UPDATE);
            FNS_ObjectAccessContainer.checkOpportunityAccess(FNS_AccessController.DML_OPERATION_INSERT);
            uow.commitWork();
        }

       
        public static void mappRecordType(Opportunity opp, List<FNS_ConfigurationType__c> configList){
            try{
                System.debug('>>>>>Access>>>' + Schema.sObjectType.Opportunity.fields.RecordTypeId.isUpdateable());
                if(Schema.sObjectType.Opportunity.fields.RecordTypeId.isUpdateable()){            
                    String oppReadOnlyRecordType = FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE ;
                    String oppEditableRecordType = FNS_Constants.OPPORTUNITY_EDITABLERECORDTYPE ;
                    
                    Set<ID> oppIDReadOnlySet = new Set<ID>();
                    Set<ID> oppIDEditableSet = new Set<ID>();
                    Set<ID> fnsOppIDSet = new Set<ID>();
                    
                    Set<String> readOnlyStages = new Set<String>(); 
                    Set<String> ediatableStages = new Set<String>();
                    String systemCode;
                    
                    FNS_AdminConfiguration__c adminConfig = FNS_AdminConfiguration__c.getOrgDefaults();
                    if(adminConfig != null){
                        systemCode = adminConfig.FNS_EditableDispositionValue__c;           
                    }
                    
                    for(FNS_ConfigurationType__c config :  configList ){
                        System.debug('>>>>config.FNS_SystemId__c >>>' + config.FNS_SystemId__c);
                        if(config.FNS_SystemId__c  == systemCode){
                            ediatableStages.add(config.FNS_Description__c);
                        }else{
                            readOnlyStages.add(config.FNS_Description__c);
                        }
                    }
                
                    ID oppReadOnlyID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppReadOnlyRecordType).RecordTypeId ;
                    ID oppEditableID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppEditableRecordType).RecordTypeId ;
                
                    fnsOppIDSet.add(oppReadOnlyID);
                    fnsOppIDSet.add(oppEditableID);
                    System.debug('>>>>>readOnlyStages>>>' + readOnlyStages);
                    
                    System.debug('>>>>>ediatableStages>>>' + ediatableStages);
                    if(readOnlyStages.contains(opp.StageName)){
                        System.debug('>>>>>opp.StageName>>>' + opp.StageName);
                        opp.RecordTypeId  = oppReadOnlyID ;
                    }else if (ediatableStages.contains(opp.StageName)){
                        opp.RecordTypeId  = oppEditableID ;                                                                                
                    }
                    
                }
            }catch(Exception ex){
                System.debug('');
                logger.addLogRecord('FNS_ApplicationTriggerHandler', 'Updating Opportunity record Type', ex.getMessage() + ex.getStackTraceString());
            }
            

        }
     
}