/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on FNS_CollateralWithProduct__c object
****************************************************************************************/
public with sharing class FNS_CollateralWithProductSelector extends fflib_SObjectSelector{

    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_CollateralWithProductSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_CollateralWithProductSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of FNS_CollateralWithProduct__c object
        * @param 	   none
        * @return      List of Schema.SObjectField of FNS_CollateralWithProduct__c object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> { 
            FNS_CollateralWithProduct__c.Name,
            FNS_CollateralWithProduct__c.FNS_Collateral__c,
			FNS_CollateralWithProduct__c.FNS_Product__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of FNS_CollateralWithProduct__c object
        * @param 	   none
        * @return      Returns SObjecttype of FNS_CollateralWithProduct__c object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_CollateralWithProduct__c.sObjectType;
    }
    
    public List<SObject> getRecordsByCollateralId(Set<Id> collateralIdSet) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();

        fflib_QueryFactory collateralQueryFactory = newQueryFactory(true, true, true);
        collateralQueryFactory.assertIsAccessible();
        //collateralQueryFactory.setEnforceFLS(true);
        collateralQueryFactory.selectField('FNS_Product__r.FNS_FinancialProductExtId__c');
       
        String collQueryCondition; 
        if(collateralIdSet != null){
            collQueryCondition= 'FNS_Collateral__c IN :collateralIdSet';
            collateralQueryFactory.setCondition(collQueryCondition);
        }
        return (List<SObject>) Database.query(collateralQueryFactory.toSOQL());
    }     

    public List<SObject> getCollateralsByApplicationId(String applicationId) {
        Set<String> productIdSet = new Set<String>();
        System.System.debug('>>>applicationID>>>'+applicationId);
        List<SObject> productList = new FNS_ProductsSelector().selectProductsByApplicationID(applicationId);
        if(productList != null && !productList.isEmpty()){
        for (SObject product : productList) {
            if(product.Id != null) {  
                productIdSet.add(product.Id); 
            }                        
        }

        System.debug('productIdSet>>>'+productIdSet);
        String baseNamespace= FNS_Util.getBasePackageNamepace();

        fflib_QueryFactory collateralWithProductsQueryFactory = newQueryFactory(true, true, true);
        collateralWithProductsQueryFactory.assertIsAccessible();
        //collateralWithProcuctsQueryFactory.selectField(baseNamespace + 'FNS_Product__r.FNS_ProductSummary__c');
		String productObjName='';
        if(FNS_Util.isFSCInstalled){
            productObjName = baseNamespace+'FNS_Product__r';
        }
        else{
            productObjName = baseNamespace+'FNS_ProductNonFSC__r';
        }
		String collateralObjName = baseNamespace+'FNS_Collateral__r';
      
        fflib_SObjectSelector productSelector = new FNS_ProductsSelector();
      	productSelector.configureQueryFactoryFields(collateralWithProductsQueryFactory, productObjName);
        fflib_SObjectSelector collateralSelector = new FNS_CollateralSelector();
        List<String> collateralQueryConditions = new List<String>();
        if(productIdSet != null && !productIdSet.isEmpty()){
            collateralQueryConditions.add('FNS_Product__c IN :productIdSet');
        }
        if(! collateralQueryConditions.isEmpty()){
            collateralWithProductsQueryFactory.setCondition(String.join(collateralQueryConditions, ' AND '));
        }
      	collateralSelector.configureQueryFactoryFields(collateralWithProductsQueryFactory, collateralObjName);
         system.debug('@@ collateralWithProductsQueryFactory.toSOQL() :: ' + collateralWithProductsQueryFactory.toSOQL() );
        return (List<SObject>) Database.query(collateralWithProductsQueryFactory.toSOQL());
        } else {
            
            return null;
        }
    }       
}