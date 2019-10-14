/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Create Product
    * @description Set the Fields, Objects API Name
  */
public with sharing class FNS_ProductDomain { 
    public static String finAccountObjName ;
    public static String finPricingObjName ;
    public static String finFeesObjName ;
    public static String finFinancialAccountTransactionObjName ;
    public static String finFinancialAccountRoleObjName ;
    public static String finAccprimaryOwner;
    public static String financialProduct; 
    public static String roleFinAccountLkp;
    public static String loanFinAccountLkp;
    public static String baseNamespace;
    public static String extNamespace;
    public static String namespace;
    public static String roleObjPklist;
    
    
    public static String finAccFieldSet;
    public static String financialAccountMoreFields;
    public static String financialAccountTransaMoreFields;
    
    
    public static String finAccRoleFieldSet; 
    public static String finAccTransactionFieldSet;
    public static String pricingFieldSet;
    public static String feeFieldSet;
    public static String loanOpportunityLkp;
    public static String financialAccountRequiredFields;
    public static String financialAccTransactionRequiredFields;
    public static String pricingRequiredFields;
    public static String pricingMoreFields;
    
    static {
        baseNamespace= FNS_Util.getBasePackageNamepace();
        extNamespace= FNS_Util.getExtensionPackageNamespace();
        namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        if(FNS_Util.isFSCInstalled){
            finAccountObjName = 'FinServ__FinancialAccount__c' ;
            finFinancialAccountTransactionObjName ='FinServ__FinancialAccountTransaction__c' ;
            finFinancialAccountRoleObjName ='FinServ__FinancialAccountRole__c' ;
            
            //Object Fields
            finAccprimaryOwner = 'FinServ__PrimaryOwner__c';
            financialProduct=namespace+'FNS_FinancialAccountFSC__c';
            roleFinAccountLkp='FinServ__FinancialAccount__c';
            loanFinAccountLkp='FinServ__FinancialAccount__c';
            roleObjPklist='FinServ__Role__c';
            
            /*Field Set Assignment Start*/
            finAccFieldSet=namespace+'FNS_FinancialAccount';
            finAccRoleFieldSet=namespace+'FNS_FinancialAccountRole'; 
            finAccTransactionFieldSet=namespace+'FNS_FinancialAccountTransaction';
            feeFieldSet =namespace+'FNS_Fee';
            pricingFieldSet=namespace+'FNS_Pricing';
            /*Field Set Assignment End*/
            financialAccountRequiredFields = namespace+'FNS_FinancialAccountRequiredFSC';
            financialAccTransactionRequiredFields = namespace+'FNS_FinancialAccTransactionRequiredFSC';
            pricingRequiredFields = namespace+'FNS_PricingRequiredFSC';
        }
        else
        {
            finAccountObjName = baseNamespace+'FNS_FinancialAccount__c' ;
            finFinancialAccountTransactionObjName = baseNamespace+'FNS_FinancialAccountTransaction__c' ;
            finFinancialAccountRoleObjName = baseNamespace+'FNS_FinancialAccountRole__c' ;
            
            //Object Fields
            finAccprimaryOwner =baseNamespace+ 'FNS_PrimaryOwner__c';
            financialProduct=baseNamespace+'FNS_FinancialAccount__c';
            roleFinAccountLkp=baseNamespace+'FNS_FinancialAccount__c';
            loanFinAccountLkp=baseNamespace+'FNS_FinancialAccount__c';
            roleObjPklist='FNS_OfficerRole__c';
            
            /*Field Set Assignment Start*/
            finAccFieldSet=baseNamespace+'FNS_FinancialAccount';
            finAccRoleFieldSet=baseNamespace+'FNS_FinancialAccountRole'; 
            finAccTransactionFieldSet=baseNamespace+'FNS_FinancialAccountTransaction';
            feeFieldSet =baseNamespace+'FNS_Fee';
            pricingFieldSet=baseNamespace+'FNS_Pricing';
            pricingRequiredFields = namespace+'FNS_PricingRequired';
            /*Field Set Assignment End*/
        }
        finPricingObjName = baseNamespace+'FNS_Pricing__c' ;
        finFeesObjName = baseNamespace+'FNS_Fee__c';
        loanOpportunityLkp = namespace+'FNS_Application__c';
        
        
        financialAccountMoreFields = baseNamespace+'FNS_FinancialAccountMoreFields';
        financialAccountTransaMoreFields=baseNamespace+'FNS_FinancialAccMoreFields';
        pricingMoreFields = baseNamespace+'FNS_PricingMoreFields';
    }
    
    /**
    * @description get Objects, Fields Map 
    * @param none
    * @return Map
    */
    public static  Map<String,FNS_FieldSetFormController.FieldSetForm> getObjFieldName(){
        Map<String,String> objectFields = new Map<String,String>();
        string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        
        objectFields.put(finAccountObjName,finAccFieldSet);
        objectFields.put(finPricingObjName,pricingFieldSet);
        objectFields.put(finFeesObjName,feeFieldSet);
        objectFields.put(finFinancialAccountRoleObjName,finAccRoleFieldSet); 
        objectFields.put(finFinancialAccountTransactionObjName,finAccTransactionFieldSet);
        System.debug('objectFields>>'+objectFields);
        Map<String, FNS_FieldSetFormController.FieldSetForm> objFieldNameMap = new Map<String, FNS_FieldSetFormController.FieldSetForm>(); 
        Map<String, FNS_FieldSetFormController.FieldSetForm> objFieldName = FNS_FieldSetFormController.getObjFields(objectFields); 
        
        for(String obj: objFieldName.keySet()){
            if(obj == finAccountObjName){
                objFieldNameMap.put('product',objFieldName.get(obj));
            }else if(obj == finFinancialAccountTransactionObjName){
                objFieldNameMap.put('loan',objFieldName.get(obj));
            }else if(obj == finPricingObjName){
                objFieldNameMap.put('pricing',objFieldName.get(obj));
            }else if(obj == finFeesObjName){
                objFieldNameMap.put('fee',objFieldName.get(obj));
            }else if(obj == finFinancialAccountRoleObjName){
                objFieldNameMap.put('role',objFieldName.get(obj));
            }
        }
        system.debug('objFieldNameMap>>'+objFieldNameMap);
        return objFieldNameMap;
    }
    
    /**
    * @description get Fields API Map 
    * @param none
    * @return Map
    */
    public static Map<String,String> getFieldAPINames(){
        
        Map<String,String> fieldAPINames= new Map<String,String>();
        fieldAPINames.put('primaryOwner',finAccPrimaryOwner);
        fieldAPINames.put('financialProduct',financialProduct);
        fieldAPINames.put('roleFinAccountLkp',roleFinAccountLkp);
        fieldAPINames.put('loanFinAccountLkp',loanFinAccountLkp); 
        fieldAPINames.put('roleObjPklist',roleObjPklist); 
        fieldAPINames.put('loanOpportunityLkp',loanOpportunityLkp);
        return fieldAPINames;
    }
    
    /**
    * @description get Objects API Map 
    * @param none
    * @return Map
    */
    public static Map<String,String> getObjectNames(){
        Map<String, String> objName = new Map<String, String>();
        objName.put('product',finAccountObjName);
        objName.put('pricing',finPricingObjName);
        objName.put('fee',finFeesObjName);
        objName.put('role',finFinancialAccountRoleObjName);
        objName.put('loan',finFinancialAccountTransactionObjName);
        return objName;
    }
    
    /**
    * @description get Financial Account Transaction Fields API Map 
    * @param none
    * @return Map
    */
    public static Map<String,String> getproductLoanFieldMap(){
        Map<String,String> productLoanFieldMap =new Map<String,String>();
        if(FNS_Util.isFSCInstalled){
            productLoanFieldMap.put('objName','FinServ__FinancialAccountTransaction__c');
            productLoanFieldMap.put('amount','FinServ__Amount__c');
            productLoanFieldMap.put('transDate','FinServ__TransactionDate__c');
            productLoanFieldMap.put('finAccountLkp','FinServ__FinancialAccount__c');
        }else{
            productLoanFieldMap.put('objName',namespace+'FNS_FinancialAccountTransaction__c');
            productLoanFieldMap.put('amount',namespace+'FNS_Amount__c');
            productLoanFieldMap.put('finAccountLkp',namespace+'FNS_FinancialAccount__c');
        }
            if(FNS_Util.checkMCEnabled()){
                productLoanFieldMap.put('currency','CurrencyIsoCode');
            }
            productLoanFieldMap.put('purpose',namespace+'FNS_LoanPurpose__c');
            productLoanFieldMap.put('term',namespace+'FNS_Term__c');
            productLoanFieldMap.put('reqDate',namespace+'FNS_RequestedDate__c');
            productLoanFieldMap.put('termUnit',namespace+'FNS_TermUnit__c');
            productLoanFieldMap.put('riskType',namespace+'FNS_RiskType__c');
            productLoanFieldMap.put('maturityDate',namespace+'FNS_MaturityDate__c');
            productLoanFieldMap.put('effDate',namespace+'FNS_EffectiveDate__c');
            productLoanFieldMap.put('pricingType',namespace+'FNS_PricingType__c');
            productLoanFieldMap.put('productType',namespace+'FNS_LoanProductType__c');
            productLoanFieldMap.put('frequency',namespace+'FNS_PricingFrequency__c');
        return productLoanFieldMap;
    }
    /**
    * @description get Financial Account Fields API Map 
    * @param none
    * @return Map
    */ 
     public static Map<String,String> getproductFieldMap(){
        Map<String,String> productFieldMap =new Map<String,String>();
        if(FNS_Util.isFSCInstalled){
            productFieldMap.put('objName','FinServ__FinancialAccount__c');
            productFieldMap.put('primaryOwner','FinServ__PrimaryOwner__c');
           
        }else{
            productFieldMap.put('objName',namespace+'FNS_FinancialAccount__c');
            productFieldMap.put('primaryOwner',namespace+'FNS_PrimaryOwner__c');
           
        }
            productFieldMap.put('productType',namespace+'FNS_ProductType__c');
            productFieldMap.put('reqAmount',namespace+'FNS_Amount__c');
            productFieldMap.put('purpose',namespace+'FNS_Purpose__c');
            productFieldMap.put('reqDate',namespace+'FNS_RequestedDate__c');
            productFieldMap.put('term',namespace+'FNS_Term__c');
            productFieldMap.put('termUnit',namespace+'FNS_TermUnit__c');
            productFieldMap.put('rateType',namespace+'FNS_RateType__c');
            productFieldMap.put('reqCloseDate',namespace+'FNS_RequestedClosingDate__c');
            productFieldMap.put('riskType',namespace+'FNS_RiskType__c');
            productFieldMap.put('currency',namespace+'CurrencyIsoCode');
            productFieldMap.put('effDate',namespace+'FNS_EffectiveDate__c');
            productFieldMap.put('supportCurrency',namespace+'FNS_SuppCurrencies__c');
         productFieldMap.put('application',namespace+'FNS_Application__c');
          productFieldMap.put('maturityDate',namespace+'FNS_MaturityDate__c');
        return productFieldMap;
    }
    
    /**
    * @description get Fees Fields API Map 
    * @param none
    * @return Map
    */
     public static Map<String,String> getFeeFieldMap(){
        Map<String,String> feeFieldMap =new Map<String,String>();
        if(FNS_Util.isFSCInstalled){
            feeFieldMap.put('finProduct',namespace+'FNS_FinancialAccountFSC__c');
        }else{
           feeFieldMap.put('finProduct',namespace+'FNS_FinancialAccount__c');
        }
            feeFieldMap.put('objName',namespace+'FNS_Fee__c');
            feeFieldMap.put('feeType',namespace+'FNS_FeeType__c');
            feeFieldMap.put('feeRate',namespace+'FNS_FeeRate__c');
            feeFieldMap.put('amount',namespace+'FNS_Amount__c');
            
            
        return feeFieldMap;
    }
    
    /**
    * @description get Pricing Fields API Map 
    * @param none
    * @return Map
    */
    public static Map<String,String> getPricingFieldMap(){
        Map<String,String> feeFieldMap =new Map<String,String>();
        if(FNS_Util.isFSCInstalled){
            feeFieldMap.put('finProduct',namespace+'FNS_FinancialAccountFSC__c');
        }else{
           feeFieldMap.put('finProduct',namespace+'FNS_FinancialAccount__c');
        }
            feeFieldMap.put('objName',namespace+'FNS_Pricing__c');
            feeFieldMap.put('pricingType',namespace+'FNS_PricingType__c');
            feeFieldMap.put('frequency',namespace+'FNS_Frequencies__c');
        return feeFieldMap;
    }
    
    /**
    * @description get Financial Account Role Fields API Map 
    * @param none
    * @return Map
    */ 
    public static Map<String,String> getproductRoleFieldMap(){
        Map<String,String> productRoleFieldMap =new Map<String,String>();
        if(FNS_Util.isFSCInstalled){
            productRoleFieldMap.put('objName','FinServ__FinancialAccountRole__c');
            productRoleFieldMap.put('finAccount','FinServ__FinancialAccount__c');
            productRoleFieldMap.put('relatedAccount','FinServ__RelatedAccount__c');
           
        }else{
            productRoleFieldMap.put('objName',namespace+'FNS_FinancialAccountRole__c');
            productRoleFieldMap.put('finAccount',namespace+'FNS_FinancialAccount__c');
            productRoleFieldMap.put('relatedAccount',namespace+'FNS_RelatedAccount__c');
           
        }
        productRoleFieldMap.put('typeofRole',namespace+'FNS_TypeofProdRole__c');
        productRoleFieldMap.put('relationshipRole',namespace+'FNS_ProductRelRole__c');
        productRoleFieldMap.put('guaranteeDoll',namespace+'FNS_GuaranteeDollar__c');
        productRoleFieldMap.put('guaranteePercent',namespace+'FNS_GuaranteePercent__c');
           
        return productRoleFieldMap;
    }
    
    ///New Screen Mockup Developement:
    public static string getProductObjectName(){
      return finAccountObjName;
    }
    public static List<FNS_Field> getProductFields(){
      List<FNS_Field> ProductFields= FNS_FieldSetFormController.getFields(finAccountObjName,finAccFieldSet);
        return ProductFields;
    }
    public static List<FNS_Field> getProductMoreFields(){
        List<FNS_Field> ProductMoreFields= FNS_FieldSetFormController.getFields(finAccountObjName,FinancialAccountMoreFields);
        return ProductMoreFields;
    }
    public static List<FNS_Field> getProductRequiredFields(){
        List<FNS_Field> ProductMoreFields= FNS_FieldSetFormController.getFields(finAccountObjName,financialAccountRequiredFields);
        return ProductMoreFields;
    }
    public static Map<String,String> getProductFieldAPINames(){
        
        Map<String,String> fieldAPINames= new Map<String,String>();
        fieldAPINames.put('primaryOwner',finAccPrimaryOwner);
        fieldAPINames.put('application',namespace+'FNS_Application__c');
        fieldAPINames.put('transDate','FinServ__TransactionDate__c');
        return fieldAPINames;
    }
    public static Map<String,String> getLoanFieldAPINames(){
        Map<String,String> fieldAPINames= new Map<String,String>();
        fieldAPINames.put('transDate','FinServ__TransactionDate__c');
        return fieldAPINames;
    }
    public static string getLoanObjectName(){
        return finFinancialAccountTransactionObjName;
    }
    public static List<FNS_Field> getLoanFields(){
        List<FNS_Field> LoanFields= FNS_FieldSetFormController.getFields(finFinancialAccountTransactionObjName,finAccTransactionFieldSet);
        return LoanFields;
    }
    public static List<FNS_Field> getLoanMoreFields(){
        List<FNS_Field> LoanMoreFields= FNS_FieldSetFormController.getFields(finFinancialAccountTransactionObjName,financialAccountTransaMoreFields);
        return LoanMoreFields;
    }
    public static List<FNS_Field> getLoanRequiredFields(){
        List<FNS_Field> ProductMoreFields= FNS_FieldSetFormController.getFields(finFinancialAccountTransactionObjName,financialAccTransactionRequiredFields);
        return ProductMoreFields;
    }
    
    public static string getPricingObjectName(){
        return finPricingObjName;
    }
    public static List<FNS_Field> getPricingFields(){
        List<FNS_Field> pricingFields = FNS_FieldSetFormController.getFields(finPricingObjName,pricingFieldSet);
        return pricingFields;
    }
    
    public static Map<String,String> getPricingFieldAPINames(){
        Map<String,String> fieldAPINames= new Map<String,String>();
        fieldAPINames.put('baseRate',namespace+'FNS_BaseRate__c');
        fieldAPINames.put('ratebasis',namespace+'FNS_RateBasis__c');
        return fieldAPINames;
    }
    public static List<FNS_Field> getPricingRequiredFields(){
        List<FNS_Field> pricingRequiredFieldList = FNS_FieldSetFormController.getFields(finPricingObjName,pricingRequiredFields);
        return pricingRequiredFieldList;
    }
    public static List<FNS_Field> getPricingMoreFields(){
        List<FNS_Field> pricingMoreFieldList = FNS_FieldSetFormController.getFields(finPricingObjName,pricingMoreFields);
        return pricingMoreFieldList;
    }
}