/*****************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Access Handler
 * @description This class is used to pull summary data for Application.

 ******************************************************************************************/
public with sharing class FNS_ApplicationRollup {
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
    /*if(FNS_Util.isFSCInstalled){
      finAccountObjName = 'FinServ__FinancialAccount__c' ;
      finFinancialAccountTransactionObjName ='FinServ__FinancialAccountTransaction__c' ;
      productLoanRelationShipName = 'Finserv__FinancialAccountTranslations__r';
      productFeeRelationShipName = namespace + 'ProductFeesFSC__r';
    }else{
      finAccountObjName = baseNamespace+'FNS_FinancialAccount__c' ;
      finFinancialAccountTransactionObjName = baseNamespace+'FNS_FinancialAccountTransaction__c' ;
      productLoanRelationShipName = baseNamespace + 'FinancialAccountLoans__r';
      productFeeRelationShipName = baseNamespace + 'FinancialProductFees__r';
    }
    finAccountObject = Schema.getGlobalDescribe().get(finAccountObjName);
    finFinancialAccountTransactionObject = Schema.getGlobalDescribe().get(finFinancialAccountTransactionObjName);
    uow = new fflib_SObjectUnitOfWork( 
      new Schema.SObjectType[] {
        Opportunity.SObjectType,
        finAccountObject, 
        FNS_Pricing__c.SObjectType,
        FNS_Fee__c.SObjectType,
        finFinancialAccountTransactionObject
      }
    ); */
  } 
   /*************************************************************************************
     * @description  Constructs the domain class for Opportunity.
     * @Params       set of Opportunity ID
     * @Returns      none
     **************************************************************************************/
    
    public static void getSummaryForLoanAndFees(Set<ID> oppSet){
       /* List<Opportunity>  oppWithProductList;
        Map<String,Opportunity> productWithOpportunity = new Map<String,Opportunity>();
       
        Set<ID> productIDSet = new Set<ID>();
        String productRelationshipName;
        String loanAmount;
        String feeAmount; 
    
        if(FNS_Util.isFSCInstalled){
            productRelationshipName = extNamespace+'FinancialAccountApplicationsFSC__r';
            loanAmount = extNamespace + 'FinServ__Amount__c';
            feeAmount = extNamespace +'FNS_Amount__c';
         
        }else{
            productRelationshipName = baseNamespace+'FinancialAccountApplications__r';
            loanAmount = baseNamespace + 'FNS_Amount__c';
            feeAmount = baseNamespace +'FNS_Amount__c';
        }

        ID oppReadOnlyID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE).RecordTypeId ;
        
        if(oppSet != null && !oppSet.isEmpty()){
            oppWithProductList = new FNS_ApplicationSelector().selectApplicationWithProducts(oppSet);
            if(oppWithProductList != null && !oppWithProductList.isEmpty()){
                for (Opportunity opp : oppWithProductList){
                    if(opp.RecordTypeId != oppReadOnlyID){
                        for(Sobject obj :opp.getsObjects(productRelationshipName)){
                            productIDSet.add(obj.Id);
                            productWithOpportunity.put(obj.Id ,opp);
                        }
                    }
                }
            }
        }
        Set<ID> oppIDsReset = new Set<ID>();
        if(!productIDSet.isEmpty()){
            List<Sobject> productWithRelatedRecList =   new FNS_ProductsSelector().selectProductsWithChilds(productIDSet);
            if(productWithRelatedRecList != null && !productWithRelatedRecList.isEmpty()){
                for (Sobject productObj : productWithRelatedRecList ){
                        opportunity opp;
                        if(productWithOpportunity.containsKey(productObj.id)){  
                            opp = productWithOpportunity.get(productObj.id);                     
                                opp.FNS_LoanAmount__c = 0;
                                opp.FNS_Fees__c  = 0;
                                oppIDsReset.add(opp.Id);
                        }
                    
                    for(Sobject loanObj : productObj.getsObjects(productLoanRelationShipName)){
                        if(opp != null){
                            opp.FNS_LoanAmount__c = opp.FNS_LoanAmount__c + Integer.valueOF( loanObj.get(loanAmount));
                        }
                    }
        
                    for(Sobject feeObj : productObj.getsObjects(productFeeRelationShipName)){
                        if(opp != null){
                            opp.FNS_Fees__c  = opp.FNS_Fees__c   + Integer.valueOF(feeObj.get(feeAmount));
                        }
                    }
                   
                    uow.registerDirty(opp);
                }
            }
        }
       
        FNS_ObjectAccessContainer.checkOpportunityAccess(FNS_AccessController.DML_OPERATION_UPDATE);
        uow.commitWork(); 
       */

    }

    /************************************************************************************************************
    * @description  This methods is used to calculate rollup amount of all associated product on application.
    * @Params       set of opportunity ID
    * @Returns      none
    ************************************************************************************************************/
    
    public static void setProductRollUpAmountOnProduct(Set<ID> oppSet){
        List<Opportunity>  oppWithProductList;
        String productRelationshipName;
        String prodAmountField;
    
        if(FNS_Util.isFSCInstalled){
            productRelationshipName = extNamespace+'FinancialAccountApplicationsFSC__r';
			prodAmountField = extNamespace+'FNS_Amount__c';
        }else{
            productRelationshipName = baseNamespace+'FinancialAccountApplications__r';
			prodAmountField = baseNamespace+'FNS_Amount__c';
        }
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork( 
				new Schema.SObjectType[] {
					Opportunity.SObjectType
				}
        );
        if(oppSet != null && !oppSet.isEmpty()){
            oppWithProductList = new FNS_ApplicationSelector().selectApplicationWithProducts(oppSet);
            if(oppWithProductList != null && !oppWithProductList.isEmpty()){
                for (Opportunity opp : oppWithProductList){
				        opp.FNS_TotalRequestedAmount__c =0;
                        for(Sobject obj :opp.getsObjects(productRelationshipName)){
                           opp.FNS_TotalRequestedAmount__c =  opp.FNS_TotalRequestedAmount__c + Integer.valueOF(obj.get(prodAmountField));
						   opp.FNS_BypassValidation__c = !opp.FNS_BypassValidation__c;
                        }
					uow.registerDirty(opp);
                }
            }
        }
        FNS_ObjectAccessContainer.checkOpportunityAccess(FNS_AccessController.DML_OPERATION_UPDATE);
        uow.commitWork(); 
    }
}