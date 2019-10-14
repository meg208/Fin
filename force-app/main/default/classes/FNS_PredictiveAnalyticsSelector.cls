/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Predictive Analytics Object
****************************************************************************************/

public with sharing class FNS_PredictiveAnalyticsSelector extends fflib_SObjectSelector{

    String finAccountObjName;
	
     /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_PredictiveAnalyticsSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_PredictiveAnalyticsSelector(Boolean enforceFLS) {
        super(true, true, false);
    }

    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Predictive Analytics 
        			   object 
        * @param 	   none
        * @return      List of Schema.SObjectField of Predictive Analytics object
    **************************************************************************************/
	public List<Schema.SObjectField> getSObjectFieldList() {
    	List<String> fieldList;
    	Map<Schema.SObjectType,List<Schema.SObjectField>> fieldsMap = new Map<Schema.SObjectType,List<Schema.SObjectField>>();    	
    	Map<String, List<String>> objectWithFieldsMap = new Map<String, List<String>>();    	
    	String sobjectName;
    	Schema.SObjectType sObj;
    	string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
    	string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
    	
    	if(FNS_Util.isFSCInstalled){
    		sobjectName =namespace + 'FNS_PredictiveAnalytics__c';
            
    		fieldList = new List<String> {
											namespace+'FNS_CustomerName__c', 
										    namespace+'FNS_Customer__c',
											namespace+'FNS_FinancialAccountName__c',
											namespace+'FNS_FinancialAccountFSC__c',
											namespace+'FNS_FinancialAccountTransactionFSC__c',
											namespace+'FNS_FinancialAccountTransactionName__c',
											namespace+'FNS_RecommendationDescription__c', 
                                            namespace+'FNS_Recommendation__c'
											
    									};
			
    	}else {
    		 //For Non FSC 
    		sobjectName =namespace + 'FNS_PredictiveAnalytics__c';
    		fieldList = new List<String> {
    										namespace+'FNS_CustomerName__c', 
										    namespace+'FNS_Customer__c',
											namespace+'FNS_FinancialAccountName__c',
											namespace+'FNS_FinancialAccount__c',
											namespace+'FNS_FinancialAccountTransaction__c',
											namespace+'FNS_FinancialAccountTransactionName__c',
											namespace+'FNS_RecommendationDescription__c', 
                                            namespace+'FNS_Recommendation__c'
										 };
			
    	}
        fieldList.add('Name');
		fieldList.add('Id');
        objectWithFieldsMap.put(sobjectName, fieldList);										  
        fieldsMap = FNS_Util.getSobjectWithFields(objectWithFieldsMap);
        sobj = Schema.getGlobalDescribe().get(sobjectName);
        return  fieldsMap.get(sobj);
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Predictive Analytics object 
        * @param 	   none
        * @return      Returns SObjecttype of Predictive Analytics object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_PredictiveAnalytics__c.sObjectType;
    }


    /*************************************************************************************
        * @description Method to return list of Predictive Analytics records
        * @param 	   none
        * @return      Returns List of Predictive Analytics object
    **************************************************************************************/
    public List<SObject> getPredictiveAnalytics(){        
        
		string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
    	string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
		
		fflib_QueryFactory predAnalyticsQueryFactory = newQueryFactory(true, true, true);
        predAnalyticsQueryFactory.assertIsAccessible();
        predAnalyticsQueryFactory.setEnforceFLS(true);
        List<String> predQueryConditions = new List<String>();      
     
        predAnalyticsQueryFactory.selectField(namespace +'FNS_CustomerName__c');
        predAnalyticsQueryFactory.selectField( namespace+'FNS_Customer__c');
        predAnalyticsQueryFactory.selectField( namespace+'FNS_FinancialAccountName__c');
        predAnalyticsQueryFactory.selectField( namespace+'FNS_FinancialAccountTransactionName__c');  
        predAnalyticsQueryFactory.selectField( namespace+'FNS_RecommendationDescription__c');
        predAnalyticsQueryFactory.selectField( namespace+'FNS_Recommendation__c');
		if(FNS_Util.isFSCInstalled){
            predAnalyticsQueryFactory.selectField( namespace+'FNS_FinancialAccountFSC__c');
            predAnalyticsQueryFactory.selectField( namespace+'FNS_FinancialAccountTransactionFSC__c');
		}
		else{
           predAnalyticsQueryFactory.selectField( namespace+'FNS_FinancialAccount__c');
           predAnalyticsQueryFactory.selectField( namespace+'FNS_FinancialAccountTransaction__c');
		}

        predQueryConditions.add(namespace +'FNS_CustomerName__c != null');
        predQueryConditions.add(namespace+'FNS_FinancialAccountName__c != null');
        predQueryConditions.add(namespace+'FNS_FinancialAccountTransactionName__c != null');
        
       
        if(!predQueryConditions.isEmpty()){
            predAnalyticsQueryFactory.setCondition(String.join(predQueryConditions, ' AND '));
        }
        predAnalyticsQueryFactory.addOrdering('FNS_PriorityOrder__c', fflib_QueryFactory.SortOrder.ASCENDING);

        return (List<SObject>) Database.query(predAnalyticsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return list of Predictive Analytics records
        * @param 	   none
        * @return      Returns List of Predictive Analytics object
    **************************************************************************************/
    public List<SObject> getAllPredictiveAnalytics(){        
        
		string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
    	string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
		
		fflib_QueryFactory predAnalyticsQueryFactory = newQueryFactory(true, true, true);
        predAnalyticsQueryFactory.assertIsAccessible();
        predAnalyticsQueryFactory.setEnforceFLS(true);   
     
        predAnalyticsQueryFactory.selectField('Id');
        return (List<SObject>) Database.query(predAnalyticsQueryFactory.toSOQL());
    }
}