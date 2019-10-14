/*****************************************************************************************
* @description Class is used to handle all request from FNS_trackingItems.cmp.
* @author Praneeth Aitharaju
* @date 25/03/2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
public class FNS_DocumentUploadController {
    
    //Praneeth - This method upsers the documents based on Application Record Id
    @AuraEnabled
    public static Object callTrackingDocsDomain (String appId) {
      return FNS_TrackingDocsDomain.getConfigurations(appId);     
    }
    
    @AuraEnabled
    public static Object callTrackingItemsandDocsDomain (String appId) {
      return FNS_TrackingItemsDomain.getConfigurations(appId);
    }
    
    //Praneeth - On Document Click, fetch the content and download the file
    @AuraEnabled
    public static String callDocumentContent (String documentId, String documentFileName) {
        String response =  FNS_DocumentUploadDomain.getContents(documentId, documentFileName);
        return response;
    }
    
    //Praneeth - To fetch list of related documents by Application Record Id
    @AuraEnabled
    public static List<FNS_TrackingDocs__c> getApplicationDocIds (String appId) {
        List<String> docExtList = new List <String> ();
        List<Boolean> docIsSharedValue = new List <Boolean>();
        List<FNS_TrackingDocs__c> docList = new List <FNS_TrackingDocs__c>();
        FNS_ApplicationSelector applicationSelector = new FNS_ApplicationSelector(); 
        List<Opportunity> applicationList = applicationSelector.getApplication(appId);
        String applicationExtId = applicationList[0].FNS_ApplicationExtId__C;
        if(applicationExtId != null) {
        FNS_TrackingDocsSelector docsSelector = new FNS_TrackingDocsSelector(); 
        docList = docsSelector.getTrackingDocsbyAppId(applicationExtId);   
        }
        return docList;
    }
    
    //Praneeth - To share the document with community user
    @AuraEnabled
    public static List<FNS_TrackingDocs__c> shareDocument (Boolean sharedDocument, String documentExternalId, String appId) {
        List<FNS_TrackingDocs__c> docList = new FNS_TrackingDocsSelector().getTrackingDocIdsByExtId(documentExternalId);
        if (docList != null) {
            docList[0].FNS_IsShared__c = sharedDocument;
            docList[0].FNS_Application__c = appId;
            new FNS_DocumentUploadService().updateRecordsforDocs(docList);
        }
        return docList;  
        
    }
    
    //Praneeth - To show the documents in community when the RM clicks on Share Document button
    @AuraEnabled
    public static List<FNS_TrackingDocs__c> getCommunityApplicationDocIds (String appExtId) {
        List<String> docExtList = new List <String> ();
        List<Boolean> docIsSharedValue = new List <Boolean>();
        String applicationExtId = appExtId;        
        FNS_TrackingDocsSelector docsSelector = new FNS_TrackingDocsSelector(); 
        List<FNS_TrackingDocs__c> docList = docsSelector.getCommunityDocsByAppId(applicationExtId);   
        return docList;
    }
    
    //Praneeth - To show list of tracking items as dropdown
    @AuraEnabled
    public static list<Task> FNS_tasks(String appId){
        List<Task> taskList;
        taskList = new FNS_TrackingItemsSelector().getAllItems(appId);
        return taskList;
    }
    
    //Praneeth - To send metadata on click of upload files
    @AuraEnabled
    public static String sendMetaData(String jsonWrapper){
        
        Map<string, object> results = new Map<string, object>();
        results = (Map<string, object>)JSON.deserializeUntyped(jsonWrapper);
        
        String trackingid = '';
        String Opportunityid = '';
        String documentid = '';
        Integer trackingitemid;
        String documentName;
        if (results != null) {
            trackingid = String.valueof(results.get('trackingid'));
            Opportunityid = String.valueof(results.get('OpportunityId'));
            documentid = String.valueof(results.get('documentId'));
        }
        // To get Description of the file Uploaded
        FNS_DocumentContentSelector versionSelector = new FNS_DocumentContentSelector(); 
        List<ContentVersion> documentList = versionSelector.geversionItems(documentid);
        if(documentList != null){
            documentName = documentList[0].Title + '.' + documentList[0].FileExtension;
        }

        if(trackingid == null || trackingid == ''){
            trackingitemid = null;
        } else {
            trackingitemid = Integer.valueOf(trackingid);
        }
        
        FNS_ApplicationSelector applicationSelector = new FNS_ApplicationSelector(); 
        List<Opportunity> applicationList = applicationSelector.getApplication(OpportunityId);
        String applicationExtId = applicationList[0].FNS_ApplicationExtId__C; 
        FNS_DocumentUploadPayload wrap = new FNS_DocumentUploadPayload();
        
        wrap.applicationId = Integer.ValueOf(applicationExtId);
        wrap.collateralId = null;
        wrap.contentAddedDate = '';
        wrap.contentDirectory = '';
        wrap.covenantTrackingId = '';
        wrap.crwId = '';
        wrap.csa = true;
        wrap.customerId = null;//TODO
        wrap.description = documentName;
        wrap.documentId = null;
        wrap.documentType = '';
        wrap.externalDocumentId = '';
        wrap.loanId = null;
        wrap.printOrderId = null;
        wrap.statusId = null;
        wrap.systemAdded = null;
        wrap.userId = null;
        wrap.trackingItemId = trackingitemid;   
        wrap.visible = true;
        String jsonBody = json.serialize(wrap);
   
        //To upload content 
        String jsonResponse = FNS_DocumentUploadDomain.metadataCallout(jsonBody,documentId);
       
        // perform a DML update after callout. 
        if(jsonResponse != null){
            FNS_TrackingDocs__c docs= new FNS_TrackingDocs__c();
            docs.FNS_CustomerExtId__c = '';
            docs.FNS_ApplicationExtId__c = applicationExtId;
            docs.FNS_TrackingItemExtId__c = String.ValueOf(trackingitemid);
            docs.FNS_DocumentExtId__c = jsonResponse;
            docs.FNS_Application__c = OpportunityId;
            docs.FNS_FileName__c = documentName;
            new FNS_DocumentUploadService().insertRecordsforDocs(docs); 
        } 
        return jsonResponse;
        
    }
    
      //Praneeth - To send metadata on click of upload files
    @AuraEnabled
    public static String sendMetaDataCommunity(String jsonWrapper){
        Map<string, object> results = new Map<string, object>();
        results = (Map<string, object>)JSON.deserializeUntyped(jsonWrapper);
        
        String trackingid = '';
        String OpportunityExtId = '';
        String documentid = '';
        Integer trackingitemid;
        String documentName;
        if (results != null) {
            trackingid = String.valueof(results.get('trackingid'));
            OpportunityExtId = String.valueof(results.get('OpportunityExtId'));
            documentid = String.valueof(results.get('documentId'));
        }
        // To get Description of the file Uploaded
        FNS_DocumentContentSelector versionSelector = new FNS_DocumentContentSelector(); 
        List<ContentVersion> documentList = versionSelector.geversionItems(documentid);
        if(documentList != null){
            documentName = documentList[0].Title + '.' + documentList[0].FileExtension;
        }
        
        
        if(trackingid == null || trackingid == ''){
            trackingitemid = null;
        } else {
            trackingitemid = Integer.valueOf(trackingid);
        }
        
        String applicationExtId =OpportunityExtId; 
        FNS_DocumentUploadPayload wrap = new FNS_DocumentUploadPayload();
        
        wrap.applicationId = Integer.ValueOf(applicationExtId);
        wrap.collateralId = null;
        wrap.contentAddedDate = '';
        wrap.contentDirectory = '';
        wrap.covenantTrackingId = '';
        wrap.crwId = '';
        wrap.csa = true;
        wrap.customerId = null;//TODO
        wrap.description = documentName;
        wrap.documentId = null;
        wrap.documentType = '';
        wrap.externalDocumentId = '';
        wrap.loanId = null;
        wrap.printOrderId = null;
        wrap.statusId = null;
        wrap.systemAdded = null;
        wrap.userId = null;
        wrap.trackingItemId = trackingitemid;   
        wrap.visible = true;
        String jsonBody = json.serialize(wrap);
   
        //To upload content 

        String jsonResponse = FNS_DocumentUploadDomain.metadataCallout(jsonBody,documentId);
        
        // perform a DML update after callout. 
        if(jsonResponse != null){
            FNS_TrackingDocs__c docs= new FNS_TrackingDocs__c();
            docs.FNS_CustomerExtId__c = '';
            docs.FNS_ApplicationExtId__c = applicationExtId;
            docs.FNS_TrackingItemExtId__c = String.ValueOf(trackingitemid);
            docs.FNS_DocumentExtId__c = jsonResponse;
            docs.FNS_FileName__c = documentName;
            docs.FNS_IsShared__c = true;
            new FNS_DocumentUploadService().insertRecordsforDocs(docs);
        } 
        return jsonResponse;
        
    }
    
    //Praneeth - PUT call when Values are Edited and new document is submitted
    @AuraEnabled
    public static String sendEdit(String OpportunityId, String documentId, String docExtId, String trackingId, String docName, String documentTrackingId){   
        Integer trackingitemid;
        String documentName;
        // To get Description of the file Uploaded
        FNS_DocumentContentSelector versionSelector = new FNS_DocumentContentSelector(); 
        List<ContentVersion> documentList = versionSelector.geversionItems(documentid);
        if(documentList != null){
            documentName = documentList[0].Title + '.' + documentList[0].FileExtension;
        }
        if(trackingid == null || trackingid == ''){
            trackingitemid = null;
        } else {
            trackingitemid = Integer.valueOf(trackingid);
        }
        FNS_ApplicationSelector applicationSelector = new FNS_ApplicationSelector(); 
        List<Opportunity> applicationList = applicationSelector.getApplication(OpportunityId);
        String applicationExtId = applicationList[0].FNS_ApplicationExtId__C; 
        FNS_DocumentUploadPayload wrap = new FNS_DocumentUploadPayload();
        
        wrap.applicationId = Integer.ValueOf(applicationExtId);
        wrap.collateralId = null;
        wrap.contentAddedDate = '';
        wrap.contentDirectory = '';
        wrap.covenantTrackingId = '';
        wrap.crwId = '';
        wrap.csa = true;
        wrap.customerId = null;
        wrap.description = docName;
        wrap.documentId = null;
        wrap.documentType = '';
        wrap.externalDocumentId = '';
        wrap.loanId = null;
        wrap.printOrderId = null;
        wrap.statusId = null;
        wrap.systemAdded = null;
        wrap.userId = null;
        wrap.trackingItemId = trackingitemid;
        wrap.visible = true;
        
        String jsonBody = json.serialize(wrap);
        //To upload content
        String jsonResponse = FNS_DocumentUploadDomain.sendEditedFile(docExtId,documentId); 
        if(jsonResponse != null){
        FNS_TrackingDocs__c docs= new FNS_TrackingDocs__c();
            docs.FNS_TrackingItemExtId__c = String.ValueOf(trackingitemid);
            docs.FNS_FileName__c = documentName;
      		docs.Id = documentTrackingId;
       
            new FNS_DocumentUploadService().updateDocsRecords(docs);
        }
        return jsonResponse;
    }
    
    //Praneeth - PUT call when Values are Edited and new document is submitted
    @AuraEnabled
    public static String sendEditValues(String OpportunityExtId, String documentId, String docExtId, String trackingId, String docName){   
        Integer trackingitemid;
        String documentName;
        // To get Description of the file Uploaded
        FNS_DocumentContentSelector versionSelector = new FNS_DocumentContentSelector(); 
        List<ContentVersion> documentList = versionSelector.geversionItems(documentid);
        if(documentList != null){
            documentName = documentList[0].Title + '.' + documentList[0].FileExtension;
        }
        if(trackingid == null || trackingid == ''){
            trackingitemid = null;
        } else {
            trackingitemid = Integer.valueOf(trackingid);
        }
        
        String applicationExtId = OpportunityExtId;//applicationList[0].FNS_ApplicationExtId__C; 
        FNS_DocumentUploadPayload wrap = new FNS_DocumentUploadPayload();
        
        wrap.applicationId = Integer.ValueOf(applicationExtId);
        wrap.collateralId = null;
        wrap.contentAddedDate = '';
        wrap.contentDirectory = '';
        wrap.covenantTrackingId = '';
        wrap.crwId = '';
        wrap.csa = true;
        wrap.customerId = null;
        wrap.description = docName;
        wrap.documentId = null;
        wrap.documentType = '';
        wrap.externalDocumentId = '';
        wrap.loanId = null;
        wrap.printOrderId = null;
        wrap.statusId = null;
        wrap.systemAdded = null;
        wrap.userId = null;
        wrap.trackingItemId = trackingitemid;
        wrap.visible = true;
        
        String jsonBody = json.serialize(wrap);
        //To upload content
        String jsonResponse = FNS_DocumentUploadDomain.sendEditedFile(docExtId,documentId); 
        return jsonResponse;
    }
}