/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description This class Config Trigger handler for record operations
****************************************************************************************/
public with sharing class FNS_ConfigurationTriggerHandler extends fflib_SObjectDomain {
    
    public static FNS_ErrorLog logger = new FNS_ErrorLog();
    Set<String> picklistSet = new Set<String>{'PURPOSES','COUNTRY','ENTITY_RELATION','ROLE_TYPE','CONFIG_CURRENCY'};
    public FNS_ConfigurationTriggerHandler(List<FNS_ConfigurationType__c> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new FNS_ConfigurationTriggerHandler(sObjectList);
        }
    }
    
    public override void onBeforeInsert() {
        try{ 
            if(Trigger.isInsert){            
                for(FNS_ConfigurationType__c configInsert : (List<FNS_ConfigurationType__c>)Trigger.New){
                    configInsert.FNS_DMLType__c = FNS_Constants.CONFIG_DMLTYPE_INSERT;
                }
            }
        }catch(Exception ex){
                logger.addLogRecord('FNS_ConfigurationTriggerHandler', 'onBeforeInsert', ex.getMessage() + ex.getStackTraceString());
            }   
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
    try{   
            if(Trigger.isUpdate){            
                for(FNS_ConfigurationType__c configUpdate : (List<FNS_ConfigurationType__c>)Records){
                    FNS_ConfigurationType__c configValue = (FNS_ConfigurationType__c)Trigger.oldMap.get(configUpdate.Id);
                    if(!configValue.FNS_Description__c.equalsIgnoreCase(configUpdate.FNS_Description__c)){
                        configUpdate.FNS_DMLType__c = FNS_Constants.CONFIG_DMLTYPE_UPDATE;
                    }
                }
            }
            }catch(Exception ex){
                logger.addLogRecord('FNS_ConfigurationTriggerHandler', 'onBeforeUpdate', ex.getMessage() + ex.getStackTraceString());
            }
    }

    public override void onAfterInsert(){
        List<FNS_ConfigurationType__c> configInsertList = new List<FNS_ConfigurationType__c>();
        try{
            if(Trigger.isInsert){  
                for(FNS_ConfigurationType__c configInsert : (List<FNS_ConfigurationType__c>)Trigger.New){
                    //if(configInsert.FNS_ConfigurationType__c != 'PURPOSES' && configInsert.FNS_ConfigurationType__c != 'COUNTRY')
                    if(!picklistSet.contains(configInsert.FNS_ConfigurationType__c))
                		configInsertList.add(configInsert);
                }
            }
            if(!configInsertList.isEmpty()){
                FNS_ConfigurationDomain.insertInGlobalPicklist(configInsertList);
            }
        }catch(Exception ex){
            logger.addLogRecord('FNS_ConfigurationTriggerHandler', 'onAfterInsert', ex.getMessage() + ex.getStackTraceString());
        }
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) { 
        List<FNS_ConfigurationType__c> configUpdateList = new List<FNS_ConfigurationType__c>();
        try{
            if(Trigger.isUpdate){            
                for(FNS_ConfigurationType__c configUpdate : (List<FNS_ConfigurationType__c>)Records){
					 //if(configUpdate.FNS_ConfigurationType__c != 'PURPOSES' && configUpdate.FNS_ConfigurationType__c != 'COUNTRY')
					  if(!picklistSet.contains(configUpdate.FNS_ConfigurationType__c))
		                configUpdateList.add(configUpdate);
                }
            }
            if(!configUpdateList.isEmpty()){
                FNS_ConfigurationDomain.updateInGlobalPicklist(configUpdateList);
            }
        }catch(Exception ex){
            logger.addLogRecord('FNS_ConfigurationTriggerHandler', 'onAfterUpdate', ex.getMessage() + ex.getStackTraceString());
        }
    }

    
}