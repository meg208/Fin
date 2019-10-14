/************************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Predictive Analytics- Home Page
* @description This class is server side controller to do all DML operation for Predictive analytics component  
****************************************************************************************/
public with sharing class FNS_PredictiveAnalyticsController {
    
    public static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    /***********************************************************************************
* @description Method to get All Records 
* @Params      null
* @Returns    Returns ListWrapper as String
***********************************************************************************/ 
    @AuraEnabled
    public static Object getRecords(){
        Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
            FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
            };
                    string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        List<FNS_PredictiveAnalytics__c> predAnalyticslist;
        List<PredictiveAnalyticsWrapper> listWrapper = new List<PredictiveAnalyticsWrapper>(); 
        
        try{
            FNS_PredictiveAnalyticsSelector predicAnalyticsSelector = new FNS_PredictiveAnalyticsSelector();
            predAnalyticslist = predicAnalyticsSelector.getPredictiveAnalytics();
            for(FNS_PredictiveAnalytics__c pred: predAnalyticslist ){
                PredictiveAnalyticsWrapper wrap = new PredictiveAnalyticsWrapper(); 
                wrap.Id= (String)pred.get('Id');
                wrap.facilityName=  pred.FNS_FinancialAccountName__c;
                wrap.loanName=  pred.FNS_FinancialAccountTransactionName__c;
                wrap.recommendation=  pred.FNS_Recommendation__c;
                wrap.recommendationDescription =  pred.FNS_RecommendationDescription__c;
                wrap.CustomerId =  pred.FNS_Customer__c;
                wrap.CustomerName=  pred.FNS_CustomerName__c;
                if(FNS_Util.isFSCInstalled){
                    wrap.facilityId=  (String)pred.get(namespace+'FNS_FinancialAccountFSC__c');
                    wrap.loanId=  (String)pred.get(namespace+'FNS_FinancialAccountTransactionFSC__c');
                }
                else{
                    wrap.facilityId=  (String)pred.get(namespace+'FNS_FinancialAccount__c');
                    wrap.loanId=  (String)pred.get(namespace+'FNS_FinancialAccountTransaction__c');
                }
                listWrapper.add(wrap);
            }
            objValue.put(FNS_Constants.API_RESPONSE,JSON.serialize(listWrapper,true));
        }
        catch(Exception ex){
            logger.addLogRecord(namespace+'FNS_PredictiveAnalysisController', 'getListViews', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        } 
        return objValue; 
    }
    
    /***********************************************************************************
* @description Method to get ListViews for PredictiveAnalytics 
* @Params      null
* @Returns     Returns List of ListViews 
***********************************************************************************/ 
    @AuraEnabled
    public static List<ListView> getListViews() {
        List<ListView> listviews; 
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        String fieldSetName = '';
        
        if(FNS_Util.isFSCInstalled){
            fieldSetName = namespace+'FNS_PredictiveAnalyticsFSC';
        }else {
            fieldSetName = namespace+'FNS_PredictiveAnalytics';
        }
        try {
            listviews = new FNS_ListViewsSelector().selectByName(baseNamespace+'FNS_PredictiveAnalytics__c', new Set<String>{fieldSetName});
        } catch(Exception ex){
            logger.addLogRecord('FNS_PredictiveAnalysisController', 'getListViews', ex.getMessage() + ex.getStackTraceString());
        }    
        return listviews;
    }
    
    /*************************************************************************************
* @description  Wrapper to return for getRecords method 
* @Params       none
* @Returns      none
**************************************************************************************/
    public with sharing class PredictiveAnalyticsWrapper{
        String Id; 
        String FacilityId; 
        String FacilityName; 
        String Recommendation; 
        String RecommendationDescription; 
        String CustomerId; 
        String CustomerName; 
        String LoanId; 
        String LoanName; 
    }
}