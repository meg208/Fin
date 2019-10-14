/*****************************************************************************************
* @description This class is used to perform DML using json for TrackingDocs from Tracking Docs API.
* @author Praneeth
* @date Mar 22 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_TrackingDocsDomain {
    
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    //Upsert documents for each application params - Application Record Id
    public static Object getConfigurations(String OpportunityId){
        Map<String, Object> objValue = new Map<String, Object> {
                FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
                FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
                };
        try {
            fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { FNS_TrackingDocs__c.SObjectType });
            FNS_UpsertUnitOfWorkHelper upsertDocs = new FNS_UpsertUnitOfWorkHelper();
            uow.registerWork(upsertDocs);
            
            String responseState = FNS_Constants.STR_FAILURE;
            FNS_ApplicationSelector applicationSelector = new FNS_ApplicationSelector(); 
            List<Opportunity> applicationList = applicationSelector.getApplicationId(OpportunityId);
            String applicationExtId = applicationList[0].FNS_ApplicationExtId__C;
            
            FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
            param.objectName = FNS_Constants.CLASS_TRACKING_ITEMS;
            param.endPoint = FNS_Constants.URL_APPLICATION;
            param.extendedAPIUrl =   applicationExtId +'/' + 'documents';
            param.bypassBackSlash = true;
            param.methodName = FNS_Constants.METHOD_GET;
            
            
            Map<String, String> headerMap = new Map<String, String>();
            headerMap.put(FNS_Constants.CONTENT_TYPE, FNS_Constants.APPLICATION_JSON);
            param.headerMap = headerMap;
            
            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            HttpResponse jsonResponse = router.getPostRequest(param);
            if(jsonResponse.getStatusCode() == 200){
                if (!String.isEmpty(jsonResponse.getBody())){
                    // code API 1.0 changes  Start >>>>
                    // List<FNS_ObjectContainer.FNS_Trackingdocs> documentConfigList = (List<FNS_ObjectContainer.FNS_Trackingdocs>)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_Trackingdocs>.class);
                   
                    System.debug('----jsonResponse.getBody()----' +jsonResponse.getBody());
                    List<FNS_ObjectContainer.FNS_Trackingdocs> documentConfigList ;
                    FNS_ObjectContainer listDocuments = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);
                    if(listDocuments != null && listDocuments.documentsList!= null)
                    {
                      documentConfigList  = listDocuments.documentsList;
                      System.debug('documentConfigList --- ' + documentConfigList  );
                    }
                    // code API changes Ends <<<<<
                    
                    List<FNS_TrackingDocs__c> documentList = new List<FNS_TrackingDocs__c>();
                    for (FNS_ObjectContainer.FNS_Trackingdocs docConfig : documentConfigList){
                        FNS_TrackingDocs__c document = new FNS_TrackingDocs__c();
                        document = FNS_TrackingDocsDomain.assignJSONTotrackingDocTypes(docConfig,OpportunityId);
                        upsertDocs.registerDocumentUpsert(document);
                    }
                     FNS_ObjectAccessContainer.checkTrackingDocsAccess(FNS_AccessController.DML_OPERATION_UPSERT);
                    
                     uow.commitWork();
                    objValue.put(FNS_Constants.API_RESPONSE,jsonResponse.getBody());
                }
            }
        }
          catch (DMLException ex){
                logger.addLogRecord('FNS_TrackingDocsDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
                objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
            } catch (Exception ex){
                logger.addLogRecord('FNS_TrackingDocsDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
                objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
            }
			return objValue;
    }
    
    /*****************************************************************************************
* @description This class is used to perform DML using json for Task from Tracking Items API.
* @author Praneeth
* @date Mar 22 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
    public static FNS_TrackingDocs__c assignJSONTotrackingDocTypes(FNS_ObjectContainer.FNS_Trackingdocs trackingdocs, String applicationId){
        FNS_TrackingDocs__c docObj = new FNS_TrackingDocs__c();
        try {
            docObj.FNS_Application__c = applicationId;
            docObj.FNS_ApplicationExtId__c = trackingdocs.applicationId;
            docObj.FNS_TrackingItemExtId__c = trackingdocs.trackingItemId;
            docObj.FNS_CustomerExtId__c = trackingdocs.customerId;
            docObj.FNS_DocumentExtId__c = trackingdocs.documentId; 
            docObj.FNS_FileName__c = trackingdocs.description;  
            system.debug('docObj' + docObj);
        } catch (DMLException ex){
            logger.addLogRecord('FNS_TrackingDocsDomain', 'assignJSONTotrackingDocTypes', ex.getMessage() + ex.getStackTraceString()); 
            throw new FNS_CustomException(Label.FNS_CustomException);
        }
        return docObj;
    }
}