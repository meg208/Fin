/*****************************************************************************************
* @description Class is used to handle all request from FNS_trackingItems.cmp.
* @author Praneeth Aitharaju
* @date 25/03/2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/

public with sharing class FNS_TrackingItemsController {   
    
    //Make API calls to fetch Tracking Items along with Documents of Application and insert into Salesforce
    @AuraEnabled
    public static Object callTrackingItemsandDocsDomain (String appId) {
      return FNS_TrackingItemsDomain.getConfigurations(appId);
    }
    
    //Fetch Tasks and Documents based on Application Record Id
    @AuraEnabled
    public static List<Taskwrapper> getTasksByAppId(String appId){//TODO change to - applicationRecordId
        List<Task> tasksToProcess = new List<Task>();
        Set<String> tskExtIdSet = new Set<String>();
        
        Set<String> tskRelatedCustomerIdSet = new Set<String>();
        List<Account> relatedAccList = new List<Account>();
        Map<String, String> relatedAccMap = new Map<String, String>();
        Set<Id> accIdSet = new Set<Id>();
        Set<String> tskRelatedUserIdSet = new Set<String>();
        List<User> relatedUserList = new List<User>();
        Map<String, String> relatedUserMap = new Map<String, String>();
        Set<Id> userIdSet = new Set<Id>();
        
        Map<String,FNS_TrackingDocs__c> extIdToDocsMap = new Map<String,FNS_TrackingDocs__c>();
        Map<String, String> priorityMap = FNS_Util.getPicklistFieldValueMap('Task', 'FNS_Priority__c');
        Map<String, String> statusMap = FNS_Util.getPicklistFieldValueMap('Task', 'FNS_Status__c');
        List<Task> taskList = new FNS_TrackingItemsSelector().getAllItems(appId);
        for (Task tsk : taskList) {
            if(tsk.FNS_TrackingItemExtId__c != null) {  
                tskExtIdSet.add(tsk.FNS_TrackingItemExtId__c); 
            }
            if(tsk.FNS_CustomerRecordIds__c != null) {  
                tskRelatedCustomerIdSet.add(tsk.FNS_CustomerRecordIds__c); 
            }
            if(tsk.FNS_UserRecordIds__c != null) {  
                tskRelatedUserIdSet.add(tsk.FNS_UserRecordIds__c); 
            }            
        }
        
        if(! tskRelatedCustomerIdSet.isEmpty()){
            for(String accId : tskRelatedCustomerIdSet){
                accIdSet.add((Id)accId);
            }
        }
        if(!accIdSet.isEmpty()){
            relatedAccList = new FNS_AccountSelector().selectById(accIdSet);
            if(! relatedAccList.isEmpty()){
                for(Account acc : relatedAccList){
                	relatedAccMap.put(acc.Id, acc.Name);
                }
            }
        }
        
        if(! tskRelatedUserIdSet.isEmpty()){
            for(String usrId : tskRelatedUserIdSet){
                userIdSet.add((Id)usrId);
            }
        }
        if(!userIdSet.isEmpty()){
            relatedUserList = new FNS_UserSelector().selectById(userIdSet);
            if(! relatedUserList.isEmpty()){
                for(User usr : relatedUserList){
                	relatedUserMap.put(usr.Id, usr.Name);
                }
            }
        }
        
        List<FNS_TrackingDocs__c> docSetVals = new FNS_TrackingDocsSelector().getTasksbysetofApplications(tskExtIdSet);
        Map<String, List<FNS_TrackingDocs__c>> docExternalIdToTrackingMap = new Map<String, List<FNS_TrackingDocs__c>> (); 
        
        for(FNS_TrackingDocs__c trackingDocument : docSetVals) {
            
            List<FNS_TrackingDocs__c> docList = docExternalIdToTrackingMap.get(trackingDocument.FNS_TrackingItemExtId__c);
            if (docList == null) {
                docExternalIdToTrackingMap.put(trackingDocument.FNS_TrackingItemExtId__c, new List<FNS_TrackingDocs__c>{trackingDocument});
            } else {
                docList.add(trackingDocument);
                docExternalIdToTrackingMap.put(trackingDocument.FNS_TrackingItemExtId__c, docList);
            }
        } 
        
        List<Taskwrapper> taskWrapperList = new List<Taskwrapper> ();
        
        for (Task task : taskList) {
            if(task.FNS_TrackingItemExtId__c != null) {
                task.FNS_Status__c = statusMap.get(task.FNS_Status__c);
                task.FNS_Priority__c = priorityMap.get(task.FNS_Priority__c);
                String accountName;
                String userName;
                if(task.FNS_CustomerRecordIds__c != null){
                	if(relatedAccMap.containsKey(task.FNS_CustomerRecordIds__c)){
                		accountName = relatedAccMap.get(task.FNS_CustomerRecordIds__c);
                	}
                }
                if(task.FNS_UserRecordIds__c != null){
                	if(relatedUserMap.containsKey(task.FNS_UserRecordIds__c)){
                		userName = relatedUserMap.get(task.FNS_UserRecordIds__c);
                	}
                }
                List<FNS_TrackingDocs__c> docIds = docExternalIdToTrackingMap.get(task.FNS_TrackingItemExtId__c);
                Taskwrapper twrapper = new TaskWrapper (task, docIds, accountName, userName);
                taskWrapperList.add(twrapper);
            }
        }
        return taskWrapperList;
    }
    
    //Assign user to Tracking Item
    @AuraEnabled
    public static list<Task> FNS_updateUser(String taskId, String userId){
        List<Task> TaskList = new List<Task>();
        TaskList = new FNS_TrackingItemsSelector().updateUser(taskid, userId);
        TaskList[0].ownerId =  userId ;
        new FNS_TrackingItemsService().updateTaskRecords(TaskList);
        return TaskList;   
    }
    
    @AuraEnabled
    public static String callDocumentContent (String documentId, String fileName) {//TODO change to - documentExternalId
        return FNS_DocumentUploadDomain.getContents(documentId, fileName);
    }
    
    
    @AuraEnabled
    public static String sendMetadata(String jsonWrapper) {
        return FNS_DocumentUploadController.sendMetaData(jsonWrapper);
    }
    
    //Method to get picklist values for all fields 
    @auraEnabled
    public static Map<String,String> getselectOptions(sObject objObject, string fld) {
        List <String> allOpts = new list <String>();
        Map<String,String> valuePicklist = new  Map<String,String>();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        
        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            valuePicklist.put(a.getLabel(),a.getValue());
        }
        return valuePicklist;
    }
    
    
  @AuraEnabled
    public static String getCalloutResponseContents(String dataCom , String dataStatus, String dataPriority, String dataDate, String dataTask) {
        List<Task> results = new FNS_TrackingItemsSelector().getTasksByTaskRecId(dataTask);
        String responseText = '';
        String trackingId =  results[0].FNS_TrackingItemExtId__c;
        
        String convertedDate ;
        if( dataDate != 'null') {
        	convertedDate = dataDate + 'T00:00:00.000Z';
        }
        DateTime creationDate =  DateTime.valueOf(results[0].createdDate);
        Map<String, String> priorityPicklistMap = new Map<String, String>(); 
        Map<String, String> statusPicklistMap = new Map<String, String>(); 
        String formattedCreationDate = FNS_Util.convertDateTimeToString(creationDate);
        List<Schema.PicklistEntry> priorityPicklist = SObjectType.Task.Fields.FNS_Priority__c.PicklistValues; 
        List<Schema.PicklistEntry> statusPicklist = SObjectType.Task.Fields.FNS_Status__c.PicklistValues; 
        for(Schema.PicklistEntry s: priorityPicklist){
            priorityPicklistMap.put(s.getLabel(), s.getValue()); 
        }
        for(Schema.PicklistEntry s: statusPicklist){
            statusPicklistMap.put(s.getLabel(), s.getValue()); 
        }
        Task tsk = new Task(); 
        if(!String.isEmpty(dataPriority)){
            tsk.FNS_Priority__c  = priorityPicklistMap.get(dataPriority); 
            tsk.Priority = dataPriority; 
        }
        
        if(!String.isEmpty(dataStatus)){
            tsk.FNS_Status__c = statusPicklistMap.get(dataStatus); 
            tsk.Status = dataStatus;
        }
        
        if(!String.isEmpty(dataDate)){
            tsk.FNS_DueDate__c = dataDate; 
        }
        if(!String.isEmpty(dataCom)){
            tsk.FNS_Comments__c = dataCom; 
        }
        
        tsk.Id =  results[0].Id; 
        
        FNS_TrackingItemsPayload wrap = new FNS_TrackingItemsPayload();
        
        List<String> collateralIds = new list<String>();
        
        List<String> loanIds = new list<String>();
        collateralids.add(results[0].FNS_FinancialAccountTransactionId__c);
        
        List<String> userIds = new list<String>();
        userIds.add(results[0].FNS_UserExtId__c);
        
        List<String> customerIds = new list<String>();
        customerIds.add(results[0].FNS_CustomerExtIds__c);
        
        List<String> lineOfCreditIds = new list<String>();
        lineOfCreditIds.add(results[0].FNS_FinancialAccountExtId__c);
        
        wrap.comments = dataCom;
        wrap.description = results[0].Subject;

        if(dataDate == null || dataDate == ''){
            if(results[0].FNS_DueDate__c != null){
            	wrap.dueDate = results[0].FNS_DueDate__c + 'T00:00:00.000Z';
            }
        } else {
            wrap.dueDate = convertedDate; 
        }
        wrap.isActive =  results[0].FNS_IsActive__c;
        wrap.isCSA =  results[0].FNS_IsCSA__c;
        wrap.isChecklist =  results[0].FNS_IsCheckList__c;
        wrap.isStandard =  results[0].FNS_IsStandard__c;
        wrap.isVerified =  results[0].FNS_IsVerified__c;
        wrap.keepOnRefresh =  results[0].FNS_KeepOnRefresh__c;
        wrap.notes  =  results[0].description; 
        wrap.pkgId  =  Integer.valueOf(results[0].FNS_PackageExtId__c);
        wrap.printStatusId = String.valueOf(results[0].FNS_PrintStatusId__c);
        wrap.refresh  = results[0].FNS_Refresh__c;
        wrap.sequence = Integer.valueOf(results[0].FNS_Sequence__c);
        wrap.slaIndicator =   results[0].FNS_SLAIndicator__c;
        wrap.slaPercentage =  results[0].FNS_SLAPercentage__c;
        if(dataStatus != null){
            wrap.trackStatusId =  statusPicklistMap.get(dataStatus); 
        }
        wrap.applicationId = results[0].FNS_ApplicationExtId__c;
        wrap.id = Integer.valueOf(results[0].FNS_TrackingItemExtId__c);
        wrap.primaryRelationship = results[0].FNS_PrimaryRelationship__c;
        wrap.trackingItemType =  results[0].FNS_Type__c;
        wrap.trackingItemId =  Integer.valueOf(results[0].FNS_TrackingItemExtId__c);
        if(dataPriority != null){
             wrap.priorityId = priorityPicklistMap.get(dataPriority);
        }
        wrap.userIds = userIds;
        wrap.collateralIds = collateralids;
        wrap.loanIds = loanIds;
        wrap.customerIds = customerIds;
	    wrap.creationDate = formattedCreationDate;
		        
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put(FNS_Constants.CONTENT_TYPE, FNS_Constants.APPLICATION_JSON);
        
        // send jsonbody and tracking id to Tracking item domain class and store the response as a string which needs to be sent to component. 
        String jsonBody = json.serialize(wrap);
        responseText =  FNS_TrackingItemsDomain.calloutToCME(trackingId,jsonBody);
        //perform a DML update after callout. 
        if(responseText != 'Failure'){
            if(tsk.Id !=null){
                new FNS_TrackingItemsService().updateRecords(tsk); 
            } 
        }
        
        return responseText;
    }
        // Wrapper class to pass Task and Document Values to UI. 
    public with sharing class Taskwrapper {
        @AuraEnabled public List<FNS_TrackingDocs__c> documentIds; 
        @AuraEnabled public Task task;
        @AuraEnabled public String customerName;
        @AuraEnabled public String relatedUserName;
        
        public TaskWrapper(Task task, List<FNS_TrackingDocs__c> documentIds, String customerName, String relatedUserName) {
            this.documentIds = documentIds;
            this.task = task;
            this.customerName = customerName;
            this.relatedUserName = relatedUserName;
        }
    }
    
    public with sharing class taskDetailsWrapper {
        List<taskwrapper> leadWrapperList = new List<taskwrapper>();
    }
}