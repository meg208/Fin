/*****************************************************************************************
* @description Config Trigger handler for record operations
* @author keerthi
* @date Apr 22 2019
* @Support Email keerthi@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_ProductTypeTriggerHandler extends fflib_SObjectDomain {
    
    /********************************************************************************************************
    * @description  Interface used by the triggerHandler in constructing instances of TriggerHandler class 
    * @Params       none
    * @Returns      none
    * @author       keerthi@comitydesigns.com
    *********************************************************************************************************/

    public FNS_ProductTypeTriggerHandler(List<FNS_ProductType__c> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new FNS_ProductTypeTriggerHandler(sObjectList);
        }
    }
    
    public override void onBeforeInsert() {
        if(Trigger.isInsert){            
            for(FNS_ProductType__c configInsert : (List<FNS_ProductType__c>)Trigger.New){
                configInsert.FNS_DMLType__c = FNS_Constants.CONFIG_DMLTYPE_INSERT;
            }
        }        
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        if(Trigger.isUpdate){            
            for(FNS_ProductType__c configUpdate : (List<FNS_ProductType__c>)Records){
                FNS_ProductType__c configValue = (FNS_ProductType__c)Trigger.oldMap.get(configUpdate.Id);
                if(!configValue.FNS_Description__c.equalsIgnoreCase(configUpdate.FNS_Description__c)){
                    configUpdate.FNS_DMLType__c = FNS_Constants.CONFIG_DMLTYPE_UPDATE;
                }
            }
        }
    }

    public override void onAfterInsert(){
        List<FNS_ProductType__c> configInsertList = new List<FNS_ProductType__c>();
        if(Trigger.isInsert){  
            for(FNS_ProductType__c configInsert : (List<FNS_ProductType__c>)Trigger.New){
                configInsertList.add(configInsert);
            }
        }
        if(!configInsertList.isEmpty()){
            FNS_ProductTypeDomain.insertInGlobalPicklist(configInsertList);
        }
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) { 
        List<FNS_ProductType__c> configUpdateList = new List<FNS_ProductType__c>();
        if(Trigger.isUpdate){            
            for(FNS_ProductType__c configUpdate : (List<FNS_ProductType__c>)Records){
                configUpdateList.add(configUpdate);
            }
        }
        if(!configUpdateList.isEmpty()){
            FNS_ProductTypeDomain.updateInGlobalPicklist(configUpdateList);
        }
    }

    
}