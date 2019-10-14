/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description This class is used to perform DML using json for an Application.
****************************************************************************************/
public with sharing class FNS_ConfigurationDomain{
   //  private static Map<String,List<RecordTypeWrapper>> globalValRecordTypeMap ;
      // public Enum ConfigType { STRUCTURE,PRICING_TYPE, CONFIG_CURRENCY, REPAY_TYPE, TRACKING_ITEM_STATUS, STATE, OFFICIAL_TYPE, SUBMISSION_REQUIREMENT_STATUS, DISPOSITION, ROLE_TYPE, DOCUMENT_PRIORITY, POLICY_EXCEPTION_STATUS, DOCUMENT_STATUS, FREQUENCY, ENTITY_RELATION, PURPOSES, PROVINCES, COUNTRY }
       //  public Enum ConfigType { STRUCTURE,PRICING_TYPE, CONFIG_CURRENCY,ENTITY_RELATION, TRACKING_ITEM_STATUS, STATE, DISPOSITION, ROLE_TYPE, DOCUMENT_PRIORITY, DOCUMENT_STATUS, FREQUENCY,PURPOSES, PROVINCES, COUNTRY,REPAY_TYPE,OFFICIAL_TYPE,SUBMISSION_REQUIREMENT_STATUS,POLICY_EXCEPTION_STATUS } 
       public Enum ConfigType { STRUCTURE , PRICING_TYPE , ENTITY_RELATION , TRACKING_ITEM_STATUS ,DISPOSITION , STATE , ROLE_TYPE ,DOCUMENT_PRIORITY,FREQUENCY,PURPOSES,PROVINCES,COUNTRY,CONFIG_CURRENCY,REPAY_TYPE,COLLAT_TYPE,APPR_TYPE,ESTATE_COM_PROP_TYPE,COLL_PROP_TYPE,COLLAT_CAT }
       static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    
    /*************************************************************************************
    * @description  Method to return Configuration data 
    * @Params       none
    * @Returns      Configuration data 
    * @author       Brillio
    **************************************************************************************/ 
    public static Object getConfigurations(){

        Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
            FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
            };

        FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
        param.objectName = FNS_Constants.CLASS_CONFIGURATION_DATA;
        param.endPoint = FNS_Constants.URL_CONFIGURATION_DATA;
        param.methodName = FNS_Constants.METHOD_GET;

        try{
            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            HttpResponse jsonResponse = router.getPostRequest(param);  
            System.debug(LoggingLevel.Error ,'Json Response>>>'+ jsonResponse.getBody())  ;         
            if(jsonResponse.getStatusCode() == 200){
                if (!String.isEmpty(jsonResponse.getBody())){
                    //List<FNS_ObjectContainer.FNS_PICKLISTTYPE> configurationData = (List<FNS_ObjectContainer.FNS_PICKLISTTYPE>)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_PICKLISTTYPE>.class);
                    //Map<String, List<String>> mapValuesPerConfigType = FNS_ConfigurationDomain.mapConfigDataList(configurationData);
                    FNS_ObjectContainer picklistConfigList = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);
					Map<String, List<String>> mapValuesPerConfigType = FNS_ConfigurationDomain.mapConfigDataList(picklistConfigList.configurationDataList);
                    
                    for (String label : mapValuesPerConfigType.keySet())
                    {
                        
                        System.debug(LoggingLevel.Error ,'mapValuesPerConfigType>>>'+ label );
                        System.debug(LoggingLevel.Error ,'mapValuesPerConfigType>>> values'+ mapValuesPerConfigType.get(label ));
                    }
                    mapDataAndPerformDML(mapValuesPerConfigType);
               }
               // objValue.put(FNS_Constants.API_RESPONSE,jsonResponse.getBody());
           }
        } catch (DMLException ex){
            logger.addLogRecord('FNS_ConfigurationDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        } catch (Exception ex){
            logger.addLogRecord('FNS_ConfigurationDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        }
        return objValue;
    }

    /*************************************************************************************
    * @description  Method to map Configuration data 
    * @Params       List of configuration data
    * @Returns      none
    * @author       Brillio
    **************************************************************************************/ 
    private static Map<String, List<String>> mapConfigDataList(List<FNS_ObjectContainer.FNS_PICKLISTTYPE> configurationDataList){
        Set<String> enumNames = new Set<String>();
        Map<String ,Set<String>> uniqueLabelMap = new Map<String ,Set<String>>();
        Set<String> uniqueLabel = new Set<String>();

        for (ConfigType keyValue : ConfigType.values()){
            enumNames.add(keyValue.name()); 
        }
        Map<String, List<String>> mapValuesPerConfigType = new Map<String, List<String>>();
        List<String> listBasedOnStructure = new List<String>();
       
        for(FNS_ObjectContainer.FNS_PICKLISTTYPE config:  configurationDataList){
            if(enumNames.contains(config.configurationDataType)){
                String key = '';
                if (config.configurationDataType == 'STRUCTURE'){
                    key = 'Structure';
                }
                if (config.configurationDataType == 'CONFIG_CURRENCY'){
                    key = 'ConfigCurrency';
                }
                if (config.configurationDataType == 'TRACKING_ITEM_STATUS'){
                    key = 'TrackingItemStatus';
                }
                if (config.configurationDataType == 'STATE'){
                    key = 'State';
                }
                if (config.configurationDataType == 'DISPOSITION'){
                    key = 'Disposition';
                }
                if (config.configurationDataType == 'ROLE_TYPE'){
                    key = 'Role';
                }
                if (config.configurationDataType == 'DOCUMENT_PRIORITY'){
                    key = 'DocumentPriority';
                }
                if (config.configurationDataType == 'PRICING_TYPE'){
                    key = 'PricingType';
                }
                if (config.configurationDataType == 'FREQUENCY'){
                    key = 'Frequency';
                }
                if (config.configurationDataType == 'PURPOSES'){
                    key = 'Purpose';
                }
                if (config.configurationDataType == 'REPAY_TYPE'){
                    key = 'PaymentType';
                }
                if (config.configurationDataType == 'ENTITY_RELATION'){
                    key = 'ContactType';
                }
                if (config.configurationDataType == 'PROVINCES'){
                    key = 'Province';
                }
                if (config.configurationDataType == 'COUNTRY'){
                    key = 'Country';
                }
                
                if (config.configurationDataType == 'COLLAT_CAT'){
                    key = 'CollateralCategoryType';
                }

                if (config.configurationDataType == 'COLLAT_TYPE'){
                    key = 'CollateralType';
                }
                if (config.configurationDataType == 'APPR_TYPE'){
                    key = 'CollateralAppraisalType';
                }
                 if (config.configurationDataType == 'ESTATE_COM_PROP_TYPE'){
                    key = 'CollateralCommercialPropertyType';
                }
                 if (config.configurationDataType == 'COLL_PROP_TYPE'){
                    key = 'CollateralPropertyType';
                }
                
                
                if (mapValuesPerConfigType.containsKey(key)){
                    listBasedOnStructure = mapValuesPerConfigType.get(key);
                }
                else {
                    listBasedOnStructure = new List<String>();
                }
                /*
                if(!uniqueLabel.contains(config.description))
                {
                     String structure = '{"valueName":"'+config.configurationDataId+'","label":"'+config.description+'"}';
                     //System.debug('structure = '+structure);
                     listBasedOnStructure.add(structure);   
                     mapValuesPerConfigType.put(key, listBasedOnStructure);
                     uniqueLabel.add(config.description);
                }
                */
                if(uniqueLabelMap.containsKey(key) )
                {
                    uniqueLabel = uniqueLabelMap.get(key);
                   
                    if (! uniqueLabel.contains(config.description))
                    {
                        String structure = '{"valueName":"'+config.configurationDataId+'","label":"'+config.description+'"}';
                        listBasedOnStructure.add(structure);   
                        mapValuesPerConfigType.put(key, listBasedOnStructure);                   
                        uniqueLabel.add(config.description); 
                        uniqueLabelMap.put(key ,uniqueLabel);
                    }
                    else
                    {
                        //To Do not clear Yet
                    }

                }
                else
                {
                   uniqueLabel = new set<String>();                   
                   String structure = '{"valueName":"'+config.configurationDataId+'","label":"'+config.description+'"}';
                   listBasedOnStructure.add(structure);   
                   mapValuesPerConfigType.put(key, listBasedOnStructure);                   
                   uniqueLabel.add(config.description); 
                   uniqueLabelMap.put(key ,uniqueLabel);
                
                }
                
            }
        }
        return mapValuesPerConfigType;
        //upsertConfigurationData(dataList);
    }
    
    /*************************************************************************************
    * @description  Method to upsert Configuration data 
    * @Params       list of configuration data
    * @Returns      none 
    * @author       Brillio
    **************************************************************************************/ 
    public static void upsertConfigurationData(List<FNS_ObjectContainer.FNS_PICKLISTTYPE> dataList){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { FNS_ConfigurationType__c.SObjectType });
        FNS_UpsertUnitOfWorkHelper upsertConfigData = new FNS_UpsertUnitOfWorkHelper();
        uow.registerWork(upsertConfigData);
        
        
        try {
            FNS_ObjectAccessContainer.checkConfigurationTypeAccess(FNS_AccessController.DML_OPERATION_UPSERT);
        
            for(FNS_ObjectContainer.FNS_PICKLISTTYPE data : dataList){
                FNS_ConfigurationType__c configObj = new FNS_ConfigurationType__c();
                configObj = FNS_ConfigurationDomain.mapJsonDataToObject(data);
                upsertConfigData.registerConfigDataUpsert(configObj);
            }
            FNS_ConfigurationDomain.commitWork(uow);
        }
        catch (Exception ex){
            logger.addLogRecord('FNS_ConfigurationDomain', 'upsertConfigurationData', ex.getMessage() + ex.getStackTraceString()); 
            throw new FNS_CustomException(Label.FNS_CustomException);
        }
    }

    /*************************************************************************************
    * @description  Method to map Configuration json data to object 
    * @Params       configuration json
    * @Returns      Configuration object 
    * @author       Brillio
    **************************************************************************************/ 
    private static FNS_ConfigurationType__c mapJsonDataToObject(FNS_ObjectContainer.FNS_PICKLISTTYPE configData){
        FNS_ConfigurationType__c configObj = new FNS_ConfigurationType__c();
        Integer idLength = 0;
        if((configData.configurationDataId+(configData.configurationDataType).replaceAll('_', '')).length() > 20){
            idLength = 20;
        } else {
            idLength = (configData.configurationDataId+(configData.configurationDataType).replaceAll('_', '')).length();
        }
        configObj.FNS_ConfigurationExternalId__c = (configData.configurationDataId+(configData.configurationDataType).replaceAll('_', '')).substring(0, idLength);
        configObj.FNS_ConfigurationType__c = configData.configurationDataType;
        configObj.FNS_ConfigurationValue__c = configData.value;
        configObj.FNS_Description__c = configData.description;
        configObj.FNS_ConfigurationId__c = configData.configurationDataId;
        configObj.FNS_SystemId__c = configData.systemId;
        configObj.FNS_SystemOrder__c = configData.systemOrder;
        return configObj;    
    }

    private static void commitWork(fflib_SObjectUnitOfWork uow){
        uow.commitWork();
    }

    public static void insertInGlobalPicklist(List<FNS_ConfigurationType__c> configInsertList){
        FNS_ConfigurationDomain.mapDataAndPerformDML(configInsertList,'INSERT');        
    }

    public static void updateInGlobalPicklist(List<FNS_ConfigurationType__c> configUpdateList){
        FNS_ConfigurationDomain.mapDataAndPerformDML(configUpdateList,'UPDATE');        
    }

    private static void mapDataAndPerformDML(Map<String, List<String>> mapValuesPerConfigType){
        String structureVal = '';
        for (String key : mapValuesPerConfigType.keySet()){
            structureVal = '';
            structureVal = String.join(mapValuesPerConfigType.get(key), ', ');
           // System.debug('structureVal = '+structureVal);

            FNS_ConfigurationDomain.updateNow(structureVal,key);
        }
    }
    
    private static void mapDataAndPerformDML(List<FNS_ConfigurationType__c> configList, String dmlType){
        String[] structureList = new String[0];
        String[] currencyList = new String[0];
        String[] trackingItemStatusList = new String[0];
        String[] stateList = new String[0];
        String[] dispositionList = new String[0];
        String[] roleList = new String[0];
        String[] docPriorityList = new String[0];
        String[] pricingTypeList = new String[0];
        String[] frequencyList = new String[0];
        String[] purposeList = new String[0];
        Set<String> purposeLabels = new Set<String>();
        String[] paymentTypeList = new String[0];
        String[] contactTypeList = new String[0];
        Set<String> structureLabels= new Set<String>();
        String[] provinceList = new String[0];
        Set<String> countryLabels = new Set<String>();
        String[] countryList = new String[0];
        
        for(FNS_ConfigurationType__c configType : configList){      
            if(configType.FNS_ConfigurationType__c == 'STRUCTURE'){                
                if(!structureLabels.contains(configType.FNS_Description__c)){
                   structureList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
                   structureLabels.add(configType.FNS_Description__c);
                }
            }
            if(configType.FNS_ConfigurationType__c == 'CONFIG_CURRENCY'){                
                currencyList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
            }
            if(configType.FNS_ConfigurationType__c == 'TRACKING_ITEM_STATUS'){
                trackingItemStatusList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
            }
            if(configType.FNS_ConfigurationType__c == 'STATE'){
                stateList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
            }
            if(configType.FNS_ConfigurationType__c == 'DISPOSITION'){
                dispositionList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
            }
            if(configType.FNS_ConfigurationType__c == 'ROLE_TYPE'){
                roleList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
            }
            if(configType.FNS_ConfigurationType__c == 'DOCUMENT_PRIORITY'){
                docPriorityList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
            }
            if(configType.FNS_ConfigurationType__c == 'PRICING_TYPE'){
                pricingTypeList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
            }
            if(configType.FNS_ConfigurationType__c == 'FREQUENCY'){
                frequencyList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
            }    
            if(configType.FNS_ConfigurationType__c == 'PURPOSES'){
                if(!purposeLabels.contains(configType.FNS_Description__c)){            
                   purposeList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
                   purposeLabels.add(configType.FNS_Description__c);
                }                
            }
            if(configType.FNS_ConfigurationType__c == 'REPAY_TYPE'){
                paymentTypeList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
            }
            if(configType.FNS_ConfigurationType__c == 'ENTITY_RELATION'){
                contactTypeList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
            }
            if(configType.FNS_ConfigurationType__c == 'PROVINCES'){
                provinceList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
            }
            if(configType.FNS_ConfigurationType__c == 'COUNTRY'){
                if(!countryLabels.contains(configType.FNS_Description__c)){
                   countryList.add('{"valueName":"'+configType.FNS_ConfigurationId__c+'","label":"'+configType.FNS_Description__c+'"}');
                   countryLabels.add(configType.FNS_Description__c);
                }
            }            
        }

        String structureVal = String.join(structureList, ', ');
        String currencyVal = String.join(currencyList, ', ');
        String trackingItemStatusVal = String.join(trackingItemStatusList, ', ');
        String stateVal = String.join(stateList, ', ');
        String dispVal = String.join(dispositionList, ', ');
        String roleVal = String.join(roleList, ', ');
        String docPriorityVal = String.join(docPriorityList, ', ');
        String pricingTypeVal = String.join(pricingTypeList, ', ');
        String freqVal = String.join(frequencyList, ', ');
        String purposeVal = String.join(purposeList, ', ');
        String paymentTypeVal = String.join(paymentTypeList, ', ');
        String contactTypeVal = String.join(contactTypeList, ', ');
        String provinceVal = String.join(provinceList, ', ');
        String countryVal = String.join(countryList, ', ');
        
        if(structureVal != ''){ FNS_ConfigurationDomain.updateNow(structureVal,'Structure'); }
        if(currencyVal != '') { FNS_ConfigurationDomain.updateNow(currencyVal,'ConfigCurrency'); }
        if(trackingItemStatusVal != '') { FNS_ConfigurationDomain.updateNow(trackingItemStatusVal,'TrackingItemStatus'); }
        if(stateVal != '') { FNS_ConfigurationDomain.updateNow(stateVal,'State'); }
        if(dispVal != '') { FNS_ConfigurationDomain.updateNow(dispVal,'Disposition'); }
        if(roleVal != '') { FNS_ConfigurationDomain.updateNow(roleVal,'Role'); }
        if(docPriorityVal != '') { FNS_ConfigurationDomain.updateNow(docPriorityVal,'DocumentPriority'); }
        if(pricingTypeVal != '') { FNS_ConfigurationDomain.updateNow(pricingTypeVal,'PricingType'); }
        if(freqVal != '') { FNS_ConfigurationDomain.updateNow(freqVal,'Frequency'); }
        if(purposeVal != '') { FNS_ConfigurationDomain.updateNow(purposeVal,'Purpose'); }
        if(paymentTypeVal != '') { FNS_ConfigurationDomain.updateNow(paymentTypeVal,'PaymentType'); }
        if(contactTypeVal != '') { FNS_ConfigurationDomain.updateNow(contactTypeVal,'ContactType'); }
        if(provinceVal != '') { FNS_ConfigurationDomain.updateNow(provinceVal,'Province'); }
        if(countryVal != '') { FNS_ConfigurationDomain.updateNow(countryVal,'Country'); }
        
    }

    /*************************************************************************************
    * @description  Method to update Configuration data 
    * @Params       value and configType
    * @Returns      None 
    * @author       Brillio
    **************************************************************************************/ 
    @future(callout = true)
    public static void updateNow(String result, String configType){
            System.debug('>>>>updateNow>>' + configType);
            System.debug('>>>>updateNow>>' + result);
        if(!Test.isRunningTest()){
           String globalPicklistRecordId = '';
            FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
            param.objectName = FNS_Constants.CLASS_CONFIGURATION_DATA;
            param.endPoint = URL.getSalesforceBaseUrl().toExternalForm()+FNS_Constants.URL_CONFIGURATION_DATA_FETCH_GLOBALPICKLISTID+'\''+configType+'\'';
            //param.endPoint =  'callout:Tooling_APIND'+FNS_Constants.URL_CONFIGURATION_DATA_GLOBALPICKLIST+'/'+globalPicklistRecordId+'?_'+FNS_Constants.URL_HTTPPATCH;
            param.methodName = FNS_Constants.METHOD_GET;
            param.bypassBackSlash = true;
            param.bypassEndPoint = true;

            Map<String, String> headerMap = new Map<String, String>();
            headerMap.put(FNS_Constants.CONTENT_TYPE, 'application/json');
            headerMap.put(FNS_Constants.AUTHORIZATION, FNS_Constants.BEARER +UserInfo.getSessionID());
            param.headerMap = headerMap;

            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            HttpResponse jsonResponse = router.getPostRequest(param); 
            System.debug('>>>jsonResponse.getBody() from picklist>>' + jsonResponse.getBody());
            FNS_ObjectContainer.FNS_GLOBALPICKLIST configData = (FNS_ObjectContainer.FNS_GLOBALPICKLIST)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.FNS_GLOBALPICKLIST.class);
            List<FNS_ObjectContainer.Records> recordValues = configData.records;

            
            if(recordValues!=null && recordValues[0] != null & recordValues[0].Id != null){
                globalPicklistRecordId = recordValues[0].Id;
            }

            if(String.isNotEmpty(globalPicklistRecordId)){
                String fieldDef = '{"Metadata":{"customValue":['+result+'],"description":null,"masterLabel":"'+configType+'","sorted":false,"urls":null},"FullName":"FNS_'+configType+'"}';
                
                FNS_IntegrationUtil.FNS_RequestParam paramValue = new FNS_IntegrationUtil.FNS_RequestParam();
                paramValue.objectName = FNS_Constants.CLASS_CONFIGURATION_DATA;
                paramValue.endPoint = URL.getSalesforceBaseUrl().toExternalForm()+FNS_Constants.URL_CONFIGURATION_DATA_GLOBALPICKLIST+'/'+globalPicklistRecordId+'?_'+FNS_Constants.URL_HTTPPATCH;
                //paramValue.endPoint =  'callout:Tooling_APIND'+FNS_Constants.URL_CONFIGURATION_DATA_GLOBALPICKLIST+'/'+globalPicklistRecordId+'?_'+FNS_Constants.URL_HTTPPATCH;
                paramValue.methodName = FNS_Constants.METHOD_POST;
                paramValue.body = fieldDef;
                paramValue.bypassBackSlash = true;
                paramValue.bypassEndPoint = true;
                
                Map<String, String> headerMapValue = new Map<String, String>();
                headerMapValue.put(FNS_Constants.CONTENT_TYPE, 'application/json');
                headerMapValue.put(FNS_Constants.AUTHORIZATION, FNS_Constants.BEARER+UserInfo.getSessionID());
                paramValue.headerMap = headerMapValue;

                FNS_JSONAPIRouter routerValue = new FNS_JSONAPIRouter();
                HttpResponse jsonResponseValue = routerValue.getPostRequest(paramValue);
                system.debug('>>>>'+jsonResponseValue+'>>>>'+configType);
            }
        } 
      
    }
    public void updateCountryPurpose(){
        List<FNS_ConfigurationType__c> configTypeList =new FNS_ConfigurationTypeSelector().getConfigTypeRecordsByType(new List<string>{'PURPOSES','COUNTRY'});
            //[Select id,FNS_ConfigurationId__c,FNS_Description__c,FNS_ConfigurationType__c from FNS_ConfigurationType__c where FNS_ConfigurationType__c='PURPOSES' or FNS_ConfigurationType__c ='Country'];
        mapDataAndPerformDML(configTypeList,'Update');
    }
   
}