/************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Application
 * @description This is for Application Trigger Handler
 ****************************************************************************************/
public with sharing class FNS_ApplicationTriggerHandler extends fflib_SObjectDomain {
    
    public static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    public FNS_ApplicationTriggerHandler(List<FNS_ConfigurationType__c> sObjectList) {
        super(sObjectList);
    }
    
    /***********************************************************************************
     * @description Constructor
     * @Params      List<SObject>
     * @Returns    fflib_SObjectDomain
     ***********************************************************************************/
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new FNS_ApplicationTriggerHandler(sObjectList);
        }
    }
    /***********************************************************************************
     * @description method to run on Validate
     * @Params      null
     * @Returns    null
     ***********************************************************************************/ 
    public override void onValidate(){
       
        User jrmUser = new FNS_UserSelector().selectById(UserInfo.getUserId());
        String oppReadOnlyRecordType = FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE ;
        String oppEditableRecordType = FNS_Constants.OPPORTUNITY_EDITABLERECORDTYPE ;

        ID oppReadOnlyID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppReadOnlyRecordType).RecordTypeId ;
        ID oppEditableID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppEditableRecordType).RecordTypeId ;
        Set<ID> fnsOppIDSet = new Set<ID>();
        fnsOppIDSet.add(oppReadOnlyID);
        fnsOppIDSet.add(oppEditableID);

        if (!jrmUser.FNS_IsOfficer__c) {
            for(Opportunity record : (List<Opportunity>) records){
                if(fnsOppIDSet.contains(record.RecordTypeId)){
                    record.addError(Label.FNS_JRM_OPPORTUNITY_ACCESS_ERROR);
                }
            }

        }
        
    }
    
    /***********************************************************************************
     * @description method to run on Before Insert
     * @Params      null
     * @Returns    null
     ***********************************************************************************/
    public override void onBeforeInsert() {
    }
    /***********************************************************************************
     * @description method to run on Before Update 
     * @Params      Map
     * @Returns    null
     ***********************************************************************************/
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        
        Map<ID,Opportunity> oldOppMap = (Map<ID,Opportunity>) existingRecords;
        String oppReadOnlyRecordType = FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE ;      
        ID oppReadOnlyID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppReadOnlyRecordType).RecordTypeId ;
        
        for(Opportunity  opp : (List<Opportunity>) Trigger.new)
        {
            //To identify if updates are done from UI or from API
            if(opp.FNS_BypassValidation__c == oldOppMap.get(opp.ID).FNS_BypassValidation__c)
            {
                if(opp.RecordTypeID == oppReadOnlyID)
                {
                    opp.addError(Label.FNS_APPLICATION_READ_ONLY);
                }

            }

        }
        new FNS_ApplicationTriggerHandler.FNS_AdminContext().updateRecordType(existingRecords, Trigger.New);
        
    }
    
    /***********************************************************************************
     * @description method to run on After Insert 
     * @Params      null
     * @Returns    null
     ***********************************************************************************/
    public override void onAfterInsert(){
    	List<FNS_ApplicationWithQueueActivity__c> applicationQueueList = new List<FNS_ApplicationWithQueueActivity__c>();
        Set<Id> oppRecordTypeIdSet = new Set<Id>();
        List<Opportunity> oppToInsertAppActivity = new List<Opportunity>();
        ID oppReadOnlyID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE).RecordTypeId ;
        ID oppEditableID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(FNS_Constants.OPPORTUNITY_EDITABLERECORDTYPE).RecordTypeId ;
        oppRecordTypeIdSet.add(oppReadOnlyID);
        oppRecordTypeIdSet.add(oppEditableID);
        for(Opportunity appObj :(List<Opportunity>) Trigger.New){
           //Community - To create new ApplicationWithQueueActivity records when new opportunity record created.
           if(oppRecordTypeIdSet.contains(appObj.RecordTypeID) && appObj.FNS_Contact__c !=  null){
               oppToInsertAppActivity.add(appObj);
            }
        }
    
        List<FNS_ApplicationWithQueueActivity__c> appQueueActivityInsertList = insertOppQueueActivity(oppToInsertAppActivity);

        if(appQueueActivityInsertList != null && !appQueueActivityInsertList.isEmpty()){
           new FNS_ApplicationWithQueueActivityService().insertRecords(appQueueActivityInsertList);
        }
    }
    
    /***********************************************************************************
     * @description method to run on After Update
     * @Params      Map 
     * @Returns    null
     ***********************************************************************************/
    public override void onAfterUpdate(Map<Id,SObject> existingRecords) { 
        String oppReadOnlyRecordType = FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE ;
        String oppEditableRecordType = FNS_Constants.OPPORTUNITY_EDITABLERECORDTYPE ;
        Map<ID, Opportunity> oppOldMap = (Map<ID, Opportunity>)Trigger.oldMap;
        Map<ID, Opportunity> oppNewMap = (Map<ID, Opportunity>)Trigger.newMap;
        Set<ID> oppIdSetForChangedContacts = new Set<ID>();
        Set<ID> oppIdSetForChangedDesc= new Set<ID>();
        List<Opportunity> applicationRecord = new List<Opportunity>();
        
        ID oppReadOnlyID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppReadOnlyRecordType).RecordTypeId ;
        ID oppEditableID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppEditableRecordType).RecordTypeId ;
        
        if(Trigger.isUpdate){
            for(Opportunity oldApplication: (List<Opportunity>)Trigger.Old){
                Opportunity newApplication = (Opportunity)Trigger.newMap.get(oldApplication.Id); 
                if(String.isBlank(oldApplication.FNS_ApplicationExtId__c)){
                    if(!String.isBlank(newApplication.FNS_ApplicationExtId__c)){
                        if(oldApplication.RecordTypeId == oppReadOnlyID || oldApplication.RecordTypeId == oppEditableID){
                           //FNS_ApplicationDomain.pullApplicationDataFromFFDC(newApplication.Id); 
                        }
                    }
                }

                //Community - syncying records of Application with  with 
                if(oldApplication.FNS_Contact__c != newApplication.FNS_Contact__c){
                    if(oldApplication.FNS_Contact__c == null){
                       applicationRecord.add(newApplication);
                    } else {
                        oppIdSetForChangedContacts.add(oldApplication.id);
                    }
                }
                
                if(oldApplication.Description != newApplication.Description){
                    oppIdSetForChangedDesc.add(oldApplication.id);
                }
            }

            List<FNS_ApplicationWithQueueActivity__c> appQueueActivityInsertList = insertOppQueueActivity(applicationRecord);
            if(appQueueActivityInsertList != null){
                new FNS_ApplicationWithQueueActivityService().insertRecords(appQueueActivityInsertList);
            } 
            
            List<FNS_ApplicationWithQueueActivity__c> syncQueueActivityWithApplicationList = syncQueueActivityWithApplication(oppIdSetForChangedDesc,oppIdSetForChangedContacts,oppOldMap,oppNewMap);
           
            if(syncQueueActivityWithApplicationList != null){
               new FNS_ApplicationWithQueueActivityService().updateRecord(syncQueueActivityWithApplicationList);
            }
        }
    }
