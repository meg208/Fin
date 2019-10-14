/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Related Roles Selector
****************************************************************************************/
public with sharing class FNS_RelatedRolesSelector  extends fflib_SObjectSelector {
   
     /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_RelatedRolesSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/ 
    public FNS_RelatedRolesSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Related Roles object 
        * @param 	   none
        * @return      List of Schema.SObjectField of Related Roles object
    **************************************************************************************/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_RelatedRoles__c.Id,
            FNS_RelatedRoles__c.FNS_AccountName__c,
            FNS_RelatedRoles__c.Name,
            FNS_RelatedRoles__c.FNS_RoleOfEntity__c,
            FNS_RelatedRoles__c.FNS_Contact__c,
            FNS_RelatedRoles__c.FNS_Type__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Related Roles object
        * @param 	   none
        * @return      List of Schema.SObjectField of Related Roles object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_RelatedRoles__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Related Roles records based on oppIds
        * @param 	   Set of Opportunity ids
        * @return      List of Opportunity object
    **************************************************************************************/
    public List<FNS_RelatedRoles__c> selectRoleByOppId(Set<Id> oppIdSet) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        fflib_QueryFactory rolesQueryFactory = newQueryFactory(true, true, true);
        rolesQueryFactory.selectField(baseNamespace+'FNS_Application__c');
            
        rolesQueryFactory.assertIsAccessible();
        rolesQueryFactory.setEnforceFLS(true);
        if(oppIdSet != null && !oppIdSet.isEmpty()){
            rolesQueryFactory.setCondition(baseNamespace+'FNS_Application__c IN :oppIdSet');
        }
        fflib_SObjectSelector accountSelector = new FNS_AccountSelector();
        accountSelector.configureQueryFactoryFields(rolesQueryFactory, baseNamespace+'FNS_AccountName__r');
        return (List<FNS_RelatedRoles__c>)Database.query(rolesQueryFactory.toSOQL());
    }
    
    public List<FNS_RelatedRoles__c> getCommunityRelatedRoles(Set<String> oppExtIdSet){
            String baseNamespace= FNS_Util.getBasePackageNamepace();
            fflib_QueryFactory rolesQueryFactory = newQueryFactory(true, true, true);
            rolesQueryFactory.setEnforceFLS(true);
            rolesQueryFactory.selectField(baseNamespace+'FNS_ApplicationExternalId__c');
            if(oppExtIdSet != null && !oppExtIdSet.isEmpty()){
                rolesQueryFactory.setCondition(baseNamespace+'FNS_ApplicationExternalId__c IN :oppExtIdSet');
            }
            fflib_SObjectSelector accountSelector = new FNS_AccountSelector();
            accountSelector.configureQueryFactoryFields(rolesQueryFactory, baseNamespace+'FNS_AccountName__r');
            return (List<FNS_RelatedRoles__c>)Database.query(rolesQueryFactory.toSOQL());
    } 
	public  List<FNS_RelatedRoles__c> getRelatedRoles(Set<Id> oppIdSet){
            String baseNamespace= FNS_Util.getBasePackageNamepace();
            fflib_QueryFactory rolesQueryFactory = newQueryFactory(true, true, true);
            rolesQueryFactory.setEnforceFLS(true);
            if(oppIdSet != null && !oppIdSet.isEmpty()){
                rolesQueryFactory.setCondition(baseNamespace+'FNS_Application__c IN :oppIdSet');
            }
            fflib_SObjectSelector accountSelector = new FNS_AccountSelector();
            accountSelector.configureQueryFactoryFields(rolesQueryFactory, baseNamespace+'FNS_AccountName__r');
            return (List<FNS_RelatedRoles__c>)Database.query(rolesQueryFactory.toSOQL());
        }      

    /*public List<FNS_RelatedRoles__c> getRelatedRoles(Set<Id> oppIdSet){
        FNS_RelatedRolesSelector.FNS_CommunityRelatedRoles selector = new FNS_RelatedRolesSelector.FNS_CommunityRelatedRoles();
        return selector.getRelatedRoles(oppIdSet);
    }
    private without sharing class FNS_CommunityRelatedRoles extends fflib_SObjectSelector{
        public Schema.SObjectType getSObjectType() {
            return FNS_RelatedRoles__c.sObjectType;
        }
        public List<Schema.SObjectField> getSObjectFieldList() {
            return new List<Schema.SObjectField> {
            FNS_RelatedRoles__c.Id,
            FNS_RelatedRoles__c.FNS_AccountName__c,
            FNS_RelatedRoles__c.FNS_Application__c,
            FNS_RelatedRoles__c.Name,
            FNS_RelatedRoles__c.FNS_RoleOfEntity__c,
            FNS_RelatedRoles__c.FNS_Contact__c,
            FNS_RelatedRoles__c.FNS_Type__c
        	};
        }
        private List<FNS_RelatedRoles__c> getRelatedRoles(Set<Id> oppIdSet){
            String baseNamespace= FNS_Util.getBasePackageNamepace();
            fflib_QueryFactory rolesQueryFactory = newQueryFactory(false, false, true);
            rolesQueryFactory.setEnforceFLS(false);
            if(oppIdSet != null && !oppIdSet.isEmpty()){
                rolesQueryFactory.setCondition(baseNamespace+'FNS_Application__c IN :oppIdSet');
            }
            fflib_SObjectSelector accountSelector = new FNS_AccountSelector();
            accountSelector.configureQueryFactoryFields(rolesQueryFactory, baseNamespace+'FNS_AccountName__r');
            return (List<FNS_RelatedRoles__c>)Database.query(rolesQueryFactory.toSOQL());
        }        
    }*/
}