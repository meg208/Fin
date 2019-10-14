/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description This class is used to perform DML using json for an ProcessCenter.
****************************************************************************************/
public with sharing class FNS_ProcessCenterDomain {

    static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    public static Object getConfigurations(){     

        Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
            FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
            };

        try {

            fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { FNS_ProcessCenter__c.SObjectType });
            FNS_UpsertUnitOfWorkHelper upsertProcessCenters = new FNS_UpsertUnitOfWorkHelper();
            uow.registerWork(upsertProcessCenters);

            FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
            param.objectName = FNS_Constants.CLASS_PROCESS_CENTERS;
            param.endPoint = FNS_Constants.URL_PROCESS_CENTERS;
            param.methodName = FNS_Constants.METHOD_GET;
            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            HttpResponse jsonResponse = router.getPostRequest(param);
            if(jsonResponse.getStatusCode() == 200){
                if (!String.isEmpty(jsonResponse.getBody())){
                    List<FNS_ProcessCenter__c> processCenterList = new List<FNS_ProcessCenter__c>(); 
                    //List<FNS_ObjectContainer.FNS_ProcessCenter> processCenterConfigList = (List<FNS_ObjectContainer.FNS_ProcessCenter>)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_ProcessCenter>.class);
                    //for(FNS_ObjectContainer.FNS_ProcessCenter pcpayload : processCenterConfigList){
                    FNS_ObjectContainer processCenterConfigList = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);
                    for(FNS_ObjectContainer.FNS_ProcessCenter pcpayload : processCenterConfigList.processCentersList){
                    	FNS_ProcessCenter__c processCenter = new FNS_ProcessCenter__c();
                        processCenter = FNS_ProcessCenterDomain.assignJSONToActivities(pcpayload);
                        upsertProcessCenters.registerProcessCenterUpsert(processCenter);
                    }
                    
                    FNS_ObjectAccessContainer.checkProcessCenterAccess(FNS_AccessController.DML_OPERATION_UPSERT);
                    uow.commitWork();                   
                
                    objValue.put(FNS_Constants.API_RESPONSE,jsonResponse.getBody());		
                }   
            }
        } catch (DMLException ex){
            logger.addLogRecord('FNS_ProcessCenterDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        } catch (Exception ex){
            logger.addLogRecord('FNS_ProcessCenterDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        }
        return objValue;
    }
    //Keerthi - Mapping the fields
    public static FNS_ProcessCenter__c assignJSONToActivities(FNS_ObjectContainer.FNS_ProcessCenter processCenter){
        FNS_ProcessCenter__c processCenterObj = new FNS_ProcessCenter__c();
        try {
            processCenterObj.FNS_State__c = processCenter.state;
            processCenterObj.Name = processCenter.processCenterName;
            processCenterobj.FNS_ProcessCenterNumber__c = processCenter.processCenterNumber;
            processCenterObj.FNS_StreetNumber__c = processCenter.streetNumber;
            processCenterObj.FNS_StreetName__c = processCenter.streetName;
            processCenterObj.FNS_AddressLine__c = processCenter.addressLine1;
            processCenterObj.FNS_City__c = processCenter.city;
            processCenterObj.FNS_County__c = processCenter.county;
            processCenterObj.FNS_Zip__c = processCenter.zip;
            processCenterobj.FNS_ProcessCenterExtId__c = processCenter.processCenterId;
        } catch (Exception ex){
            logger.addLogRecord('FNS_ProcessCenterDomain', 'assignJSONToActivities', ex.getMessage() + ex.getStackTraceString()); 
        }
        return processCenterObj;
    }
    
}