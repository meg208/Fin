/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Custom object Fee
****************************************************************************************/
public with sharing class FNS_FeeSelector extends fflib_SObjectSelector{
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_FeeSelector(){
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_FeeSelector(Boolean enforceFLS){
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Custom object Fee
        * @param 	   none
        * @return      List of Schema.SObjectField of Custom object Fee
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            FNS_Fee__c.Id,
            FNS_Fee__c.FNS_Amount__c,
            FNS_Fee__c.FNS_CurrencyCode__c,
            FNS_Fee__c.FNS_FeeRate__c,
            FNS_Fee__c.FNS_FeeType__c,
            FNS_Fee__c.FNS_FinancialAccount__c,
            FNS_Fee__c.FNS_BypassValidation__c,
            FNS_Fee__c.FNS_FinancialAccountTransaction__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Custom object Fee
        * @param 	   none
        * @return      Returns SObjecttype of Custom object Fee
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType(){
        return FNS_Fee__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Custom Fee records based on feeIds
        * @param 	   Set of Fee Ids
        * @return      Returns List of Custom object Fee
    **************************************************************************************/
    public List<FNS_Fee__c> selectById(Set<Id> feeIds){
        return (List<FNS_Fee__c>) selectSObjectsById(feeIds);
    }
    
    /*************************************************************************************
        * @description Method to return Custom Fee records based on productIds
        * @param 	   Set of Product Ids
        * @return      Returns List of Custom object Fee
    **************************************************************************************/
    public List<FNS_Fee__c> getFees(Set<Id> productIds){
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        fflib_QueryFactory feeQueryFactory = newQueryFactory(true, true, true);
        feeQueryFactory.assertIsAccessible();
        feeQueryFactory.setEnforceFLS(true);
        String feeQueryCondition = '';
        List<String> feeQueryConditions = new List<String>();
        
        if(productIds != null && !productIds.isEmpty()){
            if(FNS_Util.isFSCInstalled){
            	feeQueryCondition = extNamespace + 'FNS_FinancialAccountFSC__c IN : productIds';
            }else {
            	feeQueryCondition = baseNamespace + 'FNS_FinancialAccount__c IN : productIds';
            }
        }
        feeQueryConditions.add(feeQueryCondition);
        if(! feeQueryConditions.isEmpty()){
            feeQueryFactory.setCondition(String.join(feeQueryConditions, ' AND '));
        }
		
        return (List<FNS_Fee__c>) Database.query(feeQueryFactory.toSOQL());
    }   
}