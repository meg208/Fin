/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Component Controller
* @description Helps in submitting application to CME
****************************************************************************/
public with sharing class FNS_SubmitApplicationCompController {
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    /***********************************************************************
    * @description verify the conditions to meet for Application record
    * @param Opportunity record's Salesforce Id
    * @return Instance of FNS_SubmitAppConditionWrapper Wrapper class 
    ************************************************************************/ 
    
    @Auraenabled
    public static FNS_SubmitAppConditionWrapper initiateApplicationAPIs(Id appRecordId){
        List<Opportunity> applicationList;
        string isReadOnly;
        string applicationExternalId;
        FNS_SubmitAppConditionWrapper wrapper = new FNS_SubmitAppConditionWrapper();
        try {
            applicationList = new FNS_ApplicationSelector().getApplicationId(appRecordId);
            if(applicationList !=null){
                applicationExternalId = applicationList[0].FNS_ApplicationExtId__c;
                //Application API call to fetch Application data 
                FNS_ApplicationDomain.getApplicationDataFromFFDC(applicationList[0]);
                //FNS_ApplicationRollup.getSummaryForLoanAndFees(new set<ID>{appRecordId});
                String oppReadOnlyRecordType = FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE ;
                ID oppReadOnlyID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppReadOnlyRecordType).RecordTypeId ;
                wrapper.isReadOnly = (applicationList[0].RecordTypeId == oppReadOnlyID) ? true:false;
            } 
        }
        catch(Exception ex){
            logger.addLogRecord('FNS_ActivityComponentController', 'initiateApplicationAPIs', ex.getMessage() + ex.getStackTraceString());
            wrapper.error= ex.getMessage();
        }
        return wrapper;
    }
    
    @Auraenabled
    public static FNS_SubmitAppConditionWrapper verifyApplicationConditions(String applicationId){
        Id oppId = Id.valueOf(applicationId);
        String productObjName = '';
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        Integer productCount;
        
        FNS_SubmitAppConditionWrapper conditionObject = new FNS_SubmitAppConditionWrapper();
        try{
        if(FNS_Util.isFSCInstalled){
            productObjName = extNamespace +'FinancialAccountApplicationsFSC__r';
        }else {
            productObjName = baseNamespace + 'FinancialAccountApplications__r';
        }
        List<Opportunity> oppToProductList = new FNS_ApplicationSelector().selectApplicationWithProducts(new Set<Id>{oppId});
        if(! oppToProductList.isEmpty()){
            Opportunity oppRecord = oppToProductList[0];
            List<SObject> productList = new List<SObject>();
            productList = oppRecord.getSObjects(productObjName);
            if(productList!= null && ! productList.isEmpty()){
                productCount = productList.size();
            }else {
                productCount = 0;
            }
            Boolean quipStatus = false;
            if(oppRecord.FNS_Quip__c != null && String.isNotBlank(oppRecord.FNS_Quip__c) && oppRecord.FNS_QuipFinalized__c){
                quipStatus = true;
            }
            conditionObject.productCount = productCount;
            conditionObject.quipFinalized = quipStatus;
        }
        }catch (DMLException ex){
            logger.addLogRecord('FNS_SubmitApplicationCompController', 'verifyApplicationConditions', ex.getMessage() + ex.getStackTraceString());
            conditionObject.error=ex.getMessage();
        } catch (Exception ex){
            logger.addLogRecord('FNS_SubmitApplicationCompController', 'verifyApplicationConditions', ex.getMessage() + ex.getStackTraceString());
            conditionObject.error=ex.getMessage();
        }
        return conditionObject;
    }
    
    /***********************************************************************
    * @description Wrapper class used for submit application conditions
    * @param none
    * @return none 
    ************************************************************************/
    public with sharing class FNS_SubmitAppConditionWrapper {
        @AuraEnabled public Integer productCount {get; set;}
        @AuraEnabled public Boolean quipFinalized {get; set;}
        @AuraEnabled public Boolean isReadOnly {get; set;}
        @AuraEnabled public String error{get;set;}
    }
    
    /***********************************************************************
    * @description Pushes application record to CME
    * @param Opportunity record's Salesforce Id
    * @return none
    ************************************************************************/
    @Auraenabled
    public static FNS_SubmitAppConditionWrapper submitApplication(String applicationId){
        FNS_SubmitAppConditionWrapper wrapper = new FNS_SubmitAppConditionWrapper();
        try{
        FNS_ApplicationDomain.pushApplicationToFFDC(applicationId);
         }catch (DMLException ex){
            logger.addLogRecord('FNS_SubmitApplicationCompController', 'submitApplication', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        } catch (Exception ex){
            logger.addLogRecord('FNS_SubmitApplicationCompController', 'submitApplication', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        }
        return wrapper;
    }

}