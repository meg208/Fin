/**
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Activities
* @description Server side controller to do all DML operation for FNS_Activites component 
*/
public with sharing class FNS_ActivityComponentController {
    
    public static FNS_ErrorLog logger = new FNS_ErrorLog();
    public static String applicationExternalId; 
    
    /*************************************************************************************
* @description  Initiate Application APIs 
* @Params       application Record Id
* @Returns      applicationExtId as String
**************************************************************************************/
    /*@AuraEnabled*/
    private static String initiateApplicationAPIs(Id applicationRecordId){
        List<Opportunity> applicationList;
        String applicationExternalId='';
        try {
            applicationList = getApplicationExternalId(applicationRecordId);
            applicationExternalId = applicationList[0].FNS_ApplicationExtId__c;
            
            //Application API call to fetch Application data 
            HTTPResponse queueActivitiesRes= FNS_ApplicationWithQueueActivityDomain.getActivitiesForApplication(applicationExternalID);
            if(queueActivitiesRes.getStatusCode() == 200){
                FNS_ApplicationWithQueueActivityDomain.handleQueueActivityResponse(queueActivitiesRes); 
                
            }
        }
        catch(Exception ex){
            logger.addLogRecord('FNS_ActivityComponentController', 'initiateApplicationAPIs', ex.getMessage() + ex.getStackTraceString());
        }
        return applicationExternalId;
    }
    
    /*************************************************************************************
* @description  Wrapper to return for getAllActivities method 
* @Params       none
* @Returns      none
**************************************************************************************/
    public with sharing class ActivitiesWrapper{
        List<ActivityWrapper> activitiesListWrapper = new List<ActivityWrapper>();
        Map<Integer,List<ActivityWrapper>> fnsRouteActivityMapValuesWrapper = new Map<Integer,List<ActivityWrapper>>();
    }
    
    /*************************************************************************************
* @description  Constructs response wrapper for FNS_Activities component
* @Params       Application External Id 
* @Returns      ActivitiesWrapper as String
**************************************************************************************/
    @AuraEnabled
    public static Object getAllActivities(String applicationRecordId){
        Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
            FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
        };
        String applicationExternalId = initiateApplicationAPIs(applicationRecordId);
        if (applicationExternalId!=null && applicationExternalId.length()>0){
            
                        
            List<ActivityWrapper> activityListWrapper = new List<ActivityWrapper>();
            Map<String, List<FNS_ApplicationWithQueueActivity__c>> mapQueueActivity = new Map<String, List<FNS_ApplicationWithQueueActivity__c>>();         
            ActivitiesWrapper activitiesWrapper = new ActivitiesWrapper();
            List<FNS_ApplicationWithQueueActivity__c> activityQueueList = new List<FNS_ApplicationWithQueueActivity__c>(); 
            Map<Integer,List<ActivityWrapper>> fnsRouteActivityMapValues = new Map<Integer,List<ActivityWrapper>>();  
            FNS_ApplicationWithQueueActivity__c currentActivity = new FNS_ApplicationWithQueueActivity__c(); 
            Integer currentSequenceNumber; 
            String response; 
            List<FNS_Activity__c> activityList = new List<FNS_Activity__c>(); 
            
            try{
                System.debug('--1--');
                activityList = new FNS_ActivitiesSelector().getAllActivities(); 
                if(!String.isEmpty(applicationExternalId)){
                    activityQueueList = new FNS_ApplicationWithQueueActivitySelector().getActivitiesWithApplication(applicationExternalId);
                }
                System.debug('--2--');
                for(FNS_Activity__c activity: activityList){
                    List<FNS_ApplicationWithQueueActivity__c> queuelist = new List<FNS_ApplicationWithQueueActivity__c>(); 
                    for(FNS_ApplicationWithQueueActivity__c queue: activityQueueList){ 
                        if(activity.FNS_ActivityExternalId__c.equalsIgnoreCase(queue.FNS_ActivityExternalId__c)){
                            queuelist.add(queue); 
                        }
                    }
                    mapQueueActivity.put(activity.FNS_ActivityExternalId__c, queuelist); 
                }
                System.debug('--3--');
                
                //Fetch list of activities based on Application External ID
                for(FNS_ApplicationWithQueueActivity__c a: activityQueueList){
                    if(a.FNS_IsCurrentActivity__c){
                        currentActivity = a; 
                    }
                }
                System.debug('--4--');
                
                for(FNS_Activity__c activity : activityList){
                    if(currentActivity.FNS_ActivityExternalId__c == activity.FNS_ActivityExternalId__c){
                        currentSequenceNumber = Integer.valueOf(activity.FNS_SequenceNumber__c); 
                    }
                }
                System.debug('--5--');
    
                if(activityList != null && !activityList.isEmpty()){
                    System.debug('--6--');
    
                    //To assign values in the ActivityWrapper
                    for(FNS_Activity__c queue: activityList){
                        ActivityWrapper wrap = new ActivityWrapper();
                        wrap.Description = queue.FNS_Description__c; 
                        wrap.SequenceNumber = Integer.valueOf(queue.FNS_SequenceNumber__c); 
                        wrap.NextDefaultActivity = queue.FNS_NextDefaultActivityId__c;
                        wrap.NextActivities = queue.FNS_NextAvailableActivityIds__c; 
                        wrap.ActivityExternalId = queue.FNS_ActivityExternalId__c; 
                        if(queue.FNS_ActivityExternalId__c == currentActivity.FNS_ActivityExternalId__c){
                            wrap.ActivityNotes = currentActivity.FNS_ActivityNotes__c; 
                        }
                        else if(mapQueueActivity.keySet().contains(queue.FNS_ActivityExternalId__c)){
                            if(mapQueueActivity.get(queue.FNS_ActivityExternalId__c).size() > 0){
                                if(mapQueueActivity.get(queue.FNS_ActivityExternalId__c)[0].FNS_ActivityNotes__c != null){
                                    wrap.ActivityNotes = mapQueueActivity.get(queue.FNS_ActivityExternalId__c)[0].FNS_ActivityNotes__c; 
                                }
                            }
                        } 
                        if(queue.FNS_SequenceNumber__c < currentSequenceNumber){
                            wrap.Status = FNS_Constants.COMPLETED; 
                        }
                        else if(queue.FNS_SequenceNumber__c > currentSequenceNumber){
                            wrap.Status = FNS_Constants.PENDING; 
                        }
                        else if(queue.FNS_SequenceNumber__c == currentSequenceNumber){
                            wrap.Status = FNS_Constants.CURRENT;
                            wrap.IsCurrent = true; 
                        }
                        if(wrap.Description != null){
                            activityListWrapper.add(wrap);
                        }
                        System.debug('--7--');
                    }
                    System.debug('--8--');
    
                }
                System.debug('--9-- activityListWrapper '+activityListWrapper);
                
                if(activityListWrapper != null && !activityListWrapper.isEmpty()){
                    System.debug('--10--');
                    for(ActivityWrapper activity : activityListWrapper){
                        List<String> activityStringList = new List<String>();
                        List<String> finalActivityStringList = new List<String>();
                        List<ActivityWrapper> activityListForMapValues = new List<ActivityWrapper>();
                        
                        //To fetch list of next activities
                        if(activity.IsCurrent != null){
                            if(activity.IsCurrent){
                                if(activity.NextActivities != null){
                                    activityStringList = activity.NextActivities.split(',');    
                                }
                                
                                //To fetch next default activity
                                if(activity.NextDefaultActivity != null){
                                    finalActivityStringList.add(String.valueOf(activity.NextDefaultActivity));    
                                }
                                
                                //Merge default activity and next activities
                                for(String activityId : activityStringList){
                                    finalActivityStringList.add(activityId);
                                }
                                //Assign values to map for dropdown on UI
                                Set<String> routeActivityset = new Set<String>(finalActivityStringList);
                                for(String activityId : routeActivityset){  
                                    for(ActivityWrapper innerActivity : activityListWrapper){
                                        if(((innerActivity.ActivityExternalId).trim()).equalsIgnoreCase(activityId.trim())){
                                            activityListForMapValues.add(innerActivity);                       
                                        }
                                    }
                                }
                                if(activity.ActivityExternalId != null){
                                    fnsRouteActivityMapValues.put(Integer.valueOf(activity.ActivityExternalId.trim()),activityListForMapValues);
                                }
                            }
                        }
                    }
                }
                System.debug('activityListWrapper --->>>'+activityListWrapper);
                activitiesWrapper.activitiesListWrapper = activityListWrapper;
                activitiesWrapper.fnsRouteActivityMapValuesWrapper = fnsRouteActivityMapValues;
                objValue.put(FNS_Constants.API_RESPONSE,JSON.serialize(activitiesWrapper,true));    
            }
            catch(Exception ex){
                logger.addLogRecord('FNS_ActivityComponentController', 'getAllActivities', ex.getMessage() + ex.getStackTraceString());
                System.debug('ERROR IN ACTIVITIES '+ex.getMessage());
    
                objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
            }
        } else {
            //deal with error here
        }
        return objValue; 
    }
    
    /*************************************************************************************
* @description  To do put callout on submit button 
* @Params       ActivityId, USer, Notes, ApplicationRecordId
* @Returns      reponse String
**************************************************************************************/
    @AuraEnabled
    public static String getPutCalloutResponse(String dataActivityId, User datauser, String datanotes, Id recId) {
        String response;
        try{
            List<Opportunity> applicationList = getApplicationExternalId(recId);
            if(applicationList != null && !applicationList.isEmpty()){
                applicationExternalId = applicationList[0].FNS_ApplicationExtId__c; 
            }
            System.debug('>>> BEFORE CALLING ROUTE>>>' + dataActivityId);
            FNS_ApplicationWithQueueActivityDomain.routeActivityForApplication(dataActivityId, dataUser, datanotes, applicationList[0]); 
            
        }
        catch(Exception ex){
            logger.addLogRecord('FNS_ActivityComponentController', 'getPutCalloutResponse', ex.getMessage() + ex.getStackTraceString());
        }
        
        return response;
    }
    
    /*************************************************************************************
* @description  To fetch the application external Id based on application Id 
* @Params       ApplicationRecordId
* @Returns      List of Opportunities

**************************************************************************************/
    @AuraEnabled
    public static List<Opportunity> getApplicationExternalId(Id applicationRecordId){
        List<Opportunity> applicationList = new List<Opportunity>(); 
        FNS_ApplicationSelector applicationSelector = new FNS_ApplicationSelector(); 
        applicationList = applicationSelector.getApplicationId(applicationRecordId);
        return applicationList;
    }
    
    /*************************************************************************************
* @description  Wrapper to return for getAllActivities method 
* @Params       none
* @Returns      none
**************************************************************************************/
    public with sharing class ActivityWrapper{
        String Description; 
        Integer SequenceNumber;
        String NextDefaultActivity; 
        String NextActivities; 
        String ActivityExternalId;
        String ApplicationId; 
        Boolean IsCurrent; 
        String Status; 
        String ActivityNotes; 
    }
}