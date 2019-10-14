/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Fee Type
    * @description Fee Type Trigger Logic 
  */
public with sharing class FNS_FeeTypeTriggerHandler extends fflib_SObjectDomain{
    
	public FNS_FeeTypeTriggerHandler(List<FNS_FeeType__c> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new FNS_FeeTypeTriggerHandler(sObjectList);
        }
    }
    
	/**
	* @description Before Insert logic 
	* @return null
	*/ 
    public override void onBeforeInsert() {
        if(Trigger.isInsert){            
            for(FNS_FeeType__c configInsert : (List<FNS_FeeType__c>)Trigger.New){
                configInsert.FNS_DMLType__c = FNS_Constants.CONFIG_DMLTYPE_INSERT;
            }
        }        
    }
	
	/**
	* @description Before Update logic 
	* @return null
	*/ 
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        if(Trigger.isUpdate){            
            for(FNS_FeeType__c configUpdate : (List<FNS_FeeType__c>)Records){
                FNS_FeeType__c configValue = (FNS_FeeType__c)Trigger.oldMap.get(configUpdate.Id);
                if(!configValue.FNS_Description__c.equalsIgnoreCase(configUpdate.FNS_Description__c)){
                    configUpdate.FNS_DMLType__c = FNS_Constants.CONFIG_DMLTYPE_UPDATE;
                }
            }
        }
    }
	/**
	* @description After Insert logic 
	* @return null
	*/  
    public override void onAfterInsert(){
        List<FNS_FeeType__c> feeTypeInsertList = new List<FNS_FeeType__c>();
        if(Trigger.isInsert){  
            for(FNS_FeeType__c feeTypeInsert : (List<FNS_FeeType__c>)Trigger.New){
                feeTypeInsertList.add(feeTypeInsert);
            }
        }
        if(!feeTypeInsertList.isEmpty()){
           FNS_FeeTypeDomain.insertInGlobalPicklist(feeTypeInsertList);
        }
    }

	/**
	* @description After Update logic 
	* @param Map Fee Type Records
	* @return null
	*/  
    public override void onAfterUpdate(Map<Id,SObject> existingRecords) { 
        List<FNS_FeeType__c> feeTypeUpdateList = new List<FNS_FeeType__c>();
        if(Trigger.isUpdate){            
            for(FNS_FeeType__c feeTypeUpdate : (List<FNS_FeeType__c>)Records){
                feeTypeUpdateList.add(feeTypeUpdate);
            }
        }
        if(!feeTypeUpdateList.isEmpty()){
            FNS_FeeTypeDomain.updateInGlobalPicklist(feeTypeUpdateList);
        }
    }
}