/************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Application
 * @description This class is written so that RecordTypeID can be chnaged to ReadOnly value.
                The code is supposed to be run in the context of Admin as Logged in user
                will not have access to this recordType. RecordType switch is performed to 
                change Layout to read only mode.
 ****************************************************************************************/

   
    public without sharing class FNS_AdminContext
    {
        public void updateRecordType(Map<Id,SObject> existingRecords, List<sObject> Records)
        {
            try
            {
                System.debug('>>>>>Access>>>' + Schema.sObjectType.Opportunity.fields.RecordTypeId.isUpdateable());
                if(Trigger.isUpdate && Schema.sObjectType.Opportunity.fields.RecordTypeId.isUpdateable())
                {            
                    String oppReadOnlyRecordType = FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE ;
                    String oppEditableRecordType = FNS_Constants.OPPORTUNITY_EDITABLERECORDTYPE ;
                    
                    Set<ID> oppIDReadOnlySet = new Set<ID>();
                    Set<ID> oppIDEditableSet = new Set<ID>();
                    Set<ID> fnsOppIDSet = new Set<ID>();
                    
                    Set<String> readOnlyStages = new Set<String>(); //{'Submitted to Underwriting', 'Decisioned','Doc Preparation', 'Booking','Booked', 'Complete','Canceled'};
                    Set<String> ediatableStages = new Set<String>(); //{'Proposal', 'Initial Input'};
                    String systemCode;
                    List<FNS_ConfigurationType__c> configList = new FNS_ConfigurationTypeSelector().getConfigTypeRecordsByType(FNS_Constants.DISPOSITIONCONFIG);        
                    FNS_AdminConfiguration__c adminConfig = FNS_AdminConfiguration__c.getOrgDefaults();
                    if(adminConfig != null)
                    {
                        systemCode = adminConfig.FNS_EditableDispositionValue__c;           
                    }
                     System.debug('>>>>>systemCode >>>' + systemCode );
                    for(FNS_ConfigurationType__c config :  configList )
                    {
                        System.debug('>>>>config.FNS_SystemId__c >>>' + config.FNS_SystemId__c);
                        if(config.FNS_SystemId__c  == systemCode)
                        {
                            ediatableStages.add(config.FNS_Description__c);
                        
                        }
                         else
                        {
                            readOnlyStages.add(config.FNS_Description__c);
                        
                        }
                    
                    }
                
                    ID oppReadOnlyID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppReadOnlyRecordType).RecordTypeId ;
                    ID oppEditableID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppEditableRecordType).RecordTypeId ;
                
                    fnsOppIDSet.add(oppReadOnlyID);
                    fnsOppIDSet.add(oppEditableID);
                    System.debug('>>>>>readOnlyStages>>>' + readOnlyStages);
                    
                     System.debug('>>>>>ediatableStages>>>' + ediatableStages);
                    for(Opportunity opp : (List<Opportunity>) Records)
                    {
                        if (fnsOppIDSet.contains(opp.RecordTypeId)) 
                        {
                            Opportunity existingOpp = (Opportunity)existingRecords.get(opp.Id);
                        
                            if(opp.StageName != existingOpp.StageName) //
                            {
                                if(readOnlyStages.contains(opp.StageName))
                                   {
                                        System.debug('>>>>>opp.StageName>>>' + opp.StageName);
                                        oppIDReadOnlySet.add(opp.ID);
                                        opp.RecordTypeId  = oppReadOnlyID ;
                                        /*
                                        if(existingOpp.RecordTypeId != opp.RecordTypeId && opp.FNS_BypassValidation__c)
                                        {
                                           opp.FNS_BypassValidation__c  = false;
                                        }
                                        else if(existingOpp.RecordTypeId != opp.RecordTypeId && !opp.FNS_BypassValidation__c)
                                        {
                                           opp.FNS_BypassValidation__c  = true;
                                        
                                        }
                                        */
                                   }
                                else if (ediatableStages.contains(opp.StageName))
                                   {
                                        
                                         oppIDEditableSet.add(opp.ID);
                                         opp.RecordTypeId  = oppEditableID ;                                                                                
                                                                       
                                   }
                            }

                        }
                    
                     }
                     if(!oppIDReadOnlySet.isEmpty())
                      {
                            FNS_FinancialProductDomain.updateRecordTypeForProductandChildRec(oppIDReadOnlySet, true);
                      }
                    if(!oppIDEditableSet.isEmpty())
                    {
                         try
                        {
                             FNS_FinancialProductDomain.updateRecordTypeForProductandChildRec(oppIDEditableSet,false);

                        }
                         catch (DMLException ex)
                        {
                            logger.addLogRecord('FNS_ApplicationTriggerHandler', 'onBeforeUpdate', ex.getMessage() + ex.getStackTraceString()); 
                           // throw new FNS_CustomException(Label.FNS_CustomException);
                        }                
                    }
                }

            }catch(Exception ex)
            {
                System.debug('');
                logger.addLogRecord('FNS_ApplicationTriggerHandler', 'Updating Opportunity record Type', ex.getMessage() + ex.getStackTraceString());
                

            }
            

        }

    }
    
    /**************************************************************************************
    * @description This method sych Application and ApplicationWithActivity records.
    * @param List of Appliction ID
    * @return List of ApplicationWithQueueActivity
    *****************************************************************************************/
    public List<FNS_ApplicationWithQueueActivity__c> insertOppQueueActivity(List<Opportunity> oppList){
        List<FNS_ApplicationWithQueueActivity__c> appQueueActivityInsertList = new List<FNS_ApplicationWithQueueActivity__c>();
        for(Opportunity newApplication :oppList){
            FNS_ApplicationWithQueueActivity__c appQueueActivityObj = new FNS_ApplicationWithQueueActivity__c();
            appQueueActivityObj.FNS_Application__c =newApplication.id;
            appQueueActivityObj.FNS_Contact__c = newApplication.FNS_Contact__c ;
            appQueueActivityObj.FNS_ApplicationExternalId__c = newApplication.FNS_ApplicationExtId__c;
            appQueueActivityObj.FNS_ApplicationDescription__c = newApplication.Description;
            appQueueActivityObj.FNS_ActivityExternalId__c = 'ExtId';
            appQueueActivityObj.FNS_QueueExternalId__c = 'queueId';
            appQueueActivityObj.FNS_IsCommunity__c = true;
            appQueueActivityInsertList.add(appQueueActivityObj);
        
        }
        return appQueueActivityInsertList;
    }
   
    
    /**************************************************************************************
    * @description This method sych Application and ApplicationWithActivity records.
    * @param List of Appliction ID having updated contact
    * @param List of Appliction ID having updated Description
    * @param Map of Old Application record
    * @param Map of New Application record
    * @return List of ApplicationWithQueueActivity
    *****************************************************************************************/
    public  List<FNS_ApplicationWithQueueActivity__c> syncQueueActivityWithApplication(Set<Id> oppIdSetForChangedDesc, Set<ID> oppIdSetForChangedContacts,Map<ID, Opportunity> oppOldMap, Map<ID, Opportunity> oppNewMap){
        Set<Id> oppIdSet = new Set<Id>(oppIdSetForChangedDesc); 
        oppIdSet.addAll(oppIdSetForChangedContacts);
        List<FNS_ApplicationWithQueueActivity__c> appQueueActivityList;
        if(oppIdSet != null && !oppIdSet.isEmpty()){
            appQueueActivityList = new FNS_ApplicationWithQueueActivitySelector().getActivitiesByApplication(oppIdSet);
            for(FNS_ApplicationWithQueueActivity__c appQueueObj: appQueueActivityList){
                if(oppOldMap.get((ID)appQueueObj.FNS_Application__c).FNS_Contact__c == appQueueObj.FNS_Contact__c){
                    appQueueObj.FNS_Contact__c = oppNewMap.get(appQueueObj.FNS_Application__c).FNS_Contact__c;
                }

                if(oppIdSetForChangedDesc.contains(appQueueObj.FNS_Application__c)){
                    appQueueObj.FNS_ApplicationDescription__c = oppNewMap.get(appQueueObj.FNS_Application__c).Description;
                }
            }
        }
        return appQueueActivityList;
    }
    
}