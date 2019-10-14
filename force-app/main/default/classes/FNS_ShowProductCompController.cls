/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Component Controller
* @description Helps in displaying product record's data
****************************************************************************/
public with sharing class FNS_ShowProductCompController {
	public static FNS_ErrorLog logger = new FNS_ErrorLog();
	/***********************************************************************
	* @description Get associated product and loan record data of Application record
	* @param Opportunity record's Salesforce Id
	* @return List of FNS_ProductWrapper inner class 
	************************************************************************/
	@AuraEnabled
	public static List<FNS_ProductWrapper> getAllRelatedProductsForWrapper(String applicationId){
		List<Sobject> prodWithLoanList = new List<SObject>();
		List<FNS_ProductWrapper> productWrapperList = new List<FNS_ProductWrapper>();
		String baseNamespace= FNS_Util.getBasePackageNamepace();
		String extNamespace= FNS_Util.getExtensionPackageNamespace();
		String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        String finAccountObjName ;
    	String finFinancialAccountTransactionObjName ;
        if(FNS_Util.isFSCInstalled){
            finAccountObjName = 'FinServ__FinancialAccount__c' ;
            finFinancialAccountTransactionObjName ='FinServ__FinancialAccountTransaction__c' ;
        }
        else{
            finAccountObjName = baseNamespace+'FNS_FinancialAccount__c' ;
            finFinancialAccountTransactionObjName = baseNamespace+'FNS_FinancialAccountTransaction__c' ;
        }
        prodWithLoanList = new FNS_ProductsSelector().selectProductsWithLoans(applicationId);
		for(Sobject productRecord : prodWithLoanList){
			FNS_ProductWrapper productObject = new FNS_ProductWrapper();
			productObject.productId = (String)productRecord.get('Id');
			productObject.productSummary = (String)productRecord.get('FNS_ProductSummary__c');
			productObject.productType = FNS_Util.getPicklistFieldValueMap(finAccountObjName,namespace+'FNS_ProductType__c').get((String)productRecord.get(namespace+'FNS_ProductType__c'));
			productObject.productAmount = convertAmount((Decimal)productRecord.get(namespace+'FNS_Amount__c'));
			productObject.productPurpose = FNS_Util.getPicklistFieldValueMap(finAccountObjName,namespace+'FNS_Purpose__c').get((String)productRecord.get(namespace+'FNS_Purpose__c'));

			List<FNS_LoanWrapper> loanWrapperList = new List<FNS_LoanWrapper>();
			List<SObject> loanRecordList;
			if(FNS_Util.isFSCInstalled){
				loanRecordList = productRecord.getSObjects('FinServ__FinancialAccountTranslations__r');
			}else {
				loanRecordList = productRecord.getSObjects(namespace+'FinancialAccountLoans__r');
			}
			if(loanRecordList != null && ! loanRecordList.isEmpty()){
				for(SObject childObj : loanRecordList){
					FNS_LoanWrapper loanObject = new FNS_LoanWrapper();
					loanObject.loanId = (String)childObj.get('Id');
					loanObject.loanSummary = (String)childObj.get('FNS_LoanSummary__c');
					loanObject.loanType = FNS_Util.getPicklistFieldValueMap(finFinancialAccountTransactionObjName,namespace+'FNS_LoanProductType__c').get((String)childObj.get(namespace+'FNS_LoanProductType__c'));
					if(FNS_Util.isFSCInstalled){ 
						loanObject.loanAmount = convertAmount((Decimal)childObj.get('FinServ__Amount__c'));
					}else {
						loanObject.loanAmount = convertAmount((Decimal)childObj.get(namespace+'FNS_Amount__c'));
					}
					loanObject.loanPurpose =  FNS_Util.getPicklistFieldValueMap(finFinancialAccountTransactionObjName,namespace+'FNS_LoanPurpose__c').get((String)childObj.get(namespace+'FNS_LoanPurpose__c'));
					loanWrapperList.add(loanObject);
				}
			}
			productObject.loanRecord = loanWrapperList;

			productWrapperList.add(productObject);
		}
		return productWrapperList;
	}
	
    public class FNS_ProductResponseWrapper{
        @AuraEnabled public List<FNS_ProductWrapper> productWrapperList{get;set;}
        @AuraEnabled public String error{get;set;}
    }

	/***********************************************************************
	* @description Wrapper class used for Product and associated Loan records
	* @param none
	* @return none 
	************************************************************************/
	public with sharing class FNS_ProductWrapper {
		@AuraEnabled public String productId {get; set;}
		@AuraEnabled public String productSummary {get; set;}
		@AuraEnabled public String productType {get; set;}
		@AuraEnabled public String productAmount {get; set;}
		@AuraEnabled public String productPurpose {get; set;}
		@AuraEnabled public List<FNS_LoanWrapper> loanRecord {get; set;}
	}

	/***********************************************************************
	* @description Wrapper class used for associated Loan records
	* @param none
	* @return none 
	************************************************************************/
	public with sharing class FNS_LoanWrapper {
		@AuraEnabled public String loanId {get; set;}
		@AuraEnabled public String loanSummary {get; set;}
		@AuraEnabled public String loanType {get; set;}
		@AuraEnabled public String loanAmount {get; set;}
		@AuraEnabled public String loanPurpose {get; set;}
	}

	/***********************************************************************
	* @description Wrapper class used for Listview data
	* @param none
	* @return none 
	************************************************************************/
	public with sharing class FNS_ListViewWrapper {
		@AuraEnabled public String listViewId {get; set;}
		@AuraEnabled public String objName {get; set;}
	}

	/***********************************************************************
	* @description Wrapper class used for associated child records of Product
	* @param none
	* @return none 
	************************************************************************/
	public with sharing class FNS_ProductWithChildWrapper {
		@AuraEnabled public List<Id> loanRecords {get; set;}
		@AuraEnabled public List<Id> feesRecordIds {get; set;}
		@AuraEnabled public List<Id> pricingRecordIds {get; set;}
		@AuraEnabled public List<Id> roleRecordIds {get; set;}
        @AuraEnabled public string error {get; set;}
	}

	/***********************************************************************
	* @description Converts the decimal amount value into string format
	* @param Amount value in decimal format
	* @return Amount value in string format 
	************************************************************************/
	public static String convertAmount(Decimal amountValue){
		String orgCurrency = FNS_Util.getCorpCurrency();
		String currencySymbol = FNS_Util.convertCurrencyNameToSymbol(orgCurrency);
		String convertedAmount = currencySymbol + ' '+ String.valueOf(amountValue.format());

		return convertedAmount;
	}

	/***********************************************************************
	* @description Get listview record of Product record
	* @param none
	* @return Object of FNS_ListViewWrapper inner class 
	************************************************************************/
	@AuraEnabled
	public static FNS_ListViewWrapper getListViews() {
		List<ListView> listviews; 
		String baseNamespace= FNS_Util.getBasePackageNamepace();
		String extNamespace= FNS_Util.getExtensionPackageNamespace();
		String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;

		String objectName = '';
		String listViewName = '';

		FNS_ListViewWrapper listViewWrap = new FNS_ListViewWrapper();

		if(FNS_Util.isFSCInstalled){
			objectName = 'FinServ__FinancialAccount__c';
			listViewName = namespace+'FNS_Products';
		}else {
			objectName = namespace+'FNS_FinancialAccount__c';
			listViewName = namespace+'FNS_ProductsNonFSC';
		}
		try {
			listviews = new FNS_ListViewsSelector().selectByName(objectName, new Set<String>{listViewName});
			if(listviews != null){
				listViewWrap.listViewId = listviews[0].Id;
			}
			listViewWrap.objName = objectName;
		}catch(Exception ex){
			logger.addLogRecord('FNS_ShowProductCompController', 'getListViews', ex.getMessage() + ex.getStackTraceString());
		}
		return listViewWrap;
	}

	/***********************************************************************
	* @description This method is used to delete the product record
	* @param Product record's Salesforce id
	* @return none 
	************************************************************************/ 
	@AuraEnabled
	public static FNS_ProductResponseWrapper deleteProduct(String productId){
        FNS_ProductResponseWrapper wrapper = new FNS_ProductResponseWrapper();
        try{
			fflib_SObjectUnitOfWork uow ;  // SObjects (in order of dependency)
			uow = FNS_Util.getUOWForProductDelete();
			FNS_Util.deleteProductWithRelatedRecords(uow, new List<String>{productId});
         }catch(DMLException ex){
            logger.addLogRecord('FNS_CreateProductController', 'deleteRecords', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        }catch (Exception ex){
            logger.addLogRecord('FNS_CreateProductController', 'deleteRecords', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage(); 
        }    
        return wrapper;
	}

	/***********************************************************************
	* @description This method provides Product data and its associated child to edit
	* @param Product record's Salesforce Id in String format
	* @return Object of FNS_ProductWithChildWrapper inner class 
	************************************************************************/ 
	@AuraEnabled
	public static FNS_ProductWithChildWrapper editProduct(String productId){
        List<FNS_ProductWithChildWrapper> productWrapperList = new List<FNS_ProductWithChildWrapper>();
        FNS_ProductWithChildWrapper productObject = new FNS_ProductWithChildWrapper();
        try{
		
		String baseNamespace= FNS_Util.getBasePackageNamepace();
		String extNamespace= FNS_Util.getExtensionPackageNamespace();
		String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
		String loanObject;
		String feeObject;
		String pricingObject;
		String roleObject;
		if(FNS_Util.isFSCInstalled){
			loanObject = 'Finserv__FinancialAccountTranslations__r';
			feeObject = namespace + 'ProductFeesFSC__r';
			pricingObject = namespace + 'ApplicationPricings__r';
			roleObject = 'Finserv__FinancialAccountRoles__r';
		}else {
			loanObject = namespace+'FinancialAccountLoans__r';
			feeObject = namespace + 'FinancialProductFees__r';
			pricingObject = namespace + 'FinancialProductPricings__r';
			roleObject = namespace + 'FinancialAccountRoles__r';
		}

		List<SObject> prodWithChildList = new FNS_ProductsSelector().selectProductWithChilds(new Set<Id>{productId});
		for(Sobject productRecord : prodWithChildList){
			List<SObject> loanRecordList;
			List<SObject> feeRecordList;
			List<SObject> pricingRecordList;
			List<SObject> roleRecordList;

			List<Id> feeList = new List<Id>();
			List<Id> pricingList = new List<Id>();
			List<Id> roleList = new List<Id>();
			List<Id> loanList = new List<Id>();
			loanRecordList = productRecord.getSObjects(loanObject);
			feeRecordList = productRecord.getSObjects(feeObject);
			pricingRecordList = productRecord.getSObjects(pricingObject);
			roleRecordList = productRecord.getSObjects(roleObject);

			if(loanRecordList != null && ! loanRecordList.isEmpty()){
				for(SObject childObj : loanRecordList){
					loanList.add((Id)childObj.get('Id'));
				}
			}
			productObject.loanRecords = loanList;

			if(feeRecordList != null && ! feeRecordList.isEmpty()){
				for(SObject childObj : feeRecordList){
					feeList.add((Id)childObj.get('Id'));
				}
			}
			productObject.feesRecordIds = feeList;

			if(pricingRecordList != null && ! pricingRecordList.isEmpty()){
				for(SObject childObj : pricingRecordList){
					pricingList.add((Id)childObj.get('Id'));
				}
			}
			productObject.pricingRecordIds = pricingList;

			if(roleRecordList != null && ! roleRecordList.isEmpty()){
				for(SObject childObj : roleRecordList){
					if(FNS_Util.isFSCInstalled){
						if(childObj.get('FinServ__Role__c') !='Primary Owner'){
							roleList.add((Id)childObj.get('Id'));
						}
					} else{
						roleList.add((Id)childObj.get('Id'));
					}
				}
			}
			productObject.roleRecordIds = roleList;
			productWrapperList.add(productObject);
		}
        }catch(DMLException ex){
            logger.addLogRecord('FNS_ShowProductCompController', 'editProduct', ex.getMessage() + ex.getStackTraceString());
            productObject.error=ex.getMessage();
        }catch (Exception ex){
            logger.addLogRecord('FNS_ShowProductCompController', 'editProduct', ex.getMessage() + ex.getStackTraceString());
            productObject.error=ex.getMessage(); 
        }  
		return productObject;
	}
}