/*****************************************************************************************
* @description This class is used to perform DML using json for contentdocument from ApplicationUI.
* @author Praneeth
* @date Mar 22 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_DocumentUploadDomain {
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    //Praneeth - API call to fetch the Document ID based on the document Record Id, Json Body - applicationId(mandatory), trackingItemId(optional)
    public static String metadataCallout(String JsonBody,String documentRecordId){
        
        String documentExternalId;
        FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
        param.objectName = FNS_Constants.CLASS_DOCUMENT_UPLOAD;   
        param.endPoint = FNS_Constants.URL_UPLOADDOCUMENTS;
        param.body = jsonBody;
        param.methodName = FNS_Constants.METHOD_POST;
        param.bypassBackSlash = true;
        
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put(FNS_Constants.CONTENT_TYPE, FNS_Constants.APPLICATION_JSON);
        param.headerMap = headerMap;
        
        FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
        
        HttpResponse jsonResponse = router.getPostRequest(param);
        system.debug('jsonResponse...' + jsonResponse);
        if(jsonResponse.getStatusCode() == 200){
            if (!String.isEmpty(jsonResponse.getBody())) {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse.getBody());
                documentExternalId = String.ValueOf(results.get('documentId')); //documentId = documentExternalId
                FNS_DocumentUploadDomain.sendFile(documentExternalId,documentRecordId);
            } 
        }
        
        return documentExternalId;
    }
    
    //To send document content to CME and delete the files from Salesforce immediately
    public static String sendFile(String documentExternalId, String documentRecordId){
        Blob documentContent;
        String documentName;
        FNS_DocumentContentSelector versionSelector = new FNS_DocumentContentSelector(); 
        List<ContentVersion> documentList = versionSelector.geversionItems(documentRecordId);
        if(documentList != null){
            documentContent = documentList[0].VersionData;  //EncodingUtil.base64Encode();
            documentName = documentList[0].Title + '.' + documentList[0].FileExtension;
        }
        
        FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
        param.objectName = FNS_Constants.CLASS_DOCUMENT_UPLOAD; 
        param.endPoint = FNS_Constants.URL_UPLOADDOCUMENTS;
        param.documentContent = documentContent;
        param.methodName = FNS_Constants.METHOD_PUT;
        param.extendedAPIUrl = '/' + documentExternalId + FNS_Constants.DOCUMENT_UPLOAD_CONTENT_TEXT + '?fileName=' + documentName;
        
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put(FNS_Constants.CONTENT_TYPE,FNS_Constants.DOCUMENT_UPLOAD_CONTENT_TYPE);
        param.headerMap = headerMap;
        
        FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
        HttpResponse jsonResponse = router.getPostRequest(param);//TODO - Error handling
        //Do not delete the file yet from Salesforce, handle it if it fails, try to upload again.
        
        FNS_DocumentUploadSelector docSelector = new FNS_DocumentUploadSelector(); 
        List<SObject> alldocRecords = docSelector.getDocItems(documentRecordId);
        //To delete the files from Salesforce, files must only be in CME (Source of truth)
        try {
            new FNS_DocumentUploadService().deleteRecords(alldocRecords); 
        } catch (DMLException ex){
            logger.addLogRecord('FNS_DocumentUploadDomain', 'sendFile', ex.getMessage() + ex.getStackTraceString()); 
        }    
        return jsonResponse.getBody();
        
    }
    //Praneeth - PUT callout to send Edit Documents
    public static String sendEditedFile(String documentExternalId, String documentRecordId){
        Blob documentContent;
        String documentName;
        FNS_DocumentContentSelector versionSelector = new FNS_DocumentContentSelector(); 
        List<ContentVersion> documentList = versionSelector.geversionItems(documentRecordId);
        if(documentList != null){
            documentContent = documentList[0].VersionData;  //EncodingUtil.base64Encode();
            documentName = documentList[0].Title + '.' + documentList[0].FileExtension;
        }        
        
        FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
        param.objectName = FNS_Constants.CLASS_DOCUMENT_UPLOAD; 
        param.endPoint = FNS_Constants.URL_UPLOADDOCUMENTS;
        param.documentContent = documentContent;
        param.methodName = FNS_Constants.METHOD_PUT;
        param.extendedAPIUrl = '/' + documentExternalId + FNS_Constants.DOCUMENT_UPLOAD_CONTENT_TEXT + '?fileName=' + documentName;
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put(FNS_Constants.CONTENT_TYPE,FNS_Constants.DOCUMENT_UPLOAD_CONTENT_TYPE);
        param.headerMap = headerMap;
        
        FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
        HttpResponse jsonResponse = router.getPostRequest(param);//TODO - Error handling
        if(jsonResponse.getStatusCode() == 200){
            if(!String.isEmpty(jsonResponse.getBody())){
                return jsonResponse.getBody();
            }
        }
        return jsonResponse.getBody();
    }
    
    //Praneeth - To fetch the content of the file from API based on the document External Id
    public static String getContents(String documentExternalId, String documentFileName){
        String responsereturned = null;
        
        FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
        param.objectName = FNS_Constants.CLASS_DOCUMENT_UPLOAD ;
        param.methodName = FNS_Constants.METHOD_GET;
        param.endPoint = FNS_Constants.URL_UPLOADDOCUMENTS;
        param.bypassBackSlash = true;
        param.extendedAPIUrl = '/'+documentExternalId + FNS_Constants.DOCUMENT_UPLOAD_CONTENT_TEXT;
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put(FNS_Constants.CONTENT_TYPE,FNS_Constants.DOCUMENT_UPLOAD_CONTENT_TYPE);
        param.headerMap = headerMap;        
        
        FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
        HttpResponse jsonResponse = router.getPostRequest(param);
        if(jsonResponse.getStatusCode() == 200) {
            if(jsonResponse.getBodyAsBlob() != null) {
                responsereturned = EncodingUtil.Base64Encode(jsonResponse.getBodyAsBlob());
            }   
        }
        
        return responsereturned;
    }
    
    //Praneeth - To fetch the content of the file from API based on the document External Id
    public static String getContentsForCommunity(String documentExternalId, String documentFileName){
        String responsereturned = null;
        FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
        param.objectName = FNS_Constants.CLASS_DOCUMENT_UPLOAD ;
        param.methodName = FNS_Constants.METHOD_GET;
        param.endPoint = FNS_Constants.URL_UPLOADDOCUMENTS;
        param.bypassBackSlash = true;
        param.extendedAPIUrl = '/'+documentExternalId + FNS_Constants.DOCUMENT_UPLOAD_CONTENT_TEXT;
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put(FNS_Constants.CONTENT_TYPE,FNS_Constants.DOCUMENT_UPLOAD_CONTENT_TYPE);
        param.headerMap = headerMap;        
        
        FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
        HttpResponse jsonResponse = router.getPostRequest(param);
        if(jsonResponse.getStatusCode() == 200) {
            if(jsonResponse.getBodyAsBlob() != null) {
                responsereturned = EncodingUtil.Base64Encode(jsonResponse.getBodyAsBlob());
            }   
        }
        
        return responsereturned;
    }
}