/**
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Utility Class
 * @description This class act as a domain class for Pricing object.
 */  
public with sharing class FNS_Util {
	private static ApexClass cs;
	public static boolean  isFSCInstalled = isFSCInstalled()  ; 
	public static  Map<String,String> dispostionIdToValue = new  Map<String,String>();
	public static  Map<String,String> dispostionValueToId = new  Map<String,String>();
	public static final String dateTimeFormat = 'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'';
	public static final String zone = 'America/New_York';
	static FNS_ErrorLog logger = new FNS_ErrorLog();

	static {
		if(dispostionIdToValue.keyset().isEmpty() || dispostionValueToId.keyset().isEmpty()){
			List<FNS_ConfigurationType__c> dispositionList = new FNS_ConfigurationTypeSelector().getConfigTypeRecordsByType('DISPOSITION');
			IF(dispositionList != null){
				for(FNS_ConfigurationType__c record : dispositionList) {
					dispostionIdToValue.put(record.FNS_ConfigurationId__c, record.FNS_Description__c);
					dispostionValueToId.put(record.FNS_Description__c, record.FNS_ConfigurationId__c);
				}
			}

		}
	}

	/*************************************************************************************
	 * @description  Method to check financial service cloud package is installed.
	 * @Params       none
	 * @Returns      As true if package is installed else return false.
	 **************************************************************************************/
	private static boolean isFSCInstalled(){
		List<ApexTrigger> apexTrigger = [SELECT id FROM ApexTrigger where NamespacePrefix = 'FinServ' AND Name = 'FinancialAccountTrigger' limit 1];
		if(apexTrigger!= null  && ! apexTrigger.isEmpty() ){
			isFSCInstalled = true;
		} else {
			isFSCInstalled = false;
		}
		return isFSCInstalled ;
	}

	/*************************************************************************************
	 * @description  Method used to get the namspace.
	 * @Params       none
	 * @Returns      String as NameSpace, if not then it returns blank string.
	 **************************************************************************************/
	public static String getBasePackageNamepace(){
		String nameSpacePrefix = '';
		if (cs==null){
			cs =[select NamespacePrefix from ApexClass where Name =:'FNS_Util' limit 1];
		}
		return (String.isNotBlank(cs.nameSpacePrefix) ?  cs.nameSpacePrefix + '__' :  ''); //need to change once we have namespace
	} 

	/*************************************************************************************
	 * @description  Method used to get the namspace.
	 * @Params       none
	 * @Returns      String as NameSpace, if not then it returns blank string.
	 **************************************************************************************/
	public static String getExtensionPackageNamespace(){
		//code to be updated
		String nameSpacePrefix = '';
		return  nameSpacePrefix;
	}         

	/*************************************************************************************
	 * @description  Method to check if multi-currency is enabled in Org.
	 * @Params       none
	 * @Returns      Boolean true if multiCurrency  feature is turn-on.
	 **************************************************************************************/
	/* @description: To check if multi-currency is enabled.*/
	public static Boolean checkMCEnabled(){
		return UserInfo.isMultiCurrencyOrganization();
	}


	/*************************************************************************************
	 * @description  Method to get Corporate currency code.
	 * @Params       none
	 * @Returns      String as Corporate CurrencyIso Code.
	 **************************************************************************************/
	public static String getCorpCurrency(){         
		String corporateCurrencyIsoCode; 
		if (UserInfo.isMultiCurrencyOrganization()){
			List<String> fieldList = new List<String>{'conversionrate', 'isocode','IsActive','IsCorporate'};
			String q='select IsoCode, ConversionRate from CurrencyType where IsActive=true and IsCorporate=true';
			List<SObject> currencies = Database.query(q);
			if(currencies != null){
				if (currencies.size()>0){
					corporateCurrencyIsoCode=(String)currencies[0].get('ISOCode');  
				}
			}
		}
		return corporateCurrencyIsoCode;
	}

	/*************************************************************************************
	 * @description  Method to get Corporate currency code.
	 * @Params       none
	 * @Returns      String as Corporate CurrencyIso Code.
	 **************************************************************************************/
	public static String convertCurrencyNameToSymbol(String currencyName){
		Map<String,String> currencySymbolsMap;
		currencySymbolsMap = new Map<String,String>{'AUD' => 'AU$', 
				'CAD' => 'CA$',
				'EUR' => '€',
				'GBP' => '£',
				'MYR' => 'RM',
				'NZD' => 'NZ$',
				'SGD' => 'SG$',
				'USD' => '$',
				'ZAR' => 'R',
				'INR'  => '₹',
				'JPY'  => '¥'

		};
		if(currencySymbolsMap.containsKey(currencyName)){
			String cSymbol = currencySymbolsMap.get(currencyName);
			return cSymbol;
		} else {
			return currencyName;
		}
	}

	/*************************************************************************************
	 * @description  Method used to make HTTP callout.
	 * @Params       requestWrap
	 * @Returns      HttpResponse.
	 **************************************************************************************/
	public static HttpResponse makeHTTPCallout(String requestWrap) {
		try {
			FNS_RequestWrapper reqestWrap= (FNS_RequestWrapper)JSON.deserialize(requestWrap, FNS_RequestWrapper.class);
			HttpRequest request = new HttpRequest();

			if (reqestWrap.Body != null && reqestWrap.Body != '') {
				request.setBody(reqestWrap.body);
			}

			request.setEndpoint(reqestWrap.endPoint);
			request.setMethod(reqestWrap.method);
			request.setTimeout(99999);
			for(String str:reqestWrap.headerMap.keySet()){
				request.setHeader(str, reqestWrap.headerMap.get(str));  
			}

			Http http = new Http();
			HttpResponse response = http.send(request);
			return response;
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}

	/*************************************************************************************
	 * @description  Method used to reurn Sobject with SobjectField.
	 * @Params       Map with OBject name as Key and FieldNames within List
	 * @Returns      Map with Sobject and list Sobject fields.
	 **************************************************************************************/
	public static  Map< Schema.SObjectType,List<Schema.SObjectField>> getSobjectWithFields(Map<String,List<String>> objectWithFieldsMap) {
		Map< Schema.SObjectType,List<Schema.SObjectField>>  sobjWithFieldsMap = new Map< Schema.SObjectType,List<Schema.SObjectField>> ();
		if(objectWithFieldsMap != null && !objectWithFieldsMap.keyset().isEmpty()) {
			for( String key: objectWithFieldsMap.keySet()){
				Schema.SObjectType sObj = Schema.getGlobalDescribe().get(key);
				if(!sobjWithFieldsMap.containsKey(sObj)) {

					List<Schema.SObjectField> listObjWithfls = new List<Schema.SObjectField>();
					for(String fieldname : objectWithFieldsMap.get(key)){
						listObjWithfls.add(sObj.getDescribe().fields.getMap().get(fieldname));
					}
					sobjWithFieldsMap.put(sObj ,listObjWithfls);
				}
			}
		}

		return sobjWithFieldsMap;
	}

	/*************************************************************************************
	 * @description  Method used to reurn Sobject with SobjectField.
	 * @Params       Map with OBject name as Key and FieldNames within List
	 * @Returns      Map with Sobect and list Sobject fields.
	 **************************************************************************************/
	public static Schema.SObjectType getSobject(String objName) {
		return Schema.getGlobalDescribe().get(objName);
	}

	/*************************************************************************************
	 * @description  Method to get the picklist field value
	 * @Params       sObjectType and set of Fields
	 * @Returns      Map of String, List of String
	 **************************************************************************************/
	public static Map<String, List<String>> getFieldPickListValues(String objectType, set<String> fieldList){
		Map<String, List<String>> picklistFldMap = new Map<String, List<String>>();
		for(String fld : fieldList){
			List<String> pickListValuesList = new List<String>();
			Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
			Schema.DescribeSObjectResult res = convertToObj.getDescribe();
			Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(fld).getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for( Schema.PicklistEntry pickListVal : ple){
				pickListValuesList.add(pickListVal.getLabel());
			}     
			picklistFldMap.put(fld, pickListValuesList); 
		} 
		return picklistFldMap;
	}
	/*************************************************************************************
	 * @description  Method to get the picklist field Value and Labels
	 * @Params       sObjectType and Fiel dName
	 * @Returns      Map of String
	 **************************************************************************************/
    public static Map<String,String> getPicklistFieldValueMap(String objectType,String fieldName){
        Map<String,String> PicklistFieldValueMap = new Map<String,String>();
        	List<String> pickListValuesList = new List<String>();
			Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
			Schema.DescribeSObjectResult res = convertToObj.getDescribe();
			Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(fieldName).getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for( Schema.PicklistEntry pickListVal : ple){
				PicklistFieldValueMap.put(pickListVal.getValue(),pickListVal.getLabel());
			}     
		return PicklistFieldValueMap;
    }
    /*************************************************************************************
     * @description  Method to get the picklist field Label and Value
     * @Params       sObjectType and Fiel dName
     * @Returns      Map of String
     **************************************************************************************/
    public static Map<String,String> getPicklistLabelToValueMap(String objectType,String fieldName){
        Map<String,String> pklistFldLblToValMap = new Map<String,String>();
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pklistFldLblToValMap.put(pickListVal.getLabel(),pickListVal.getValue());
        }     
        return pklistFldLblToValMap;
    }    

	/*************************************************************************************
	 * @description  Method to get the field Labels
	 * @Params       sObjectType and set of Fields
	 * @Returns      Map of String, List of String
	 **************************************************************************************/
	public static Map<String,String> getFieldLabels(String objectName,Set<String> fieldAPINames){
		Map<String, String> fieldLabels = new Map<String, String>();
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType ObjectSchema = schemaMap.get(objectName);

		Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();

		for (String fieldName: fieldMap.keySet()) {  
			if(fieldAPINames.contains(fieldName)){
				String fName = fieldMap.get(fieldName).getDescribe().getLabel();
				fieldLabels.put(fieldName,fName);
			}
		}
		return fieldLabels;
	}

	/*************************************************************************************
	 * @description  Method to get uow for product delete operation
	 * @Params       none
	 * @Returns      fflib_SObjectUnitOfWork as object
	 **************************************************************************************/
	public static fflib_SObjectUnitOfWork getUOWForProductDelete(){
		String baseNamespace= FNS_Util.getBasePackageNamepace();
		String extNamespace= FNS_Util.getExtensionPackageNamespace();
		String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;

		fflib_SObjectUnitOfWork uow ;  // SObjects (in order of dependency)

		String productObjName;
		String loanObjectName;
		FNS_Pricing__c pricing;
		FNS_Fee__c fee;

		// Check to identify if Financial Service Cloud package is installed   
		if(FNS_Util.isFSCInstalled){
			productObjName = 'FinServ__FinancialAccount__c' ;
			loanObjectName ='FinServ__FinancialAccountTransaction__c' ;
		}else {
			productObjName = baseNamespace+'FNS_FinancialAccount__c' ;
			loanObjectName = baseNamespace+'FNS_FinancialAccountTransaction__c' ;
		}

		Schema.SObjectType productObjType = Schema.getGlobalDescribe().get(productObjName);
		Schema.SObjectType loanObjType = Schema.getGlobalDescribe().get(loanObjectName);

		uow = new fflib_SObjectUnitOfWork( 
				new Schema.SObjectType[] {
						productObjType, 
						FNS_Pricing__c.SObjectType,
						FNS_Fee__c.SObjectType,
						loanObjType
				});

		return uow;
	}

	/*************************************************************************************
	 * @description  Method to delete product and its related records.
	 * @Params       fflib_SObjectUnitOfWork as object
	 * @Params       Product Id list.
	 * @Returns      none
	 **************************************************************************************/
	public static void deleteProductWithRelatedRecords(fflib_SObjectUnitOfWork uowForProduct, List<String> productIdList){
		fflib_SObjectUnitOfWork uow = uowForProduct;
		List<Sobject> productList = new List<SObject>();
		List<Sobject> loanList = new List<SObject>();
		List<Sobject> feeList = new List<SObject>();
		List<Sobject> pricingList = new List<SObject>();
		Set<Id> productIdSet = new Set<Id>();
		String productObjName = '';

		String baseNamespace= FNS_Util.getBasePackageNamepace();
		String extNamespace= FNS_Util.getExtensionPackageNamespace();
		String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;

		if(FNS_Util.isFSCInstalled){
			productObjName = 'FinServ__FinancialAccount__c' ;
		}else {
			productObjName = namespace+'FNS_FinancialAccount__c' ;
		}

		for(String productId : productIdList){
			productIdSet.add(Id.valueOf(productId));
			
			Sobject parentSobj = Schema.getGlobalDescribe().get(productObjName).newSObject();
			parentSobj.put('Id', productId);
			productList.add(parentSobj); 
		}
		loanList = new FNS_LoansSelector().getLoans(productIdSet);
		if(loanList != null && ! loanList.isEmpty()){
			uow.registerDeleted(loanList);
		}
        
		feeList = new FNS_FeeSelector().getFees(productIdSet);
		if(feeList != null && ! feeList.isEmpty()){
			uow.registerDeleted(feeList);
		}
        
		pricingList = new FNS_PricingSelector().getPricings(productIdSet);
		if(pricingList != null && ! pricingList.isEmpty()){
			uow.registerDeleted(pricingList);
		}
		
		if(productList != null && ! productList.isEmpty()){
			uow.registerDeleted(productList);
		}
		FNS_ObjectAccessContainer.checkFinAccountAccess(FNS_AccessController.DML_OPERATION_DELETE);
		FNS_ObjectAccessContainer.checkFinAccountTransactionAccess(FNS_AccessController.DML_OPERATION_DELETE);
		FNS_ObjectAccessContainer.checkFeeAccess(FNS_AccessController.DML_OPERATION_DELETE);
		FNS_ObjectAccessContainer.checkPricingAccess(FNS_AccessController.DML_OPERATION_DELETE);
		uow.commitWork();
	}

	/*************************************************************************************
	 * @description  Method to get opportunity details by external id.
	 * @Params       External Id as string
	 * @Returns      Opportunity object
	 **************************************************************************************/
	public static Opportunity getOpportunityFromAppResp(String applicationID){
		Opportunity application;  
		if(!String.isEmpty(applicationID)){
			List<Opportunity> appList = new List<Opportunity>();
			Set<String> applicationIDSet = new Set<String>();
			applicationIDSet.add(applicationID);
			appList = new FNS_ApplicationSelector().selectByExternalId(applicationIDSet);

			if(!appList.isEmpty()){
				application  = appList.get(0);
			}
		}
		return application;
	}

	/*************************************************************************************
	 * @description  Method to get the end point details
	 * @Params       API name as string
	 * @Returns      Endpoint as string
	 **************************************************************************************/
	public static string getEndpoint(string apiName){
		String urlEndPoint = '';
		List<FNS_FFDCAPIConfiguration__mdt> apiConfigList = new FNS_APIConfigurationSelector().getAllRecords();
		for(FNS_FFDCAPIConfiguration__mdt mdRecord : new FNS_APIConfigurationSelector().getAllRecords()){
			if(mdRecord.MasterLabel == apiName){
				urlEndPoint = mdRecord.FNS_APIName__c;
			}
		}
		return urlEndPoint;
	}

	/*************************************************************************************
	 * @description  Method to get uow for record delete operation.
	 * @Params       none
	 * @Returns      fflib_SObjectUnitOfWork object
	 **************************************************************************************/
	public static fflib_SObjectUnitOfWork getUOWForRecordDelete(){
		String baseNamespace= FNS_Util.getBasePackageNamepace();
		String extNamespace= FNS_Util.getExtensionPackageNamespace();
		String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
		String productRoleObjName;
		String productLoanObjName;
		fflib_SObjectUnitOfWork uow ;  // SObjects (in order of dependency)
		if(FNS_Util.isFSCInstalled){
			productRoleObjName = 'FinServ__FinancialAccountRole__c' ;
			productLoanObjName ='FinServ__FinancialAccountTransaction__c' ;
		}else {
			productRoleObjName = baseNamespace+'FNS_FinancialAccountRole__c' ;
			productLoanObjName = baseNamespace+'FNS_FinancialAccountTransaction__c' ;
		}
		Schema.SObjectType productRoleObjType = Schema.getGlobalDescribe().get(productRoleObjName);
		Schema.SObjectType productLoanObjType = Schema.getGlobalDescribe().get(productLoanObjName);
		uow = new fflib_SObjectUnitOfWork( 
				new Schema.SObjectType[] {
						productRoleObjType,
						productLoanObjType
				});

		return uow;
	}

	/*************************************************************************************
	 * @description  Method to delete records as per record id and object name
	 * @Params       uow for product object
	 * @Params       Record id as list
	 * @Params       Object name as string
	 * @Returns      none
	 **************************************************************************************/
	public static void deleteRecords(fflib_SObjectUnitOfWork uowForProduct, List<String> recordId, String objName){
		fflib_SObjectUnitOfWork uow = uowForProduct;
		List<Sobject> recordList = new List<SObject>();
		List<Sobject> loanList = new List<SObject>();
		Sobject objectRecord = Schema.getGlobalDescribe().get(objName).newSObject();
		for(String recId : recordId){
			objectRecord.put('Id', recId);
			recordList.add(objectRecord); 
			uow.registerDeleted(recordList);
		}
		uow.commitWork();
	}

	/*************************************************************************************
	 * @description  Method to query the FFDC API version to fetch Organization defaults
	 * @Params       none
	 * @Returns      API Version
	 **************************************************************************************/
	public static String getFFDCAPIVersion(){
		FNS_SFDCFFDCSetup__c ffdcConfig = FNS_SFDCFFDCSetup__c.getOrgDefaults();
		if(ffdcConfig != null){
			return ffdcConfig.FNS_APIVersion__c;
		}
		return null;
	}
	/*************************************************************************************
	 * @description  Method to convert Datetime value to String
	 * @Params       dateTime value
	 * @Returns      String value of inputted datetime parameter
	 **************************************************************************************/
	 public static String convertDateTimeToString(DateTime inputDateTime){
	 	String strConvertedDateTime;
	 	if(inputDateTime != null){
		 	try{
		 		strConvertedDateTime =  inputDateTime.format(dateTimeFormat,zone);
		 	}catch (Exception ex){
		 		system.debug('Error in date parsing :: ' + ex.getMessage() + ex.getStackTraceString());
		 	}
	 	}
	 	return strConvertedDateTime;
	 }
	
	 /*************************************************************************************
	 * @description  Method to convert Date value to String
	 * @Params       date value
	 * @Returns      String value of inputted date parameter
	 **************************************************************************************/	 
	 public static String convertDateToString(Date inputDate){
	 	String strConvertedDate;
	 	if(inputDate != null){
		 	try{
		 		strConvertedDate =  String.valueOf(inputDate);
		 	}catch (Exception ex){
		 		system.debug('Error in date parsing :: ' + ex.getMessage() + ex.getStackTraceString());
		 	}
	 	}
	 	return strConvertedDate;
	 }
	 /*************************************************************************************
	 * @description  Method to convert String value to Datetime value
	 * @Params       String value
	 * @Returns      Datetime value of inputted date parameter
	 **************************************************************************************/	 
	 public static DateTime convertStringToDateTime(String inputDateTime){
	 	DateTime convertedDateTime;
	 	if(String.isNotBlank(inputDateTime)){
		 	try{
		 		convertedDateTime =  (DateTime) JSON.deserialize('"'+inputDateTime+'"', DateTime.class);
		 	}catch (Exception ex){
		 		system.debug('Error in date parsing :: ' + ex.getMessage() + ex.getStackTraceString());
		 	}
	 	}
	 	return convertedDateTime;
	 }
	 /*************************************************************************************
	 * @description  Method to convert String value to Date value
	 * @Params       String value
	 * @Returns      Date value of inputted date parameter
	 **************************************************************************************/	 
	 public static Date convertStringToDate(String inputDate){
	 	Date convertedDate;
	 	if(String.isNotBlank(inputDate)){
		 	try{
		 		convertedDate =  Date.valueOf(inputDate);
		 	}catch (Exception ex){
		 		system.debug('Error in date parsing :: ' + ex.getMessage() + ex.getStackTraceString());
		 	}
	 	}
	 	return convertedDate;
	 }	 
}