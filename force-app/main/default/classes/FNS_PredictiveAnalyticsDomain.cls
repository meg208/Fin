/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Domain Class
* @description This class acts as domain class for Predictive Analytics object 
****************************************************************************/
public with sharing class FNS_PredictiveAnalyticsDomain {
    
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    /***********************************************************************
    * @description This method update User records
    * @param none
    * @return returns json response  
    ************************************************************************/
    public static void getConfigurations(){
        Map<Integer, String> emailMap = new Map<Integer, String>();
        
        FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
        param.objectName = FNS_Constants.CLASS_PREDICTIVE_ANALITICS;
        param.endPoint = FNS_Constants.URL_PREDICTIVE_ANALITICS;
        param.methodName = FNS_Constants.METHOD_GET;
        
        FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
        HttpResponse jsonResponse = router.getPostRequest(param);
        if(jsonResponse.getStatusCode() == 200){
            if (!String.isEmpty(jsonResponse.getBody())){
                
                List<FNS_ObjectContainer.FNS_PredictiveAnalytics> predAnalyticsConfigList = (List<FNS_ObjectContainer.FNS_PredictiveAnalytics>)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_PredictiveAnalytics>.class);
                List<String> loanIdList = new List<String> ();
                for(FNS_ObjectContainer.FNS_PredictiveAnalytics pa: predAnalyticsConfigList){
                    loanIdList.add(pa.loanId.trim()); 
                }
                try{
                    //get related object data from loan 
                    FNS_LoansSelector loanSelector = new FNS_LoansSelector(); 
                    List<sObject>  loanObjList = loanSelector.selectLoanName(loanIdList);
                    
                    List<FNS_PredictiveAnalytics__c> predAnalyticsobjList = new List<FNS_PredictiveAnalytics__c>();
                    for (FNS_ObjectContainer.FNS_PredictiveAnalytics predpayload : predAnalyticsConfigList ){
                        predAnalyticsobjList.add(FNS_PredictiveAnalyticsDomain.assignJSONToPredictiveAnalytics(loanObjList, predpayload));
                    }
                    
                    if(!predAnalyticsobjList.isEmpty()){
                        FNS_PredictiveAnalyticsSelector pAselector = new FNS_PredictiveAnalyticsSelector(); 
                        List<SObject> allRecords = pAselector.getAllPredictiveAnalytics();
                        new FNS_PredictiveAnalyticsService().deleteRecords(allRecords);
                        new FNS_PredictiveAnalyticsService().insertRecords(predAnalyticsobjList); // insert the pred Analytics object 
                    }
                }
                catch(Exception ex){
                    logger.addLogRecord('FNS_PredictiveAnalyticsDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString()); 
                }
            }    
        }
        
    }
    public static FNS_PredictiveAnalytics__c assignJSONToPredictiveAnalytics(List<SObject> loanObjList, FNS_ObjectContainer.FNS_PredictiveAnalytics predpayload){
        FNS_PredictiveAnalytics__c predAnalyticObj = new FNS_PredictiveAnalytics__c();
        Integer loanId;
        string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        try{
            for(sObject loan: loanObjList){
                loanId =  Integer.valueOf(loan.get('FNS_FinancialAccountTransactionExtId__c'));
                
                if(Integer.valueOf(predpayload.loanId.trim()) == loanId){
                    if(FNS_Util.isFSCInstalled){
                        if((String)loan.get('FNS_Account__c') != null && (String)loan.get('FinServ__FinancialAccount__c') != null){
                            if((String)loan.getSObject('FNS_Account__r').get('Name') == predpayload.borrowerName && (String)loan.getSObject('FinServ__FinancialAccount__r').get('Name') == predpayload.facilityName ){  // insert record only if all related data matches to data in SF 
                                predAnalyticObj.FNS_Customer__c = (String)loan.get('FNS_Account__c');
                                predAnalyticObj.put(extNamespace+'FNS_FinancialAccountFSC__c', (String)loan.get('FinServ__FinancialAccount__c')); 
                                predAnalyticObj.put(extNamespace+'FNS_FinancialAccountTransactionFSC__c', (String)loan.get('Id'));
                                predAnalyticObj.FNS_CustomerName__c =String.valueOf(predpayload.borrowerName);
                                predAnalyticObj.FNS_FinancialAccountTransactionName__c = predpayload.loanName;
                                predAnalyticObj.FNS_FinancialAccountName__c = String.valueOf(predpayload.facilityName);
                                predAnalyticObj.FNS_RecommendationId__c = predpayload.recommendationId;
                                predAnalyticObj.FNS_RecommendationDescription__c = predpayload.recommendationDescription;
                                predAnalyticObj.FNS_Recommendation__c = predpayload.recommendation; 
                                predAnalyticObj.FNS_PriorityOrder__c = Integer.valueOf(predpayload.priorityOrder);
                            } 
                        }
                    }
                    else {
                        if((String)loan.get('FNS_Account__c') != null && (String)loan.get('FNS_FinancialAccount__c') != null){
                            if((String)loan.getSObject('FNS_Account__r').get('Name') == predpayload.borrowerName && (String)loan.getSObject('FNS_FinancialAccount__r').get('Name') == predpayload.facilityName ){  // insert record only if all related data matches to data in SF 
                                predAnalyticObj.FNS_Customer__c = (String)loan.get('FNS_Account__c');
                                predAnalyticObj.put(baseNamespace+'FNS_FinancialAccount__c', (String)loan.get('FNS_FinancialAccount__c'));
                                predAnalyticObj.put(baseNamespace+'FNS_FinancialAccountTransaction__c', (String)loan.get('Id'));
                                predAnalyticObj.FNS_CustomerName__c =predpayload.borrowerName;
                                predAnalyticObj.FNS_FinancialAccountTransactionName__c = predpayload.loanName;
                                predAnalyticObj.FNS_FinancialAccountName__c = predpayload.facilityName;
                                predAnalyticObj.FNS_RecommendationId__c = predpayload.recommendationId;
                                predAnalyticObj.FNS_RecommendationDescription__c = predpayload.recommendationDescription;
                                predAnalyticObj.FNS_Recommendation__c = predpayload.recommendation; 
                                predAnalyticObj.FNS_PriorityOrder__c = Integer.valueOf(predpayload.priorityOrder);
                            }
                        }
                    }
                }
            }
        }
        catch(Exception ex){
            logger.addLogRecord('FNS_PredictiveAnalyticsDomain', 'assignJSONToPredictiveAnalytics', ex.getMessage() + ex.getStackTraceString()); 
        }
        return predAnalyticObj; 
    } 
}