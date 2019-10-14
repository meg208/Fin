/**
 * Copyright (c) 2019, brillio, inc
 * All rights reserved.
 * @author brillio inc.
 * @date 2019
 * @group API Service
 * @description Act as a wrapper class for API service class.
 */  
/**
  Namespace rules :
    1. Standard fields of Standard/Custom objects do not carry namespace
    2. Custom fields of base package will have baseNamespace
    3. Custom fields of extension package will carry extension namespace.
    we must send fields with name space to FNS_AccessController.checkCRUD_FLS() method.
 */
public with sharing class FNS_ObjectAccessContainer {
	public static string baseNamespace = FNS_Util.getBasePackageNamepace();
	public static string extNamespace = FNS_Util.getExtensionPackageNamespace();
	public static string namespace = FNS_Util.isFSCInstalled?extNamespace:baseNamespace;

	/**************************************************************************************************************************************
	 * @description  Method to perform Account object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkAccountAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add('Name');    
		fieldSet.add('AccountNumber');
		fieldSet.add('AnnualRevenue');
		fieldSet.add(baseNamespace+'FNS_CustomerExtId__c');
		fieldSet.add(baseNamespace+'FNS_IdentityNumber__c');
		fieldSet.add(baseNamespace+'FNS_IdentityType__c');
		fieldSet.add(baseNamespace+'FNS_OfficialType__c');
		fieldSet.add(baseNamespace+'FNS_CustomerDescription__c');
		FNS_AccessController.checkCRUD_FLS('Account' ,dml,fieldSet);
	}
    
	/**************************************************************************************************************************************
	 * @description  Method to perform Opportunity object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkApplicationRolesAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add('Name');
		fieldSet.add('OwnerId');
         
		fieldSet.add(baseNamespace+'FNS_AccountName__c');
		fieldSet.add(baseNamespace+'FNS_RoleOfEntity__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_RelatedRoles__c' ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform Opportunity object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkProductRolesAccess(String dml){
		Set<String> fieldSet = new Set<String>();
        String objName = baseNamespace+'FNS_FinancialAccount__c';
		fieldSet.add('Name');
		fieldSet.add('OwnerId');
         
        if (FNS_Util.isFSCInstalled){
			fieldSet.add('FinServ__Role__c');
            objName = 'FinServ__FinancialAccountRole__c';
        } else {
            fieldSet.add(baseNamespace+'FNS_Role__c');
        }
		FNS_AccessController.checkCRUD_FLS(objName,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform Opportunity object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkOpportunityAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add('Name');
		fieldSet.add('Amount');
		fieldSet.add('StageName');
		fieldSet.add('CloseDate');
		fieldSet.add('Description');
		fieldSet.add('AccountID');  
		fieldSet.add(baseNamespace+'FNS_SLAStatus__c');
		fieldSet.add(baseNamespace+'FNS_ApplicationExtId__c');
		fieldSet.add(baseNamespace+'FNS_StartDateTime__c');
	    fieldSet.add(baseNamespace+'FNS_Fees__c');
        fieldSet.add(baseNamespace+'FNS_LoanAmount__c');
        fieldSet.add(baseNamespace+'FNS_BypassValidation__c');
		if(FNS_Util.isFSCInstalled){
			//fieldSet.add('FinServ__FinancialAccount__c');
		}
		FNS_AccessController.checkCRUD_FLS('Opportunity' ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform Contact object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkContactAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add('Email');
		fieldSet.add('Phone');
		fieldSet.add('Title');
		fieldSet.add('HomePhone');
		fieldSet.add('MobilePhone');
		fieldSet.add('Department');
		FNS_AccessController.checkCRUD_FLS('Contact' ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform Fee object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkFeeAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_Amount__c');
		fieldSet.add(baseNamespace+'FNS_CurrencyCode__c');
		fieldSet.add(baseNamespace+'FNS_FeeRate__c');
		fieldSet.add(baseNamespace+'FNS_FeeType__c');
		fieldSet.add(baseNamespace+'FNS_FinancialAccount__c');
		fieldSet.add(baseNamespace+'FNS_FinancialAccountTransaction__c');
		fieldSet.add(baseNamespace+'FNS_BypassValidation__c');
		if(FNS_Util.isFSCInstalled){
			fieldSet.add(extNamespace+'FNS_FinancialAccountFSC__c');
			fieldSet.add(extNamespace+'FNS_FinancialAccountTransactionFSC__c');
		}
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_Fee__c' ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform Pricing object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkPricingAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_AllInRate__c');
		fieldSet.add(baseNamespace+'FNS_BaseRate__c');
		fieldSet.add(baseNamespace+'FNS_CalcType__c');
		fieldSet.add(baseNamespace+'FNS_Frequencies__c');
		fieldSet.add(baseNamespace+'FNS_FinancialAccount__c');
		fieldSet.add(baseNamespace+'FNS_FinancialAccountTransaction__c');
		fieldSet.add(baseNamespace+'FNS_PricingType__c');
		fieldSet.add(baseNamespace+'FNS_RateBasis__c');
		fieldSet.add(baseNamespace+'FNS_RateType__c');
		fieldSet.add(baseNamespace+'FNS_Spread__c');
		fieldSet.add(baseNamespace+'FNS_BypassValidation__c');

		if(FNS_Util.isFSCInstalled){
			fieldSet.add(extNamespace+'FNS_FinancialAccountFSC__c');
			fieldSet.add(extNamespace+'FNS_FinancialAccountTransactionFSC__c');
		}
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_Pricing__c' ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform FinAccount object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkFinAccountAccess(String dml){
		Set<String> fieldSet;
		String sobjectName;

		if(FNS_Util.isFSCInstalled){
			sobjectName = 'FinServ__FinancialAccount__c';
			fieldSet = new Set<String> {
				extNamespace + 'FNS_CurrencyCode__c',
                extNamespace + 'FNS_EffectiveDate__c',
                extNamespace + 'FNS_FinancialProductExtId__c',
                extNamespace + 'FNS_MaturityDate__c',                   
                extNamespace + 'FNS_OriginationTypeIndicator__c',
                extNamespace + 'FNS_BypassValidation__c', 
                extNamespace + 'FNS_ExpiryDate__c',
                extNamespace + 'FNS_ProductType__c',
                extNamespace + 'FNS_Purpose__c',
                extNamespace + 'FNS_RateType__c',
                extNamespace + 'FNS_Amount__c',
                extNamespace + 'FNS_RequestedClosingDate__c',
                extNamespace + 'FNS_Term__c',
                extNamespace + 'FNS_TermUnit__c',
                extNamespace + 'FNS_Application__c'
			};                        
		} else {
			//For Non FSC 
			sobjectName = baseNamespace +'FNS_FinancialAccount__c';
			fieldSet = new Set<String> {
				baseNamespace + 'FNS_Account__c',
                baseNamespace + 'FNS_Amount__c',
                baseNamespace + 'FNS_CurrencyCode__c',
                baseNamespace + 'FNS_EffectiveDate__c',
                baseNamespace + 'FNS_ExpiryDate__c',
                baseNamespace + 'FNS_FinancialProductExtId__c',
                baseNamespace + 'FNS_FinancialAccountTransaction__c',
                baseNamespace + 'FNS_MaturityDate__c',
                baseNamespace + 'FNS_Application__c',
                baseNamespace + 'FNS_OriginationTypeIndicator__c',
                baseNamespace + 'FNS_BypassValidation__c',
                baseNamespace + 'FNS_ProductType__c',
               
                baseNamespace + 'FNS_Purpose__c',
                baseNamespace + 'FNS_RateType__c',
                baseNamespace + 'FNS_RequestedClosingDate__c',
                baseNamespace + 'FNS_Term__c',
                baseNamespace + 'FNS_TermUnit__c'
			};
		}
		FNS_AccessController.checkCRUD_FLS(sobjectName ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform FinAccountTransaction object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkFinAccountTransactionAccess(String dml){
		Set<String> fieldSet;
		String sobjectName;
		Schema.SObjectType sObj;

		if(FNS_Util.isFSCInstalled) {
			sobjectName = 'FinServ__FinancialAccountTransaction__c';
			fieldSet = new Set<String> {
				extNamespace + 'FNS_Account__c',
                'FinServ__FinancialAccount__c',
                'FinServ__Amount__c',
                extNamespace + 'FNS_EffectiveDate__c',
                extNamespace + 'FNS_ExpiryDate__c',
                extNamespace + 'FNS_FinancialAccountTransactionExtId__c',
                extNamespace + 'FNS_LoanProductType__c',
                extNamespace + 'FNS_LoanPurpose__c',
                extNamespace + 'FNS_MaturityDate__c',
                extNamespace + 'FNS_Application__c',
				extNamespace + 'FNS_BypassValidation__c',
                extNamespace + 'FNS_OriginationTypeIndicator__c',
                extNamespace + 'FNS_PricingFrequency__c',
                extNamespace + 'FNS_PricingType__c',
                extNamespace + 'FNS_RateType__c',
                extNamespace + 'FNS_RequestedDate__c',
                extNamespace + 'FNS_RiskType__c',
                extNamespace + 'FNS_Term__c',
                extNamespace + 'FNS_TermUnit__c'
			};                        
		} else {                            
			sobjectName = baseNamespace +'FNS_FinancialAccountTransaction__c';
			fieldSet = new Set<String> {
				baseNamespace + 'FNS_Account__c',
                baseNamespace + 'FNS_Amount__c',
                baseNamespace + 'FNS_EffectiveDate__c',
                baseNamespace + 'FNS_FinancialAccountTransactionExtId__c',
                baseNamespace + 'FNS_ExpiryDate__c',
                baseNamespace + 'FNS_FinancialAccount__c',
                baseNamespace + 'FNS_RateType__c',
                baseNamespace + 'FNS_LoanProductType__c',
                baseNamespace + 'FNS_LoanPurpose__c',
                baseNamespace + 'FNS_MaturityDate__c',
                baseNamespace + 'FNS_Application__c',
				baseNamespace + 'FNS_BypassValidation__c',
                baseNamespace + 'FNS_OriginationTypeIndicator__c',
                baseNamespace + 'FNS_PricingFrequency__c',
                baseNamespace + 'FNS_PricingType__c',
                baseNamespace + 'FNS_RequestedDate__c',
                baseNamespace + 'FNS_RiskType__c',
                baseNamespace + 'FNS_Status__c',
                baseNamespace + 'FNS_Term__c',
                baseNamespace + 'FNS_TermUnit__c'
			};
		}
		FNS_AccessController.checkCRUD_FLS(sobjectName ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform FinAccountRole object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkFinAccountRoleAccess(String dml){
		Set<String> fieldSet;
		String sobjectName;

		if(FNS_Util.isFSCInstalled){
			sobjectName = 'FinServ__FinancialAccountRole__c';
			fieldSet = new Set<String> {
				extNamespace + 'FNS_GuaranteeDollar__c',
				extNamespace + 'FNS_GuaranteePercent__c',
				extNamespace + 'FNS_FinancialAccountTransaction__c',
				extNamespace + 'FNS_ProductRelRole__c',
				extNamespace + 'FNS_TypeofProdRole__c'
			};
		}else{
			sobjectName = baseNamespace +'FNS_FinancialAccountRole__c';
			fieldSet = new Set<String> {

				baseNamespace + 'FNS_GuaranteeDollar__c',
				baseNamespace + 'FNS_GuaranteePercent__c',
				baseNamespace + 'FNS_FinancialAccountTransaction__c',
				baseNamespace + 'FNS_ProductRelRole__c',
				baseNamespace + 'FNS_TypeofProdRole__c',
				baseNamespace + 'FNS_FinancialAccount__c',
				baseNamespace + 'FNS_RelatedAccount__c'
			};
		}
		FNS_AccessController.checkCRUD_FLS(sobjectName ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform RelatedRole object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkRelatedRoleAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_AccountName__c');
		fieldSet.add(baseNamespace+'FNS_Application__c');
		fieldSet.add(baseNamespace+'FNS_RoleOfEntity__c');
		fieldSet.add(baseNamespace+'FNS_Contact__c');
		fieldSet.add(baseNamespace+'FNS_Type__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_RelatedRoles__c' ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform Address object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkAddressAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_Account__c');
		fieldSet.add(baseNamespace+'FNS_Address1__c');
		fieldSet.add(baseNamespace+'FNS_Address2__c');
		fieldSet.add(baseNamespace+'FNS_Address3__c');
		fieldSet.add(baseNamespace+'FNS_AddressType__c');
		fieldSet.add(baseNamespace+'FNS_City__c');
		fieldSet.add(baseNamespace+'FNS_CountryCode__c');
		fieldSet.add(baseNamespace+'FNS_PostalCodeExtension__c');
		fieldSet.add(baseNamespace+'FNS_PostalCode__c');
		fieldSet.add(baseNamespace+'FNS_ProvinceCode__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_Address__c' ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform ApplicationWithOfficer object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkApplicationWithOfficerAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_Application__c');
		fieldSet.add(baseNamespace+'FNS_OfficerRole__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_ApplicationWithOfficer__c' ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform Tax object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void CheckTaxAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_AccountName__c');
		fieldSet.add(baseNamespace+'FNS_TaxDetailsExtId__c');
		fieldSet.add(baseNamespace+'FNS_TaxCountry__c');
		fieldSet.add(baseNamespace+'FNS_TaxExmptCode__c');
		fieldSet.add(baseNamespace+'FNS_TaxNumber__c');
		fieldSet.add(baseNamespace+'FNS_TaxPayerId__c');
		fieldSet.add(baseNamespace+'FNS_TaxRegion__c');
		fieldSet.add(baseNamespace+'FNS_TaxType__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_TaxDetails__c' ,dml,fieldSet);
	}  

	/**************************************************************************************************************************************
	 * @description  Method to perform CustomerProfile object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkCustomerProfileAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_CreditComment__c');
		fieldSet.add(baseNamespace+'FNS_CreditReviewDate__c');
		fieldSet.add(baseNamespace+'FNS_CustomerBusiness__c');
		fieldSet.add(baseNamespace+'FNS_ProfileType__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_CustomerProfile__c' ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform ApplicationWithQueueActivity object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkApplicationWithQueueActivityAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_ActivityExternalId__c');
		fieldSet.add(baseNamespace+'FNS_ActivityNotes__c');
		fieldSet.add(baseNamespace+'FNS_ApplicationExternalId__c');
		fieldSet.add(baseNamespace+'FNS_IsCurrentActivity__c');     
		fieldSet.add(baseNamespace+'FNS_QueueExternalId__c');
		fieldSet.add(baseNamespace+'FNS_SequenceNumber__c');
		fieldSet.add(baseNamespace+'FNS_Status__c');
		fieldSet.add(baseNamespace+'FNS_User__c');

		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_ApplicationWithQueueActivity__c' ,dml,fieldSet);
	}

	/**************************************************************************************************************************************
	 * @description  Method to perform ErrorLog object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 **************************************************************************************************************************************/
	public static void checkErrorLogAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_ApexClass__c');
		fieldSet.add(baseNamespace+'FNS_ErrorMessage__c');
		fieldSet.add(baseNamespace+'FNS_Method__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_ErrorLog__c' ,dml,fieldSet);
	}

	/*************************************************************************************
	 * @description  Method to perform FeeType object level below checks for field updateable or not and record delete permission checks.	
	 * @Params       DML operation type
	 * @Returns      none
	 *************************************************************************************/
	public static void checkFeeTypeAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_Description__c');
		fieldSet.add(baseNamespace+'FNS_DMLType__c');
		fieldSet.add(baseNamespace+'FNS_FeeTypeExternalId__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_FeeType__c' ,dml,fieldSet);
	}

	/*************************************************************************************
	 * @description  Method to perform PredictiveAnalytics object level below checks for field updateable or not and record delete permission checks.
	 * @Params       DML operation type
	 * @Returns      none
	 *************************************************************************************/
	public static void checkPredictiveAnalyticsAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_Customer__c');
		fieldSet.add(baseNamespace+'FNS_CustomerName__c');
		fieldSet.add(baseNamespace+'FNS_FinancialAccountName__c');
		fieldSet.add(baseNamespace+'FNS_FinancialAccount__c');
		fieldSet.add(baseNamespace+'FNS_FinancialAccountTransaction__c');
		fieldSet.add(baseNamespace+'FNS_FinancialAccountTransactionName__c');
		fieldSet.add(baseNamespace+'FNS_PriorityOrder__c');
		fieldSet.add(baseNamespace+'FNS_Recommendation__c');
		fieldSet.add(baseNamespace+'FNS_RecommendationDescription__c');
		fieldSet.add(baseNamespace+'FNS_RecommendationId__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_PredictiveAnalytics__c' ,dml,fieldSet);
	}

	/*************************************************************************************
	 * @description  Method to perform ProcessCenter object level below checks for field updateable or not and record delete permission checks.
	 * @Params       DML operation type
	 * @Returns      none
	 *************************************************************************************/
	public static void checkProcessCenterAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_AddressLine__c');
		fieldSet.add(baseNamespace+'FNS_City__c');
		fieldSet.add(baseNamespace+'FNS_County__c');
		fieldSet.add(baseNamespace+'FNS_ProcessCenterExtId__c');
		fieldSet.add('Name');
		fieldSet.add(baseNamespace+'FNS_ProcessCenterNumber__c');
		fieldSet.add(baseNamespace+'FNS_State__c');
		fieldSet.add(baseNamespace+'FNS_StreetName__c');
		fieldSet.add(baseNamespace+'FNS_StreetNumber__c');
		fieldSet.add(baseNamespace+'FNS_Zip__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_ProcessCenter__c' ,dml,fieldSet);
	}

	/*************************************************************************************
	 * @description  Method to perform ProcessGroup object level below checks for field updateable or not and record delete permission checks.
	 * @Params       DML operation type
	 * @Returns      none
	 *************************************************************************************/
	public static void checkProcessGroupAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_Description__c');
		fieldSet.add(baseNamespace+'FNS_NextDefaultProcessGroupId__c');
		fieldSet.add(baseNamespace+'FNS_InactiveIndicator__c');
		fieldSet.add(baseNamespace+'FNS_ProcessGroupExtId__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_ProcessGroup__c' ,dml,fieldSet);
	}

	/*************************************************************************************
	 * @description  Method to perform ProductType object level below checks for field updateable or not and record delete permission checks.
	 * @Params       DML operation type
	 * @Returns      none
	 *************************************************************************************/
	public static void checkProductTypeAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_Description__c');
		fieldSet.add(baseNamespace+'FNS_DMLType__c');
		fieldSet.add(baseNamespace+'FNS_HierarchyIndicator__c');
		fieldSet.add(baseNamespace+'FNS_ProductTypeExternalId__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_ProductType__c' ,dml,fieldSet);
	}

	/*************************************************************************************
	 * @description  Method to perform TrackingDocs object level below checks for field updateable or not and record delete permission checks.
	 * @Params       DML operation type
	 * @Returns      none
	 *************************************************************************************/
	public static void checkTrackingDocsAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		//fieldSet.add(baseNamespace+'FNS_Application__c');
		fieldSet.add(baseNamespace+'FNS_ApplicationExtId__c');
		fieldSet.add(baseNamespace+'FNS_CustomerExtId__c');
		fieldSet.add(baseNamespace+'FNS_DocumentExtId__c');
		fieldSet.add(baseNamespace+'FNS_FileName__c');
		fieldSet.add(baseNamespace+'FNS_TrackingItemExtId__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_TrackingDocs__c' ,dml,fieldSet);
	}

	/*******************************************************************************************************************************************
	 * @description  Method to perform Task object level below checks for field updateable or not and record delete permission checks.
	 * @Params       DML operation type
	 * @Returns      none
	 *******************************************************************************************************************************************/
	public static void checkTaskAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add('Subject');
		fieldSet.add('ActivityDate');
		fieldSet.add('Status');
		fieldSet.add('ActivityDate');
		fieldSet.add('WhatId');
		fieldSet.add('WhoId');
		FNS_AccessController.checkCRUD_FLS('Task',dml,fieldSet);
	}

	/*******************************************************************************************************************************************
	 * @description  Method to perform Task object level below checks for field updateable or not and record delete permission checks.
	 * @Params       DML operation type
	 * @Returns      none
	 *******************************************************************************************************************************************/
	public static void checkUserAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add('FirstName');
		fieldSet.add('LastName');
		fieldSet.add('Email');
		fieldSet.add('Phone');
		fieldSet.add('Title');
		fieldSet.add('EmployeeNumber'); 
		fieldSet.add(baseNamespace + 'FNS_UserExternalId__c'); 
		fieldSet.add(baseNamespace + 'FNS_isOfficer__c');
		FNS_AccessController.checkCRUD_FLS('User',dml,fieldSet);
	}

	/*******************************************************************************************************************************************
	 * @description  Method to perform Activity object level below checks for field updateable or not and record delete permission checks.
	 * @Params       DML operation type
	 * @Returns      none
	 *******************************************************************************************************************************************/
	public static void checkActivityAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_ActivityNotes__c');
		fieldSet.add(baseNamespace+'FNS_ApplicationExtId__c');
		fieldSet.add(baseNamespace+'FNS_NextDefaultActivityId__c');
		fieldSet.add(baseNamespace+'FNS_Description__c');
		fieldSet.add(baseNamespace+'FNS_NextAvailableActivityIds__c');
		//fieldSet.add(baseNamespace+'FNS_SequenceNumber__c');
		//fieldSet.add(baseNamespace+'FNS_Status__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_Activity__c' ,dml,fieldSet);
	}


	/*******************************************************************************************************************************************
	 * @description  Method to perform Bank object level below checks for field updateable or not and record delete permission checks.
	 * @Params       DML operation type
	 * @Returns      none
	 *******************************************************************************************************************************************/
	public static void checkBankAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_BankExternalId__c');
		fieldSet.add(baseNamespace+'FNS_BankNumber__c');
		fieldSet.add(baseNamespace+'FNS_BankValue__c');
		fieldSet.add(baseNamespace+'FNS_Branch__c');
		fieldSet.add(baseNamespace+'FNS_GoverningState__c');
		fieldSet.add(baseNamespace+'FNS_RCNumber__c');
		fieldSet.add(baseNamespace+'FNS_RegionNumber__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_Bank__c' ,dml,fieldSet);
	}

	/*******************************************************************************************************************************************
	 * @description  Method to perform ConfigurationType object level below checks for field updateable or not and record delete permission checks.
	 * @Params       DML operation type
	 * @Returns      none
	 *******************************************************************************************************************************************/
	public static void checkConfigurationTypeAccess(String dml){
		Set<String> fieldSet = new Set<String>();
		fieldSet.add(baseNamespace+'FNS_ConfigurationExternalId__c');
		fieldSet.add(baseNamespace+'FNS_ConfigurationId__c');
		fieldSet.add(baseNamespace+'FNS_ConfigurationType__c');
		fieldSet.add(baseNamespace+'FNS_ConfigurationValue__c');
		fieldSet.add(baseNamespace+'FNS_Description__c');
		fieldSet.add(baseNamespace+'FNS_DMLType__c');
		fieldSet.add(baseNamespace+'FNS_SystemId__c');
		fieldSet.add(baseNamespace+'FNS_SystemOrder__c');
		FNS_AccessController.checkCRUD_FLS(baseNamespace+'FNS_ConfigurationType__c' ,dml,fieldSet);
	}
}