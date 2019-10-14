/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description This class is used to perform DML using json for an Application.
****************************************************************************************/
public with sharing class FNS_ProductTypeDomain {

    static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    public static Object getConfigurations(){

        Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
            FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
            };

        try {

            fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { FNS_ProductType__c.SObjectType });
            FNS_UpsertUnitOfWorkHelper upsertProductTypes = new FNS_UpsertUnitOfWorkHelper();
            uow.registerWork(upsertProductTypes);
            
            FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
            param.objectName = FNS_Constants.CLASS_PRODUCT_TYPES;
            param.endPoint = FNS_Constants.URL_PRODUCT_TYPES;
            param.methodName = FNS_Constants.METHOD_GET;
            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            HttpResponse jsonResponse = router.getPostRequest(param);
            if(jsonResponse.getStatusCode() == 200){
                if (!String.isEmpty(jsonResponse.getBody())){
                    //List<FNS_ObjectContainer.FNS_ProductType> productTypeConfigList = (List<FNS_ObjectContainer.FNS_ProductType>)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_ProductType>.class);
                    //List<FNS_ProductType__c> productTypeList = new List<FNS_ProductType__c>();
                    //for (FNS_ObjectContainer.FNS_ProductType productTypeConfig : productTypeConfigList){
                    FNS_ObjectContainer productTypeConfigList = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);
                    List<FNS_ProductType__c> productTypeList = new List<FNS_ProductType__c>();
                    for (FNS_ObjectContainer.FNS_ProductType productTypeConfig : productTypeConfigList.productTypesList){
                        FNS_ProductType__c productType = new FNS_ProductType__c();
                        productType = FNS_ProductTypeDomain.assignJSONToBank(productTypeConfig);
                        upsertProductTypes.registerProductTypeUpsert(productType);
                    }
                    
                    FNS_ObjectAccessContainer.checkProductTypeAccess(FNS_AccessController.DML_OPERATION_UPSERT);
                    uow.commitWork();                   
                    
                    objValue.put(FNS_Constants.API_RESPONSE,jsonResponse.getBody());		
                }   
            }
        } catch (DMLException ex){
            logger.addLogRecord('FNS_ProductTypeDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        } catch (Exception ex){
            logger.addLogRecord('FNS_ProductTypeDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        }
        return objValue;
    }
    
    public static FNS_ProductType__c assignJSONToBank(FNS_ObjectContainer.FNS_ProductType productType){
        FNS_ProductType__c productTypeObj = new FNS_ProductType__c();
        try {
            productTypeObj.FNS_Description__c  = productType.description;
            productTypeObj.FNS_HierarchyIndicator__c  = productType.hierarchyIndicator;
            productTypeObj.FNS_ProductTypeExternalId__c = productType.productTypeId;
        } catch (Exception ex){
            logger.addLogRecord('FNS_ProductTypeDomain', 'assignJSONToBank', ex.getMessage() + ex.getStackTraceString()); 
        }
        return productTypeObj;
    }

    public static void insertInGlobalPicklist(List<FNS_ProductType__c> configInsertList){
        FNS_ProductTypeDomain.mapDataAndPerformDML(configInsertList,FNS_Constants.CONFIG_DMLTYPE_INSERT);        
    }

    public static void updateInGlobalPicklist(List<FNS_ProductType__c> configUpdateList){
        FNS_ProductTypeDomain.mapDataAndPerformDML(configUpdateList,FNS_Constants.CONFIG_DMLTYPE_UPDATE);        
    }

    private static void mapDataAndPerformDML(List<FNS_ProductType__c> configInsertList, String dmlType){
        String[] productTypeList = new String[0];
		Set<String> productTypeLabels= new Set<String>();
        
        for(FNS_ProductType__c configType : configInsertList){               
            if(!productTypeLabels.contains(configType.FNS_Description__c)){
               productTypeList.add('{"valueName":"'+configType.FNS_ProductTypeExternalId__c+'","label":"'+configType.FNS_Description__c+'"}'); 
               productTypeLabels.add(configType.FNS_Description__c);
            }
        }
        String productTypeVal = String.join(productTypeList, ', ');
        if(dmlType.equalsIgnoreCase(FNS_Constants.CONFIG_DMLTYPE_INSERT)){
            if(String.isNotEmpty(productTypeVal)){          
                FNS_ConfigurationDomain.updateNow(productTypeVal,FNS_Constants.GLOBAL_PRODUCTTYPE_PICKLIST);
            }
        } else {            
            if(String.isNotEmpty(productTypeVal)){
                FNS_ConfigurationDomain.updateNow(productTypeVal,FNS_Constants.GLOBAL_PRODUCTTYPE_PICKLIST);
            }
        }
    }
}