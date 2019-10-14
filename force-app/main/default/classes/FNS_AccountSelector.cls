/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Account object
****************************************************************************************/
public with sharing class FNS_AccountSelector extends fflib_SObjectSelector{

    String finAccountObjName;

    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_AccountSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_AccountSelector(Boolean enforceFLS) {
        super(true, true, false);
    }

    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Accountobject
        * @param 	   none
        * @return      List of Schema.SObjectField of Accountobject
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        
        List<String> fieldList;
    	Map<Schema.SObjectType,List<Schema.SObjectField>> fieldsMap = new Map<Schema.SObjectType,List<Schema.SObjectField>>();    	
    	Map<String, List<String>> objectWithFieldsMap = new Map<String, List<String>>();    	
    	String sobjectName;
    	Schema.SObjectType sObj;
    	string baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
    	
    	if(FNS_Util.isFSCInstalled){
    		sobjectName = 'Account';
            
    		fieldList = new List<String> {
											baseNamespace+'FNS_CustomerExtId__c', 
										    baseNamespace+'FNS_IdentityNumber__c',
											baseNamespace+'FNS_IdentityType__c',
											baseNamespace+'FNS_OfficialType__c',
											baseNamespace+'FNS_CustomerDescription__c',
                                            baseNamespace+'FNS_NAICSCode__c', 
                                            baseNamespace+'FNS_CustomerStruct__c', 
                                            baseNamespace+'FNS_SICCode__c', 
											 'NaicsDesc'
    									};
			
    	}else {
    		 //For Non FSC 
    		sobjectName = 'Account';
    		fieldList = new List<String> {
    										baseNamespace+'FNS_CustomerExtId__c', 
										    baseNamespace+'FNS_IdentityNumber__c',
											baseNamespace+'FNS_IdentityType__c',
											baseNamespace+'FNS_OfficialType__c',
											baseNamespace+'FNS_CustomerDescription__c',
											baseNamespace+'FNS_NaicsDescription__c',
                                            baseNamespace+'FNS_NAICSCode__c', 
                                            baseNamespace+'FNS_CustomerStruct__c', 
                                            baseNamespace+'FNS_SICCode__c',
                                            baseNamespace+'FNS_NaicsDescription__c'
											
										 };
			
    	}
        fieldList.add('AccountNumber'); 
        fieldList.add('AnnualRevenue'); 
        fieldList.add('SicDesc');
        fieldList.add('Name');
		fieldList.add('Id');
        objectWithFieldsMap.put(sobjectName, fieldList);										  
        fieldsMap = FNS_Util.getSobjectWithFields(objectWithFieldsMap);
        sobj = Schema.getGlobalDescribe().get(sobjectName);
        return  fieldsMap.get(sobj);
    }

    /*************************************************************************************
        * @description Method to return SObject type of Accountobject
        * @param 	   none
        * @return      Returns SObjecttype of Accountobject
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }

    /*************************************************************************************
        * @description Method to return Accountrecords based on accountIds
        * @param 	   Set of Accountids
        * @return      Returns List of Accountobject
    **************************************************************************************/
    public List<Account> selectById(Set<Id> accountIds) {
        return (List<Account>) selectSObjectsById(accountIds);
    }
    
    /*************************************************************************************
        * @description Method to return Accountrecords based on accountIds
        * @param 	   Set of Account External Ids
        * @return      Returns List of Accountobject
    **************************************************************************************/
    public List<Account> selectByExternalId(Set<String> accountExtIds){
    	fflib_QueryFactory query = newQueryFactory();
		String baseNamespace = FNS_Util.getBasePackageNamepace();
		if(accountExtIds != null && !accountExtIds.isEmpty()){
		    query.setCondition(baseNamespace+'FNS_CustomerExtId__c IN :accountExtIds');
		}
        return (List<Account>) Database.query( query.toSOQL());
	}
	
    /*************************************************************************************
        * @description Method to return Account query along with its child records
        * @param 	   none
        * @return      Returns List of Account object and its associated child records
    **************************************************************************************/
    public fflib_QueryFactory getCustomerSOQL() {
        
        String baseNamespace = FNS_Util.getBasePackageNamepace();
		String addressObjName = baseNamespace+'Addresses__r';
        String custProfileObjName = baseNamespace+'CustomerProfiles__r';
        String taxDetailsObjName = baseNamespace+'TaxDetails__r';
        
        fflib_QueryFactory customerQueryFactory = newQueryFactory(true, true, true);
        customerQueryFactory.assertIsAccessible();
        customerQueryFactory.setEnforceFLS(true);
        if(FNS_Util.checkMCEnabled()){
        	customerQueryFactory.selectField('CurrencyIsoCode');
        }
       
        fflib_QueryFactory addressSubQueryFactory = new FNS_AddressSelector().addQueryFactorySubselect(customerQueryFactory, addressObjName);
		fflib_QueryFactory contactsSubQueryFactory = new FNS_ContactSelector().addQueryFactorySubselect(customerQueryFactory, 'Contacts');
		fflib_QueryFactory customerProfileSubQueryFactory = new FNS_CustomerProfilesSelector().addQueryFactorySubselect(customerQueryFactory, custProfileObjName);
		fflib_QueryFactory taxDetailsSubQueryFactory = new FNS_TaxDetailsSelector().addQueryFactorySubselect(customerQueryFactory, taxDetailsObjName);
        
        return customerQueryFactory;
    }
    
    /*************************************************************************************
        * @description Method to return Account records along with its child records based 
                       on ExternalId
        * @param 	   Set of Account External Ids
        * @return      Returns List of Account object and its associated child records
    **************************************************************************************/
    public List<Account> selectCustomerWithRelatedRecordsByExtId(Set<String> accountExtIds) {
        
        String baseNamespace = FNS_Util.getBasePackageNamepace();
		fflib_QueryFactory accountQueryFactory = getCustomerSOQL();
        
        if(accountExtIds != null && !accountExtIds.isEmpty()){
            accountQueryFactory.setCondition(baseNamespace+'FNS_CustomerExtId__c IN :accountExtIds');
        }
		return (List<Account>) Database.query(accountQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return Account records along with its child records based 
                       on Account Id
        * @param 	   Set of Account Ids
        * @return      Returns List of Account object and its associated child records
    **************************************************************************************/
    public List<Account> selectCustomerWithRelatedRecordsById(Set<String> accountIds) {
        
        fflib_QueryFactory accountQueryFactory = getCustomerSOQL();
        if(accountIds != null && !accountIds.isEmpty()){
            accountQueryFactory.setCondition('Id IN :accountIds');
        }
		return (List<Account>) Database.query(accountQueryFactory.toSOQL());
    }

    /*************************************************************************************
        * @description Method to return Account records based on Account record Id
        * @param 	   Account Record Id
        * @return      Returns List of Account object 
    **************************************************************************************/
    public Account getAccountRecord(Id accountRecordId) {
        
        fflib_QueryFactory accountQueryFactory = newQueryFactory(true, true, true);
        //String accountQueryCondition; 
        if(accountRecordId !=  null){
           accountQueryFactory.setCondition('Id =: accountRecordId'); 
        }    
        accountQueryFactory.setLimit(1); 
		return (Account) Database.query(accountQueryFactory.toSOQL());
    }
}