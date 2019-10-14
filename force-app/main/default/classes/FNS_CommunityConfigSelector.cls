/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on FNS_CommunityConfig custom settings
****************************************************************************************/
public with sharing class FNS_CommunityConfigSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param       none
        * @return      none
    **************************************************************************************/
    public FNS_CommunityConfigSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param       Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/ 
    public FNS_CommunityConfigSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of FNS_CommunityConfig__c 
                       custom setting object 
        * @param       none
        * @return      List of Schema.SObjectField of FNS_CommunityConfig object
    **************************************************************************************/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_CommunityConfig__c.FNS_CommunityProfile__c,
            FNS_CommunityConfig__c.FNS_PermisionSetName__c,
            FNS_CommunityConfig__c.FNS_WelcomeEmailTemplateName__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of FNS_CommunityConfig__c custom setting 
                       object 
        * @param       none
        * @return      Returns SObjecttype of FNS_CommunityConfig object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_CommunityConfig__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return FNS_CommunityConfig__c custom setting 
                       object records
        * @param       none
        * @return      Returns List of FNS_CommunityConfig object
    **************************************************************************************/
    public List<FNS_CommunityConfig__c> getAllRecords() {
        return Database.query(newQueryFactory().toSOQL());
    }
}