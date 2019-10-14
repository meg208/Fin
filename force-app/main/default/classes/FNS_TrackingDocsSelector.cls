/****************************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Object Selector
* @description This class is used to Query on Custom FNS_TrackingDocs__c
****************************************************************************************/
public with sharing class FNS_TrackingDocsSelector extends fflib_SObjectSelector{
    
    /*************************************************************************************
	* @description Constructor to set boolean values to TRUE of Super class.We are 
	setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
	constructor to TRUE
	* @param 	   none
	* @return      none
	**************************************************************************************/
    public FNS_TrackingDocsSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
	* @description Constructor to set boolean values to TRUE of Super class.We are 
	setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
	constructor to TRUE
	* @param 	   Boolean variable for enforcing FLS
	* @return      none
	**************************************************************************************/
    public FNS_TrackingDocsSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
	* @description Method to return Schema.SObjectField list of Custom FNS_TrackingDocs__c 
	object
	* @param 	   none
	* @return      List of Schema.SObjectField of Custom FNS_TrackingDocs__c object
	**************************************************************************************/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_TrackingDocs__c.Id,
                FNS_TrackingDocs__c.FNS_ApplicationExtId__c,
                FNS_TrackingDocs__c.FNS_CustomerExtId__c, 
                FNS_TrackingDocs__c.FNS_DocumentExtId__c, 
                FNS_TrackingDocs__c.FNS_FileName__c, 
                FNS_TrackingDocs__c.FNS_TrackingItemExtId__c,
                FNS_TrackingDocs__c.FNS_IsShared__c
                //FNS_TrackingDocs__c.FNS_Application__c
                };
                    }
    
    /*************************************************************************************
	* @description Method to return SObject type of Custom FNS_TrackingDocs__c object
	* @param 	   none
	* @return      Returns SObjecttype of Custom FNS_TrackingDocs__c object
	**************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_TrackingDocs__c.sObjectType;
    }
    
    /*************************************************************************************
	* @description Method to return Custom FNS_TrackingDocs__c records based on activityIds
	* @param 	   Set of Custom Activity ids
	* @return      Returns List of Custom FNS_TrackingDocs__c object
	**************************************************************************************/
    public List<FNS_TrackingDocs__c> selectById(Set<Id> queueActivityIds) {
        return (List<FNS_TrackingDocs__c>) selectSObjectsById(queueActivityIds);
    }
    
    /*************************************************************************************
	* @description Method to return Custom FNS_TrackingDocs__c records based on activityIds
	* @param 	   none
	* @return      Returns List of Custom FNS_TrackingDocs__c object
	**************************************************************************************/
    public List<FNS_TrackingDocs__c> getAllqueueActivities() {
        return Database.query(newQueryFactory().toSOQL());
    }
    
    /*************************************************************************************
	* @description Method to return Custom FNS_TrackingDocs__c records based on trackingIds
	* @param 	   Tracking Item External Id
	* @return      Returns List of Custom FNS_TrackingDocs__c object
	**************************************************************************************/
    public List<FNS_TrackingDocs__c> getTasks(String trackingItemExternalId) {
        fflib_QueryFactory docsQueryFactory = newQueryFactory(true, true, true);
        docsQueryFactory.assertIsAccessible();
        docsQueryFactory.setEnforceFLS(true);
        docsQueryFactory.selectField('Id');
        String docsQueryCondition; 
        if(trackingItemExternalId != null){
            docsQueryCondition= 'FNS_TrackingItemExtId__c=:trackingItemExternalId'; 
            docsQueryFactory.setCondition(docsQueryCondition);
        }
        return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
	* @description Method to return Custom FNS_TrackingDocs__c records based on applicationIds
	* @param 	   Application External Id
	* @return      Returns List of Custom FNS_TrackingDocs__c object
	**************************************************************************************/
    public List<FNS_TrackingDocs__c> getDocsByAppId(String applicationExternalId) {
        fflib_QueryFactory docsQueryFactory = newQueryFactory(true, true, true);
        docsQueryFactory.assertIsAccessible();
        docsQueryFactory.setEnforceFLS(true);
        docsQueryFactory.selectField('Id');
        String docsQueryCondition; 
        if(applicationExternalId != null){
            docsQueryCondition= 'FNS_ApplicationExtId__c=:applicationExternalId'; 
            docsQueryFactory.setCondition(docsQueryCondition);
        }  
        return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
	* @description Method to return Custom FNS_TrackingDocs__c records based on trackingIds
	* @param 	   Set of Tracking Item External Id
	* @return      Returns List of Custom FNS_TrackingDocs__c object
	**************************************************************************************/
    public List<FNS_TrackingDocs__c> getTasksbysetofApplications(Set<String> vals) {
        fflib_QueryFactory docsQueryFactory = newQueryFactory(true, true, true);
        docsQueryFactory.assertIsAccessible();
        docsQueryFactory.setEnforceFLS(true);
        docsQueryFactory.selectField('Id');
        String docsQueryCondition; 
        if(vals != null){
            docsQueryCondition= 'FNS_TrackingItemExtId__c=:vals'; 
            docsQueryFactory.setCondition(docsQueryCondition);
        }
        return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
	* @description Method to return Custom FNS_TrackingDocs__c records based on documentId
	* @param 	   Document External Id
	* @return      Returns List of Custom FNS_TrackingDocs__c object
	**************************************************************************************/
    public List<FNS_TrackingDocs__c> getDocIdsByExtId(String docExtId) {
        fflib_QueryFactory docsQueryFactory = newQueryFactory(true, true, true);
        docsQueryFactory.assertIsAccessible();
        docsQueryFactory.setEnforceFLS(true);
        docsQueryFactory.selectField('Id');
        String docsQueryCondition; 
        if(docExtId != null){
            docsQueryCondition= 'FNS_DocumentExtId__c=:docExtId'; 
            docsQueryFactory.setCondition(docsQueryCondition);
        }
        return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
	* @description Method to return Custom FNS_TrackingDocs__c records based on applicationIds
	* @param 	   Application External Id
	* @return      Returns List of Custom FNS_TrackingDocs__c object
	**************************************************************************************/
		/*public List<FNS_TrackingDocs__c> getCommunityDocsByAppId(String applicationExternalId) {
	fflib_QueryFactory docsQueryFactory = newQueryFactory(true, true, true);
	docsQueryFactory.assertIsAccessible();
	docsQueryFactory.setEnforceFLS(true);
	docsQueryFactory.selectField('Id');
	String docsQueryCondition; 
	if(applicationExternalId != null){
	docsQueryCondition= 'FNS_ApplicationExtId__c=:applicationExternalId'; 
	docsQueryFactory.setCondition(docsQueryCondition);
	}  
	return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
	}*/
    
    /*************************************************************************************
	* @description Method to return Custom FNS_TrackingDocs__c records based on trackingIds
	* @param 	   Set of Tracking Item External Id
	* @return      Returns List of Custom FNS_TrackingDocs__c object
	**************************************************************************************/
    public List<FNS_TrackingDocs__c> getDocsForBorrower(Set<String> vals) {
        fflib_QueryFactory docsQueryFactory = newQueryFactory(true, true, true);
        docsQueryFactory.assertIsAccessible();
        docsQueryFactory.setEnforceFLS(true);
        docsQueryFactory.selectField('Id');
        String docsQueryCondition; 
        if(vals != null){
            docsQueryCondition= 'FNS_ApplicationExtId__c=:vals AND FNS_IsShared__c = true'; 
            docsQueryFactory.setCondition(docsQueryCondition);
        }
        return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
    }
	public List<FNS_TrackingDocs__c> getTrackingDocsbyAppId(String applicationExternalId) {
		fflib_QueryFactory docsQueryFactory = newQueryFactory(true, true, true);
		docsQueryFactory.assertIsAccessible();
		docsQueryFactory.setEnforceFLS(true);
		docsQueryFactory.selectField('Id');
		String docsQueryCondition; 
		if(applicationExternalId != null){
			docsQueryCondition= 'FNS_ApplicationExtId__c=:applicationExternalId'; 
			docsQueryFactory.setCondition(docsQueryCondition);
		}  
		return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
	}
	public List<FNS_TrackingDocs__c> getTrackingDocIdsByExtId(String docExtId) {
		fflib_QueryFactory docsQueryFactory = newQueryFactory(true, true, true);
		docsQueryFactory.assertIsAccessible();
		docsQueryFactory.setEnforceFLS(true);
		docsQueryFactory.selectField('Id');
		String docsQueryCondition; 
		if(docExtId != null){
			docsQueryCondition= 'FNS_DocumentExtId__c=:docExtId'; 
			docsQueryFactory.setCondition(docsQueryCondition);
		}
		return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
	} 
	public List<FNS_TrackingDocs__c> getCommunityDocsByAppId(String applicationExternalId) {
		fflib_QueryFactory docsQueryFactory = newQueryFactory(true, true, true);
		docsQueryFactory.assertIsAccessible();
		docsQueryFactory.setEnforceFLS(true);docsQueryFactory.selectField('Id');
		String docsQueryCondition; 
		if(applicationExternalId != null){
			docsQueryCondition= 'FNS_ApplicationExtId__c=:applicationExternalId'; 
			docsQueryFactory.setCondition(docsQueryCondition);
		}  
		return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
	* @description Method to return FNS_TrackingDocs__c records for Community
	* @param       Set of Application Id
	* @return      Returns List of FNS_TrackingDocs__c object
	**************************************************************************************/
   /* public List<FNS_TrackingDocs__c> getTrackingDocs(Set<Id> vals){
        FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs selector = new FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs();
        return selector.getTrackingDocs(vals);
    }*/
    /*************************************************************************************
	* @description Method to return FNS_TrackingDocs__c records for Community
	* @param       string Application Id
	* @return      Returns List of FNS_TrackingDocs__c object
	**************************************************************************************/
    /*public List<FNS_TrackingDocs__c> getTrackingDocsbyAppId (String applicationExternalId){
        FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs selector = new FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs();
        return selector.getTrackingDocsbyAppId(applicationExternalId);
    }*/
    /*************************************************************************************
	* @description Method to return FNS_TrackingDocs__c records for Community
	* @param       string Application Id
	* @return      Returns List of FNS_TrackingDocs__c object
	**************************************************************************************/
    /*public List<FNS_TrackingDocs__c> getTrackingDocIdsByExtId (String docExtId){
        FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs selector = new FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs();
        return selector.getTrackingDocIdsByExtId(docExtId);
    }
    public List<FNS_TrackingDocs__c> getCommunityDocsForBorrower(Set<Id> vals){
        FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs selector = new FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs();
        return selector.getDocsForBorrower(vals);
    }*/
    /*************************************************************************************
	* @description Method to return FNS_TrackingDocs__c records for Community based on application external Id
	* @param       Application External Id
	* @return      Returns List of FNS_TrackingDocs__c object
	**************************************************************************************/
    /*public List<FNS_TrackingDocs__c> getCommunityDocsByAppId (String applicationExternalId){
        FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs selector = new FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs();
        return selector.getCommunityDocsByAppId(applicationExternalId);
    }
    
    private without sharing class FNS_CommunityTrackingDocs extends fflib_SObjectSelector{
        public Schema.SObjectType getSObjectType() {
            return FNS_TrackingDocs__c.sObjectType;
        }
        
        public List<Schema.SObjectField> getSObjectFieldList() {
            return new List<Schema.SObjectField> {
                FNS_TrackingDocs__c.Id,
                    FNS_TrackingDocs__c.FNS_ApplicationExtId__c,
                    FNS_TrackingDocs__c.FNS_CustomerExtId__c, 
                    FNS_TrackingDocs__c.FNS_DocumentExtId__c, 
                    FNS_TrackingDocs__c.FNS_FileName__c, 
                    FNS_TrackingDocs__c.FNS_TrackingItemExtId__c,
                    FNS_TrackingDocs__c.FNS_IsShared__c,
                    FNS_TrackingDocs__c.FNS_Application__c
                    };
                 }
        
        private List<FNS_TrackingDocs__c> getTrackingDocs(Set<Id> vals) {
            fflib_QueryFactory docsQueryFactory = newQueryFactory(false, false, true);
            docsQueryFactory.setEnforceFLS(false);
            docsQueryFactory.selectField('Id');
            String docsQueryCondition; 
            if(vals != null){
                docsQueryCondition= 'FNS_Application__c=:vals'; 
                docsQueryFactory.setCondition(docsQueryCondition);
            }
            return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
        }
        
        private List<FNS_TrackingDocs__c> getTrackingDocsbyAppId(String applicationExternalId) {
            fflib_QueryFactory docsQueryFactory = newQueryFactory(false, false, true);
            docsQueryFactory.selectField('Id');
            String docsQueryCondition; 
            if(applicationExternalId != null){
                docsQueryCondition= 'FNS_ApplicationExtId__c=:applicationExternalId'; 
                docsQueryFactory.setCondition(docsQueryCondition);
            }  
            return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
        }
        
        private List<FNS_TrackingDocs__c> getTrackingDocIdsByExtId(String docExtId) {
            fflib_QueryFactory docsQueryFactory = newQueryFactory(false, false, true);
            docsQueryFactory.selectField('Id');
            String docsQueryCondition; 
            if(docExtId != null){
                docsQueryCondition= 'FNS_DocumentExtId__c=:docExtId'; 
                docsQueryFactory.setCondition(docsQueryCondition);
            }
            return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
        } 
        
        private List<FNS_TrackingDocs__c> getCommunityDocsByAppId(String applicationExternalId) {
            fflib_QueryFactory docsQueryFactory = newQueryFactory(false, false, true); 
            docsQueryFactory.selectField('Id');
            String docsQueryCondition; 
            if(applicationExternalId != null){
                docsQueryCondition= 'FNS_ApplicationExtId__c=:applicationExternalId'; 
                docsQueryFactory.setCondition(docsQueryCondition);
            }  
            return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
        }
        private List<FNS_TrackingDocs__c> getDocsForBorrower(Set<Id> vals) {
            fflib_QueryFactory docsQueryFactory = newQueryFactory(false, false, true);
            docsQueryFactory.selectField('Id');
            String docsQueryCondition; 
            if(vals != null){
                docsQueryCondition= 'FNS_Application__c=:vals AND FNS_IsShared__c = true'; 
                docsQueryFactory.setCondition(docsQueryCondition);
            }
            return (List<FNS_TrackingDocs__c>) Database.query(docsQueryFactory.toSOQL());
    }
    }*/
    
	/*************************************************************************************
	* @description Method to return FNS_TrackingDocs__c records for Community
	* @param       string Application Id
	* @return      Returns List of FNS_TrackingDocs__c object
	**************************************************************************************/
    /*public List<FNS_TrackingDocs__c> getTrackingDocsbyAppId (String applicationExternalId){
        FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs selector = new FNS_TrackingDocsSelector.FNS_CommunityTrackingDocs();
        return selector.getTrackingDocsbyAppId(applicationExternalId);
    }*/
}