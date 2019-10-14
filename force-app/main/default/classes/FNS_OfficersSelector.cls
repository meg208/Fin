/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Officer object
****************************************************************************************/
public with sharing class FNS_OfficersSelector extends fflib_SObjectSelector{
	
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_OfficersSelector(){
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/ 
    public FNS_OfficersSelector(Boolean enforceFLS){
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Officer object 
        * @param 	   none
        * @return      List of Schema.SObjectField of Officer object
    **************************************************************************************/
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            FNS_Officer__c.Id,
            FNS_Officer__c.FNS_OfficerDescription__c,
            FNS_Officer__c.FNS_OfficerId__c,
            FNS_Officer__c.Name,
            FNS_Officer__c.FNS_OfficerType__c
            
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Officer object 
        * @param 	   none
        * @return      Returns SObjecttype of Officers object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType(){
        return FNS_Officer__c.sObjectType;
    }

    /*************************************************************************************
        * @description Method to return list of Officer records
        * @param 	   none
        * @return      Returns List of Officer object
    **************************************************************************************/
    public List<FNS_Officer__c> getAllOfficers(){        
		fflib_QueryFactory predAnalyticsQueryFactory = newQueryFactory(true, true, true);
        predAnalyticsQueryFactory.assertIsAccessible();
        predAnalyticsQueryFactory.setEnforceFLS(true);   
        return (List<FNS_Officer__c>) Database.query(predAnalyticsQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return Officer object records based on officerIds
        * @param 	   Set of Officers object ids
        * @return      Returns List of Officer object 
    **************************************************************************************/
    public List<FNS_Officer__c> selectByExternalId(Set<String> officerIds){
		fflib_QueryFactory query = newQueryFactory();
 		String baseNamespace= FNS_Util.getBasePackageNamepace();
 		if(officerIds != null && !officerIds.isEmpty()){
            query.setCondition(baseNamespace+'FNS_OfficerId__c IN :officerIds');
        }
      	return (List<FNS_Officer__c>) Database.query( query.toSOQL() );
	}
}