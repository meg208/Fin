/**
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Community
* @description Helps in evaluating CRUD Access
*/
public  with sharing class FNS_ApplicationWithOfficerController {
     static FNS_ErrorLog logger = new FNS_ErrorLog();
    /*************************************************************************************
    * @description  Get the Application with officer records based on Opportunity Id.
    * @Params       Opportunity Id
    * @Returns      wrapper
    **************************************************************************************/
    @AuraEnabled
    public static ApplicatinwithOfficerWrapper getApplicationWithOfficer(Id opportunityId){
        ApplicatinwithOfficerWrapper wrapper = new  ApplicatinwithOfficerWrapper();
        try{
            System.debug(loggingLevel.ERROR,'opportunityId>>>>'+opportunityId);
            String namespace= FNS_Util.isFSCInstalled? FNS_Util.getExtensionPackageNamespace():FNS_Util.getBasePackageNamepace();
            List<FNS_ApplicationWithOfficer__c> AppOfficerList = new FNS_ApplicationOfficersSelector().getApplicationOfficersByAppId(new set<Id>{opportunityId});
            List<OfficerWrapper> officerWrapperList = new List<OfficerWrapper>();
            for (FNS_ApplicationWithOfficer__c officer :AppOfficerList){
                FNS_Officer__c officerRecord = (FNS_Officer__c)officer.getSObject('FNS_Officer__r');
                system.debug('officerRecord>>'+officerRecord);
                OfficerWrapper wrap = new OfficerWrapper();
                wrap.officerId = (String)officerRecord.get('Id');
                wrap.Name=(String)officerRecord.get('Name');
                wrap.officerType=(String)officerRecord.get(namespace+'FNS_OfficerType__c');
                //wrap.branch=(String)officerRecord.get(namespace+'FNS_Branch__c');
                officerWrapperList.add(wrap);
            }
            
            wrapper.officerList=officerWrapperList;
        }catch (DMLException ex){
            logger.addLogRecord('FNS_ApplicationWithOfficerController', 'getApplicationWithOfficer', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        } catch (Exception ex){
            logger.addLogRecord('FNS_ApplicationWithOfficerController', 'getApplicationWithOfficer', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        }
        return wrapper;
    }
   
    
    public class ApplicatinwithOfficerWrapper{
        @AuraEnabled public List<OfficerWrapper> officerList{get;set;}
        @AuraEnabled public String error{get;set;}
    }
    
    public class OfficerWrapper{
        @AuraEnabled public String officerId {get; set;}
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public String officerType {get; set;}
        @AuraEnabled public String branch {get; set;}
    }
}