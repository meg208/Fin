/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Custom object CustomerProfile
****************************************************************************************/
public with sharing class FNS_CustomerProfilesSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_CustomerProfilesSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_CustomerProfilesSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Custom object CustomerProfile
        * @param 	   none
        * @return      List of Schema.SObjectField of Custom object CustomerProfile
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_CustomerProfile__c.Id,
            FNS_CustomerProfile__c.FNS_CreditComment__c,
            FNS_CustomerProfile__c.FNS_CreditReviewDate__c,
            FNS_CustomerProfile__c.FNS_CustomerBusiness__c,
            FNS_CustomerProfile__c.FNS_ProfileType__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Custom object CustomerProfile
        * @param 	   none
        * @return      Returns SObjecttype of Custom object CustomerProfile
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        return FNS_CustomerProfile__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Customer Profile records based on CustomerProfile Ids
        * @param 	   Set of Customer Profile ids
        * @return      Returns List of Custom object CustomerProfile
    **************************************************************************************/ 
    public List<FNS_CustomerProfile__c> selectById(Set<Id> addressIds) {
        return (List<FNS_CustomerProfile__c>) selectSObjectsById(addressIds);
    }
    
    /*************************************************************************************
        * @description Method to return Customer Profile records based on accountIds
        * @param 	   Set of Account ids
        * @return      Returns List of Custom object CustomerProfile
    **************************************************************************************/ 
    public List<FNS_CustomerProfile__c> selectCustomerProfilesByCustomer(Set<Id> accountIds) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        
        fflib_QueryFactory custProfileQueryFactory = newQueryFactory(true, true, true);
        custProfileQueryFactory.assertIsAccessible();
        custProfileQueryFactory.setEnforceFLS(true);
    
        List<String> addressQueryConditions = new List<String>();
            
        if(accountIds != null && !accountIds.isEmpty()){
            addressQueryConditions.add(baseNamespace+'FNS_CustomerBusiness__c IN :accountIds');
        }
        
        if(! addressQueryConditions.isEmpty()){
            custProfileQueryFactory.setCondition(String.join(addressQueryConditions, ' AND '));
        }
        return (List<FNS_CustomerProfile__c>) Database.query(custProfileQueryFactory.toSOQL());
    } 
}