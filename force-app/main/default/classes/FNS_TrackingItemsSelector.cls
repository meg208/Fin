/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Tasks
****************************************************************************************/
public with sharing class FNS_TrackingItemsSelector extends fflib_SObjectSelector {
	public static string baseNamespace = FNS_Util.getBasePackageNamepace();
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/   
    public FNS_TrackingItemsSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_TrackingItemsSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of tasks object 
        * @param 	   none
        * @return      List of Schema.SObjectField of Task object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            	Task.Id,
                Task.ActivityDate,
                Task.OwnerId,
                Task.Priority,
                Task.description,
                Task.Status,
                Task.Subject,
                Task.WhoId,
                Task.WhatId,
                Task.FNS_Comments__c,
                Task.FNS_DueDate__c,
                Task.FNS_IsCSA__c,
                Task.FNS_IsStandard__c,
                Task.FNS_IsVerified__c,
                Task.FNS_KeepOnRefresh__c,
                Task.FNS_FinancialProductExtId__c,
                Task.FNS_PrimaryRelationship__c,
                Task.FNS_PrintStatusId__c,
                Task.FNS_Refresh__c,
                Task.FNS_SLAIndicator__c,
                Task.FNS_SLAPercentage__c,
                Task.FNS_TrackingItemExtId__c,
                Task.FNS_TrackStatusId__c,
                Task.FNS_ApplicationStageName__c,
                Task.FNS_ApplicationExtId__c,
                Task.FNS_IsActive__c,
                Task.FNS_IsCheckList__c,
                Task.FNS_FinancialAccountTransactionId__c, 
                Task.FNS_FinancialAccountExtId__c, 
                Task.FNS_CustomerExtIds__c ,
                Task.FNS_UserExtId__c,
                Task.FNS_UserRecordIds__c,
                Task.FNS_CustomerRecordIds__c,
                Task.FNS_FinancialAccountTransactionRecordId__c,
                Task.FNS_Status__c,
                Task.FNS_Borrower__c,
                Task.FNS_PackageExtId__c,
                Task.FNS_Sequence__c,
                Task.FNS_Type__c,
                Task.FNS_PriorityId__c,
                Task.createdDate
                };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Tasks object 
        * @param 	   none
        * @return      Returns SObjecttype of Task object
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType(){
        return Task.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Task records based on taskIds 
        * @param 	   Set of Task ids
        * @return      Returns List of Task object
    **************************************************************************************/ 
    public List<Task> selectById(Set<Id> tasksIds){
        return (List<Task>) selectSObjectsById(tasksIds);
    }
    
    /*************************************************************************************
        * @description Method to return tasks records based on Application Record Id
        * @param 	   Application Record Id
        * @return      Returns List of Task object
    **************************************************************************************/ 
    public List<Task> getAllItems(String applicationRecordId){
        fflib_QueryFactory taskQueryFactory = newQueryFactory(true, true, true);
        taskQueryFactory.assertIsAccessible();
        taskQueryFactory.setEnforceFLS(true);
        taskQueryFactory.selectField(baseNamespace+'FNS_Priority__c');
        
        String taskQueryCondition; 
        if(applicationRecordId != null){
            taskQueryCondition= 'what.Id =: applicationRecordId'; 
            taskQueryFactory.setCondition(taskQueryCondition);
        }
        return (List<Task>) Database.query(taskQueryFactory.toSOQL());
    }    
    
    /*************************************************************************************
        * @description Method to return Tasks records based on taskIds and userIds
        * @param 	   Task Id
        * @param 	   user Id
        * @return      Returns List of Task object
    **************************************************************************************/ 
    public List<Task> updateUser(String taskid, String userId){
        fflib_QueryFactory taskQueryFactory = newQueryFactory(true, true, true);
        taskQueryFactory.assertIsAccessible();
        taskQueryFactory.setEnforceFLS(true);
        taskQueryFactory.selectField('Id');
        taskQueryFactory.selectField('WhoId');
        String taskQueryCondition;
        if(taskId!=null) {
            taskQueryCondition = 'Id=:taskid';
            taskQueryFactory.setCondition(taskQueryCondition);
        }
        return (List<Task>) Database.query(taskQueryFactory.toSOQL());
    }
    
     /*************************************************************************************
        * @description Method to return Tasks records based on taskIds and loggedinuserIds
        * @param 	   Task Id
        * @param 	   user Id
        * @return      Returns List of Task object
    **************************************************************************************/ 
    public List<Task> getTasksforBorrower(Set<String> oppExtIdSet, Id assignedOwner){
        fflib_QueryFactory taskQueryFactory = newQueryFactory(true, true, true);
        taskQueryFactory.assertIsAccessible();
        taskQueryFactory.setEnforceFLS(true);
        taskQueryFactory.selectField('Id');
        taskQueryFactory.selectField('WhatId');
        String taskQueryCondition;
        if(oppExtIdSet!=null) {
            taskQueryCondition = baseNamespace+'FNS_ApplicationExtId__c IN :oppExtIdSet AND OwnerId = :assignedOwner';
            taskQueryFactory.setCondition(taskQueryCondition);
        }
        return (List<Task>) Database.query(taskQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return Tasks records based on taskIds and userIds
        * @param 	   Task Id
        * @param 	   user Id
        * @return      Returns List of Task object
    **************************************************************************************/ 
    public List<Task> getTasksByTaskRecId(String taskId){
        fflib_QueryFactory taskQueryFactory = newQueryFactory(true, true, true);
        taskQueryFactory.assertIsAccessible();
        taskQueryFactory.setEnforceFLS(true);
        taskQueryFactory.selectField('Id');
        String taskQueryCondition;
        if(taskId!=null) {
            taskQueryCondition = 'Id=:taskId';
            taskQueryFactory.setCondition(taskQueryCondition);
        }
        return (List<Task>) Database.query(taskQueryFactory.toSOQL());
    }
}