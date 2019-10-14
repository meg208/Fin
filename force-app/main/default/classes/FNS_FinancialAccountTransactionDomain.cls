/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Domain Class
* @description This class acts as domain class for Financial Account Transaction object 
****************************************************************************/
public with sharing class FNS_FinancialAccountTransactionDomain {
	/***********************************************************************
	* @description This methods converts json response to financial account transaction object
	* @param package namespace value
	* @param financial account transaction object name
	* @param Instance of FNS_ObjectContainer.FNS_Loan class
	* @return instance of financial account transaction object
	************************************************************************/
	public static SObject assignJSONToFinancialAccountTransaction(String namespace, String finFinancialAccountTransactionObjName, FNS_ObjectContainer.FNS_Loan loanRec){
		//For FSC installed package nameSpace is extensionNameSpace for NON FSC installed package baseNameSpace
		SObject finAccTransaction = Schema.getGlobalDescribe().get(finFinancialAccountTransactionObjName).newSObject();

		if(FNS_Util.isFSCInstalled) {
            //API 1.0 changes
			//finAccTransaction.put('FinServ__Amount__c', loanRec.amount );
            if(loanRec.amount!= null)
            {
                finAccTransaction.put('FinServ__Amount__c', loanRec.amount.amount );
            }
			finAccTransaction.put('FinServ__TransactionDate__c',system.today());
		}
		else{
            //API 1.0 changes
			//finAccTransaction.put(namespace+'FNS_Amount__c', loanRec.amount );
            if(loanRec.amount!= null)
            {
                 finAccTransaction.put(namespace+'FNS_Amount__c', loanRec.amount.amount );
            }
			finAccTransaction.put(namespace+'FNS_TransactionDate__c',system.today());
		}
		if(FNS_Util.checkMCEnabled()){
			//finAccTransaction.put('CurrencyIsoCode', loanRec.currencyCode );
             if(loanRec.amount!= null)
            {
                finAccTransaction.put('CurrencyIsoCode', loanRec.amount.currencyCode);
            }
		}
		if(loanRec.effectiveDate != null){
			finAccTransaction.put(namespace+'FNS_EffectiveDate__c', FNS_Util.convertStringToDateTime(loanRec.effectiveDate));  
		}else {
			finAccTransaction.put(namespace+'FNS_EffectiveDate__c', System.now());
		}
		
		if(loanRec.expiryDate != null){
			finAccTransaction.put(namespace+'FNS_ExpiryDate__c', FNS_Util.convertStringToDateTime(loanRec.expiryDate));  
		}else {
			finAccTransaction.put(namespace+'FNS_ExpiryDate__c', System.now());
		}
		
		if(loanRec.maturityDate != null){
			finAccTransaction.put(namespace+'FNS_MaturityDate__c', FNS_Util.convertStringToDateTime(loanRec.maturityDate));  
		}else {
			finAccTransaction.put(namespace+'FNS_MaturityDate__c', System.now());
		}
		
		finAccTransaction.put(namespace+'FNS_FinancialAccountTransactionExtId__c',loanRec.loanId );
		finAccTransaction.put(namespace+'FNS_LoanProductType__c',loanRec.productType);
		finAccTransaction.put(namespace+'FNS_LoanPurpose__c',loanRec.purposeTypeId);
		finAccTransaction.put(namespace+'FNS_OriginationTypeIndicator__c',loanRec.originationTypeIndicator); 
		finAccTransaction.put(namespace+'FNS_Term__c',loanRec.term);
		finAccTransaction.put(namespace+'FNS_TermUnit__c',FNS_Constants.MONTH);    
		
		return finAccTransaction;
	} 
}