/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Contacts
****************************************************************************************/
public with sharing class FNS_ContactSelector extends fflib_SObjectSelector {
     static FNS_ErrorLog logger = new FNS_ErrorLog();
   
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_ContactSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_ContactSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Contact object
        * @param 	   none
        * @return      List of Schema.SObjectField of Contact object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> { 
        	Contact.Id,
        	Contact.Name,
        	Contact.Email,
        	Contact.Phone,
        	Contact.Title,
        	Contact.HomePhone,
        	Contact.MobilePhone,
        	Contact.FNS_ContactType__c,
        	Contact.Department
        };
     }
    
    /*************************************************************************************
        * @description Method to return SObject type of Contact object
        * @param 	   none
        * @return      Returns SObjecttype of Contact object
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        return Contact.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Contact records based on contact Ids
        * @param 	   Set of Contact ids
        * @return      Returns List of Contact object
    **************************************************************************************/
    public List<Contact> selectById(Set<Id> contactIds) {
        return (List<Contact>) selectSObjectsById(contactIds);
    }
    
    /*************************************************************************************
        * @description Method to return Contact records based on account Ids
        * @param 	   Set of Account ids
        * @return      Returns List of Contact object
    **************************************************************************************/
    public List<Contact> selectContactsByCustomer(Set<Id> accountIds) {
        fflib_QueryFactory contactQueryFactory = newQueryFactory(true, true, true);
        List<Contact> contactsByCustomer = new List<Contact>();
        try {
            contactQueryFactory.assertIsAccessible();
            contactQueryFactory.setEnforceFLS(true);
            
            if(accountIds != null && !accountIds.isEmpty()){
                contactQueryFactory.setCondition('AccountId IN :accountIds');
            }
            contactsByCustomer = (List<Contact>) Database.query( contactQueryFactory.toSOQL() );
        }
        catch (Exception ex){
            logger.addLogRecord('FNS_ContactSelector', 'selectContactsByCustomer', ex.getMessage() + ex.getStackTraceString()); 
            throw new FNS_CustomException(Label.FNS_CustomException);
        }
        return contactsByCustomer;
    }
}