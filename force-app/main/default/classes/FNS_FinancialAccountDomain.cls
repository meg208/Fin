/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Domain Class
* @description This class acts as domain class for Financial Account object 
****************************************************************************/
public with sharing class FNS_FinancialAccountDomain {
	/***********************************************************************
	* @description This methods updates FNS_FinancialAccountDomain object records from FFDC 
	* @param Opportunity record's Salesforce Id 
	* @param package namespace value
	* @param financial account object name
	* @param Instance of FNS_FinancialProductPayload class
	* @return instance of financial account object
	************************************************************************/
	public static SObject assignJSONToFinancialAccount(String  applicationID ,String namespace, String finAccountObjName, FNS_FinancialProductPayload financialProduct){
	//For FSC installed package nameSpace is extensionNameSpace for NON FSC installed package baseNameSpace

		Opportunity application;
		if(!String.isEmpty(applicationID)){
			application = FNS_Util.getOpportunityFromAppResp(applicationID);
		}
		Set<ID> accIDSet = new Set<ID>();
		accIDSet.add(application.AccountID);
		List<Account> accList = new FNS_AccountSelector().selectById(accIDSet);
		Account oppBorrower;
		if(accList != null && !accList.isEmpty()){
			oppBorrower = accList[0];
		}
		SObject finAccount   = Schema.getGlobalDescribe().get(finAccountObjName).newSObject();

		finAccount.put(namespace+'FNS_FinancialProductExtId__c',  financialProduct.lineOfCreditId );
		finAccount.put(namespace+'FNS_RateType__c',  financialProduct.rateType );
		finAccount.put(namespace+'FNS_Purpose__c', financialProduct.purposeTypeId );
		if(financialProduct.effectiveDate != null){
			finAccount.put(namespace+'FNS_EffectiveDate__c', FNS_Util.convertStringToDateTime(financialProduct.effectiveDate)); 
		} 
        //API 1.0 changes        
		//finAccount.put(namespace+'FNS_Amount__c', financialProduct.amount);
		//finAccount.put(namespace+'FNS_CurrencyCode__c', financialProduct.currencyCode );
		if(financialProduct.amount!= null)
        {
          finAccount.put(namespace+'FNS_Amount__c', financialProduct.amount.amount);
          finAccount.put(namespace+'FNS_CurrencyCode__c', financialProduct.amount.currencyCode );
        }      
		finAccount.put(namespace+'FNS_ProductType__c',  financialProduct.productType);
		finAccount.put(namespace+'FNS_FinancialAccountTransaction__c',  financialProduct.hostLoanNumber);
		finAccount.put(namespace+'FNS_Term__c', financialProduct.term);
		finAccount.put(namespace+'FNS_TermUnit__c', FNS_Constants.MONTH);
		finAccount.put(namespace+'FNS_OriginationTypeIndicator__c',financialProduct.originationTypeIndicator);
		

		if(financialProduct.expiryDate != null){
			finAccount.put(namespace+'FNS_ExpiryDate__c', FNS_Util.convertStringToDateTime(financialProduct.expiryDate)) ;  
		}

		if(financialProduct.maturityDate != null) {
			finAccount.put(namespace+'FNS_MaturityDate__c', FNS_Util.convertStringToDateTime(financialProduct.maturityDate)) ;  
		}
		//Object relationship management
		if (FNS_Util.isFSCInstalled) {
			if(oppBorrower != null) {
				finAccount.put('FinServ__PrimaryOwner__c', oppBorrower.ID);
				finAccount.put('FinServ__FinancialAccountNumber__c', oppBorrower.FNS_CustomerExtId__c);
			}                         
			finAccount.put(namespace +'FNS_Application__c', application.ID);
		}
		else {
			finAccount.put(namespace +'FNS_Application__c', application.ID);   
			if(oppBorrower !=null){     
				finAccount.put(namespace+'FNS_Account__c', oppBorrower.ID );
			}
		}
		return finAccount;
	} 
}