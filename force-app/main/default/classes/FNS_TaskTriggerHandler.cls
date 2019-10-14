/*****************************************************************************************
* @description Task Trigger handler for record operations
* @author Praneeth
* @date Apr 04 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/

public with sharing class FNS_TaskTriggerHandler extends fflib_SObjectDomain {
    
    /********************************************************************************************************
    * @description  Interface used by the triggerHandler in constructing instances of TriggerHandler class 
    * @Params       none
    * @Returns      none
    * @author       praneeth.aitharaju@comitydesigns.com
    *********************************************************************************************************/
    
    public FNS_TaskTriggerHandler(List<Task> sObjectList) {
        super(sObjectList);
    }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new FNS_TaskTriggerHandler(sObjectList);
        }
    }
    
    public override void onBeforeInsert() {
        if(Trigger.isInsert){
            updateUserIdOnTask(null,(List<Task>)Trigger.New,Trigger.isInsert);
            updateCustomerIdOnTask(null,(List<Task>)Trigger.New,Trigger.isInsert);
            //updateLoanIdOnTask(null,(List<Task>)Trigger.New,Trigger.isInsert);
        }
    }
    
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        if(Trigger.isUpdate){
            updateUserIdOnTask((Map<id,Task>)Trigger.oldMap,(List<Task>)Trigger.New,Trigger.isUpdate);
            updateCustomerIdOnTask((Map<id,Task>)Trigger.oldMap,(List<Task>)Trigger.New,Trigger.isUpdate);
            //updateLoanIdOnTask((Map<id,Task>)Trigger.oldMap,(List<Task>)Trigger.New,Trigger.isUpdate);
        }
    }
    
    /********************************************************************************************************
    * @description   Method to store User Record ids 
    * @Params       none
    * @Returns      none
    * @author       praneeth.aitharaju@comitydesigns.com
    *********************************************************************************************************/
    
    private void updateUserIdOnTask(Map<Id,Task> oldTaskMap, List<Task> newTaskList, Boolean isInsert){
        List<Task> tasksToProcess = new List<Task>();
        Set<String> userExtIdSet = new Set<String>();
        Map<String,User> extIdToUserMap = new Map<String,User>();
        for(Task tsk : newTaskList){
            if(!isInsert){
                if(tsk.FNS_UserExtId__c != oldTaskMap.get(tsk.Id).FNS_UserExtId__c){
                    tasksToProcess.add(tsk);
                    for(String extId : tsk.FNS_UserExtId__c.split(',')){
                        userExtIdSet.add(extId);    
                    }
                }
            } else {
                tasksToProcess.add(tsk);
                if(tsk.FNS_UserExtId__c != null) {
                    for(String extId : tsk.FNS_UserExtId__c.split(',')){
                        userExtIdSet.add(extId);    
                    }
                }
            }
        }
        FNS_UserSelector userSelector = new FNS_UserSelector(); 
        List<User> userList = userSelector.getUsersByExtId(userExtIdSet);
        
        for(User user : userList){
            extIdToUserMap.put(user.FNS_UserExternalId__c,user);
        }
        
        for(Task tsk : tasksToProcess){
            tsk.FNS_UserRecordIds__c = '';
            List<String> userIdList = new List<String>();
            if(tsk.FNS_UserExtId__c != null) {
                for(String extId : tsk.FNS_UserExtId__c.split(',')){
                    if(extIdToUserMap.containsKey(extid)){
                        userIdList.add(extIdToUserMap.get(extid).Id);    
                    }
                }
            }
            tsk.FNS_UserRecordIds__c = String.join(userIdList,',');
        }
    }
    
    /********************************************************************************************************
    * @description   Method to store Account Record ids 
    * @Params       none
    * @Returns      none
    * @author       praneeth.aitharaju@comitydesigns.com
    *********************************************************************************************************/
    
    private void updateCustomerIdOnTask(Map<Id,Task> oldTaskMap, List<Task> newTaskList, Boolean isInsert){
        List<Task> tasksToProcess = new List<Task>();
        Set<String> custExtIdSet = new Set<String>();
        Map<String,Account> extIdToCustMap = new Map<String,Account>();
        
        for(Task tsk : newTaskList){
            if(!isInsert){
                if(tsk.FNS_CustomerExtIds__c != oldTaskMap.get(tsk.Id).FNS_CustomerExtIds__c){
                    tasksToProcess.add(tsk);
                    for(String extId : tsk.FNS_CustomerExtIds__c.split(',')){
                        custExtIdSet.add(extId);    
                    }
                }
            } else {
                tasksToProcess.add(tsk);
                if(tsk.FNS_CustomerExtIds__c != null) {
                    for(String extId : tsk.FNS_CustomerExtIds__c.split(',')){
                        custExtIdSet.add(extId);    
                    }
                }
            }
        }
        FNS_AccountSelector accSelector = new FNS_AccountSelector();
         List<Account> accList = accSelector.selectByExternalId(custExtIdSet);

        for(Account acct : accList){
            extIdToCustMap.put(acct.FNS_CustomerExtId__c,acct);
        }
        
        for(Task tsk : tasksToProcess){
            tsk.FNS_CustomerRecordIds__c = '';
            List<String> custIdList = new List<String>();
            if(tsk.FNS_CustomerExtIds__c != null) {
                for(String extId : tsk.FNS_CustomerExtIds__c.split(',')){
                    if(extIdToCustMap.containsKey(extid)){
                        custIdList.add(extIdToCustMap.get(extid).Id);    
                    }
                }
            }
            tsk.FNS_CustomerRecordIds__c = String.join(custIdList,',');
        }
    }

}