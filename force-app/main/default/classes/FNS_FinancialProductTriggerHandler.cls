/************************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Application
* @description This is for Application Trigger Handler
****************************************************************************************/
public with sharing class FNS_FinancialProductTriggerHandler extends fflib_SObjectDomain {
    public static string baseNamespace = FNS_Util.getBasePackageNamepace();
    
    public static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    public FNS_FinancialProductTriggerHandler(List<SObject> sObjectList) {
        super(sObjectList);
    }
    
    /***********************************************************************************
* @description Constructor
* @Params      List<SObject>
* @Returns    fflib_SObjectDomain
***********************************************************************************/
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new FNS_FinancialProductTriggerHandler(sObjectList);
        }
    }
    
    /***********************************************************************************
    * @description method to run on Before Insert
    * @Params      null
    * @Returns    null
    ***********************************************************************************/
    public override void onBeforeInsert() {
        System.debug('ZZZZ + BEFORE INSERT');
        for(SObject prodObj :(List<SObject>) Trigger.New){
            System.debug('ZZZZ '+prodObj.get(baseNamespace+'FNS_ProductSummary__c'));
            prodObj.put('Name', prodObj.get(baseNamespace+'FNS_ProductSummary__c'));
        }
    }

    /***********************************************************************************
    * @description method to run on Before Update 
    * @Params      Map
    * @Returns    null
    ***********************************************************************************/
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        System.debug('ZZZZ + BEFORE UPDATE');
        for(SObject prodObj :(List<SObject>) Trigger.New){
            System.debug('ZZZZ update '+prodObj.get(baseNamespace+'FNS_ProductSummary__c'));
            prodObj.put('Name', prodObj.get(baseNamespace+'FNS_ProductSummary__c'));
        }
    }
    
    /***********************************************************************************
    * @description method to run on After Insert 
    * @Params      null
    * @Returns    null
    ***********************************************************************************/
    public override void onAfterInsert(){
        String prodRoleObjName = baseNamespace+'FNS_FinancialAccountRole__c';
        String prodObjName = baseNamespace+'FNS_FinancialAccount__c';
        if(FNS_Util.isFSCInstalled){
            prodObjName = 'FinServ__FinancialAccount__c';
            prodRoleObjName = 'FinServ__FinancialAccountRole__c';
        }

        Set<Id> recTypeSet = new Set<Id>();
        Schema.DescribeSObjectResult prodSobjectResult = Schema.getGlobalDescribe().get(prodObjName).getDescribe();
        Schema.DescribeSObjectResult prodRoleSobjectResult = Schema.getGlobalDescribe().get(prodRoleObjName).getDescribe();
   
        Schema.SObjectType prodRoleObjType = Schema.getGlobalDescribe().get(prodRoleObjName);
        ID prodEditableID = prodSobjectResult.getRecordTypeInfosByDeveloperName().get(FNS_Constants.PRODUCT_EDITABLERECORDTYPE).RecordTypeId ;
        ID prodRoleEditableID = prodRoleSobjectResult.getRecordTypeInfosByDeveloperName().get(FNS_Constants.PRODUCT_ROLE_EDITABLERECORDTYPE).RecordTypeId ;
        recTypeSet.add(prodEditableID);
        List<SObject> prodRoleObjList = new List<SObject>();
        for(SObject prodObj :(List<SObject>) Trigger.New){
           //Community - To create new ApplicationWithQueueActivity records when new opportunity record created.
           if(recTypeSet.contains((Id)prodObj.get('RecordTypeID'))){
               SObject prodRoleObj = prodRoleObjType.newSObject(prodRoleEditableID, true);
               prodRoleObj.put(baseNamespace+'FNS_Application__c', prodObj.get(baseNamespace+'FNS_Application__c'));
               if (FNS_Util.isFSCInstalled){                
                   prodRoleObj.put('FinServ__FinancialAccount__c', prodObj.get('Id'));
                   prodRoleObj.put('FinServ__RelatedAccount__c', prodObj.get('FinServ__PrimaryOwner__c'));
                   prodRoleObj.put('FinServ__Role__c', FNS_Constants.PRIMARYOWNER);
                    
               } else {
                   prodRoleObj.put(baseNamespace+'FNS_FinancialAccount__c', prodObj.get('Id'));
                   prodRoleObj.put(baseNamespace+'FNS_RelatedAccount__c', prodObj.get(baseNamespace+'FNS_RelatedAccount__c'));
                   //prodRoleObj.put('????', FNS_Constants.PRIMARYOWNER);
               }
               prodRoleObjList.add(prodRoleObj);
            }
        }
        if (prodRoleObjList!=null && !prodRoleObjList.isEmpty()){
            new FNS_ProductRolesService().upsertRecords(prodRoleObjList);
        }
    }
    
    /***********************************************************************************
    * @description method to run on After Update
    * @Params      Map 
    * @Returns    null
    ***********************************************************************************/
    public override void onAfterUpdate(Map<Id,SObject> existingRecords) { 
    }
    
    public override void onAfterDelete(){
        
    }
    
    
}