/************************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Application
* @description This is for Application Trigger Handler
****************************************************************************************/
public with sharing class FNS_LeadTriggerHandler extends fflib_SObjectDomain {
    
    public static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    public FNS_LeadTriggerHandler(List<FNS_ConfigurationType__c> sObjectList) {
        super(sObjectList);
    }
    
    /***********************************************************************************
* @description Constructor
* @Params      List<SObject>
* @Returns    fflib_SObjectDomain
***********************************************************************************/
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new FNS_LeadTriggerHandler(sObjectList);
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
        
    }
    
    /***********************************************************************************
* @description method to run on After Insert 
* @Params      null
* @Returns    null
***********************************************************************************/
    public override void onAfterInsert(){
        
    }
    
    /***********************************************************************************
* @description method to run on After Update
* @Params      Map 
* @Returns    null
***********************************************************************************/
    public override void onAfterUpdate(Map<Id,SObject> existingRecords) { 
        Set<Id> contactToCreateCommUser = new Set<Id>();
        List<Lead> leadList = trigger.new;
        system.debug('&&& leadList ' + leadList);
        Map<Id,Id> oppToContactMap = new Map<Id,Id>();
        Map<Id,Id> oppToAccountMap = new Map<Id,Id>();
        for (Lead lead:  leadList){
            if(lead.isconverted){
                contactToCreateCommUser.add(lead.ConvertedContactId);
                oppToContactMap.put((Id)lead.ConvertedOpportunityId,(Id)lead.ConvertedContactId);
                oppToAccountMap.put((Id)lead.ConvertedOpportunityId,(Id)lead.ConvertedAccountId);
            }
        }
        if(contactToCreateCommUser != null){
            new FNS_CommunityUtil().createCommunityUserFromContact(contactToCreateCommUser);
        }
        
        System.debug('@@ Oppmap ' + oppToContactMap);
        if(oppToContactMap != null && !oppToContactMap.isEmpty() ){
            populateContactOnApplication(oppToContactMap);
        }
        if(oppToContactMap != null && !oppToAccountMap.isEmpty() ){
	        populateApplicationRoleOnApplication(oppToAccountMap);
        }
    }
    
    Public void populateContactOnApplication(Map<Id,Id> oppToContactMap){
        List<Opportunity> oppList = new FNS_ApplicationSelector().selectApplicationById(oppToContactMap.keySet());
        System.debug('## oppList :: '  + oppList);
        for(Opportunity opp : oppList){
            opp.FNS_Contact__c = oppToContactMap.get(opp.id);
        }
        if(!oppList.isEmpty()){
            new FNS_ApplicationService().updateRecords(oppList);
        }
    }
    
    Public void populateApplicationRoleOnApplication(Map<Id,Id> oppToAccountMap){
        List<FNS_RelatedRoles__c> appRolesList = new List<FNS_RelatedRoles__c>();
        for(Id oppId : oppToAccountMap.keySet()){
            FNS_RelatedRoles__c appRole = new FNS_RelatedRoles__c();
            appRole.FNS_Application__c = oppId;
            appRole.FNS_AccountName__c = oppToAccountMap.get(oppId);
            appRole.FNS_RoleOfEntity__c = FNS_Constants.BORROWER;
            appRolesList.add(appRole);
        }
        if(!appRolesList.isEmpty()){
            new FNS_ApplicationRoleService().upsertRecords(appRolesList);
        }
    }
    
}