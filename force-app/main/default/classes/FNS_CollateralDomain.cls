public class FNS_CollateralDomain {
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    Map<String,String> collateralCategoryToIdMap = new Map<String,String>();
    Map<String,String> collateralTypeToIdMap = new Map<String,String>();
    
    public static List<FNS_Field> getFieldsFromFieldSet(String objectName, String fieldSetName){
         List<FNS_Field> objectFields= FNS_FieldSetFormController.getFields(objectName,fieldSetName);
        return objectFields;
    }

    public void getAllCollateralConfig(){
        List<String> collateralConfigValues = new List<String>{'CollateralType','CollateralCategoryType'};
        system.debug('@@ collateralConfigValues' + collateralConfigValues);
        List<FNS_ConfigurationType__c> collateralConfigList = new FNS_ConfigurationTypeSelector().getConfigTypeRecordsByType(collateralConfigValues);
	            system.debug('@@ collateralConfigList' + collateralConfigList);

        If(collateralConfigList != null){
	        for(FNS_ConfigurationType__c record : collateralConfigList){
                if(record.FNS_ConfigurationType__c == 'CollateralType' ){
                    collateralTypeToIdMap.put(record.FNS_Description__c, record.FNS_ConfigurationId__c);
                }   
        
                if(record.FNS_ConfigurationType__c == 'CollateralCategoryType'){
                    collateralCategoryToIdMap.put(record.FNS_Description__c, record.FNS_ConfigurationId__c);
                }
            }
	    }
        system.debug('@@ collateralCategoryToIdMap :: '+ collateralCategoryToIdMap);
          system.debug('@@ collateralCategoryToIdMap :: '+ collateralTypeToIdMap);
    }
    
    
    public static void pushCollateralToFFDC(String collateralId){
        try{
            system.debug('>>>pushCollateralToFFDC>>');
            if(collateralId != null) {
                String appJson = createCollateralWrapper(new Set<ID>{(ID)(collateralId)});
                system.debug('Application Response>>>'+appJson);
                if(appJson != null){
                    /*FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
                    param.objectName = FNS_Constants.CLASS_APPLICATION;
                    param.endPoint = FNS_Constants.URL_APPLICATION;
                    param.methodName = FNS_Constants.METHOD_POST;
                    param.body = appJson;
                    
                    Map<String, String> headerMap = new Map<String, String>();
                    headerMap.put(FNS_Constants.CONTENT_TYPE, 'application/json');
                    param.headerMap = headerMap;
                    
                    FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
                    HttpResponse jsonResponse = router.getPostRequest(param);
                    system.debug('>>>Application Push Response>>>>'+jsonResponse);
                    if(jsonResponse.getStatusCode() == 200){
                        if (!String.isEmpty(jsonResponse.getBody())){
                            FNS_ApplicationPayload applicationResp = (FNS_ApplicationPayload )JSON.deserialize(jsonResponse.getBody(), FNS_ApplicationPayload.class);
                            system.debug('>>>applicationResp>>'+applicationResp.applicationId);
                            if(applicationResp != null){
                                List<Opportunity> applicationList; 
                                applicationList = new FNS_ApplicationSelector().selectById(new Set<Id>{applicationId});
                                if(applicationList != null){
                                    applicationList[0].FNS_ApplicationExtId__c = applicationResp.applicationId;
                                    uow.registerUpsert(applicationList);                                    
                                }
                            }  
                        } 
                    }
                    FNS_ObjectAccessContainer.checkOpportunityAccess(FNS_AccessController.DML_OPERATION_UPDATE);
                    FNS_ObjectAccessContainer.checkAccountAccess(FNS_AccessController.DML_OPERATION_UPDATE);
                    uow.commitwork(); */
                }
            }
        }
        catch (Exception ex){
            logger.addLogRecord('pushCollateralToFFDC', 'pushCollateralToFFDC', ex.getMessage() + ex.getStackTraceString());
        }        
    }

    public Static Map<ID, Set<String>> getCollateralToProdMap(Set<Id> collateralIdSet){
        List<SObject> collWithProdList = new FNS_CollateralWithProductSelector().getRecordsByCollateralId(collateralIdSet);
        Map<ID, Set<String>> collateralToProductMap = new Map<ID, Set<String>>();
        Set<String> productIdSet;
        for(SObject collProdObj : collWithProdList){
            if(collateralToProductMap.containsKey((Id)collProdObj.get('FNS_Collateral__c'))){
                productIdSet = collateralToProductMap.get(string.valueOf(collProdObj.get('FNS_Collateral__c')));
            }else{
                productIdSet = new Set<String>();
                collateralToProductMap.put((Id)collProdObj.get('FNS_Collateral__c'), productIdSet);
            }
            sObject sObj = collProdObj.getSobject('FNS_Product__r'); 
            productIdSet.add((String)sObj.get('FNS_FinancialProductExtId__c'));
        }
        return collateralToProductMap;
	}


    public Static String createCollateralWrapper(Set<ID> collateralIdSet) {
       FNS_CollateralWrapper collateralWrapper = new FNS_CollateralWrapper();
       if(collateralIdSet != null){
            Map<ID, Set<String>> collateralToProdctMap = getCollateralToProdMap(collateralIdSet);
            List<FNS_Collateral__c> collateralList = new FNS_CollateralSelector().getCollateralById(collateralIdSet);
                for(FNS_Collateral__c collateralObj : collateralList){
                    List<String> prodIDList = new List<String>();
                    prodIDList.addAll(collateralToProdctMap.get(collateralObj.id));
                    /*collateralWrapper.loanIds = prodIDList;
                    collateralWrapper.description = collateralObj.FNS_Description__c;
                    collateralWrapper.valueDate = collateralObj.FNS_ValueDate__c;
                    collateralWrapper.pledgedDate= String.valueOf(collateralObj.FNS_PledgedDate__c);
                    collateralWrapper.typeId = 115; */
                    collateralWrapper.categoryId = 80;
                    collateralWrapper.valueFairMarket = 90;
                }
       
        }
        system.debug('@@@@@ collateralWrapper ' + JSON.Serialize(collateralWrapper));
        return JSON.Serialize(collateralWrapper);
    }

    


}