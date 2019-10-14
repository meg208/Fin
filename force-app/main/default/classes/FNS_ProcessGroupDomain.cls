/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description This class is used to perform DML using json for an Application.
****************************************************************************************/
public with sharing class FNS_ProcessGroupDomain {

    static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    public static Object getConfigurations(){

        Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
            FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
            };

        try {

            fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { FNS_ProcessGroup__c.SObjectType });
            FNS_UpsertUnitOfWorkHelper upsertProcessGroups = new FNS_UpsertUnitOfWorkHelper();
            uow.registerWork(upsertProcessGroups);
            
            FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
            param.objectName = FNS_Constants.CLASS_PROCESS_GROUPS;
            param.endPoint = FNS_Constants.URL_PROCESS_GROUPS;
            param.methodName = FNS_Constants.METHOD_GET;
            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            HttpResponse jsonResponse = router.getPostRequest(param);
            if(jsonResponse.getStatusCode() == 200){
                if (!String.isEmpty(jsonResponse.getBody())){
                    List<FNS_ProcessGroup__c> processGroupList = new List<FNS_ProcessGroup__c>();            
                    ///List<FNS_ObjectContainer.FNS_ProcessGroup> processGroupConfigList = (List<FNS_ObjectContainer.FNS_ProcessGroup>)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_ProcessGroup>.class);            
                    //for(FNS_ObjectContainer.FNS_ProcessGroup pcpayload : processGroupConfigList){
                    FNS_ObjectContainer processGroupConfigList = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);            
                    for(FNS_ObjectContainer.FNS_ProcessGroup pcpayload : processGroupConfigList.processGroupsList){
                    
                        FNS_ProcessGroup__c processGroup = new FNS_ProcessGroup__c();
                        processGroup = FNS_ProcessGroupDomain.assignJSONToActivities(pcpayload);
                        upsertProcessGroups.registerProcessGroupUpsert(processGroup);
                    }
                    
                    FNS_ObjectAccessContainer.checkProcessGroupAccess(FNS_AccessController.DML_OPERATION_UPSERT);
                    uow.commitWork();                    
                    
                    objValue.put(FNS_Constants.API_RESPONSE,jsonResponse.getBody());		
                }   
            }
        } catch (DMLException ex){
            logger.addLogRecord('FNS_ProcessGroupDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        } catch (Exception ex){
            logger.addLogRecord('FNS_ProcessGroupDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        }
        return objValue; 
    }
    //Keerthi - Mapping the fields
    public static FNS_ProcessGroup__c assignJSONToActivities(FNS_ObjectContainer.FNS_ProcessGroup processGroup){
        FNS_ProcessGroup__c processGroupObj = new FNS_ProcessGroup__c();

        try {
            processGroupObj.FNS_Description__c = processGroup.description;
            processGroupObj.FNS_NextDefaultProcessGroupId__c = processGroup.nextDefaultProcessGroupId;
            processGroupObj.FNS_InactiveIndicator__c = processGroup.inactiveIndicator;        
            processGroupObj.FNS_ProcessGroupExtId__c = processGroup.processGroupId;
        } catch (Exception ex){
            logger.addLogRecord('FNS_ProcessGroupDomain', 'assignJSONToActivities', ex.getMessage() + ex.getStackTraceString()); 
        }
        return processGroupObj;
    }
    
}