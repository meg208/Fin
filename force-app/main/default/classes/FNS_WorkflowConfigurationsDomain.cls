/*********************************************************************************************************************************
    * @description This class is used to insert workflow configuration data into FNS_Activity__c object common for all applications
    * @author Keerthi Kambhampati
    * @date March 5th 2019
    * @Support Email Keerthi@comitydesigns.com
    **********************************************************************************************************************************/
	public with sharing class FNS_WorkflowConfigurationsDomain {

        static FNS_ErrorLog logger = new FNS_ErrorLog();
		
		/*************************************************************************************
        * @description  Method to insert list of activities into FNS_Activity__c object
        * @Params       apexClass, methodName, errorMsg
        * @Returns      none
        * @author       Keerthi@comitydesigns.com
		*************************************************************************************/
        
        public static Object getConfigurations(){

            Map<String, Object> objValue = new Map<String, Object> {
                FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
                FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
                };
            
            try {
                fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { FNS_Activity__c.SObjectType });
                FNS_UpsertUnitOfWorkHelper upsertActivities = new FNS_UpsertUnitOfWorkHelper();
                uow.registerWork(upsertActivities);

                FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
                param.objectName = FNS_Constants.CLASS_WORKFLOW_CONFIGURATIONS;
                param.endPoint = FNS_Constants.URL_WORKFLOW_CONFIGURATIONS;
                param.methodName = FNS_Constants.METHOD_GET;
                FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
                HttpResponse jsonResponse = router.getPostRequest(param);
                if(jsonResponse.getStatusCode() == 200){
                    if (!String.isEmpty(jsonResponse.getBody())){
                        //List<FNS_WorkflowConfigurationsPayload> workflowConfigList = (List<FNS_WorkflowConfigurationsPayload>)JSON.deserialize(jsonResponse.getBody(), List<FNS_WorkflowConfigurationsPayload>.class);
                        FNS_WorkflowConfigurationsPayload workflowConfig = (FNS_WorkflowConfigurationsPayload)JSON.deserialize(jsonResponse.getBody(), FNS_WorkflowConfigurationsPayload.class);

                        List<FNS_Activity__c> activityList = new List<FNS_Activity__c>();
                        for (FNS_WorkflowConfigurationsPayload.FNS_WorkflowConfig config : workflowConfig.workflowConfigurationsList){
                            FNS_Activity__c activityObj = new FNS_Activity__c();
                            activityObj = FNS_WorkflowConfigurationsDomain.assignJSONToActivities(config);
                            upsertActivities.registerActivityUpsert(activityObj);
                        }
                        
                        FNS_ObjectAccessContainer.checkActivityAccess(FNS_AccessController.DML_OPERATION_UPSERT);
                        uow.commitWork();
                        
                        objValue.put(FNS_Constants.API_RESPONSE,jsonResponse.getBody());		
                    }
                }
            } catch (DMLException ex){
                logger.addLogRecord('FNS_WorkflowConfigurationsDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
                objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
            } catch (Exception ex){
                logger.addLogRecord('FNS_WorkflowConfigurationsDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
                objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
            }
			return objValue;
		}
		
        /*************************************************************************************
            * @description  Method to prepare the FNS_Activity__c object data based on JSON
            * @Params       FNS_WorkflowConfigurationPayload 
            * @Returns      FNS_Activity__c object
            * @author       Keerthi@comitydesigns.com
        *************************************************************************************/    
        private static FNS_Activity__c assignJSONToActivities(FNS_WorkflowConfigurationsPayload.FNS_WorkflowConfig payload){
            FNS_Activity__c activity = new FNS_Activity__c();
            try {
                activity.FNS_ActivityExternalId__c = payload.activity.activityId;
                activity.FNS_Description__c = payload.activity.description;
                activity.FNS_SequenceNumber__c = payload.sequenceNumber;
                if(payload.nextDefaultactivity != null){
                    activity.FNS_NextDefaultActivityId__c = payload.nextDefaultactivity.activityId;
                }
                String actValue = '';
                for(FNS_ObjectContainer.FNS_Activity act : payload.nextAvailableActivities){
                    actValue += act.activityId + ',' ;
                }
                if(actValue.length() > 0){
                activity.FNS_NextAvailableActivityIds__c = actValue.removeEnd(',');
                }
            } catch (Exception ex){
                logger.addLogRecord('FNS_WorkflowConfigurationsDomain', 'assignJSONToActivities', ex.getMessage() + ex.getStackTraceString()); 
            }
            return activity;
        }
	}