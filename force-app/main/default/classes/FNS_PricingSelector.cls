/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Custom object Pricing
****************************************************************************************/
public with sharing class FNS_PricingSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_PricingSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_PricingSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Custom object Pricing
        * @param 	   none
        * @return      List of Schema.SObjectField of Custom object Pricing
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_Pricing__c.Id,
            FNS_Pricing__c.FNS_AllInRate__c,
            FNS_Pricing__c.FNS_BaseRate__c,
            FNS_Pricing__c.FNS_CalcType__c,
            FNS_Pricing__c.FNS_Frequencies__c,
            FNS_Pricing__c.FNS_FinancialAccount__c,
            FNS_Pricing__c.FNS_FinancialAccountTransaction__c,
            FNS_Pricing__c.FNS_PricingType__c,
            FNS_Pricing__c.FNS_RateBasis__c,
            FNS_Pricing__c.FNS_RateType__c,
            FNS_Pricing__c.FNS_BypassValidation__c,
            FNS_Pricing__c.FNS_Spread__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Custom object Pricing
        * @param 	   none
        * @return      Returns SObjecttype of Custom object Pricing
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        return FNS_Pricing__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Custom Pricing records based on pricingIds
        * @param 	   Set of Pricing ids
        * @return      Returns List of Custom object Pricing
    **************************************************************************************/ 
    public List<FNS_Pricing__c> selectById(Set<Id> pricingIds) {
        return (List<FNS_Pricing__c>) selectSObjectsById(pricingIds);
    }
    
    /*************************************************************************************
        * @description Method to return Custom Pricing records based on productIds
        * @param 	   Set of Product Ids
        * @return      Returns List of Custom object Pricing
    **************************************************************************************/ 
    public List<FNS_Pricing__c> getPricings(Set<Id> productIds) {
        fflib_QueryFactory pricingQueryFactory = newQueryFactory(true, true, true);
        pricingQueryFactory.assertIsAccessible();
        pricingQueryFactory.setEnforceFLS(true);
        String pricingQueryCondition = '';
        List<String> pricingQueryConditions = new List<String>();
		
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        if(productIds != null){
            if(FNS_Util.isFSCInstalled){
            	pricingQueryCondition = extNamespace + 'FNS_FinancialAccountFSC__c IN : productIds';
            }else {
            	pricingQueryCondition = baseNamespace + 'FNS_FinancialAccount__c IN : productIds';
            }
        }
        pricingQueryConditions.add(pricingQueryCondition);
        if(! pricingQueryConditions.isEmpty()){
            pricingQueryFactory.setCondition(String.join(pricingQueryConditions, ' AND '));
        }
		
        return (List<FNS_Pricing__c>) Database.query(pricingQueryFactory.toSOQL());
    }
}