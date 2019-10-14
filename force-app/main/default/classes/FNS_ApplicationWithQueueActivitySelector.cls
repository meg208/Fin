/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on ApplicationWithQueueActivity object
****************************************************************************************/
public with sharing class FNS_ApplicationWithQueueActivitySelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_ApplicationWithQueueActivitySelector() {
        super(true, true, true);
    }
     
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/ 
    public FNS_ApplicationWithQueueActivitySelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of 
        			   ApplicationWithQueueActivity object 
        * @param 	   none
        * @return      List of Schema.SObjectField of ApplicationWithQueueActivity
       		 		   object
    **************************************************************************************/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_ApplicationWithQueueActivity__c.Id,
                FNS_ApplicationWithQueueActivity__c.FNS_ActivityExternalId__c,
                FNS_ApplicationWithQueueActivity__c.FNS_QueueExternalId__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_IsCurrentActivity__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_ActivityNotes__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_SequenceNumber__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_CompletedByUserId__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_CompletionDate__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_CompletionTime__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_CreatedByUserId__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_CreationDate__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_DueDate__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_DueTime__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_GroupDueDate__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_HostIdentifier__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_JobDueDate__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_LegalBookNumber__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_NumberOfHours__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_ProcessCenterId__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_ProcessGroupId__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_ProcessJobId__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_SlaIndicator__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_SlaPercentage__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_StartDateTime__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_StartTime__c, 
                FNS_ApplicationWithQueueActivity__c.FNS_StopClockIndicator__c,
                FNS_ApplicationWithQueueActivity__c.FNS_ApplicationExtId__c 
                };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of ApplicationWithQueueActivity
        			   object
        * @param 	   none
        * @return      Returns SObjecttype of ApplicationWithQueueActivity object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_ApplicationWithQueueActivity__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return ApplicationWithQueueActivity records based on 
        			   queue Activity Ids
        * @param 	   Set of queue Activity ids
        * @return      Returns List of ApplicationWithQueueActivity object
    **************************************************************************************/
    public List<FNS_ApplicationWithQueueActivity__c> selectById(Set<Id> queueActivityIds) {
        return (List<FNS_ApplicationWithQueueActivity__c>) selectSObjectsById(queueActivityIds);
    }
    
    /*************************************************************************************
        * @description Method to return ApplicationWithQueueActivity records
        * @param 	   none
        * @return      Returns List of ApplicationWithQueueActivity object
    **************************************************************************************/
    public List<FNS_ApplicationWithQueueActivity__c> getAllqueueActivities() {
        return Database.query(newQueryFactory().toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return ApplicationWithQueueActivity records based on 
                       Application ID 
        * @param       Set of Application Ids
        * @return      Returns List of ApplicationWithQueueActivity object
    **************************************************************************************/
    public List<FNS_ApplicationWithQueueActivity__c> getActivities(String appId) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        fflib_QueryFactory queueActivitiesQueryFactory = newQueryFactory(true, true, true);
        queueActivitiesQueryFactory.assertIsAccessible();
        queueActivitiesQueryFactory.setEnforceFLS(true);
        queueActivitiesQueryFactory.selectField('Id');
        
        String queueActivityQueryCondition; 
        if(appId != null){
            queueActivityQueryCondition= baseNamespace+'FNS_ApplicationExternalId__c=:appId'; 
            queueActivitiesQueryFactory.setCondition(queueActivityQueryCondition);
        }
        return (List<FNS_ApplicationWithQueueActivity__c>) Database.query(queueActivitiesQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return ApplicationWithQueueActivity records based on 
                       Activity Ids and Application ID
        * @param       Set of Activity Ids
        * @param       Set of Application Ids
        * @return      Returns List of ApplicationWithQueueActivity object
    **************************************************************************************/
    public List<FNS_ApplicationWithQueueActivity__c> getActivitiesRecords(String activityId, String appId) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        fflib_QueryFactory queueActivitiesQueryFactory = newQueryFactory(true, true, true);
        queueActivitiesQueryFactory.assertIsAccessible();
        queueActivitiesQueryFactory.setEnforceFLS(true);
        queueActivitiesQueryFactory.selectField('Id');
        queueActivitiesQueryFactory.selectField(baseNamespace+'FNS_ApplicationExternalId__c');
        
        List<String> queueActivityQueryConditions = new List<String>(); 
        if(appId != null && activityId != null){
            queueActivityQueryConditions.add(baseNamespace+'FNS_IsCurrentActivity__c= true');
            queueActivityQueryConditions.add(baseNamespace+'FNS_ApplicationExternalId__c=:appId');
            queueActivityQueryConditions.add(baseNamespace+'FNS_IsCommunity__c = false');             
            queueActivitiesQueryFactory.setCondition(String.join(queueActivityQueryConditions, ' AND '));
        }
        fflib_SObjectSelector activitySelector = new FNS_ActivitiesSelector();
        activitySelector.configureQueryFactoryFields(queueActivitiesQueryFactory, baseNamespace+'FNS_Activity__r');
        
        return (List<FNS_ApplicationWithQueueActivity__c>) Database.query(queueActivitiesQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return ApplicationWithQueueActivity records based on 
        			   Activity Ids 
		* @param 	   Set of Activity Ids
        * @return      Returns List of ApplicationWithQueueActivity object
    **************************************************************************************/
    public List<FNS_ApplicationWithQueueActivity__c> getActivitiesWithApplication(String appId) {
        String baseNamespace= FNS_Util.getBasePackageNamepace(); 
        fflib_QueryFactory queueActivitiesQueryFactory = newQueryFactory(true, true, true);
        queueActivitiesQueryFactory.assertIsAccessible();
        queueActivitiesQueryFactory.setEnforceFLS(true);
        queueActivitiesQueryFactory.selectField('Id');
        queueActivitiesQueryFactory.selectField(baseNamespace+'FNS_ActivityExternalId__c');
        queueActivitiesQueryFactory.selectField(baseNamespace+'FNS_QueueExternalId__c');
        queueActivitiesQueryFactory.selectField(baseNamespace+'FNS_ApplicationExternalId__c');
        queueActivitiesQueryFactory.selectField(baseNamespace+'FNS_ActivityNotes__c');
        queueActivitiesQueryFactory.selectField(baseNamespace+'FNS_IsCurrentActivity__c');
        
        List<String> queueActivityQueryConditions = new List<String>(); 
        if(appId != null){
            queueActivityQueryConditions.add(baseNamespace+'FNS_ApplicationExternalId__c=:appId'); 
            queueActivityQueryConditions.add(baseNamespace+'FNS_IsCommunity__c = false'); 
            queueActivitiesQueryFactory.setCondition(String.join(queueActivityQueryConditions, ' AND '));
        }
        
        queueActivitiesQueryFactory.setOrdering(baseNamespace+'FNS_CompletionDate__c', fflib_QueryFactory.SortOrder.DESCENDING, true );
        return (List<FNS_ApplicationWithQueueActivity__c>) Database.query(queueActivitiesQueryFactory.toSOQL());
    }
    
    public List<FNS_ApplicationWithQueueActivity__c> getActivitiesByApp(Set<id> oppIdSet) {
        fflib_QueryFactory query = newQueryFactory();
        query.selectField('FNS_ApplicationCloseDate__c');
        query.selectField('FNS_ApplicationStage__c');
        query.selectField('FNS_ApplicationExtId__c');
        query.selectField('FNS_Application__c');
        query.selectField('FNS_Contact__c');
        List<String> oppQueryConditions = new List<String>();
        if(oppIdSet != null && !oppIdSet.isEmpty()){
            oppQueryConditions.add('FNS_Application__c IN :oppIdSet');
        }
        
        if(! oppQueryConditions.isEmpty()){
            query.setCondition(String.join(oppQueryConditions, ' AND '));
        }
        return (List<FNS_ApplicationWithQueueActivity__c>) Database.query(query.toSOQL());
    }
    /*************************************************************************************
        * @description Method to return ApplicationWithQueueActivity records based on 
                       Contact ID 
        * @param       Contact Id
        * @return      Returns List of ApplicationWithQueueActivity object
    **************************************************************************************/
    public List<FNS_ApplicationWithQueueActivity__c> getActivitiesfromContact(String contactId) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        fflib_QueryFactory queueActivitiesQueryFactory = newQueryFactory(true, true, true);
        queueActivitiesQueryFactory.assertIsAccessible();
        queueActivitiesQueryFactory.setEnforceFLS(true);
        queueActivitiesQueryFactory.selectField('Id');
        queueActivitiesQueryFactory.selectField('FNS_ApplicationCloseDate__c');
        queueActivitiesQueryFactory.selectField('FNS_ApplicationName__c');
        queueActivitiesQueryFactory.selectField('FNS_ApplicationQuip__c');
        queueActivitiesQueryFactory.selectField('FNS_ApplicationStage__c');
        queueActivitiesQueryFactory.selectField('FNS_ApplicationDescription__c');
        List<String> queueActivityQueryCondition = new List<String>(); 
        if(contactId != null){
            queueActivityQueryCondition.add(baseNamespace+'FNS_Contact__c=:contactId'); 
            queueActivityQueryCondition.add(baseNamespace+'FNS_IsCommunity__c = true'); 
            queueActivityQueryCondition.add(baseNamespace+'FNS_ApplicationExtId__c != null');
            queueActivitiesQueryFactory.setCondition(String.join(queueActivityQueryCondition, ' AND '));
        }
        return (List<FNS_ApplicationWithQueueActivity__c>) Database.query(queueActivitiesQueryFactory.toSOQL());
    }
    
    /*****************************************************************************************************
        * @description Method to return ApplicationWithQueueActivity records based on Application Ids 
        * @param       Set of Application Ids
        * @return      Returns List of ApplicationWithQueueActivity object
    **********************************************************************************************************/
    public List<FNS_ApplicationWithQueueActivity__c> getActivitiesByApplication(Set<id> appIdSet) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        fflib_QueryFactory query = newQueryFactory();
        query.selectField('FNS_ApplicationCloseDate__c');
        query.selectField('FNS_ApplicationStage__c');
        query.selectField('FNS_ApplicationExtId__c');
        query.selectField('FNS_Application__c');
        query.selectField('FNS_Contact__c');
        List<String> oppQueryConditions = new List<String>();
        if(appIdSet != null && !appIdSet.isEmpty()){
            oppQueryConditions.add(baseNamespace+'FNS_Application__c IN :appIdSet');
             oppQueryConditions.add(baseNamespace+'FNS_IsCommunity__c = true'); 
        }
        
        if(! oppQueryConditions.isEmpty()){
            query.setCondition(String.join(oppQueryConditions, ' AND '));
        }
        return (List<FNS_ApplicationWithQueueActivity__c>) Database.query(query.toSOQL());
    }

}