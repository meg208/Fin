/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Loan object
****************************************************************************************/
public with sharing class FNS_LoansSelector extends fflib_SObjectSelector {
    
     /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_LoansSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_LoansSelector(Boolean enforceFLS) {
        super(true, true, false);
    }

    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Loan object
        * @param 	   none
        * @return      List of Schema.SObjectField of Loan object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        List<String> fieldList;
        Map<Schema.SObjectType,List<Schema.SObjectField>> fieldsMap = new Map<Schema.SObjectType,List<Schema.SObjectField>>();    	
        Map<String, List<String>> objectWithFieldsMap = new Map<String, List<String>>();    	
        String sobjectName;
        Schema.SObjectType sObj;
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        if(FNS_Util.isFSCInstalled) {
            sobjectName = 'FinServ__FinancialAccountTransaction__c';
            fieldList = new List<String> {
                    namespace + 'FNS_Account__c',
                                'FinServ__FinancialAccount__c',
                                'FinServ__Amount__c',
                    namespace + 'FNS_EffectiveDate__c',
                    namespace + 'FNS_LoanSummary__c',
                    namespace + 'FNS_ExpiryDate__c',                  
                    namespace + 'FNS_FinancialAccountTransactionExtId__c',
                    namespace + 'FNS_LoanProductType__c',
                    namespace + 'FNS_LoanPurpose__c',
                    namespace + 'FNS_MaturityDate__c',
                    namespace + 'FNS_Application__c',
                    namespace + 'FNS_OriginationTypeIndicator__c',              
                    namespace + 'FNS_PricingFrequency__c',
                    namespace + 'FNS_PricingType__c',                    
                    namespace + 'FNS_RateType__c',
                    namespace + 'FNS_RequestedDate__c',
                    namespace + 'FNS_RiskType__c',
                    namespace + 'FNS_Term__c',
                    namespace + 'FNS_BypassValidation__c',
                    namespace + 'FNS_TermUnit__c'                   
                    };                        
        } 
        else {                            
            sobjectName = baseNamespace+'FNS_FinancialAccountTransaction__c';
                fieldList = new List<String> {
                    'Id',
                    namespace + 'FNS_Account__c',
                    namespace + 'FNS_Amount__c',
                    namespace + 'FNS_EffectiveDate__c',
                    namespace + 'FNS_LoanSummary__c', 
                    namespace + 'FNS_FinancialAccountTransactionExtId__c',                    
                    namespace + 'FNS_ExpiryDate__c',
                    namespace + 'FNS_FinancialAccount__c',
                    namespace + 'FNS_RateType__c',                    
                    namespace + 'FNS_LoanProductType__c',
                    namespace + 'FNS_LoanPurpose__c',
                    namespace + 'FNS_MaturityDate__c',
                    namespace + 'FNS_Application__c',
                    namespace + 'FNS_OriginationTypeIndicator__c',                   
                    namespace + 'FNS_PricingFrequency__c',
                    namespace + 'FNS_PricingType__c',               
                    namespace + 'FNS_RequestedDate__c',                   
                    namespace + 'FNS_RiskType__c',
                    namespace + 'FNS_Status__c',
                    namespace + 'FNS_Term__c',
                    namespace + 'FNS_BypassValidation__c',
                    namespace + 'FNS_TermUnit__c'                  
                };                            
        }
        fieldList.add('Name');
        objectWithFieldsMap.put(sobjectName, fieldList);										  
        fieldsMap = FNS_Util.getSobjectWithFields(objectWithFieldsMap);
        sobj = Schema.getGlobalDescribe().get(sobjectName);
        return  fieldsMap.get(sobj);
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Loan object
        * @param 	   none
        * @return      Returns SObjecttype of Loan object
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        String finAccountObjName;
        string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        if(FNS_Util.isFSCInstalled){
            finAccountObjName = 'FinServ__FinancialAccountTransaction__c' ;
        }
        else {
            finAccountObjName = baseNamespace + 'FNS_FinancialAccountTransaction__c' ;
        }
        Schema.SObjectType finAccountObject = FNS_Util.getSobject(finAccountObjName);
        return finAccountObject;
    }
    
    /*************************************************************************************
        * @description Method to return List of Sobject
        * @param 	   none
        * @return      Returns List of Loan object
    **************************************************************************************/ 
    public List<Sobject> getAllProducts() {
        return Database.query(newQueryFactory().toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return List of sobject records
        * @param 	   Number of Loans
        * @param 	   Operator
        * @return      Returns List of Loan object
    **************************************************************************************/ 
    public List<Sobject> getLoanDetailsWithFilter(Integer numberOFLoan, String operator) {
        String queryString;
    	String objectName;
        String baseNamespace= FNS_Util.getBasePackageNamepace();
    	if(FNS_Util.isFSCInstalled){
    		objectName = 'FinServ__FinancialAccountTransaction__c';
    	} 
        else{
    		 objectName = baseNamespace+'FNS_FinancialAccountTransaction__c';
    	}
        queryString = 'SELECT '+baseNamespace+'FNS_Application__c,count(ID) oppCount FROM '+  String.escapeSingleQuotes(objectName) + ' group by '+baseNamespace+'FNS_Application__c having count(ID) ' + operator  +' ' + numberOFLoan + ' Limit 1000';
        FNS_ObjectAccessContainer.checkFinAccountTransactionAccess(FNS_AccessController.DML_OPERATION_READ);
        List<sObject> loanList = Database.query(queryString); 
        return loanList;
    }

    /*************************************************************************************
        * @description Method to return List of Sobject based on productIds
        * @param 	   Set of Product ids
        * @return      Returns List of loan object
    **************************************************************************************/ 
    public List<SObject> getLoans(Set<Id> productIds) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        String loanQueryCondition = '';
        fflib_QueryFactory loanQueryFactory = newQueryFactory(true, true, true);
        loanQueryFactory.assertIsAccessible();
        loanQueryFactory.setEnforceFLS(true);
        List<String> loanQueryConditions = new List<String>();
        if(FNS_Util.isFSCInstalled){
            loanQueryCondition = 'FinServ__FinancialAccount__c IN : productIds';
        }else {
            loanQueryCondition = namespace + 'FNS_FinancialAccount__c IN : productIds';
        }
        loanQueryConditions.add(loanQueryCondition);
        if(! loanQueryConditions.isEmpty()){
            loanQueryFactory.setCondition(String.join(loanQueryConditions, ' AND '));
        }
        return (List<SObject>) Database.query(loanQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return List of Sobject based on List of Loan Ids
        * @param 	   List of loan Ids
        * @return      Returns List of Loan object
    **************************************************************************************/ 
    public List<SObject> selectLoanName(List<String> loanIds) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        fflib_QueryFactory loansQueryFactory = newQueryFactory(true, true, true); 
        loansQueryFactory.assertIsAccessible();
        loansQueryFactory.setEnforceFLS(true);
        loansQueryFactory.selectField('Id'); 
        loansQueryFactory.selectField(namespace+'FNS_FinancialAccountTransactionExtId__c');
        String loansQueryCondition;
        if(loanIds != null){
            loansQueryCondition = namespace+'FNS_FinancialAccountTransactionExtId__c IN :loanIds';
            loansQueryFactory.setCondition(loansQueryCondition);
        }
        fflib_SObjectSelector accountSelector = new FNS_AccountSelector();
        accountSelector.configureQueryFactoryFields(loansQueryFactory, namespace+'FNS_Account__r');
        fflib_SObjectSelector productSelector = new FNS_ProductsSelector();
        if(FNS_Util.isFSCInstalled){
            productSelector.configureQueryFactoryFields(loansQueryFactory, 'FinServ__FinancialAccount__r');
        }
        else{
            productSelector.configureQueryFactoryFields(loansQueryFactory, namespace+'FNS_FinancialAccount__r');
        }
        loansQueryFactory.setLimit(5); // to be updated later based as response 
        return (List<SObject>) Database.query(loansQueryFactory.toSOQL());
    }
}