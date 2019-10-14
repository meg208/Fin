/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Fee Type
    * @description get Configuration Data from CME and update object.
  */
public with sharing class FNS_FeeTypeDomain {

    static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    /**
        * @description get the Fee Type configuration data from CME. 
        * @return a json string
		*/ 
    public static Object getConfigurations(){

        Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
            FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
            };

        try {

            fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { FNS_FeeType__c.SObjectType });
            FNS_UpsertUnitOfWorkHelper upsertFeeTypes = new FNS_UpsertUnitOfWorkHelper();
            uow.registerWork(upsertFeeTypes);

            FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
            param.objectName = FNS_Constants.CLASS_FEE_TYPES;
            param.endPoint = FNS_Constants.URL_FEE_TYPES ;
            param.methodName = FNS_Constants.METHOD_GET;

            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            HttpResponse jsonResponse = router.getPostRequest(param);

            if(jsonResponse.getStatusCode() == 200){
                if (!String.isEmpty(jsonResponse.getBody())){
                    FNS_ObjectContainer feeTypeList = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);
                    List<FNS_FeeType__c> feeTypeObjList = new List<FNS_FeeType__c>();
                    for (FNS_ObjectContainer.FNS_FeeType feetypayload : feeTypeList.feeTypesList){
                        FNS_FeeType__c feeTypeObj = new FNS_FeeType__c();
                        feeTypeObj = FNS_FeeTypeDomain.assignJSONToFeeTypes(feetypayload);
                        upsertFeeTypes.registerFeeTypeUpsert(feeTypeObj);
                    }
                    
                    FNS_ObjectAccessContainer.checkFeeTypeAccess(FNS_AccessController.DML_OPERATION_UPSERT);
                    uow.commitWork();
                    
                }
                objValue.put(FNS_Constants.API_RESPONSE,jsonResponse.getBody());		
            }
        } catch (DMLException ex){
            logger.addLogRecord('FNS_FeeTypeDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        } catch (Exception ex){
            logger.addLogRecord('FNS_FeeTypeDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        }
        return objValue;
    }
	/**
        * @description get the Fee Type Object record. 
        * @param Fee Type wrapper 
        * @return Fee Type Object
        */ 
    //Keerthi - Mapping the fields
    public static FNS_FeeType__c assignJSONToFeeTypes(FNS_ObjectContainer.FNS_FeeType feeType){
        FNS_FeeType__c feeTypeObj = new FNS_FeeType__c();
        //TODO - currencyType
        //TODO - defaultAmount
        feeTypeObj.FNS_Description__c = feeType.description;
        feeTypeObj.FNS_FeeTypeExternalId__c = feeType.feeTypeId; 
        return feeTypeObj;
    }
	
    /**
        * @description insert the global picklist value set. 
        * @param Fee Type records list 
        * @return null
        */ 
    public static void insertInGlobalPicklist(List<FNS_FeeType__c> feeTypeInsertList){
        FNS_FeeTypeDomain.mapDataAndPerformDML(feeTypeInsertList,FNS_Constants.CONFIG_DMLTYPE_INSERT);
    }
	
	/**
        * @description update the global picklist value set
        * @param Fee Type records list
        * @return null
        */ 
    public static void updateInGlobalPicklist(List<FNS_FeeType__c> feeTypeUpdateList){
        FNS_FeeTypeDomain.mapDataAndPerformDML(feeTypeUpdateList,FNS_Constants.CONFIG_DMLTYPE_UPDATE);
    }
	
	/**
        * @description update the global picklist value set
        * @param Fee Type records List
		* @param DML type INSERT,UPDATE
        * @return null
        */  
    private static void mapDataAndPerformDML(List<FNS_FeeType__c> configInsertList, String dmlType){
        String[] feeTypeList = new String[0];
		Set<String> feeTypeLabels= new Set<String>();

        for(FNS_FeeType__c feeType : configInsertList){
            if(!feeTypeLabels.contains(feeType.FNS_Description__c)){
                feeTypeList.add('{"valueName":"'+feeType.FNS_FeeTypeExternalId__c+'","label":"'+feeType.FNS_Description__c+'"}');      
                feeTypeLabels.add(feeType.FNS_Description__c);
            }
        }

		String feeTypeVal = String.join(feeTypeList, ', ');
        if(dmlType.equalsIgnoreCase(FNS_Constants.CONFIG_DMLTYPE_INSERT)){           
            if(String.isNotEmpty(feeTypeVal)){
                FNS_ConfigurationDomain.updateNow(feeTypeVal,FNS_Constants.GLOBAL_FEETYPE_PICKLIST); 
            }
        } else {     
            if(String.isNotEmpty(feeTypeVal)){
                FNS_ConfigurationDomain.updateNow(feeTypeVal,FNS_Constants.GLOBAL_FEETYPE_PICKLIST); 
            }
        }
    }
    
}