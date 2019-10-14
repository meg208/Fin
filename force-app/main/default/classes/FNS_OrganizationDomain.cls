/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Object Domain
* @description This class act as domain class for Organization/Account 
****************************************************************************/
public with sharing class FNS_OrganizationDomain extends fflib_SObjectDomain {
    static FNS_ErrorLog logger = new FNS_ErrorLog();
	static public Boolean isCustomerPushSuccess = true;
    /***********************************************************************
    * @description Constructs the domain class for Account
    * @param List of Account records
    * @return none 
    ************************************************************************/
    public FNS_OrganizationDomain(List<Account> sObjectList) {
        super(sObjectList);
    }

	/***********************************************************************
	* @description Interface used by the triggerHandler in constructing instances of Domain class
	* @param List of Account records
	* @return returns new instance of FNS_OrganizationDomain class 
	************************************************************************/
	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new FNS_OrganizationDomain(sObjectList);
		}
	}
	/***********************************************************************
	* @description Get all the account records based on external id 
	* @param Set of External Id of Account records
	* @param instance of unit of work
	* @return none 
	************************************************************************/
	public static Map<String, String> pushCustomerAndRelatedRecords(Set<String> customerExtIdSet, String bankExtId, fflib_ISObjectUnitOfWork uow){
		String baseNamespace = FNS_Util.getBasePackageNamepace();
		Map<String, String> customerIdToExtIdMap = new Map<String, String>();
		try{
			User rmUSer = new FNS_UserSelector().selectById(UserInfo.getUserId());
			List<Account> accountList = new FNS_AccountSelector().selectCustomerWithRelatedRecordsById(customerExtIdSet);
			Map<String, String> customerIdToDataMap = new Map<String, String>(); 
			Boolean isSuccess = true;
			List<Account> accToUpdateList = new List<Account>(); 
            if(accountList != null){
				for(Account accRec: accountList){
					String wrapperData = buildCustomerWrapperObject(accRec, bankExtId);
                    system.debug(LoggingLevel.ERROR,'Organization Request wrapper>>>>'+wrapperData);
					customerIdToDataMap.put((String)accRec.Id, wrapperData);

					FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
					param.objectName = FNS_Constants.CLASS_ORGANIZATIONS;
					param.endPoint = FNS_Constants.URL_ORGANIZATIONS;
					param.methodName = FNS_Constants.METHOD_POST;
					param.body=wrapperData;

					Map<String, String> headerMap = new Map<String, String>();
					headerMap.put(FNS_Constants.ACCEPT, FNS_Constants.APPLICATION_JSON);
					headerMap.put(FNS_Constants.CONTENT_TYPE, FNS_Constants.APPLICATION_JSON);
					headerMap.put(FNS_Constants.CUSTOMER_PUSH_HEADER, rmUSer.FNS_UserExternalId__c);
					param.headerMap = headerMap;

					FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
					HttpResponse jsonResponse = router.getPostRequest(param);

					System.debug(LoggingLevel.ERROR,'Organization Response>>>>'+jsonResponse);
					if(jsonResponse.getStatusCode() == 200){
						if (!String.isEmpty(jsonResponse.getBody())){
							FNS_OrganizationPayLoad.FNS_Response respWrapper = (FNS_OrganizationPayLoad.FNS_Response) JSON.deserialize(jsonResponse.getBody(), FNS_OrganizationPayLoad.FNS_Response.class);

							if(respWrapper.organizationId == null){
								isSuccess = false;
							}else {
								Account accToUpdate = new Account(
									Id = accRec.Id,
									FNS_CustomerExtId__c = respWrapper.organizationId
								);
								uow.registerDirty(accToUpdate);
								customerIdToExtIdMap.put(accRec.Id, respWrapper.organizationId);
							}
						}	
					}else {
						isCustomerPushSuccess = false;
					}
				}
			}
		}catch(Exception ex){
            logger.addLogRecord('FNS_OrganizationDomain', 'pushCustomerAndRelatedRecords', ex.getMessage() + ex.getStackTraceString());
        }
        return customerIdToExtIdMap;
	}
	
	/***********************************************************************
	* @description build the customer wrapper object 
	* @param Set of External Id of Account records
	* @param instance of unit of work
	* @return returns json string of account and its associated child record 
	************************************************************************/
	public static String buildCustomerWrapperObject(Account accountRecord, String bankExtId){
		String baseNamespace = FNS_Util.getBasePackageNamepace();

		List<SObject> contactRecordList = accountRecord.getSObjects('Contacts');
		List<SObject> addressRecordList = accountRecord.getSObjects(baseNamespace+'Addresses__r');
		List<SObject> taxDetailsRecordList = accountRecord.getSObjects(baseNamespace+'TaxDetails__r');
		List<SObject> customerProfileRecordList = accountRecord.getSObjects(baseNamespace+'CustomerProfiles__r');

		List<FNS_OrganizationPayLoad.FNS_ContactList> contactWrapperList = new List<FNS_OrganizationPayLoad.FNS_ContactList>();
		List<FNS_OrganizationPayLoad.FNS_Addresses> addressWrapperList = new List<FNS_OrganizationPayLoad.FNS_Addresses>();
		List<FNS_OrganizationPayLoad.FNS_TaxDetails> taxDetailsWrapperList = new List<FNS_OrganizationPayLoad.FNS_TaxDetails>();
		List<FNS_OrganizationPayLoad.FNS_CustomerProfiles> customerProfileWrapperList = new List<FNS_OrganizationPayLoad.FNS_CustomerProfiles>();

		FNS_OrganizationPayLoad wrapperObject = new FNS_OrganizationPayLoad();
        wrapperObject.annualRevenue = new FNS_OrganizationPayLoad.AnnualRevenue();

		if(addressRecordList != null && ! addressRecordList.isEmpty()){
			for(SObject childObj : addressRecordList){
				FNS_OrganizationPayLoad.FNS_Addresses addressObject = new FNS_OrganizationPayLoad.FNS_Addresses();

				addressObject.addressType = (String)childObj.get(baseNamespace+'FNS_AddressType__c');
				addressObject.city = (String)childObj.get(baseNamespace+'FNS_City__c');
                addressObject.state = (String)childObj.get(baseNamespace+'FNS_State__c');
				//addressObject.country = (String)childObj.get(baseNamespace+'FNS_CountryCode__c');
                //addressObject.country = FNS_Util.getPicklistFieldValueMap('FNS_Address__c',baseNamespace+'FNS_CountryCode__c').get((String)childObj.get(baseNamespace+'FNS_CountryCode__c'));
				addressObject.country =(String)childObj.get(baseNamespace+'FNS_CountryCode__c');//'USA';this should be name like USA ater changed it from CME
                addressObject.postalCode = String.valueOf(childObj.get(baseNamespace+'FNS_PostalCode__c'));
				addressObject.postalCodeExtension = String.valueOf(childObj.get(baseNamespace+'FNS_PostalCodeExtension__c'));
				addressObject.province = (String)childObj.get(baseNamespace+'FNS_ProvinceCode__c');
				addressObject.street1 = (String)childObj.get(baseNamespace+'FNS_Address1__c');
				addressObject.street2 = (String)childObj.get(baseNamespace+'FNS_Address2__c');
				addressObject.street3 = (String)childObj.get(baseNamespace+'FNS_Address3__c');
				addressObject.houseNumber = '1234';//Not Available on Object API 1.0
				addressWrapperList.add(addressObject);
			}
		}

		if(contactRecordList != null && ! contactRecordList.isEmpty()){
			for(SObject childObj : contactRecordList){
				List<FNS_OrganizationPayLoad.FNS_PhoneList> phoneWrapperList = new List<FNS_OrganizationPayLoad.FNS_PhoneList>();

				FNS_OrganizationPayLoad.FNS_PhoneList phoneWrapperRecord1 = new FNS_OrganizationPayLoad.FNS_PhoneList();
				phoneWrapperRecord1.phoneNumber = (String)childObj.get('Phone');
				phoneWrapperRecord1.phoneType = FNS_Constants.CONTACT_PHONE_TYPE_PRIMARY;
				phoneWrapperList.add(phoneWrapperRecord1);

				FNS_OrganizationPayLoad.FNS_PhoneList phoneWrapperRecord2 = new FNS_OrganizationPayLoad.FNS_PhoneList();
				phoneWrapperRecord2.phoneNumber = (String)childObj.get('HomePhone');
				phoneWrapperRecord2.phoneType = FNS_Constants.CONTACT_PHONE_TYPE_SECONDARY;
				phoneWrapperList.add(phoneWrapperRecord2);

				FNS_OrganizationPayLoad.FNS_PhoneList phoneWrapperRecord3 = new FNS_OrganizationPayLoad.FNS_PhoneList();
				phoneWrapperRecord3.phoneNumber = (String)childObj.get('MobilePhone');
				phoneWrapperRecord3.phoneType = FNS_Constants.CONTACT_PHONE_TYPE_HOME;
				phoneWrapperList.add(phoneWrapperRecord3);

				FNS_OrganizationPayLoad.FNS_ContactList conObject = new FNS_OrganizationPayLoad.FNS_ContactList();

				conObject.department = (String)childObj.get('Department');
				conObject.fullName = (String)childObj.get('Name');
				conObject.phoneList = phoneWrapperList;
				conObject.primaryBusinessEmail = (String)childObj.get('Email');
                conObject.contactType = (String)childObj.get('FNS_ContactType__c');
				conObject.title = (String)childObj.get('Title');
				conObject.contactType = FNS_Util.getPicklistFieldValueMap('Contact',baseNamespace+'FNS_ContactType__c').get((String)childObj.get(baseNamespace+'FNS_ContactType__c'));
				contactWrapperList.add(conObject);
			}
		}

		if(taxDetailsRecordList != null && ! taxDetailsRecordList.isEmpty()){
			for(SObject childObj : taxDetailsRecordList){
				FNS_OrganizationPayLoad.FNS_TaxDetails taxDetailObject = new FNS_OrganizationPayLoad.FNS_TaxDetails();

				//taxDetailObject.taxCountry = (String)childObj.get(baseNamespace+'FNS_TaxCountry__c');//API 1.0
				taxDetailObject.taxExemptCode = (String)childObj.get(baseNamespace+'FNS_TaxExmptCode__c');
				taxDetailObject.taxNumber = (String)childObj.get(baseNamespace+'FNS_TaxNumber__c');
				taxDetailObject.taxPayerId = String.valueOf(childObj.get(baseNamespace+'FNS_TaxPayerId__c'));
				taxDetailObject.taxRegion = (String)childObj.get(baseNamespace+'FNS_TaxRegion__c');
				taxDetailObject.taxType = (String)childObj.get(baseNamespace+'FNS_TaxType__c');
				taxDetailObject.country= (String)childObj.get(baseNamespace+'FNS_TaxCountry__c');//'USA';//not available in Request; //API 1.0
				taxDetailsWrapperList.add(taxDetailObject);
			}
		}
		if(customerProfileRecordList != null && ! customerProfileRecordList.isEmpty()){
			for(SObject childObj : customerProfileRecordList){
				FNS_OrganizationPayLoad.FNS_CustomerProfiles customerProfileObject = new FNS_OrganizationPayLoad.FNS_CustomerProfiles();
                 //API 1.0
				//customerProfileObject.creditComment = (String)childObj.get(baseNamespace+'FNS_CreditComment__c');
				//customerProfileObject.creditReviewDate = (DateTime)childObj.get(baseNamespace+'FNS_CreditReviewDate__c');
				customerProfileObject.profileType = (String)childObj.get(baseNamespace+'FNS_ProfileType__c');

				customerProfileWrapperList.add(customerProfileObject);
			}
		}
		FNS_OrganizationPayLoad.FNS_PrimaryIdentifier primaryWrapper = new FNS_OrganizationPayLoad.FNS_PrimaryIdentifier();
		primaryWrapper.identityNumber = (String)accountRecord.get(baseNamespace+'FNS_IdentityNumber__c');
		primaryWrapper.identityType = (String)accountRecord.get(baseNamespace+'FNS_IdentityType__c');

		FNS_OrganizationPayLoad.FNS_HostSystemInternalIdentifiers hostWrapper = new FNS_OrganizationPayLoad.FNS_HostSystemInternalIdentifiers();
		List<FNS_OrganizationPayLoad.FNS_HostSystemInternalIdentifiers> hostWrapperList = new List<FNS_OrganizationPayLoad.FNS_HostSystemInternalIdentifiers>();
		if(String.isNotBlank(bankExtId)) {
			hostWrapper.bankId = bankExtId;
		}else {
			hostWrapper.bankId = '1';
		}
		//hostWrapper.hostSystemInternalIdentifierCode = 'LIQ';
		hostWrapper.name = 'Loan IQ';
        hostWrapper.code='LIQ';
		hostWrapperList.add(hostWrapper);

		wrapperObject.addresses = addressWrapperList;
       
		wrapperObject.annualRevenue.amount = Integer.valueOf(accountRecord.AnnualRevenue);
       
		wrapperObject.contactList = contactWrapperList;
		wrapperObject.customerId = (String)accountRecord.get(baseNamespace+'FNS_CustomerExtId__c');
		wrapperObject.customerProfiles = customerProfileWrapperList;
		wrapperObject.fullName = accountRecord.Name;
		wrapperObject.hostSystemInternalIdentifiers = hostWrapperList;
		wrapperObject.official = false;
		wrapperObject.officialType = (String)accountRecord.get(baseNamespace+'FNS_OfficialType__c');
		wrapperObject.structure = (String)accountRecord.get(baseNamespace+'FNS_CustomerStruct__c');
		wrapperObject.primaryIdentifier = primaryWrapper;
        
        wrapperObject.sicCodeCountry = 'USA';//API 1.0 field Mapping not sure
        wrapperObject.legalName = accountRecord.Name;//'Houston Oil Corp';
        wrapperObject.annualRevenue.currencyCode = 'USD';//this should dynamic API 1.0
		if(FNS_Util.checkMCEnabled()){
			//wrapperObject.revenueCurrency = (String)accountRecord.get('CurrencyIsoCode');//API 1.0
		}
		wrapperObject.taxDetails = taxDetailsWrapperList;
		wrapperObject.customerDescription = (String)accountRecord.get(baseNamespace+'FNS_CustomerDescription__c');

		return JSON.serialize(wrapperObject,true);
	}

	/***********************************************************************
	* @description This method returns map of Account and its External Id 
	* @param Set of External Id of Account records
	* @return returns map of Account's External Id to Account record
	************************************************************************/
	public static Map<String,Account> fetchCustomersFromCME(Set<String> customerExtIDs){

		Map<String,FNS_OrganizationPayLoad> custResMap = new Map<String,FNS_OrganizationPayLoad>();
		List<Account> customerList;
		Map<String,Account> custMapWithExtId = new Map<String,Account>();

		if(customerExtIDs != null && !customerExtIDs.isEmpty()){   
			//Start API callout
			for(String customerID : customerExtIDs) {
				FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
				param.objectName = FNS_Constants.CLASS_ORGANIZATIONS;
				if(String.isNotEmpty(customerID))
				{
					param.endPoint = FNS_Constants.URL_ORGANIZATIONS;
					param.extendedAPIUrl = customerID;
					param.methodName = FNS_Constants.METHOD_GET;
					Map<String, String> headerMap = new Map<String, String>();
					headerMap.put(FNS_Constants.ACCEPT, FNS_Constants.APPLICATION_JSON);
					param.headerMap = headerMap;
					FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
					HttpResponse jsonResponse = router.getPostRequest(param);
					System.debug('jsonResponse -::: '+jsonResponse);
					if (jsonResponse.getStatusCode() == 200){
						if (!String.isEmpty(jsonResponse.getBody())){
							FNS_OrganizationPayLoad orgPayLoad = (FNS_OrganizationPayLoad )JSON.deserialize(jsonResponse.getbody(), FNS_OrganizationPayLoad.class);
							custResMap.put(customerID ,orgPayLoad);
						} 
					}
				}
							 
			}
			////End API callout
			//Start DML Transaction for Account upsert
			fflib_SObjectUnitOfWork uow = getunitOfWork(); // start Transaction
			FNS_UpsertUnitOfWorkHelper upsertAccRelatedRecs = new FNS_UpsertUnitOfWorkHelper();
			uow.registerWork(upsertAccRelatedRecs);

			if(custResMap != null && !custResMap.isEmpty()){
				for (String custID : custResMap.keySet()){
					if(custResMap.containsKey(custID)){
						Account acc = updateAccount(custResMap.get(custID));
						if (acc != null){
							upsertAccRelatedRecs.registerAccountUpsert(acc);
						}
					}
				}
			}
			FNS_ObjectAccessContainer.checkAccountAccess(FNS_AccessController.DML_OPERATION_UPDATE);
			try{
				uow.commitwork();
			}catch (DMLException ex){
                System.debug('>>>>Exception>>' +ex.getMessage() + 'Line Number' + ex.getLineNumber()  + 'getStackTraceString'  +ex.getStackTraceString());
        		throw new FNS_CustomException(ex.getmessage());
				//logger.addLogRecord('FNS_OrganizationDomain', 'fetchCustomersFromCME', ex.getMessage() + ex.getStackTraceString());
			} 
			customerList = new FNS_AccountSelector().selectCustomerWithRelatedRecordsByExtId(customerExtIDs);

			for(Account  acc : customerList){
				custMapWithExtId.put(acc.FNS_CustomerExtId__c , acc);
			}
			handleResponseForAccRelatedRecords (custResMap ,custMapWithExtId);
		}
		return custMapWithExtId;
	}

	/***********************************************************************
	* @description This method upserts child records for related Account record
	* @param Map of Account record's External id to inner class FNS_OrganizationPayLoad  
	* @param Map of Account record's External id to Account  
	* @return none
	************************************************************************/
	public static void handleResponseForAccRelatedRecords(Map<String,FNS_OrganizationPayLoad> custResMap, Map<String,Account> custMapWithExtId ){
		//Start DML Transaction for AccountRelated Records upsert
		fflib_SObjectUnitOfWork uow = getunitOfWork(); // start Transaction
		FNS_UpsertUnitOfWorkHelper upsertAccRelatedRecs = new FNS_UpsertUnitOfWorkHelper();
		uow.registerWork(upsertAccRelatedRecs);

		if (custResMap != null && custMapWithExtId != null) {
			for (String custID : custResMap.keySet()){
				FNS_OrganizationPayLoad orgPayLoad = custResMap.get(custID);
				Account acc = custMapWithExtId.get(custID);
				createAddress(orgPayLoad.addresses,uow, acc);
				createTaxDetails(orgPayLoad.taxDetails,uow, acc );
				createContacts(orgPayLoad.contactList,uow, acc);
				//updateContacts(orgPayLoad.contactList,upsertAccRelatedRecs, acc);
				updateCustomerProfiles(orgPayLoad.customerProfiles,upsertAccRelatedRecs, acc );
			}
			if (custMapWithExtId != null && !custMapWithExtId.isEmpty()){
				deleteCustomerRelatedRecords(custMapWithExtId.values(), uow);
			}

		}
		FNS_ObjectAccessContainer.checkContactAccess(FNS_AccessController.DML_OPERATION_UPDATE);
		FNS_ObjectAccessContainer.checkAddressAccess(FNS_AccessController.DML_OPERATION_INSERT);
		FNS_ObjectAccessContainer.CheckTaxAccess(FNS_AccessController.DML_OPERATION_UPDATE);
		FNS_ObjectAccessContainer.checkCustomerProfileAccess(FNS_AccessController.DML_OPERATION_UPDATE);
		try{
			uow.commitwork();
		}catch (DMLException ex){
			logger.addLogRecord('FNS_OrganizationDomain', 'handleResponseForAccRelatedRecords', ex.getMessage() + ex.getStackTraceString());
		} 
		upsertAccRelatedRecs.printDebug();
	}

	/***********************************************************************
	* @description This method update Account data
	* @param instance of FNS_OrganizationPayLoad class
	* @return updated account record instance
	************************************************************************/
	public static Account updateAccount(FNS_OrganizationPayLoad customerPayload){
		if (!String.isEmpty(customerPayload.customerId)){
			Account  updateAcc = new Account();
			updateAcc.FNS_CustomerExtId__c = customerPayload.customerId;
			updateAcc.Name = customerPayload.fullName;
			updateAcc.FNS_CustomerDescription__c = customerPayload.customerDescription;
			updateAcc.AnnualRevenue = customerPayload.annualRevenue.amount;
			updateAcc.FNS_OfficialType__c = customerPayload.officialType;
			updateAcc.Sic = customerPayload.sicCode;
			updateAcc.FNS_CustomerStruct__c = customerPayload.structure;
			return updateAcc;
		}
		else{
			return null ;
		}
	}
	
	/***********************************************************************
	* @description This method creates Address records associated to Account record
	* @param List of instances of FNS_OrganizationPayLoad.FNS_Addresses class
	* @param Instances of unit of work
	* @param Instances of related Account record
	* @return none
	************************************************************************/
	public static void createAddress( List<FNS_OrganizationPayLoad.FNS_Addresses> addressList ,fflib_SObjectUnitOfWork uow , Account acc) {
		if (addressList != null && !addressList.isEmpty()) {
			for (FNS_OrganizationPayLoad.FNS_Addresses addressRec : addressList) {
				FNS_Address__c address = new FNS_Address__c();
				address.FNS_Account__c = acc.ID;
				address.FNS_Address1__c = addressRec.street1;
				address.FNS_Address2__c = addressRec.street2;
				address.FNS_Address3__c = addressRec.street3;
				address.FNS_AddressType__c = addressRec.addressType;
				address.FNS_City__c = addressRec.city;
				address.FNS_CountryCode__c = addressRec.country;
				address.FNS_PostalCode__c = addressRec.postalCode;
				address.FNS_PostalCodeExtension__c = addressRec.postalCodeExtension;
				address.FNS_ProvinceCode__c = addressRec.province;
				uow.registerNew(address);
			}
		}
	}
	
	/***********************************************************************
	* @description This method updates TaxDetail records associated to Account record
	* @param List of instances of FNS_OrganizationPayLoad.FNS_TaxDetails class
	* @param Instances of fflib_SObjectUnitOfWork class
	* @param Instances of related Account record
	* @return none
	************************************************************************/
	public static void createTaxDetails(List<FNS_OrganizationPayLoad.FNS_TaxDetails> taxList ,fflib_SObjectUnitOfWork uow , Account acc) {
		if (taxList != null && !taxList.isEmpty()) {
			for (FNS_OrganizationPayLoad.FNS_TaxDetails taxRec  : taxList) {
				FNS_TaxDetails__c  tax  = new FNS_TaxDetails__c();
				tax.FNS_AccountName__c = acc.ID;
				tax.FNS_TaxCountry__c = taxRec.country;
				tax.FNS_TaxExmptCode__c = taxRec.taxExemptCode;
				tax.FNS_TaxNumber__c = taxRec.taxNumber;
				tax.FNS_TaxPayerId__c = taxRec.taxPayerId;
				tax.FNS_TaxRegion__c = taxRec.taxRegion;
				tax.FNS_TaxType__c = taxRec.taxType;
				uow.registerNew(tax);
			}
		}
	}
	
	/***********************************************************************
	* @description This method updates Contact records associated to Account record
	* @param List of instances of FNS_OrganizationPayLoad.FNS_ContactList class
	* @param Instances of FNS_UpsertUnitOfWorkHelper class
	* @param Instances of related Account record
	* @return none
	************************************************************************/
	/*public static void updateContacts(List<FNS_OrganizationPayLoad.FNS_ContactList> contactsList ,FNS_UpsertUnitOfWorkHelper upsertAccRelatedRecs , Account acc) {
		if (contactsList != null && !contactsList.isEmpty()) {
			for (FNS_OrganizationPayLoad.FNS_ContactList contactRec  : contactsList) {
				Contact  person  = new Contact();
				person.AccountID = acc.ID;
				person.LastName = contactRec.fullName;
				person.Department = contactRec.department;
				person.FNS_ContactType__c = contactRec.contactType;
				person.Email = contactRec.primaryBusinessEmail;
				person.Title = contactRec.title;
				person.FNS_ContactExternalId__c = contactRec.contactId;
				person.FNS_ContactExternalId__c = contactRec.primaryBusinessEmail;
				if(contactRec.phoneList != null && ! contactRec.phoneList.isEmpty()){
					for (FNS_OrganizationPayLoad.FNS_PhoneList phoneRec : contactRec.phoneList) {
						if(phoneRec.phoneType == FNS_Constants.CONTACT_PHONE_TYPE_PRIMARY){
							person.Phone = phoneRec.phoneNumber;
						}
						if(phoneRec.phoneType == FNS_Constants.CONTACT_PHONE_TYPE_SECONDARY){
							person.HomePhone = phoneRec.phoneNumber;
						}
						if(phoneRec.phoneType == FNS_Constants.CONTACT_PHONE_TYPE_HOME){
							person.MobilePhone = phoneRec.phoneNumber;
						}
					}
				}
				upsertAccRelatedRecs.registerContactUpsert(person);
			}
		}

	}*/
	
	public static void createContacts(List<FNS_OrganizationPayLoad.FNS_ContactList> contactsList ,fflib_SObjectUnitOfWork uow , Account acc) {
		String baseNamespace = FNS_Util.getBasePackageNamepace();
		if (contactsList != null && !contactsList.isEmpty()) {
			for (FNS_OrganizationPayLoad.FNS_ContactList contactRec  : contactsList) {
				Contact  person  = new Contact();
				person.AccountID = acc.ID;
				person.LastName = contactRec.fullName;
				person.Department = contactRec.department;
				person.FNS_ContactType__c = FNS_Util.getPicklistFieldValueMap('Contact',baseNamespace+'FNS_ContactType__c').get(contactRec.contactType);
				person.Email = contactRec.primaryBusinessEmail;
				person.Title = contactRec.title;
				
				if(contactRec.phoneList != null && ! contactRec.phoneList.isEmpty()){
					for (FNS_OrganizationPayLoad.FNS_PhoneList phoneRec : contactRec.phoneList) {
						if(phoneRec.phoneType == FNS_Constants.CONTACT_PHONE_TYPE_PRIMARY){
							person.Phone = phoneRec.phoneNumber;
						}
						if(phoneRec.phoneType == FNS_Constants.CONTACT_PHONE_TYPE_SECONDARY){
							person.HomePhone = phoneRec.phoneNumber;
						}
						if(phoneRec.phoneType == FNS_Constants.CONTACT_PHONE_TYPE_HOME){
							person.MobilePhone = phoneRec.phoneNumber;
						}
					}
				}
				uow.registerNew(person);
			}
		}

	}
	/***********************************************************************
	* @description This method updates CustomerProfile records associated to Account record
	* @param List of instances of FNS_OrganizationPayLoad.FNS_CustomerProfiles class
	* @param Instances of FNS_UpsertUnitOfWorkHelper class
	* @param Instances of related Account record
	* @return none
	************************************************************************/
	public static void updateCustomerProfiles(List<FNS_OrganizationPayLoad.FNS_CustomerProfiles> customerProfilesList , FNS_UpsertUnitOfWorkHelper upsertAccRelatedRecs , Account acc) { 		
		if (customerProfilesList != null && !customerProfilesList.isEmpty()) {
			for (FNS_OrganizationPayLoad.FNS_CustomerProfiles custProfileRec  : customerProfilesList) {
				FNS_CustomerProfile__c  customerProfile  = new FNS_CustomerProfile__c();
				customerProfile.FNS_CustomerBusiness__c = acc.ID;
				customerProfile.FNS_CreditComment__c = custProfileRec.creditComment;
				customerProfile.FNS_CreditReviewDate__c = custProfileRec.creditReviewDate;
				// customerProfile.nextReviewDate = custProfileRec.nextReviewDate;
				customerProfile.FNS_ProfileType__c = custProfileRec.profileType;
				customerProfile.FNS_CustomerProfileExternalId__c = custProfileRec.customerProfileId;
				upsertAccRelatedRecs.registerCustomerProfileUpsert(customerProfile);
			}
		}
	}

	/***********************************************************************
	* @description This method deletes related records for Account
	* @param List of Account records
	* @param Instances of unit of work
	* @return none
	************************************************************************/
	public static void deleteCustomerRelatedRecords( List<Account> accList, fflib_SObjectUnitOfWork uow) {
		if(accList != null && !accList.isEmpty()){
			for(Account acc  : accList) {
				List<FNS_Address__c> addressList = acc.Addresses__r;
				List<FNS_CustomerProfile__c> customeProfileList = acc.CustomerProfiles__r;
				List<FNS_TaxDetails__c> taxDetailsList = acc.TaxDetails__r;
				List<Contact> contactList = acc.Contacts;
				if(addressList != null){
					uow.registerDeleted(addressList);
				}
				if(contactList != null){
					uow.registerDeleted(contactList);
				}
				if(customeProfileList != null){
					//uow.registerDeleted(customeProfileList);
				}
				if(taxDetailsList != null){
					uow.registerDeleted(taxDetailsList);
				}
			}
		}
	}

	/***********************************************************************
	* @description This method returns unit of work instance for Account and its associated child records
	* @param none
	* @return none
	************************************************************************/
	public static fflib_SObjectUnitOfWork getunitOfWork() { 
		return new fflib_SObjectUnitOfWork( 
			new Schema.SObjectType[] {	
				Account.SObjectType,
				Contact.SObjectType,
				FNS_Address__c.SObjectType,
				FNS_CustomerProfile__c.SObjectType,
				FNS_TaxDetails__c.SObjectType
			});
	} 

}