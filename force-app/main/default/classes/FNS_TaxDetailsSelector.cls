/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on FNS_TaxDetails__c object
****************************************************************************************/
public with sharing class FNS_TaxDetailsSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_TaxDetailsSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_TaxDetailsSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of FNS_TaxDetails__c object
        * @param 	   none
        * @return      List of Schema.SObjectField of FNS_TaxDetails__c object
    **************************************************************************************/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> { 
            FNS_TaxDetails__c.Id,
            FNS_TaxDetails__c.FNS_AccountName__c,
            FNS_TaxDetails__c.FNS_TaxDetailsExtId__c,
            FNS_TaxDetails__c.FNS_TaxCountry__c,
            FNS_TaxDetails__c.FNS_TaxExmptCode__c,
            FNS_TaxDetails__c.FNS_TaxNumber__c,
            FNS_TaxDetails__c.FNS_TaxPayerId__c,
            FNS_TaxDetails__c.FNS_TaxRegion__c,
            FNS_TaxDetails__c.FNS_TaxType__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of FNS_TaxDetails__c object
        * @param 	   none
        * @return      Returns SObjecttype of FNS_TaxDetails__c object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_TaxDetails__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return FNS_TaxDetails__c records based on accountIds
        * @param 	   Set of Account ids
        * @return      Returns List of FNS_TaxDetails__c object
    **************************************************************************************/
    public List<FNS_TaxDetails__c> selectTaxDetailsByCustomer(Set<Id> accountIds) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        
        fflib_QueryFactory taxDetailsQueryFactory = newQueryFactory(true, true, true);
        taxDetailsQueryFactory.assertIsAccessible();
        taxDetailsQueryFactory.setEnforceFLS(true);
        
        if(accountIds != null && !accountIds.isEmpty()){
            taxDetailsQueryFactory.setCondition(baseNamespace+'FNS_AccountName__c IN :accountIds');
        }

        return (List<FNS_TaxDetails__c>) Database.query( taxDetailsQueryFactory.toSOQL() );
    }
}