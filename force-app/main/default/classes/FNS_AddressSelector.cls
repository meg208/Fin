/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on FNS_Address__c object
****************************************************************************************/
public with sharing class FNS_AddressSelector extends fflib_SObjectSelector{

    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_AddressSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_AddressSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of FNS_Address__c object
        * @param 	   none
        * @return      List of Schema.SObjectField of FNS_Address__c object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> { 
            FNS_Address__c.Id,
            FNS_Address__c.FNS_Account__c,
            FNS_Address__c.FNS_Address1__c,
            FNS_Address__c.FNS_Address2__c,
            FNS_Address__c.FNS_Address3__c,
            FNS_Address__c.FNS_AddressType__c,
            FNS_Address__c.FNS_City__c,
            FNS_Address__c.FNS_CountryCode__c,
            FNS_Address__c.FNS_PostalCodeExtension__c,
            FNS_Address__c.FNS_PostalCode__c,
            FNS_Address__c.FNS_ProvinceCode__c,
            FNS_Address__c.FNS_State__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of FNS_Address__c object
        * @param 	   none
        * @return      Returns SObjecttype of FNS_Address__c object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_Address__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return FNS_Address__c records based on accountIds
        * @param 	   Set of Account ids
        * @return      Returns List of FNS_Address__c object
    **************************************************************************************/
    public List<FNS_Address__c> selectAddressByCustomer(Set<Id> accountIds) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();    
        fflib_QueryFactory addressQueryFactory = newQueryFactory(true, true, true);
        addressQueryFactory.assertIsAccessible();
        addressQueryFactory.setEnforceFLS(true);
        
        if(accountIds != null && !accountIds.isEmpty()){
            addressQueryFactory.setCondition(baseNamespace+'FNS_Account__c IN :accountIds');
        }

        return (List<FNS_Address__c>) Database.query(addressQueryFactory.toSOQL() );
    }
    
    /*************************************************************************************
        * @description Method to return FNS_Address__c records based on accountIds
        * @param 	   Set of Account ids
        * @return      Returns List of FNS_Address__c object
    **************************************************************************************/
    public List<FNS_Address__c> getCollateralAddressRecords(Set<Id> collateralIDSet){
		String baseNamespace= FNS_Util.getBasePackageNamepace();    
	    fflib_QueryFactory addressQueryFactory = newQueryFactory(true, true, true);
	    addressQueryFactory.assertIsAccessible();
	        addressQueryFactory.setEnforceFLS(true);
	        
	        if(collateralIDSet != null && !collateralIDSet.isEmpty()){
	            addressQueryFactory.setCondition(baseNamespace+'FNS_Collateral__c IN :collateralIDSet');
	        }
	        return (List<FNS_Address__c>) Database.query(addressQueryFactory.toSOQL() );
	}
}