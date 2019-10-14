/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Domain Class
* @description This class is server side controller for FNS_CommunityPath component 
****************************************************************************/
public with sharing class FNS_CommunityPathController {
    
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    private class FNS_ApplicationPath{
        /**
        * @description get picklist value for StageName field on Application 
        * @param null
        * @return a List of picklist values
        */
        private String getApplication(String stageNameValue){   
            Map<Integer, FNS_ConfigurationType__c> dispositionMap = new Map<Integer, FNS_ConfigurationType__c>(); 
            List<FNS_ConfigurationType__c> sortedDispositionValues = new List<FNS_ConfigurationType__c>(); 
            List<String> disposition = new List<String>();
            //Get Disposition values from Configuration Type Object 
            FNS_ConfigurationTypeSelector configSelector = new FNS_ConfigurationTypeSelector(); 
            List<FNS_ConfigurationType__c> dispositionValues = configSelector.getConfigTypeRecordsByType('DISPOSITION');
            
            for(FNS_ConfigurationType__c f: dispositionValues){
                disposition.add(f.FNS_Description__c); 
                dispositionMap.put(Integer.valueOf(f.FNS_SystemOrder__c), f); 
            }
            //Sort disposition values based on System Order 
            List<Integer> systemOrderList = new List<Integer>(dispositionMap.keySet()); 
            systemOrderList.sort(); 
            for(Integer i: systemOrderList){
                sortedDispositionValues.add(dispositionMap.get(i)); 
            }
            if(!disposition.contains(stageNameValue)){
                stageNameValue ='Initial Input';
            }
            Boolean curValMatched = false;
            Integer widthPerItem = 100/(sortedDispositionValues.size()-1);
            
            List<chevronData> lstRet = new List<chevronData>(); 
            for( FNS_ConfigurationType__c f : sortedDispositionValues)
            {
                chevronData obj = new chevronData();
                obj.val = f.FNS_Description__c;
                
                obj.width = widthPerItem+'%';            
                if(obj.val == stageNameValue){
                    obj.cssClass = 'active';
                    curValMatched = true;
                }
                else if(curValMatched){
                    obj.cssClass = '';
                }else{
                    obj.cssClass = 'visited'; 
                } 
                if(obj.val.equalsIgnoreCase('Canceled') || obj.val.equalsIgnoreCase('Pending Closure')){
                    
                } 
                else {
                    lstRet.add(obj);
                }
            }
            return JSON.serialize(lstRet);
        }
    }
    
    /**
    * @description get picklist value for StageName field on Application 
    * @param null
    * @return a List of picklist values
    */  
    @AuraEnabled
    public static Object getfromCommunity(String stageName)
    {
        Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
            FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
        };
        String jsonResponse;
        try{
            FNS_CommunityPathController.FNS_ApplicationPath innerCls = new FNS_CommunityPathController.FNS_ApplicationPath();
            jsonResponse  =  innerCls.getApplication(stageName);
            objValue.put(FNS_Constants.API_RESPONSE,jsonResponse);
        }
        catch(Exception ex){
            logger.addLogRecord('FNS_CommunityPathController', 'getfromCommunity', ex.getMessage() + ex.getStackTraceString()); 
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        }
        return objValue;
    }
    
    private with sharing class chevronData{
        public String val{get;set;}
        public String cssClass{get;set;}
        public String width {get;set;}
    }
}