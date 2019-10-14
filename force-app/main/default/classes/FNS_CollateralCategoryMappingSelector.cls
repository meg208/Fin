/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on FFDC APIConfiguration metadata
****************************************************************************************/
public with sharing class FNS_CollateralCategoryMappingSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param       none
        * @return      none
    **************************************************************************************/  
    public FNS_CollateralCategoryMappingSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param       Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/ 
    public FNS_CollateralCategoryMappingSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of FFDC APIConfiguration 
                       metadata object
        * @param       none
        * @return      List of Schema.SObjectField of FFDC APIConfiguration metadata object
    **************************************************************************************/  
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_CollateralCategoryFieldSetMapping__mdt.Id,
            FNS_CollateralCategoryFieldSetMapping__mdt.MasterLabel,
            FNS_CollateralCategoryFieldSetMapping__mdt.FNS_CollateralCategory__c,
            FNS_CollateralCategoryFieldSetMapping__mdt.FNS_FieldSetName__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of FFDC APIConfiguration metadata object
        * @param       none
        * @return      Returns SObjecttype of FFDC APIConfiguration metadata object
    **************************************************************************************/  
    public Schema.SObjectType getSObjectType() {
        return FNS_CollateralCategoryFieldSetMapping__mdt.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return FFDC APIConfiguration metadata records 
        * @param       none
        * @return      Returns List of FFDC APIConfiguration metadata object
    **************************************************************************************/ 
    public List<FNS_CollateralCategoryFieldSetMapping__mdt> getAllRecords() {
        return Database.query(newQueryFactory().toSOQL());
    }
  
}