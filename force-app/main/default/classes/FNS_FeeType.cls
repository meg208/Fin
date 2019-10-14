public class FNS_FeeType {
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    public static object getConfigurations()
    {
         Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
            FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
            };
        try {
        FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
        param.objectName = FNS_Constants.CLASS_FEE_TYPES;
        param.endPoint = FNS_Constants.URL_FEE_TYPES;
        param.methodName = FNS_Constants.METHOD_GET;
        FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
        HttpResponse jsonResponse = router.getPostRequest(param);
        System.debug('>>>> jsonResponse  >>' + jsonResponse.getBody());
        if(jsonResponse.getStatusCode() == 200)
        {
            if (!String.isEmpty(jsonResponse.getBody()))
            {
                //List<FNS_ObjectContainer.FNS_FeeType> configurationData = (List<FNS_ObjectContainer.FNS_FeeType>)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_FeeType>.class);
                //Map<String, List<String>> mapValuesPerConfigType = FNS_FeeType.mapConfigDataList(configurationData);
                FNS_ObjectContainer feeTypeObj = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);
                if(feeTypeObj  !=null && feeTypeObj.feeTypesList !=null && !feeTypeObj.feeTypesList.isEmpty()){
                     Map<String, List<String>> mapValuesPerConfigType = FNS_FeeType.mapConfigDataList(feeTypeObj.feeTypesList);
                	System.debug('>>> mapValuesPerConfigType  >>>' + mapValuesPerConfigType );
                	mapDataAndPerformDML(mapValuesPerConfigType);
                	objValue.put(FNS_Constants.API_RESPONSE,jsonResponse.getBody());
                }
            }
            
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

    private static Map<String, List<String>> mapConfigDataList(List<FNS_ObjectContainer.FNS_FeeType> configurationDataList)
    {    
       Map<String, List<String>> mapValuesPerConfigType = new Map<String, List<String>>();  
       Set<String> uniqueLabel = new Set<String>(); 
       List<String> listBasedOnStructure = new List<String>();
       for(FNS_ObjectContainer.FNS_FeeType config:  configurationDataList)
       {
            String key = 'FeeType';
           
            if (mapValuesPerConfigType.containsKey(key))
            {
                    listBasedOnStructure = mapValuesPerConfigType.get(key);
            }
            else
            {
                    listBasedOnStructure = new List<String>();
            }
           if(!uniqueLabel.contains(config.description))
            {
                     String structure = '{"valueName":"'+config.FeeTypeId+'","label":"'+config.description+'"}';
                     System.debug('structure = '+structure);
                     listBasedOnStructure.add(structure);   
                     mapValuesPerConfigType.put(key, listBasedOnStructure);
                     uniqueLabel.add(config.description);
            }
       }
       return mapValuesPerConfigType;
        
    }
    
    private static void mapDataAndPerformDML(Map<String, List<String>> mapValuesPerConfigType)
    {
        String structureVal = '';
        for (String key : mapValuesPerConfigType.keySet())
        {
            structureVal = '';
            structureVal = String.join(mapValuesPerConfigType.get(key), ', ');
            System.debug('structureVal = '+structureVal);

            FNS_ConfigurationDomain.updateNow(structureVal,key);
        }
    }
    
}