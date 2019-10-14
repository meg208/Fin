/*****************************************************************************************
* @description This class is used to perform DML using json for Task from Tracking Items API.
* @author Praneeth
* @date Mar 22 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_TrackingItemsDomain {
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    //Praneeth - Make API call to fetch list of Tracking items based on Application Record Id and insert into Salesforce
    public static Object getConfigurations(String apprecId){//TODO change to applicationRecordId
        Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
                FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
                };
		try {
			String applicationExtId;
			String stageName;
			String responseState = FNS_Constants.STR_FAILURE;
			FNS_TrackingItemsSelector taskSelector = new FNS_TrackingItemsSelector(); 
			Map<String, Id> taskMap = new Map<String, Id>(); 
			if(apprecId != null){
				List<Task> tskList= taskSelector.getAllItems(apprecId);
				if(tskList != null){
					for(Task t: tskList){
						if(t.FNS_TrackingItemExtId__c != null){
							taskMap.put(t.FNS_TrackingItemExtId__c, t.Id); 
						}
					}
				}
			}
			
			FNS_ApplicationSelector applicationSelector = new FNS_ApplicationSelector(); 
			List<Opportunity> applicationList = applicationSelector.getApplicationId(apprecId);
			if(!applicationList.isEmpty()) {
				applicationExtId = applicationList[0].FNS_ApplicationExtId__C;
				stageName = applicationList[0].StageName;
			}
			String applicationId = apprecId;
			
			FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
			param.objectName = FNS_Constants.CLASS_TRACKING_ITEMS;
			param.endPoint = FNS_Constants.URL_APPLICATION;
			param.bypassBackSlash = true;
			param.methodName = FNS_Constants.METHOD_GET;
			param.extendedAPIUrl = applicationExtId + '/' +FNS_Constants.URL_TRACKING_ITEMS;
			
			Map<String, String> headerMap = new Map<String, String>();
			headerMap.put(FNS_Constants.CONTENT_TYPE, FNS_Constants.APPLICATION_JSON);
			param.headerMap = headerMap;
			
			FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
			HttpResponse jsonResponse = router.getPostRequest(param);
			if(jsonResponse.getStatusCode() == 200){
				if (!String.isEmpty(jsonResponse.getBody())) {
					// code for API 1.0 changes  Start >>>>
					System.debug('>>>jsonResponse.getBody()' + jsonResponse.getBody() );
					// List<FNS_ObjectContainer.FNS_TrackingItem> trackingItemList = (List<FNS_ObjectContainer.FNS_TrackingItem>)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_TrackingItem>.class);
					List<FNS_ObjectContainer.FNS_TrackingItem> trackingItemList ;
					FNS_ObjectContainer listTrackingItem = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);
					if(listTrackingItem != null && listTrackingItem.trackingItemsList != null ){
						trackingItemList = listTrackingItem.trackingItemsList;
						//System.debug('>trackingItemList.size()>>>' + trackingItemList.size() );
						System.debug('>>trackingItemList>>' + trackingItemList );
						List<Task> taskObjList = new List<Task>();
						for (FNS_ObjectContainer.FNS_TrackingItem tasktypayload : trackingItemList){
							taskObjList.add(FNS_TrackingItemsDomain.assignJSONTotrackingTypes(tasktypayload, StageName,applicationId, taskMap,applicationExtId));
						}
						if(!taskObjList.isEmpty()){
							new FNS_TrackingItemsService().upsertRecords(taskObjList);
							objValue.put(FNS_Constants.API_RESPONSE,jsonResponse.getBody());   
						}
					}
					//>>>> API 1.0 chnages Ends
				} 
			}
		}
        catch (DMLException ex){
            //logger.addLogRecord('FNS_TrackingItemsDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
            System.debug('>>>>Exception>>' +ex.getMessage() + 'Line Number' + ex.getLineNumber()  + 'getStackTraceString'  +ex.getStackTraceString());
            throw new FNS_CustomException(ex.getmessage());
        } catch (Exception ex){
            //logger.addLogRecord('FNS_TrackingItemsDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
            System.debug('>>>>Exception>>' +ex.getMessage() + 'Line Number' + ex.getLineNumber()  + 'getStackTraceString'  +ex.getStackTraceString());
            throw new FNS_CustomException(ex.getmessage());
        }
        return objValue;
    }
    
    public static task assignJSONTotrackingTypes(FNS_ObjectContainer.FNS_TrackingItem trackingType, String StageName, String applicationId, Map<String, Id> taskMap, String applicationExtId ){
        
        String custValue = '';
        String loanValue = '';
        String locValue = '';		
        String userValue = '';
        List<String> taskExtIdList = new List<String>(taskMap.KeySet());
        Task taskObj = new Task();
        try{
            if(taskExtIdList.contains(trackingType.trackingItemId)){
                taskObj.Id = taskMap.get(trackingType.trackingItemId); 
            }
            
            taskObj.Subject = trackingType.description;
            if(trackingType.comments != null){
                taskObj.FNS_Comments__c = trackingType.comments;
            }
            if(trackingType.dueDate == null) {
                taskObj.FNS_DueDate__c = '';
            } else {
                taskObj.FNS_DueDate__c = trackingType.dueDate.subString(0,10);
            }
            if(trackingType.priorityId != null && trackingType.priorityId != 0){
                taskObj.FNS_Priority__c = String.valueOf(trackingType.priorityId);            
            }
            taskObj.description = trackingType.notes;
            taskObj.FNS_TrackStatusId__c = trackingType.trackStatusId;
            taskObj.FNS_Status__c = trackingType.trackStatusId;
            taskObj.FNS_TrackingItemExtId__c = trackingType.trackingItemId;
            taskObj.FNS_SLAPercentage__c = trackingType.slaPercentage;
            taskObj.FNS_SLAIndicator__c = trackingType.slaIndicator;
            
            taskObj.FNS_PrintStatusId__c = trackingType.printStatusId;
            taskObj.FNS_PrimaryRelationship__c = trackingType.primaryRelationship;
            taskObj.FNS_PackageExtId__c = trackingType.pkgId;
            taskObj.FNS_ApplicationExtId__c = applicationExtId;
            taskObj.FNS_ApplicationStageName__c = stageName;
            taskObj.whatid = applicationId;
            
            if(trackingType.refresh == null) {
                taskObj.FNS_Refresh__c = false;
            } else {
                taskObj.FNS_Refresh__c = trackingType.refresh;
            }
            if(trackingType.isActive == null) {
                taskObj.FNS_IsActive__c = false;
            } else {
                taskObj.FNS_IsActive__c = trackingType.isActive;
            }
            if(trackingType.isChecklist == null) {
                taskObj.FNS_isChecklist__c = false;
            } else {
                taskObj.FNS_isChecklist__c = trackingType.isChecklist;
            }
            if(trackingType.keepOnRefresh == null) {
                taskObj.FNS_KeepOnRefresh__c = false;
            } else {
                taskObj.FNS_KeepOnRefresh__c = trackingType.keepOnRefresh;
            }
            if(trackingType.isVerified == null) {
                taskObj.FNS_IsVerified__c = false;
            } else {
                taskObj.FNS_IsVerified__c = trackingType.isVerified;
            }
            if(trackingType.isStandard == null) {
                taskObj.FNS_IsStandard__c = false;
            } else {
                taskObj.FNS_IsStandard__c = trackingType.isStandard;
            }
            if(trackingType.isCSA == null) {
                taskObj.FNS_IsCSA__c = false;
            } else {
                taskObj.FNS_IsCSA__c = trackingType.isCSA;
            }
            
            
            if(trackingType.customerIds == null) {
                taskObj.FNS_CustomerExtIds__c = null;
            }else { 
                for(String cust : trackingType.customerIds){
                    custValue += cust+ ',' ;
                }
                if(custValue.length() > 0){
                    taskObj.FNS_CustomerExtIds__c = custValue.removeEnd(',');
                }
            }
            
            if(trackingType.customerIds == null) {
                taskObj.FNS_FinancialAccountTransactionId__c = null;
            }else {
                for(String loan : trackingType.customerIds){
                    loanValue += loan+ ',' ;
                }
                if(loanValue.length() > 0){
                    taskObj.FNS_FinancialAccountTransactionId__c = loanValue.removeEnd(',');
                }
            }
            
            
            if(trackingType.linesOfCreditId == null) {
                taskObj.FNS_FinancialAccountExtId__c = null;
            }else {
                for(String loc : trackingType.linesOfCreditId){
                    locValue += loc+ ',' ;
                }
                if(locValue.length() > 0){
                    taskObj.FNS_FinancialAccountExtId__c = locValue.removeEnd(',');
                }
            }
            
            if(trackingType.userIds == null) {
                taskObj.FNS_UserExtId__c = null;
            }else {
                for(String user : trackingType.userIds){
                    userValue += user+ ',' ;
                }
                if(userValue.length() > 0){
                    taskObj.FNS_UserExtId__c = userValue.removeEnd(',');
                }  
            }
            
            
        }catch(Exception ex){
            logger.addLogRecord('FNS_TrackingItemsDomain', 'assignJSONTotrackingTypes', ex.getMessage() + ex.getStackTraceString()); 
            throw new FNS_CustomException(Label.FNS_CustomException);
        }
       
        return taskObj;       
        
    }   
    
    public static String calloutToCME (String trackingId, String jsonBody) {
        String responseState = FNS_Constants.STR_FAILURE;
        String responseBody;
        String responseCode;
        try {
            FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
            param.objectName = FNS_Constants.CLASS_TRACKING_ITEMS;
            param.endPoint = FNS_Constants.URL_TRACKING_ITEMSAPI;
            param.bypassBackSlash = true;
            param.methodName = FNS_Constants.METHOD_PUT;
            param.extendedAPIUrl =  FNS_Constants.URL_TRACKING_ITEMS +  trackingId ;
            param.body = jsonBody;
            Map<String, String> headerMap = new Map<String, String>();
            headerMap.put(FNS_Constants.CONTENT_TYPE, FNS_Constants.APPLICATION_JSON);
            param.headerMap = headerMap;
            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            HttpResponse jsonResponse = router.getPostRequest(param);
            if(jsonResponse.getStatusCode() == 200){ 
                responseState = FNS_Constants.STR_SUCCESS;
            } else {
                responseState = FNS_Constants.STR_FAILURE;
            }
            
        }catch(Exception ex){
            logger.addLogRecord('FNS_TrackingItemsDomain', 'calloutToCME', ex.getMessage() + ex.getStackTraceString()); 
            throw new FNS_CustomException(Label.FNS_CustomException);
        }
        return responseState;
    }
    
}