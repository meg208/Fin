/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Domain Class
* @description This class acts as domain class for Financial Product object 
****************************************************************************/
public with sharing class FNS_FinancialProductDomain {
    
    static string baseNamespace  = FNS_Util.getBasePackageNamepace(); 
    static string extNamespace  = FNS_Util.getExtensionPackageNamespace() ;
    static string namespace = FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
    static String finAccountObjName ;
    static String finFinancialAccountTransactionObjName ;
    static String finFinancialAccountRoleObjName ;
    static Schema.SObjectType finAccountObject;
    static Schema.SObjectType finFinancialAccountTransactionObject;
    static Schema.SObjectType finFinancialAccountRoleObject ;
    static fflib_SObjectUnitOfWork uow ;  // SObjects (in order of dependency)
    static string productLoanRelationShipName ;
    static string productPricngRelationShipName ;
    static string productFeeRelationShipName ;
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    static {
        initCode();
    }
    
  /***********************************************************************
  * @description This method initializes all the static variables when class is initialized
  * @param none
  * @return none
  ************************************************************************/
  private static void initCode() {
    if(FNS_Util.isFSCInstalled){
      finAccountObjName = 'FinServ__FinancialAccount__c' ;
      finFinancialAccountTransactionObjName ='FinServ__FinancialAccountTransaction__c' ;
      finFinancialAccountRoleObjName ='FinServ__FinancialAccountRole__c' ;
      productLoanRelationShipName = 'Finserv__FinancialAccountTranslations__r';
      productPricngRelationShipName = namespace + 'ApplicationPricings__r' ;
      productFeeRelationShipName = namespace + 'ProductFeesFSC__r';
    }
    else{
      finAccountObjName = baseNamespace+'FNS_FinancialAccount__c' ;
      finFinancialAccountTransactionObjName = baseNamespace+'FNS_FinancialAccountTransaction__c' ;
      finFinancialAccountRoleObjName = baseNamespace+'FNS_FinancialAccountRole__c' ;
      productLoanRelationShipName = baseNamespace + 'FinancialAccountLoans__r';
      productPricngRelationShipName = baseNamespace + 'FinancialProductPricings__r';
      productFeeRelationShipName = baseNamespace + 'FinancialProductFees__r';
    }
    finAccountObject = Schema.getGlobalDescribe().get(finAccountObjName);
    finFinancialAccountTransactionObject = Schema.getGlobalDescribe().get(finFinancialAccountTransactionObjName);
    finFinancialAccountRoleObject = Schema.getGlobalDescribe().get(finFinancialAccountRoleObjName);
    uow = new fflib_SObjectUnitOfWork( 
      new Schema.SObjectType[] {
        finAccountObject, 
        FNS_Pricing__c.SObjectType,
        FNS_Fee__c.SObjectType,
        finFinancialAccountTransactionObject,
        finFinancialAccountRoleObject
      }
    );
  }
 
  /***********************************************************************
  * @description This method inserts Financial Product, Loan, pricing and 
           Fee details for an Application record
  * @param Application Salesforce Id
  * @param List of instance of FNS_FinancialProductPayload class
  * @param List Account records
  * @return none
  ************************************************************************/
  public static void upsertfinancialProductList( String applicationID, List<FNS_FinancialProductPayload> financialProductArray, List<Account> customerList) {
        FNS_Pricing__c pricing;
        FNS_Fee__c fee;
        Opportunity application ;
        Boolean isRecordTypeReadOnly = false;
        
        String oppReadOnlyRecordType = FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE ;
        String oppEditableRecordType = FNS_Constants.OPPORTUNITY_EDITABLERECORDTYPE ;

        ID oppReadOnlyID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppReadOnlyRecordType).RecordTypeId ;
        ID oppEditableID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppEditableRecordType).RecordTypeId ;
        
        String productReadOnlyRecordType = FNS_Constants.PRODUCT_READONLYRECORDTYPE;
        String loanReadOnlyRecordType = FNS_Constants.LOAN_READONLYRECORDTYPE;
        String pricingReadOnlyRecordType = FNS_Constants.PRICING_READONLYRECORDTYPE;
        String feeReadOnlyRecordType = FNS_Constants.FEE_READONLYRECORDTYPE;         

        ID productReadOnlyID = (Schema.getGlobalDescribe().get(finAccountObjName).getDescribe()).getRecordTypeInfosByDeveloperName().get(productReadOnlyRecordType).getRecordTypeId();
        ID loanReadOnlyID = (Schema.getGlobalDescribe().get(finFinancialAccountTransactionObjName).getDescribe()).getRecordTypeInfosByDeveloperName().get(loanReadOnlyRecordType).getRecordTypeId();
        ID feeReadOnlyID = Schema.SObjectType.FNS_Fee__c.getRecordTypeInfosByDeveloperName().get(feeReadOnlyRecordType).RecordTypeId ;
        ID pricingReadOnlyID  = Schema.SObjectType.FNS_Pricing__c.getRecordTypeInfosByDeveloperName().get(pricingReadOnlyRecordType).RecordTypeId;

        String productEditableRecordType = FNS_Constants.PRODUCT_EDITABLERECORDTYPE;
        String loanEditableRecordType = FNS_Constants.LOAN_EDITABLERECORDTYPE;
        String pricingEditableRecordType = FNS_Constants.PRICING_EDITABLERECORDTYPE;
        String feeEditableRecordType = FNS_Constants.FEE_EDITABLERECORDTYPE;         

        ID productEditableID = (Schema.getGlobalDescribe().get(finAccountObjName).getDescribe()).getRecordTypeInfosByDeveloperName().get(productEditableRecordType).getRecordTypeId();
        ID loanEditableID = (Schema.getGlobalDescribe().get(finFinancialAccountTransactionObjName).getDescribe()).getRecordTypeInfosByDeveloperName().get(loanEditableRecordType).getRecordTypeId();
        ID feeEditableID = Schema.SObjectType.FNS_Fee__c.getRecordTypeInfosByDeveloperName().get(feeEditableRecordType).RecordTypeId;
        ID pricingEditableID  = Schema.SObjectType.FNS_Pricing__c.getRecordTypeInfosByDeveloperName().get(pricingEditableRecordType).RecordTypeId;

        if(!String.isEmpty(applicationID)){
            application = FNS_Util.getOpportunityFromAppResp(applicationID);
        }
        if(application.RecordTypeId == oppReadOnlyID){
            isRecordTypeReadOnly = true;
        }
        if(financialProductArray != null) {
            for( FNS_FinancialProductPayload financialProduct: financialProductArray) {
                SObject finAccount = FNS_FinancialAccountDomain.assignJSONToFinancialAccount(application.FNS_ApplicationExtId__c ,namespace, finAccountObjName, financialProduct);
                if(isRecordTypeReadOnly){
                    finAccount.put('RecordTypeId',productReadOnlyID);
                } else {
                    finAccount.put('RecordTypeId',productEditableID);
                }
                uow.registerNew(finAccount);

                if(financialProduct.customerIds != null) {
                    FNS_FinancialAccountRolesDomain.setFinancialAccountRoles(uow, finAccount, namespace, finFinancialAccountRoleObjName, financialProduct.customerIds, customerList);
                }
                //insert Pricing
                if(financialProduct.pricings != null) {  
                    for(FNS_ObjectContainer.FNS_Pricing pricingRec : financialProduct.pricings ){
                        pricing = FNS_PricingDomain.assignJSONToPricing(namespace ,finAccount,pricingRec);                                     
                        if(FNS_Util.isFSCInstalled){
                            uow.registerRelationship(pricing,  FNS_Pricing__c.SObjectType.getDescribe().fields.getMap().get(namespace +'FNS_FinancialAccountFSC__c'), finAccount);
                        }else{
                            uow.registerRelationship(pricing,  FNS_Pricing__c.SObjectType.getDescribe().fields.getMap().get(namespace+'FNS_FinancialAccount__c'), finAccount);
                        }
                        if(isRecordTypeReadOnly){
                            pricing.RecordTypeId = pricingReadOnlyID;
                        } else {
                            pricing.RecordTypeId = pricingEditableID;
                        }
                        uow.registerNew(pricing);
                    }
                } 
                // insert Fee
                if(financialProduct.fees  != null){
                    for(FNS_ObjectContainer.FNS_Fee feeRec : financialProduct.fees ){
                        fee = FNS_FeeDomain.assignJSONToFee(feeRec);
                        if(FNS_Util.isFSCInstalled){
                            uow.registerRelationship(fee,  FNS_Fee__c.SObjectType.getDescribe().fields.getMap().get(namespace+'FNS_FinancialAccountFSC__c'), finAccount);
                        }else{
                            uow.registerRelationship(fee,  FNS_Fee__c.SObjectType.getDescribe().fields.getMap().get(namespace+'FNS_FinancialAccount__c'), finAccount);
                        }
                        
                        if(isRecordTypeReadOnly){
                            fee.RecordTypeId = feeReadOnlyID;
                        } else {
                            fee.RecordTypeId = feeEditableID;
                        }
                        uow.registerNew(fee);
                    }
                }
                //  insert Loans
                if (financialProduct.loans != null) {               
                    for(FNS_ObjectContainer.FNS_Loan loanRec : financialProduct.loans){        
                        SObject finAccTransaction = FNS_FinancialAccountTransactionDomain.assignJSONToFinancialAccountTransaction(namespace, finFinancialAccountTransactionObjName, loanRec);
                        if(FNS_Util.isFSCInstalled){
                            uow.registerRelationship(finAccTransaction,  finFinancialAccountTransactionObject.getDescribe().fields.getMap().get('FinServ__FinancialAccount__c'), finAccount);
                            uow.registerRelationship(finAccTransaction,  finFinancialAccountTransactionObject.getDescribe().fields.getMap().get(namespace+'FNS_Application__c'), application);
                        }else{
                            uow.registerRelationship(finAccTransaction,  finFinancialAccountTransactionObject.getDescribe().fields.getMap().get(namespace+'FNS_FinancialAccount__c'), finAccount);
                            uow.registerRelationship(finAccTransaction,  finFinancialAccountTransactionObject.getDescribe().fields.getMap().get(namespace+'FNS_Application__c'), application);
                        } 
                        if(isRecordTypeReadOnly){
                            finAccTransaction.put('RecordTypeId',loanReadOnlyID);
                        } else {
                            finAccTransaction.put('RecordTypeId', loanEditableID);
                        }
                        uow.registerNew(finAccTransaction);
                    } 
                }
            }
            Set<ID> applicationIDs = new Set<ID>();
            applicationIDs.add(application.ID);
            List<SObject> productRecList  = new FNS_ProductsSelector().selectApplicationProductWithChilds(applicationIDs);
            if(productRecList != null && !productRecList.isEmpty()) {
                for(Sobject productObj : productRecList) {
                    List<SObject> loanRecList = productObj.getsObjects(productLoanRelationShipName);    
                    List<SObject> pricingRecList = productObj.getsObjects(productPricngRelationShipName);
                    List<SObject> feeRecList = productObj.getsObjects(productFeeRelationShipName);
                    if(loanRecList != null ){
                        uow.registerdeleted(loanRecList);
                    }
                    if(pricingRecList != null ){
                        uow.registerdeleted(pricingRecList);
                    }
                    if(feeRecList != null ){
                        uow.registerdeleted(feeRecList);
                    }
                }
                if(productRecList != null){
                    uow.registerdeleted(productRecList);
                }
            }
            FNS_ObjectAccessContainer.checkFinAccountTransactionAccess(FNS_AccessController.DML_OPERATION_INSERT);
            FNS_ObjectAccessContainer.checkFinAccountTransactionAccess(FNS_AccessController.DML_OPERATION_DELETE);

            FNS_ObjectAccessContainer.checkFinAccountAccess(FNS_AccessController.DML_OPERATION_INSERT);
            FNS_ObjectAccessContainer.checkFinAccountAccess(FNS_AccessController.DML_OPERATION_DELETE);

            FNS_ObjectAccessContainer.checkFinAccountRoleAccess(FNS_AccessController.DML_OPERATION_INSERT);
            FNS_ObjectAccessContainer.checkFinAccountRoleAccess(FNS_AccessController.DML_OPERATION_DELETE);

            FNS_ObjectAccessContainer.checkFeeAccess(FNS_AccessController.DML_OPERATION_INSERT);
            FNS_ObjectAccessContainer.checkFeeAccess(FNS_AccessController.DML_OPERATION_DELETE);

            FNS_ObjectAccessContainer.checkPricingAccess(FNS_AccessController.DML_OPERATION_INSERT);
            FNS_ObjectAccessContainer.checkPricingAccess(FNS_AccessController.DML_OPERATION_DELETE);
            try{
                uow.commitwork();
            }catch (DMLException ex){
                logger.addLogRecord('FNS_FinancialProductDomain', 'upsertfinancialProductList', ex.getMessage() + ex.getStackTraceString());
            } 
        }
  }
  
  /***********************************************************************
  * @description This method updates all Financial Product, Loan, pricing and 
           Fee details to read only/ Editable based on isreadOnly flag
  * @param Set of Application Salesforce Id
  * @param Boolean flag
  * @return none
  ************************************************************************/
  public static void updateRecordTypeForProductandChildRec(Set<ID> oppID , boolean isreadOnly) {
  
   new FNS_FinancialProductDomain.FNS_AdminContext().updateRecordType( oppID , isreadOnly);
  }
  /************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Application
 * @description This class is written so that RecordTypeID can be chnaged to ReadOnly value.
                The code is supposed to be run in the context of Admin as Logged in user
                will not have access to this recordType. RecordType switch is performed to 
                change Layout to read only mode.
 ****************************************************************************************/

  public without sharing class FNS_AdminContext{
    string baseNamespace  = FNS_Util.getBasePackageNamepace(); 
    string extNamespace  = FNS_Util.getExtensionPackageNamespace() ;
    string namespace = FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
  
     public void updateRecordType(Set<ID> oppID , boolean isreadOnly){
            String productReadOnlyRecordType = FNS_Constants.PRODUCT_READONLYRECORDTYPE;
            String loanReadOnlyRecordType = FNS_Constants.LOAN_READONLYRECORDTYPE;
            String pricingReadOnlyRecordType = FNS_Constants.PRICING_READONLYRECORDTYPE;
            String feeReadOnlyRecordType = FNS_Constants.FEE_READONLYRECORDTYPE;         

            ID productReadOnlyID = (Schema.getGlobalDescribe().get(finAccountObjName).getDescribe()).getRecordTypeInfosByDeveloperName().get(productReadOnlyRecordType).getRecordTypeId();
            ID loanReadOnlyID = (Schema.getGlobalDescribe().get(finFinancialAccountTransactionObjName).getDescribe()).getRecordTypeInfosByDeveloperName().get(loanReadOnlyRecordType).getRecordTypeId();
            ID feeReadOnlyID = Schema.SObjectType.FNS_Fee__c.getRecordTypeInfosByDeveloperName().get(feeReadOnlyRecordType).RecordTypeId ;
            ID pricingReadOnlyID  = Schema.SObjectType.FNS_Pricing__c.getRecordTypeInfosByDeveloperName().get(pricingReadOnlyRecordType).RecordTypeId;

            String productEditableRecordType = FNS_Constants.PRODUCT_EDITABLERECORDTYPE;
            String loanEditableRecordType = FNS_Constants.LOAN_EDITABLERECORDTYPE;
            String pricingEditableRecordType = FNS_Constants.PRICING_EDITABLERECORDTYPE;
            String feeEditableRecordType = FNS_Constants.FEE_EDITABLERECORDTYPE;         

            ID productEditableID = (Schema.getGlobalDescribe().get(finAccountObjName).getDescribe()).getRecordTypeInfosByDeveloperName().get(productEditableRecordType).getRecordTypeId();
            ID loanEditableID = (Schema.getGlobalDescribe().get(finFinancialAccountTransactionObjName).getDescribe()).getRecordTypeInfosByDeveloperName().get(loanEditableRecordType).getRecordTypeId();
            ID feeEditableID = Schema.SObjectType.FNS_Fee__c.getRecordTypeInfosByDeveloperName().get(feeEditableRecordType).RecordTypeId;
            ID pricingEditableID  = Schema.SObjectType.FNS_Pricing__c.getRecordTypeInfosByDeveloperName().get(pricingEditableRecordType).RecordTypeId;

            List<Sobject> productRecList = new FNS_ProductsSelector().selectApplicationProductWithChilds(oppID);
            
            if(productRecList != null && isreadOnly) {
              for (Sobject productObj : productRecList ) {
                productObj.put('RecordTypeId', productReadOnlyID );
                bypassValidation(productObj);
                uow.registerDirty(productObj);

                for(Sobject loanObj : productObj.getsObjects(productLoanRelationShipName)) {
                     loanObj.put('RecordTypeId', loanReadOnlyID);
                     bypassValidation(loanObj);
                     uow.registerDirty(loanObj);
                }
                for(Sobject pricingObj : productObj.getsObjects(productPricngRelationShipName)) {
                    pricingObj.put('RecordTypeId', pricingReadOnlyID);
                    bypassValidation(pricingObj);
                    uow.registerDirty(pricingObj);            
                }
                for(Sobject feeObj : productObj.getsObjects(productFeeRelationShipName)) {
                    feeObj.put('RecordTypeId', feeReadOnlyID );
                    bypassValidation(feeObj);
                    uow.registerDirty(feeObj);       
                }
              }
            }else if(productRecList != null && !isreadOnly) {
              for (Sobject productObj : productRecList ) {
                productObj.put('RecordTypeId', productEditableID);
                bypassValidation(productObj);
                uow.registerDirty(productObj);

                for(Sobject loanObj : productObj.getsObjects(productLoanRelationShipName)) {
                  loanObj.put('RecordTypeId', loanEditableID);
                  bypassValidation(loanObj);
                  uow.registerDirty(loanObj);
                }
                for(Sobject pricingObj : productObj.getsObjects(productPricngRelationShipName)) {
                  pricingObj.put('RecordTypeId', pricingEditableID);
                  bypassValidation(pricingObj);
                  uow.registerDirty(pricingObj);            
                }
                for(Sobject feeObj : productObj.getsObjects(productFeeRelationShipName)) {
                  feeObj.put('RecordTypeId', feeEditableID );
                  bypassValidation(feeObj);
                  uow.registerDirty(feeObj);       
                }
              }
            }
            /*
            FNS_ObjectAccessContainer.checkFinAccountAccess(FNS_AccessController.DML_OPERATION_UPDATE);
            FNS_ObjectAccessContainer.checkFinAccountTransactionAccess(FNS_AccessController.DML_OPERATION_UPDATE);
            FNS_ObjectAccessContainer.checkFeeAccess(FNS_AccessController.DML_OPERATION_UPDATE);
            FNS_ObjectAccessContainer.checkPricingAccess(FNS_AccessController.DML_OPERATION_UPDATE);
            */
            List<String> fieldList = new List<String>();
            fieldList.add('RecordTypeID');
            fflib_SecurityUtils.checkUpdate(finFinancialAccountTransactionObject ,fieldList);
            fflib_SecurityUtils.checkUpdate(FNS_Pricing__c.SObjectType ,fieldList);
            fflib_SecurityUtils.checkUpdate(finAccountObject ,fieldList);
            fflib_SecurityUtils.checkUpdate(FNS_Fee__c.SObjectType ,fieldList);
            try{
                uow.commitwork();
            }catch (DMLException ex){
                logger.addLogRecord('FNS_FinancialProductDomain', 'updateRecordType', ex.getMessage() + ex.getStackTraceString());
            } 
    }

    public void bypassValidation(Sobject obj){
        if( obj.get(namespace +'FNS_BypassValidation__c') == true){
			obj.put(namespace +'FNS_BypassValidation__c' , false) ;
        }
        else{
			obj.put(namespace +'FNS_BypassValidation__c' , true);
        }

    }

  }  
}