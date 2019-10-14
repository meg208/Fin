/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Task
****************************************************************************************/
public with sharing class FNS_TasksSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_TasksSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_TasksSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Task object
        * @param 	   none
        * @return      List of Schema.SObjectField of Task object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Task.Id,
            Task.Subject,
            Task.ActivityDate,
            Task.Status,
            Task.ActivityDate,
            Task.WhatId,
            Task.WhoId
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Task object
        * @param 	   none
        * @return      Returns SObjecttype of Task object
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        return Task.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Task records based on Task Ids
        * @param 	   Set of Task Ids
        * @return      Returns List of Task object
    **************************************************************************************/ 
    public List<Task> selectById(Set<Id> taskIds) {
        return (List<Task>) super.selectSObjectsById(taskIds);
    }
    
    /*************************************************************************************
        * @description Method to Task records based on Task.Owner, Task.WhatId, Task.WhoId 
        			   and pending Deals
        * @param 	   assignedTo Id
        * @param 	   relatedTo Id
        * @param 	   whomTo Id
        * @param 	   ispending 
        * @return      Returns List of Task object
    **************************************************************************************/
    public List<Task> selectOpenTasks(Id assignedToId, Id relatedToId, Id whomToId, Boolean isPending) {
        
        Set<String> taskStatusSet = new Set<String>{'Completed'};
        
        fflib_QueryFactory tasksQueryFactory = newQueryFactory(true, true, true);
        tasksQueryFactory.assertIsAccessible();
        tasksQueryFactory.setEnforceFLS(true);
        tasksQueryFactory.addOrdering('ActivityDate', fflib_QueryFactory.SortOrder.ASCENDING);
        List<String> taskQueryConditions = new List<String>();
        
        if(assignedToId != null){
            taskQueryConditions.add('OwnerId =: assignedToId');
        }
        
        if(relatedToId != null){
            taskQueryConditions.add('WhatId =: relatedToId');
        }
        
        if(whomToId != null){
            taskQueryConditions.add('WhoId =: whomToId');
        }
        
        if(isPending){
            taskQueryConditions.add('Status IN :taskStatusSet');
        }
        
        if(! taskQueryConditions.isEmpty()){
            tasksQueryFactory.setCondition(String.join(taskQueryConditions, ' AND '));
        }
        
        tasksQueryFactory.setLimit(5);
        
        return (List<Task>) Database.query(tasksQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return Order By clause
        * @param 	   none
        * @return      Returns parameter of order by clause
    **************************************************************************************/ 
    public override String getOrderBy(){
        return 'ActivityDate ASC';
    }
}