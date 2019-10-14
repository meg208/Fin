/**
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Activities
* @description This class is used to get activity data from CME  
*/
public with sharing class FNS_ApplicationWithQueueActivityDomain {
    
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    /*************************************************************************************
    * @description  Method to get all activites based on CME applicationId
    * @Params       application Record 
    * @Returns      response String 
    **************************************************************************************/
    public static HttpResponse getActivitiesForApplication(String applicationExternalId){
        String responseStatus = FNS_Constants.STR_FAILURE; 
        HttpResponse jsonResponse;
        List<FNS_ApplicationWithQueueActivity__c> queueActivityObjList = new List<FNS_ApplicationWithQueueActivity__c>();
        List<String> activityIds = new List<String>(); 
        
        
        String response; 
        try{
            FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
            param.objectName = FNS_Constants.CLASS_QUEUE_ACTIVITIES;
            param.endPoint = FNS_Constants.URL_APPLICATION;
            param.methodName = FNS_Constants.METHOD_GET;
            param.extendedAPIUrl =  applicationExternalId + FNS_Constants.URL_QUEUE_ACTIVITIES_BY_APPLICATION;
          
            param.bypassBackSlash = true; 
            Map<String, String> headerMap = new Map<String, String>();
            headerMap.put(FNS_Constants.CONTENT_TYPE, FNS_Constants.CONTENT_TYPE_URLENCODED);        
            param.headerMap = headerMap;
            
            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            jsonResponse = router.getPostRequest(param);
        }
        catch (Exception ex){
            logger.addLogRecord('FNS_ApplicationWithQueueActivityDomain', 'getActivitiesForApplication', ex.getMessage() + ex.getStackTraceString()); 
        }      
        return jsonResponse;
    }
    
   /*************************************************************************************
    * @description  Method to handle Queue Activity Response 
    * @Params       HTTPResponse 
    * @Returns      null
    **************************************************************************************/
    public static void handleQueueActivityResponse(HTTPResponse jsonResponse){
        List<FNS_ApplicationWithQueueActivity__c> queueActivityObjList = new List<FNS_ApplicationWithQueueActivity__c>();
        List<String> activityIds = new List<String>(); 
        FNS_ActivitiesSelector activitySelector = new FNS_ActivitiesSelector();
        Map<String, FNS_Activity__c> mapActivityRecords = new Map<String, FNS_Activity__c>();
        Integer currentSequenceNumber;
        String applicationExternalId; 
        if(jsonResponse.getStatusCode() == 200){
                if(!String.isEmpty(jsonResponse.getBody())){
       
                    //This Json response will have activities related to the application
                     //This Json response will have activities related to the application
                    // code commented for API 1.0 changes  Start >>>>
                    //List<FNS_ObjectContainer.FNS_QueueActivityRoute > applicationConfigList = (List<FNS_ObjectContainer.FNS_QueueActivityRoute >)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_QueueActivityRoute >.class);
                    List<FNS_ObjectContainer.FNS_QueueActivityRoute > applicationConfigList ;
                    FNS_ObjectContainer listQueueActivity = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);
                    if(listQueueActivity != null && listQueueActivity.queueActivitiesList  != null)
                    {
                       applicationConfigList = listQueueActivity.queueActivitiesList ;
                    }
                    for(FNS_ObjectContainer.FNS_QueueActivityRoute  appConfig : applicationConfigList){
                        activityIds.add(appConfig.activityId); 
                    }

                    //Fetch list of configuration activity records based on the application activityIds
                    List<FNS_Activity__c> activityRecords = activitySelector.getActivitywithId(activityIds); 
                    for(FNS_Activity__c actRecord: activityRecords){
                        mapActivityRecords.put(actRecord.FNS_ActivityExternalId__c, actRecord);
                    }
                    for(FNS_ObjectContainer.FNS_QueueActivityRoute appConfig : applicationConfigList){
                      
                        if(appConfig.current != null && appConfig.current){                    
                            currentSequenceNumber = appConfig.sequenceNumber;  
                            applicationExternalId = appConfig.applicationId; 
                        }
                    }
                    //For each activity, map appropriate fields from the Config data
                    for(FNS_ObjectContainer.FNS_QueueActivityRoute appConfig : applicationConfigList){ 
                        FNS_ApplicationWithQueueActivity__c queueActivityObj = new FNS_ApplicationWithQueueActivity__c(); 
                        queueActivityObj.FNS_ApplicationExternalId__c = appConfig.applicationId;
                        queueActivityObj.FNS_QueueExternalId__c = appConfig.queueActivityId;
                        queueActivityObj.FNS_ActivityExternalId__c = appConfig.activityId; 
                        if(appConfig.current!= null){
                            queueActivityObj.FNS_IsCurrentActivity__c = appConfig.current;
                        }
                        else {
                            queueActivityObj.FNS_IsCurrentActivity__c = false; 
                        }
                        queueActivityObj.FNS_SequenceNumber__c = appConfig.sequenceNumber; 
                        queueActivityObj.FNS_CompletedByUserId__c = appConfig.completedByUserId; 
                        queueActivityObj.FNS_CompletionDate__c = appConfig.completionDate; 
                        queueActivityObj.FNS_CompletionTime__c = appconfig.completionTime; 
                        queueActivityObj.FNS_CreatedByUserId__c = appConfig.createdByUserId; 
                        queueActivityObj.FNS_CreationDate__c = appConfig.creationDate; 
                        queueActivityObj.FNS_DueDate__c = appConfig.dueDate; 
                        queueActivityObj.FNS_DueTime__c = appConfig.dueTime; 
                        queueActivityObj.FNS_GroupDueDate__c = appConfig.groupDueDate;
                        queueActivityObj.FNS_HostIdentifier__c = appConfig.hostSystemInternalIdentifier;
                        queueActivityObj.FNS_JobDueDate__c = appConfig.jobDueDate;
                        queueActivityObj.FNS_LegalBookNumber__c = appConfig.legalBookNumber; 
                        queueActivityObj.FNS_NumberOfHours__c = appConfig.numHours; 
                        queueActivityObj.FNS_ProcessCenterId__c = appConfig.processCenterId; 
                        queueActivityObj.FNS_ProcessGroupId__c = appConfig.processGroupId; 
                        queueActivityObj.FNS_ProcessJobId__c = appConfig.processJobId; 
                        queueActivityObj.FNS_SlaIndicator__c = appConfig.slaIndicator; 
                        queueActivityObj.FNS_SlaPercentage__c = Integer.valueOf(appConfig.slaPercentage.trim());
                        queueActivityObj.FNS_StartDateTime__c = appConfig.startDate; 
                        queueActivityObj.FNS_StartTime__c = appConfig.startTime; 
                        queueActivityObj.FNS_StopClockIndicator__c = appConfig.stopClockIndicator; 
                        queueActivityObj.FNS_ActivityNotes__c = appConfig.note;
                        
                        if(mapActivityRecords.get(appConfig.activityId) != null){
                            queueActivityObj.FNS_Activity__c = mapActivityRecords.get(appConfig.activityId).Id; 
                        }
                        if(queueActivityObj.FNS_ActivityExternalId__c != null){
                            queueActivityObjList.add(queueActivityObj);
                        }
                        
                        
                    }
                    //delete the existing activity records for an application and insert new activity records 
                    if(!queueActivityObjList.isEmpty()){
                        if(applicationExternalId != null){
                            FNS_ApplicationWithQueueActivitySelector queueActivitySelector = new FNS_ApplicationWithQueueActivitySelector(); 
                            List<FNS_ApplicationWithQueueActivity__c> allRecords = queueActivitySelector.getActivitiesWithApplication(applicationExternalId);
                            new FNS_ApplicationWithQueueActivityService().deleteRecords(allRecords);
                            new FNS_ApplicationWithQueueActivityService().insertRecords(queueActivityObjList);
                        }
                    }
                }
         }
    }

    /*************************************************************************************
* @description  To do put callout on submit button 
* @Params       ActivityId, USer, Notes, ApplicationRecord
* @Returns      reponse String
**************************************************************************************/
    public static void routeActivityForApplication(String dataActivityId, User datauser, String datanotes, Opportunity applicationRecord){
        FNS_ApplicationwithQueueActivity__c queueActivityObj = new FNS_ApplicationwithQueueActivity__c();
        List<FNS_ApplicationWithQueueActivity__c> queueActivityList = new List<FNS_ApplicationWithQueueActivity__c>();
        FNS_ObjectContainer.FNS_QueueActivityRoute wrap = new FNS_ObjectContainer.FNS_QueueActivityRoute();
        List<Opportunity> applicationList = new List<Opportunity>();
        HTTPResponse jsonRes;
        HttpResponse jsonResponse; 
         if(dataActivityId != null){
            wrap.activityId =dataActivityId;  
            wrap.note= datanotes;
       
            if(datauser.FNS_UserExternalId__c != null){
                wrap.userId = datauser.FNS_UserExternalId__c;
            }
            
            wrap.applicationId = applicationRecord.FNS_ApplicationExtId__c;
            wrap.current = true; 
            
            FNS_ApplicationwithQueueActivitySelector activtyselector = new FNS_ApplicationwithQueueActivitySelector();
            List<FNS_ApplicationwithQueueActivity__c> actList = activtyselector.getActivitiesRecords(dataActivityId, applicationRecord.FNS_ApplicationExtId__c);
        
            if(actList != null && !actList.isEmpty()){
                wrap.queueActivityId = String.valueOf(actList[0].FNS_QueueExternalId__c);
                wrap.sequenceNumber = Integer.valueOf(actList[0].FNS_Activity__r.FNS_SequenceNumber__c); 
                wrap.completedByUserId = actList[0].FNS_CompletedByUserId__c; 
                wrap.completionDate = actList[0].FNS_CompletionDate__c; 
                wrap.createdByUserId = actList[0].FNS_CreatedByUserId__c; 
                wrap.completionTime= actList[0].FNS_CompletionTime__c; 
                wrap.creationDate= actList[0].FNS_CreationDate__c; 
                wrap.dueDate = actList[0].FNS_DueDate__c; 
                wrap.dueTime = actList[0].FNS_DueTime__c; 
                wrap.groupDueDate =actList[0].FNS_GroupDueDate__c; 
                wrap.hostSystemInternalIdentifier = actList[0].FNS_HostIdentifier__c; 
                wrap.jobDueDate = actList[0].FNS_JobDueDate__c; 
                wrap.legalBookNumber = actList[0].FNS_LegalBookNumber__c; 
                wrap.numHours = actList[0].FNS_NumberOfHours__c; 
                wrap.processCenterId = actList[0].FNS_ProcessCenterId__c; 
                wrap.processGroupId = actList[0].FNS_ProcessGroupId__c; 
                wrap.processJobId = actList[0].FNS_ProcessJobId__c; 
                wrap.slaIndicator = actList[0].FNS_SlaIndicator__c; 
                wrap.slaPercentage = String.valueOf(actList[0].FNS_SlaPercentage__c); 
                wrap.startDate = actList[0].FNS_StartDateTime__c; 
                wrap.startTime = actList[0].FNS_StartTime__c; 
                wrap.stopClockIndicator = actList[0].FNS_StopClockIndicator__c; 

                //update user details and notes on the activity record 
                queueActivityObj.FNS_ActivityNotes__c = datanotes;
                queueActivityObj.FNS_User__c = dataUser.Id;  
                queueActivityObj.Id = actList[0].Id; 
                
                String jsonBody = json.serialize(wrap);
                FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
                param.objectName = FNS_Constants.CLASS_QUEUE_ACTIVITIES;
                param.endPoint = FNS_Constants.URL_QUEUE_ACTIVITIES;
                param.methodName = FNS_Constants.METHOD_PUT;
                param.extendedAPIUrl =  actList[0].FNS_QueueExternalId__c + '/' + FNS_Constants.URL_QUEUE_ACTIVITIES_ROUTE;
                param.body=jsonBody;
                Map<String, String> headerMap = new Map<String, String>();
                headerMap.put(FNS_Constants.CONTENT_TYPE, FNS_Constants.APPLICATION_JSON);        
                param.headerMap = headerMap;
                System.debug('>>>JSON:>>>>' + jsonBody);
                FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
                jsonResponse = router.getPostRequest(param);
                
                if(jsonResponse != null){
                    if(jsonResponse.getStatusCode() == 200){
                        if(queueActivityObj.Id !=null){
                            queueActivityList.add(queueActivityObj);
                            new FNS_ApplicationWithQueueActivityService().updateRecord(queueActivityList); 
                        } 
                    }
                }
            }
        }  
    }
}