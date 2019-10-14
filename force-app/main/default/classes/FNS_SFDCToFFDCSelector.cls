/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on FFDC APIConfiguration metadata
****************************************************************************************/
public with sharing class FNS_SFDCToFFDCSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_SFDCToFFDCSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/ 
    public FNS_SFDCToFFDCSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of FNS_SFDCFFDCSetup__c 
        			   custom setting object 
        * @param 	   none
        * @return      List of Schema.SObjectField of FFDC APIConfiguration object
    **************************************************************************************/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_SFDCFFDCSetup__c.FNS_ConsumerKey__c,
            FNS_SFDCFFDCSetup__c.FNS_ConsumerSecret__c,
            FNS_SFDCFFDCSetup__c.FNS_AccessTokenUrl__c,
            FNS_SFDCFFDCSetup__c.FNS_OrganisationId__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of FNS_SFDCFFDCSetup__c custom setting 
         			   object 
        * @param 	   none
        * @return      Returns SObjecttype of FFDC APIConfiguration object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_SFDCFFDCSetup__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return FNS_SFDCFFDCSetup__c custom setting 
         			   object records
        * @param 	   none
        * @return      Returns List of FFDC APIConfiguration object
    **************************************************************************************/
    public List<FNS_SFDCFFDCSetup__c> getAllRecords() {
        return Database.query(newQueryFactory().toSOQL());
    }
}