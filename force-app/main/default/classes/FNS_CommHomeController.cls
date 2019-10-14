/**
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Community
* @description Helps in evaluating CRUD Access
*/
public with sharing class FNS_CommHomeController {
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    /**
* @description Get the opportunity data on Community.
* @param none
* @return wrapper
*/  
    @AuraEnabled
    public static FNS_CommunityWrapper getActiveApplication(){
        FNS_CommunityWrapper wrapper= new FNS_CommunityWrapper();
        try{
            FNS_UserSelector userRecord= new FNS_UserSelector();
            Id contactId = userRecord.selectById(UserInfo.getUserId()).ContactId;
            Id assigneduser = userRecord.selectById(UserInfo.getUserId()).Id;
            FNS_ApplicationWithQueueActivitySelector selector = new FNS_ApplicationWithQueueActivitySelector();
            List<FNS_ApplicationWithQueueActivity__c> oppList = selector.getActivitiesfromContact(String.valueOf(contactId));
            wrapper.oppList=oppList;
            wrapper.relatedRoles = FNS_CommHomeController.getRelatedRoles(oppList);
            wrapper.Tasklist = FNS_CommHomeController.getTasks(oppList,assigneduser);
            wrapper.doclist = FNS_CommHomeController.getTrackingDocs(oppList);
        }catch (DMLException ex){
            logger.addLogRecord('FNS_CommHomeController', 'getActiveApplication', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        } catch (Exception ex){
            logger.addLogRecord('FNS_CommHomeController', 'getActiveApplication', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        }
        return wrapper;
    }
    
    
    /**
* @description get picklist value for respective record type .
* @param null
* @return a List of picklist values
*/  
    @AuraEnabled
    public static List<String> getPickListValues(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String shost = System.Url.getSalesforceBaseURL().toExternalForm();
        String url = shost + '/services/data/v41.0/ui-api/object-info/opportunity/picklist-values/0122E000000NWQ1QAO/StageName';
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); 
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = http.send(request);
        String json = response.getbody();
        FNS_PickListValueWrapper pickWrap =FNS_PickListValueWrapper.parse(json);
        List<String> pickValues = new List<String>();
        if(pickWrap !=null){
            for(FNS_PickListValueWrapper.Values valueObj : pickWrap.values){
                pickValues.add(valueObj.label);
            }
        }
        return pickValues;
    }
    
    
    public class FNS_CommunityWrapper {
        @AuraEnabled public List<FNS_ApplicationWithQueueActivity__c> oppList{get;set;}
        @AuraEnabled public Map<String, List<FNS_RelatedRoles__c>> relatedRoles{get;set;}
        @AuraEnabled public List<String> pickListFieldValues{get;set;}
        @AuraEnabled public Map<String, List<Task>> Tasklist {get;set;}
        @AuraEnabled public Map<String, List<FNS_TrackingDocs__c>> doclist {get;set;}
        @AuraEnabled public String error{get;set;}
    } 
    
    /**
* @description get the Role related to Opportunity on Community.
* @param list of Opportunity
* @return a Map of Application Id and list of Related Roles
*/  
    Public static Map<String,List<FNS_RelatedRoles__c>> getRelatedRoles(List<FNS_ApplicationWithQueueActivity__c> oppList){
        Set<String> oppExtId = New Set<String>();
        for(FNS_ApplicationWithQueueActivity__c opp :oppList ){
            oppExtId.add(opp.FNS_ApplicationExtId__c);
        }
        FNS_RelatedRolesSelector roleSelector= new FNS_RelatedRolesSelector();
        List<FNS_RelatedRoles__c> roleList= roleSelector.getCommunityRelatedRoles(oppExtId);
        Map<String,List<FNS_RelatedRoles__c>> oppRelatedRoleMap = new Map<String,List<FNS_RelatedRoles__c>>();
        
        For(FNS_RelatedRoles__c role : roleList){
            if(oppRelatedRoleMap.containsKey(role.FNS_ApplicationExternalId__c)){
                List<FNS_RelatedRoles__c> tempRoleList = oppRelatedRoleMap.get(role.FNS_ApplicationExternalId__c);
                tempRoleList.add(role);
            }
            else{
                List<FNS_RelatedRoles__c> tempRoleList = new List<FNS_RelatedRoles__c>();
                tempRoleList.add(role);
                oppRelatedRoleMap.put(role.FNS_ApplicationExternalId__c,tempRoleList);
            }
        }
        return oppRelatedRoleMap;
    }
    
    /**
* @description get picklist value for respective record type .
* @param Opportunity List and userId
* @return a List of picklist values
*/  
    Public static Map<String,List<Task>> getTasks(List<FNS_ApplicationWithQueueActivity__c> oppList,Id assigneduser){
        Set<String> oppExtId = New Set<String>();
        for(FNS_ApplicationWithQueueActivity__c opp :oppList ){
            oppExtId.add(opp.FNS_ApplicationExtId__c);
        }
        
        FNS_TrackingItemsSelector itemsSelector = new FNS_TrackingItemsSelector();
        List<Task> taskList =  itemsSelector.getTasksforBorrower(oppExtId,assigneduser);
        
        Map<String,List<Task>> oppRelatedTaskMap = new Map<String,List<Task>>();
        
        if(taskList != null){
            For(Task task : taskList){ 
                
                if(oppRelatedTaskMap.containsKey(task.FNS_ApplicationExtId__c)){
                    List<Task> tempTaskList = oppRelatedTaskMap.get(task.FNS_ApplicationExtId__c);
                    tempTaskList.add(task);
                }
                else{
                    List<task> tempTaskList = new List<task>();
                    tempTaskList.add(task);
                    oppRelatedTaskMap.put(task.FNS_ApplicationExtId__c,tempTaskList);
                }
            }  
        }
        
        return oppRelatedTaskMap;
    }    
    /**
* @description get picklist value for respective record type .
* @param opportunity List
* @return a List of picklist values
*/  
    Public static Map<String,List<FNS_TrackingDocs__c>> getTrackingDocs(List<FNS_ApplicationWithQueueActivity__c> oppList){
        Set<String> oppExtId = New Set<String>();
        for(FNS_ApplicationWithQueueActivity__c opp :oppList ){
            oppExtId.add(opp.FNS_ApplicationExtId__c);
        }
        FNS_TrackingDocsSelector docsSelector = new FNS_TrackingDocsSelector();
        List<FNS_TrackingDocs__c> docList =  docsSelector.getDocsForBorrower(oppExtId);
        Map<String,List<FNS_TrackingDocs__c>> oppRelateddocsMap = new Map<String,List<FNS_TrackingDocs__c>>();
        For(FNS_TrackingDocs__c docs : docList){
            if(oppRelateddocsMap.containsKey(docs.FNS_ApplicationExtId__c)){
                List<FNS_TrackingDocs__c> tempdocList = oppRelateddocsMap.get(docs.FNS_ApplicationExtId__c);
                tempdocList.add(docs);
            }
            else{
                List<FNS_TrackingDocs__c> tempdocList = new List<FNS_TrackingDocs__c>();
                tempdocList.add(docs);
                oppRelateddocsMap.put(docs.FNS_ApplicationExtId__c,tempdocList);
            }
        }
        return oppRelateddocsMap;
    }
}