/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Product Role object
****************************************************************************************/
public with sharing class FNS_ProductRolesSelector extends fflib_SObjectSelector {
	
	/*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_ProductRolesSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_ProductRolesSelector(Boolean enforceFLS) {
        super(true, true, false);
    }

    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Custom Product Role object
        * @param 	   none
        * @return      List of Schema.SObjectField of Custom Product Role object
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
    	if(FNS_Util.isFSCInstalled){
    		sobjectName = 'FinServ__FinancialAccountRole__c';
    		fieldList = new List<String> {
                        'Id',
                        namespace + 'FNS_GuaranteeDollar__c',
                        namespace + 'FNS_GuaranteePercent__c',
                        namespace + 'FNS_FinancialAccountTransaction__c',
                        namespace + 'FNS_ProductRelRole__c',
                        namespace + 'FNS_TypeofProdRole__c',
                        'FinServ__FinancialAccount__c',
                        'FinServ__RelatedAccount__c',
                        'FinServ__Role__c'
    				    };
		}else {
    		sobjectName = namespace+'FNS_FinancialAccountRole__c';
    		fieldList = new List<String> {
                        'Id',
                        namespace + 'FNS_GuaranteeDollar__c',
                        namespace + 'FNS_GuaranteePercent__c',
                        namespace + 'FNS_FinancialAccountTransaction__c',
                        namespace + 'FNS_ProductRelRole__c',
                        namespace + 'FNS_TypeofProdRole__c',
                        namespace + 'FNS_FinancialAccount__c',
                        namespace + 'FNS_RelatedAccount__c'
						};
    	}
    	 objectWithFieldsMap.put(sobjectName, fieldList);										  
    	 fieldsMap = FNS_Util.getSobjectWithFields(objectWithFieldsMap);
    	 sobj = Schema.getGlobalDescribe().get(sobjectName);
         return  fieldsMap.get(sobj);
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Custom Product Role object
        * @param 	   none
        * @return      Returns SObjecttype of Custom Product Role object
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
    	 String finAccountObjName;
    	 string baseNamespace= FNS_Util.getBasePackageNamepace();
         string extNamespace= FNS_Util.getExtensionPackageNamespace();
    	 string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
    	 if(FNS_Util.isFSCInstalled){
    	 	finAccountObjName = 'FinServ__FinancialAccountRole__c' ;
    	 }else {
    	 	finAccountObjName = namespace + 'FNS_FinancialAccountRole__c';
    	 }
    	 Schema.SObjectType finAccountObject = FNS_Util.getSobject(finAccountObjName);
         return finAccountObject;
    }
    
    /*************************************************************************************
        * @description Method to return Custom Product Role records
        * @param 	   none
        * @return      Returns List of Product object
    **************************************************************************************/
    public List<Sobject> getAllProducts() {
        return Database.query(newQueryFactory().toSOQL());
    }

    /*************************************************************************************
        * @description Method to return List of Sobject records based on productIds
        * @param 	   Set of Product Ids
        * @return      Returns List of Sobject
    **************************************************************************************/
    public List<SObject> getProductRoles(Set<Id> productIds) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
    	String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
		String productRoleQueryCondition = '';  
        fflib_QueryFactory productRoleQueryFactory = newQueryFactory(true, true, true);
        productRoleQueryFactory.assertIsAccessible();
        productRoleQueryFactory.setEnforceFLS(true);	
		List<String> productRoleQueryConditions = new List<String>();
        if(FNS_Util.isFSCInstalled){
			productRoleQueryCondition = 'FinServ__FinancialAccount__c IN : productIds';
		}else {
			productRoleQueryCondition = namespace + 'FNS_FinancialAccount__c IN : productIds';
		}
        productRoleQueryConditions.add(productRoleQueryCondition);
		if(! productRoleQueryConditions.isEmpty()){
            productRoleQueryFactory.setCondition(String.join(productRoleQueryConditions, ' AND '));
        }
		return (List<SObject>) Database.query(productRoleQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return Product-Role relationship as per ther provided productId
        * @param 	   Set of Product object ids
        * @return      Returns List of Product-Role object 
    **************************************************************************************/
    public List<SObject> getProductRolesWithParentsInfo(Set<Id> productIds) {
		String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
    	String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
		String productRoleQueryCondition = '';
		String accObjName = '';
        fflib_QueryFactory productRoleQueryFactory = newQueryFactory(true, true, true);
        productRoleQueryFactory.assertIsAccessible();
        productRoleQueryFactory.setEnforceFLS(true);	
		List<String> productRoleQueryConditions = new List<String>();  
        if(FNS_Util.isFSCInstalled){
			productRoleQueryCondition = 'FinServ__FinancialAccount__c IN : productIds';
			accObjName = 'FinServ__RelatedAccount__r';
		}else {
			productRoleQueryCondition = namespace + 'FNS_FinancialAccount__c IN : productIds';
			accObjName = baseNamespace+'FNS_RelatedAccount__r';
		}  
        fflib_SObjectSelector accountSelector = new FNS_AccountSelector();
      	accountSelector.configureQueryFactoryFields(productRoleQueryFactory, accObjName);
      	return (List<SObject>) Database.query( productRoleQueryFactory.toSOQL() );
	}
}