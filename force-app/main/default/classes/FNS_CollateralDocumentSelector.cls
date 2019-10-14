/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on FNS_CollateralDocument__c object
****************************************************************************************/
public with sharing class FNS_CollateralDocumentSelector extends fflib_SObjectSelector{

    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_CollateralDocumentSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_CollateralDocumentSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of FNS_CollateralDocument__c object
        * @param 	   none
        * @return      List of Schema.SObjectField of FNS_CollateralDocument__c object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> { 
            FNS_CollateralDocument__c.FNS_DocumentExtId__c,
            FNS_CollateralDocument__c.FNS_DocumentId__c,
			FNS_CollateralDocument__c.Name,
            FNS_CollateralDocument__c.FNS_Collateral__c,
            FNS_CollateralDocument__c.FNS_FileName__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of FNS_CollateralDocument__c object
        * @param 	   none
        * @return      Returns SObjecttype of FNS_CollateralDocument__c object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_CollateralDocument__c.sObjectType;
    }
    
    public List<SObject> getRecordsByCollateralId(Id collateralId) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();

        fflib_QueryFactory collateralQueryFactory = newQueryFactory(true, true, true);
        collateralQueryFactory.assertIsAccessible();
        //collateralQueryFactory.setEnforceFLS(true);
        
        String collQueryCondition; 
        if(collateralId != null){
            collQueryCondition= 'FNS_Collateral__c = :collateralId';
            collateralQueryFactory.setCondition(collQueryCondition);
        }
        List<SObject> collDocumentsList = (List<SObject>) Database.query(collateralQueryFactory.toSOQL());

        String documentName = '';
        
        // To get Description of the file Uploaded
        if (collDocumentsList != null) {
            for (SObject document : collDocumentsList) {
                if(((FNS_CollateralDocument__c)document).FNS_DocumentId__c != null) {  
                    FNS_DocumentContentSelector versionSelector = new FNS_DocumentContentSelector(); 
            
                    List<ContentVersion> documentList = versionSelector.geversionItems(((FNS_CollateralDocument__c)document).FNS_DocumentId__c);
                    if(documentList != null){
                        documentName = documentList[0].Title + '.' + documentList[0].FileExtension;
                    }
                    ((FNS_CollateralDocument__c)document).FNS_FileName__c = documentName;
                }                        
            }
        }

        return collDocumentsList;
    }     
    
    public List<SObject> getRecordsByProductId(Set<Id> productIdSet) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();

        fflib_QueryFactory collateralQueryFactory = newQueryFactory(true, true, true);
        collateralQueryFactory.assertIsAccessible();
        //collateralQueryFactory.setEnforceFLS(true);
        //collateralQueryFactory.selectField('FNS_Product__r.FNS_FinancialProductExtId__c');
       
        String collQueryCondition; 
        if(productIdSet != null){
            collQueryCondition= 'FNS_Product__c IN :productIdSet';
            collateralQueryFactory.setCondition(collQueryCondition);
        }
        return (List<SObject>) Database.query(collateralQueryFactory.toSOQL());
    }     
   
}