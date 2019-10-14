/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Domain Class
* @description This class acts as domain class for Financial Account Roles object 
****************************************************************************/
public with sharing class FNS_FinancialAccountRolesDomain {
	/***********************************************************************
	* @description This methods assigns values to financial account role record 
	* @param package namespace value
	* @param financial account role object name
	* @param Instance of FNS_ObjectContainer.FNS_FinAccountRole class
	* @return instance of financial account role object
	************************************************************************/
	public static SObject assignJSONToFinancialAccountRoles(String namespace, String finFinancialAccountRoleObjName, FNS_ObjectContainer.FNS_FinAccountRole productRole){
		//For FSC installed package nameSpace is extensionNameSpace for NON FSC installed package baseNameSpace
		SObject finAccRoleForFacility = Schema.getGlobalDescribe().get(finFinancialAccountRoleObjName).newSObject();

		finAccRoleForFacility.put(namespace+'FNS_TypeofProdRole__c', productRole.typeOfProductRole );
		finAccRoleForFacility.put(namespace+'FNS_ProductRelRole__c', productRole.productRelationshipRole );
		finAccRoleForFacility.put(namespace+'FNS_GuaranteeDollar__c', productRole.guaranteeDollar );
		finAccRoleForFacility.put(namespace+'FNS_GuaranteePercent__c', productRole.guaranteePercent );
		finAccRoleForFacility.put('FinServ__Role__c', 'Accountant');
		finAccRoleForFacility.put('FinServ__RelatedAccount__c', productRole.relatedAccount);
		finAccRoleForFacility.put('FinServ__RelatedContact__c', productRole.relatedContact);

		return finAccRoleForFacility;
	}
	
	/***********************************************************************
	* @description This method creates set of all associated customers  
	* @param Instance of FNS_ObjectContainer.FNS_CustomerIds class
	* @return returns set of external ids of Customers
	************************************************************************/
	public static Set<String> getCustomerExtIDs (FNS_ObjectContainer.FNS_CustomerIds customerIds) {
		Set<String> customerSet = new Set<String>();
		if (customerIds != null) {
			Set<String> borrowerSet = new Set<String>();
			Set<String> guarantorSet = new Set<String>();
			Set<String> co_borrowerSet = new Set<String>();

			if (customerIds.BORROWER != null && !customerIds.BORROWER.isEmpty()) {
				for(String deci : customerIds.BORROWER) {
					borrowerSet.add(String.valueof(Integer.valueof(deci)));
				}
				customerSet.addall(borrowerSet);
			}
			if (customerIds.GUARANTOR != null && !customerIds.GUARANTOR.isEmpty()){
				for(String deci : customerIds.GUARANTOR) {
					guarantorSet.add(String.valueof(Integer.valueof(deci)));
				}
				customerSet.addall(guarantorSet);
			}
			if (customerIds.CO_BORROWER != null && !customerIds.CO_BORROWER.isEmpty()){
				for(String deci : customerIds.CO_BORROWER) {
					co_borrowerSet.add(String.valueof(Integer.valueof(deci)));
				}
				customerSet.addall(co_borrowerSet);
			}
		}
		return customerSet;
	}

	/***********************************************************************
	* @description This method creates set value for Financial Account Role records  
	* @param Instance of unit of work
	* @param Instance of financial account record
	* @param package namespace value
	* @param financial account role object name
	* @param Instance of FNS_ObjectContainer.FNS_CustomerIds class
	* @param List of customer record
	* @return none
	************************************************************************/
	public static void setFinancialAccountRoles(fflib_SObjectUnitOfWork uow, Sobject finAccount, String nameSpace, String finFinancialAccountRoleObjName, 	FNS_ObjectContainer.FNS_CustomerIds customerIds, List<Account> customerList ) {
		Schema.SObjectType finFinancialAccountRoleObject ;
		finFinancialAccountRoleObject = Schema.getGlobalDescribe().get(finFinancialAccountRoleObjName);
		Set<String> customerSet = new Set<String>();
		Set<String> borrowerSet = new Set<String>();
		Set<String> guarantorSet = new Set<String>();
		Set<String> co_borrowerSet = new Set<String>();

		if (customerIds.BORROWER != null && !customerIds.BORROWER.isEmpty()) {
			for(String deci : customerIds.BORROWER) {
				borrowerSet.add(String.valueof(Integer.valueof(deci)));
			}
			customerSet.addall(borrowerSet);
		}
		if (customerIds.GUARANTOR != null && !customerIds.GUARANTOR.isEmpty()) {
			for(String deci : customerIds.GUARANTOR) {
				guarantorSet.add(String.valueof(Integer.valueof(deci)));
			}
			customerSet.addall(guarantorSet);
		}
		if (customerIds.CO_BORROWER != null && !customerIds.CO_BORROWER.isEmpty()) {
			for(String deci : customerIds.CO_BORROWER) {
				co_borrowerSet.add(String.valueof(Integer.valueof(deci)));
			}
			customerSet.addall(co_borrowerSet);
		}

		Map<String,Account> customerMap =  new Map<String,Account>();
		Account entity;
		List<Sobject> finServProductRoleList;
		if(customerList != null && !customerList.isEmpty()) {
			for(Account acc : customerList){
				if(! String.isEmpty(acc.FNS_CustomerExtId__c)){
					customerMap.put(String.valueof(Integer.valueof(acc.FNS_CustomerExtId__c) ), acc);
				}
			}
		}
		Map<String, String> pklstFldMap = FNS_Util.getPicklistLabelToValueMap(finFinancialAccountRoleObjName,namespace+'FNS_ProductRelRole__c');
		for(String custID : customerMap.keySet()){
			SObject finAccRoleForFacility = Schema.getGlobalDescribe().get(finFinancialAccountRoleObjName).newSObject();
			entity = customerMap.get(custID);

			if(borrowerSet.contains(custID) && pklstFldMap.containsKey(FNS_Constants.BORROWER)){
				finAccRoleForFacility.put(namespace+'FNS_ProductRelRole__c', pklstFldMap.get(FNS_Constants.BORROWER));
			}else if(guarantorSet.contains(custID) && pklstFldMap.containsKey(FNS_Constants.GUARANTOR)) {
				finAccRoleForFacility.put(namespace+'FNS_ProductRelRole__c', pklstFldMap.get(FNS_Constants.GUARANTOR));
			}else if(co_borrowerSet.contains(custID) && pklstFldMap.containsKey(FNS_Constants.CO_BORROWER)){
				finAccRoleForFacility.put(namespace+'FNS_ProductRelRole__c', pklstFldMap.get(FNS_Constants.CO_BORROWER));
			}

			if(FNS_Util.isFSCInstalled){
				uow.registerRelationship(finAccRoleForFacility, finFinancialAccountRoleObject.getDescribe().fields.getMap().get('FinServ__FinancialAccount__c'), finAccount);
				uow.registerRelationship(finAccRoleForFacility, finFinancialAccountRoleObject.getDescribe().fields.getMap().get('FinServ__RelatedAccount__c'), entity);
				uow.registerNew(finAccRoleForFacility);

				finAccRoleForFacility.put('FinServ__Role__c', 'Accountant');
			}else{
				uow.registerRelationship(finAccRoleForFacility,  finFinancialAccountRoleObject.getDescribe().fields.getMap().get(nameSpace+'FNS_FinancialAccount__c'), finAccount);
				uow.registerRelationship(finAccRoleForFacility,  finFinancialAccountRoleObject.getDescribe().fields.getMap().get(nameSpace+'FNS_RelatedAccount__c'), entity);
				uow.registerNew(finAccRoleForFacility);
			}
		}
	}
}