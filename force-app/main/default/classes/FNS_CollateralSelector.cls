/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on FNS_Collateral__c object
****************************************************************************************/
public with sharing class FNS_CollateralSelector extends fflib_SObjectSelector{

    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_CollateralSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_CollateralSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of FNS_Collateral__c object
        * @param 	   none
        * @return      List of Schema.SObjectField of FNS_Collateral__c object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> { 
            FNS_Collateral__c.Id,
            FNS_Collateral__c.FNS_AccountNumber__c,
			FNS_Collateral__c.FNS_ValueDate__c,
			FNS_Collateral__c.FNS_AgricultureUse__c,
			FNS_Collateral__c.FNS_Amount__c,
			FNS_Collateral__c.FNS_Application__c,
			FNS_Collateral__c.FNS_AppraisalDate__c,
			FNS_Collateral__c.FNS_AppraisalRequired__c,
			FNS_Collateral__c.FNS_AppraisalTypeId__c,
			FNS_Collateral__c.FNS_BookNumber__c,
			FNS_Collateral__c.FNS_CollateralAddress__c,
			FNS_Collateral__c.FNS_CollateralCategory__c,
			FNS_Collateral__c.FNS_CollateralExtId__c,
			FNS_Collateral__c.FNS_CollateralNumber__c,	
			FNS_Collateral__c.FNS_CollateralOwner__c,	
			FNS_Collateral__c.FNS_CollateralType__c,
			FNS_Collateral__c.FNS_PropertyBuiltDate__c,
			FNS_Collateral__c.FNS_Description__c,
			FNS_Collateral__c.FNS_HostNumber__c,
			FNS_Collateral__c.FNS_IssuerName__c,
			FNS_Collateral__c.FNS_LegalDescription__c,	
			FNS_Collateral__c.FNS_NumberOfUnits__c,
			FNS_Collateral__c.FNS_OwnerOccupied__c,	
			FNS_Collateral__c.FNS_PageNumber__c,	
			FNS_Collateral__c.FNS_Parcel__c,
			FNS_Collateral__c.FNS_PercentLeased__c,
			FNS_Collateral__c.FNS_PledgedDate__c,
			FNS_Collateral__c.FNS_PropertyContactEmail__c,
			FNS_Collateral__c.FNS_PropertyContactFirstName__c,	
			FNS_Collateral__c.FNS_PropertyContactLastName__c,	
			FNS_Collateral__c.FNS_PropertyDescription__c,	
			FNS_Collateral__c.FNS_PropertyIdNumber__c,	
			//FNS_Collateral__c.FNS_ProposedUse__c,
			FNS_Collateral__c.FNS_PurchaseDate__c,
			FNS_Collateral__c.FNS_PurchasedDate__c,
			FNS_Collateral__c.FNS_RecordingOffice__c,
			FNS_Collateral__c.FNS_SecurityType__c,
			FNS_Collateral__c.FNS_ValueSource__c,
			FNS_Collateral__c.FNS_ValueFairMarket__c,	
			FNS_Collateral__c.FNS_SpecifiedGuidelines__c,	
			FNS_Collateral__c.FNS_SquareFootage__c,
			FNS_Collateral__c.FNS_StockSymbol__c,	
			FNS_Collateral__c.FNS_Subdivision__c,
			FNS_Collateral__c.FNS_TaxMapNumber__c,
			FNS_Collateral__c.FNS_CensusTract__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of FNS_Collateral__c object
        * @param 	   none
        * @return      Returns SObjecttype of FNS_Collateral__c object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_Collateral__c.sObjectType;
    }
    
    public List<SObject> getCollateralById(Set<Id> collateralIdSet) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();

        fflib_QueryFactory collateralQueryFactory = newQueryFactory(true, true, true);
        collateralQueryFactory.assertIsAccessible();
        //collateralQueryFactory.setEnforceFLS(true);
        collateralQueryFactory.selectField('Id');
       
        String collQueryCondition; 
        if(collateralIdSet != null){
            collQueryCondition= 'Id IN :collateralIdSet';
            collateralQueryFactory.setCondition(collQueryCondition);
        }
        return (List<SObject>) Database.query(collateralQueryFactory.toSOQL());
    }     
    
}