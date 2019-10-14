/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Products object
****************************************************************************************/
public with sharing class FNS_ProductsSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_ProductsSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_ProductsSelector(Boolean enforceFLS) {
        super(true, true, false);
    }

    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Product object
        * @param 	   none
        * @return      List of Schema.SObjectField of Product object
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
            sobjectName = 'FinServ__FinancialAccount__c';
            fieldList = new List<String> {
                        namespace + 'FNS_CurrencyCode__c',
                        namespace + 'FNS_EffectiveDate__c',
                        namespace + 'FNS_FinancialProductExtId__c',                   
                        namespace + 'FNS_MaturityDate__c',
                        namespace + 'FNS_OriginationTypeIndicator__c',
                        namespace + 'FNS_ProductSummary__c',
                        namespace + 'FNS_ExpiryDate__c',                 
                        namespace + 'FNS_ProductType__c',
                        namespace + 'FNS_Purpose__c',
                        namespace + 'FNS_RateType__c',
                        namespace + 'FNS_Amount__c',
                        namespace + 'FNS_RequestedClosingDate__c',
                        namespace + 'FNS_Term__c',
                        namespace + 'FNS_TermUnit__c', 
                        namespace + 'FNS_BypassValidation__c',
                        namespace + 'FNS_Application__c'                      
                    };                        
        } else {
            //For Non FSC 
            sobjectName = namespace+'FNS_FinancialAccount__c';
            fieldList = new List<String> {
                        namespace + 'FNS_Account__c',
                        namespace + 'FNS_Amount__c',
                        namespace + 'FNS_CurrencyCode__c',
                        namespace + 'FNS_EffectiveDate__c',                       
                        namespace + 'FNS_ExpiryDate__c',
                        namespace + 'FNS_FinancialProductExtId__c',
                        namespace + 'FNS_FinancialAccountTransaction__c',
                        namespace + 'FNS_MaturityDate__c',
                        namespace + 'FNS_Application__c',
                        namespace + 'FNS_OriginationTypeIndicator__c',                      
                        namespace + 'FNS_ProductSummary__c',                                            
                        namespace + 'FNS_ProductType__c',
                        namespace + 'FNS_Purpose__c',                      
                        namespace + 'FNS_RateType__c',
                        namespace + 'FNS_RequestedClosingDate__c',
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
        * @description Method to return Custom Product records based on feeIds
        * @param 	   Set of Prod Ids
        * @return      Returns List of Custom object Product
    **************************************************************************************/
    public List<Sobject> selectById(Set<Id> prodIds){
        return (List<Sobject>) selectSObjectsById(prodIds);
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Product object
        * @param 	   none
        * @return      Returns SObjecttype of Product object
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        String finAccountObjName;
        string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        if(FNS_Util.isFSCInstalled){
            finAccountObjName = 'FinServ__FinancialAccount__c' ;
        }else {
            /* For Non FSC */
            finAccountObjName = baseNamespace + 'FNS_FinancialAccount__c';
        }
        Schema.SObjectType finAccountObject = FNS_Util.getSobject(finAccountObjName);
        return finAccountObject;
    }
    
    /*************************************************************************************
        * @description Method to return Custom Product records
        * @param 	   none
        * @return      Returns List of Product object
    **************************************************************************************/
    public List<Sobject> getAllProducts() {
        return Database.query(newQueryFactory().toSOQL());
    }

    /*************************************************************************************
        * @description Method to return Product records along with its child records for Fee, 
                       Pricing records.This method returns record based on Product ids
        * @param 	   Set of Product Ids
        * @return      Returns List of Product object and its associated child records
    **************************************************************************************/
    public List<Sobject> selectProductsWithChilds(Set<Id> productIds) {
        
        String feeObjName = '';
        String pricingObjName = '';
        String productRoleObjName = '';
        String loanObjName = '';
        
        String productRolesQueryCondition = '';
        String loanQueryCondition = '';
        String feesQueryCondition = '';
        String pricingQueryCondition = '';
        
        string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        fflib_QueryFactory productsQueryFactory = newQueryFactory(true, true, true);
        productsQueryFactory.assertIsAccessible();
        productsQueryFactory.setEnforceFLS(true);
        
        if(FNS_Util.checkMCEnabled()){
            productsQueryFactory.selectField('CurrencyIsoCode');
        }
        
        List<String> prodQueryConditions = new List<String>();
        if(productIds != null && !productIds.isEmpty()){
            prodQueryConditions.add('Id IN :productIds');
        }
        
        if(! prodQueryConditions.isEmpty()){
            productsQueryFactory.setCondition(String.join(prodQueryConditions, ' AND '));
        }
        
        if(FNS_Util.isFSCInstalled){
            //This needs to relationship name to fetch the child records
            feeObjName = namespace + 'ProductFeesFSC__r';
            pricingObjName = namespace + 'ApplicationPricings__r';
            productRoleObjName = 'Finserv__FinancialAccountRoles__r';
            loanObjName = 'Finserv__FinancialAccountTranslations__r';
            productRolesQueryCondition = 'FinServ__FinancialAccount__c IN : productIds';
            loanQueryCondition = 'FinServ__FinancialAccount__c IN : productIds';
            feesQueryCondition = namespace +'FNS_FinancialAccountFSC__c IN : productIds';
            pricingQueryCondition = namespace +'FNS_FinancialAccountFSC__c IN : productIds';
        }else {
            feeObjName = namespace + 'FinancialProductFees__r';
            pricingObjName = namespace + 'FinancialProductPricings__r';
            productRoleObjName = namespace + 'FinancialAccountRoles__r';
            loanObjName = namespace + 'FinancialAccountLoans__r';
            productRolesQueryCondition = namespace + 'FNS_FinancialAccount__c IN : productIds';
            loanQueryCondition = namespace + 'FNS_FinancialAccount__c IN : productIds';
            feesQueryCondition = namespace +'FNS_FinancialAccount__c IN : productIds';
            pricingQueryCondition = namespace +'FNS_FinancialAccount__c IN : productIds';
            /* For Non FSC */
        }
        
        fflib_QueryFactory feesSubQueryFactory = new FNS_FeeSelector().addQueryFactorySubselect(productsQueryFactory, feeObjName);
        
        List<String> feesQueryConditions = new List<String>();
        feesQueryConditions.add(feesQueryCondition);
        feesSubQueryFactory.setCondition(String.join(feesQueryConditions, ' AND '));
        
        fflib_QueryFactory pricingSubQueryFactory = new FNS_PricingSelector().addQueryFactorySubselect(productsQueryFactory, pricingObjName);
        
        List<String> pricingQueryConditions = new List<String>();
        pricingQueryConditions.add(pricingQueryCondition);
        pricingSubQueryFactory.setCondition(String.join(pricingQueryConditions, ' AND '));
        
        fflib_QueryFactory productRoleSubQueryFactory = new FNS_ProductRolesSelector().addQueryFactorySubselect(productsQueryFactory, productRoleObjName);
        
        List<String> productRolesQueryConditions = new List<String>();
        productRolesQueryConditions.add(productRolesQueryCondition);
        productRoleSubQueryFactory.setCondition(String.join(productRolesQueryConditions, ' AND '));
        
        fflib_QueryFactory loanSubQueryFactory = new FNS_LoansSelector().addQueryFactorySubselect(productsQueryFactory, loanObjName);
        
        List<String> loanQueryConditions = new List<String>();
        loanQueryConditions.add(loanQueryCondition);
        loanSubQueryFactory.setCondition(String.join(loanQueryConditions, ' AND '));
        
        return (List<Sobject>) Database.query(productsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return Product records along with its child Loan records.
                       This method returns record based on Product ids
        * @param 	   Opportunity Id
        * @return      Returns List of Product object and its associated child Loan records
    **************************************************************************************/
    public List<Sobject> selectProductsWithLoans(String opportunityId) {
        
        String loanObjName = '';
        string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        fflib_QueryFactory productsQueryFactory = newQueryFactory(true, true, true);
        productsQueryFactory.assertIsAccessible();
        productsQueryFactory.setEnforceFLS(true);
        
        if(FNS_Util.checkMCEnabled()){
            productsQueryFactory.selectField('CurrencyIsoCode');
        }
        
        List<String> prodQueryConditions = new List<String>();
        if(opportunityId != null){
            prodQueryConditions.add(namespace +'FNS_Application__c = :opportunityId');
        }
        productsQueryFactory.setCondition(String.join(prodQueryConditions, ' AND '));
        if(FNS_Util.isFSCInstalled){
            //This needs to relationship name to fetch the child records
            loanObjName = 'Finserv__FinancialAccountTranslations__r';
        }else {
            loanObjName = namespace + 'FinancialAccountLoans__r';
        }
        fflib_QueryFactory loanSubQueryFactory = new FNS_LoansSelector().addQueryFactorySubselect(productsQueryFactory, loanObjName);
        System.debug('>>>ProductQuery>>>'+productsQueryFactory);
        return (List<Sobject>) Database.query(productsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return Product records along with its child Loan records.
                       This method returns record based on Application id
        * @param 	   Opportunity Id
        * @return      Returns List of Product object 
    **************************************************************************************/
    public List<Sobject> selectProductsByApplicationID(String opportunityId) {
        
        String loanObjName = '';
        string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        fflib_QueryFactory productsQueryFactory = newQueryFactory(true, true, true);
        productsQueryFactory.assertIsAccessible();
        productsQueryFactory.setEnforceFLS(true);
        
        List<String> prodQueryConditions = new List<String>();
        if(opportunityId != null){
            prodQueryConditions.add(namespace +'FNS_Application__c = :opportunityId');
        }
        productsQueryFactory.setCondition(String.join(prodQueryConditions, ' AND '));
        System.debug('>>>ProductQuery>>>'+productsQueryFactory);
        return (List<Sobject>) Database.query(productsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return Product records along with its child Fee records.
                       This method returns record based on Product ids
        * @param 	   Product Id
        * @return      Returns List of Product object and its associated child Fee records
    **************************************************************************************/
    public List<Sobject> selectProductsWithFee(String productId) {
        
        String loanObjName = '';
        string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        fflib_QueryFactory productsQueryFactory = newQueryFactory(true, true, true);
        productsQueryFactory.assertIsAccessible();
        productsQueryFactory.setEnforceFLS(true);
        
        if(FNS_Util.checkMCEnabled()){
            productsQueryFactory.selectField('CurrencyIsoCode');
        }
        
        List<String> prodQueryConditions = new List<String>();
        if(productId != null){
            prodQueryConditions.add('Id = :productId');
        }
        productsQueryFactory.setCondition(String.join(prodQueryConditions, ' AND '));
        if(FNS_Util.isFSCInstalled){
            loanObjName = 'Finserv__FinancialAccountTranslations__r';
        }else {
            loanObjName = namespace + 'FinancialAccountLoans__r';
        }
        fflib_QueryFactory loanSubQueryFactory = new FNS_LoansSelector().addQueryFactorySubselect(productsQueryFactory, loanObjName);
        return (List<Sobject>) Database.query(productsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return Product records along with its child records.
                       This method returns record based on Product ids
        * @param 	   Set of Product Id
        * @return      Returns List of Product object and its associated child records
    **************************************************************************************/
    public List<Sobject> selectProductWithChilds(Set<Id> productIdSet) {
        
        String feeObjName = '';
        String pricingObjName = '';
        String roleObjName = '';
        String loanObjName = '';
        
        string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        fflib_QueryFactory productsQueryFactory = newQueryFactory(true, true, true);
        productsQueryFactory.assertIsAccessible();
        productsQueryFactory.setEnforceFLS(true);
        
        if(FNS_Util.checkMCEnabled()){
            productsQueryFactory.selectField('CurrencyIsoCode');
        }
        
        List<String> prodQueryConditions = new List<String>();
        if(productIdSet != null && !productIdSet.isEmpty()){
            prodQueryConditions.add('Id IN :productIdSet');
        }
        productsQueryFactory.setCondition(String.join(prodQueryConditions, ' AND '));
        if(FNS_Util.isFSCInstalled){
            //This needs to relationship name to fetch the child records
            loanObjName = 'Finserv__FinancialAccountTranslations__r';
            roleObjName = 'Finserv__FinancialAccountRoles__r';
            feeObjName = namespace + 'ProductFeesFSC__r';
            pricingObjName = namespace + 'ApplicationPricings__r';
        }else {
            loanObjName = namespace + 'FinancialAccountLoans__r';
            roleObjName = namespace + 'FinancialAccountRoles__r';
            feeObjName = namespace + 'FinancialProductFees__r';
            pricingObjName = namespace + 'FinancialProductPricings__r';
        }
        fflib_QueryFactory loanSubQueryFactory = new FNS_LoansSelector().addQueryFactorySubselect(productsQueryFactory, loanObjName);
        fflib_QueryFactory roleSubQueryFactory = new FNS_ProductRolesSelector().addQueryFactorySubselect(productsQueryFactory, roleObjName);
        fflib_QueryFactory feeSubQueryFactory = new FNS_FeeSelector().addQueryFactorySubselect(productsQueryFactory, feeObjName);
        fflib_QueryFactory pricingSubQueryFactory = new FNS_PricingSelector().addQueryFactorySubselect(productsQueryFactory, pricingObjName);
        return (List<Sobject>) Database.query(productsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return Product records along with its child records.
                       This method returns record based on Opportunity ids
        * @param 	   Set of Opportunity Id
        * @return      Returns List of Product object and its associated child records
    **************************************************************************************/
    public List<Sobject> selectApplicationProductWithChilds(Set<Id> oppIdSet) {
        
        String feeObjName = '';
        String pricingObjName = '';
        String roleObjName = '';
        String loanObjName = '';
        
        string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        fflib_QueryFactory productsQueryFactory = newQueryFactory(true, true, true);
        productsQueryFactory.assertIsAccessible();
        productsQueryFactory.setEnforceFLS(true);
        productsQueryFactory.selectField('RecordTypeId');
        if(FNS_Util.checkMCEnabled()){
            productsQueryFactory.selectField('CurrencyIsoCode');
        }
        List<String> prodQueryConditions = new List<String>();
        if(oppIdSet != null && !oppIdSet.isEmpty()){
            prodQueryConditions.add(namespace +'FNS_Application__c IN :oppIdSet');
        }
        productsQueryFactory.setCondition(String.join(prodQueryConditions, ' AND '));
        if(FNS_Util.isFSCInstalled){
            //This needs to relationship name to fetch the child records
            loanObjName = 'Finserv__FinancialAccountTranslations__r';
            roleObjName = 'Finserv__FinancialAccountRoles__r';
            feeObjName = namespace + 'ProductFeesFSC__r';
            pricingObjName = namespace + 'ApplicationPricings__r';
        }else {
            loanObjName = namespace + 'FinancialAccountLoans__r';
            roleObjName = namespace + 'FinancialAccountRoles__r';
            feeObjName = namespace + 'FinancialProductFees__r';
            pricingObjName = namespace + 'FinancialProductPricings__r';
        }
        fflib_QueryFactory loanSubQueryFactory = new FNS_LoansSelector().addQueryFactorySubselect(productsQueryFactory, loanObjName);
        loanSubQueryFactory.selectField('RecordTypeId');
        fflib_QueryFactory roleSubQueryFactory = new FNS_ProductRolesSelector().addQueryFactorySubselect(productsQueryFactory, roleObjName);
        roleSubQueryFactory.selectField('RecordTypeId');
        fflib_QueryFactory feeSubQueryFactory = new FNS_FeeSelector().addQueryFactorySubselect(productsQueryFactory, feeObjName);
        feeSubQueryFactory.selectField('RecordTypeId');
        fflib_QueryFactory pricingSubQueryFactory = new FNS_PricingSelector().addQueryFactorySubselect(productsQueryFactory, pricingObjName);
        pricingSubQueryFactory.selectField('RecordTypeId');
        return (List<Sobject>) Database.query(productsQueryFactory.toSOQL());
    }
}