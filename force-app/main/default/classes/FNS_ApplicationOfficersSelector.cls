/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Application-Officer object
****************************************************************************************/
public with sharing class FNS_ApplicationOfficersSelector extends fflib_SObjectSelector {
	
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_ApplicationOfficersSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   enforcing FLS
        * @return      none
    **************************************************************************************/ 
    public FNS_ApplicationOfficersSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Application-Officer 
        			   object 
        * @param 	   none
        * @return      List of Schema.SObjectField of Application-Officer object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_ApplicationWithOfficer__c.Id,
            FNS_ApplicationWithOfficer__c.FNS_Application__c,
            FNS_ApplicationWithOfficer__c.FNS_OfficerRole__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Application-Officer object 
        * @param 	   none
        * @return      SObjecttype of Application-Officer object 
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        return FNS_ApplicationWithOfficer__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Application-Officer object records based on 
        			   ExternalIds 
        * @param 	   Set of external Id 
        * @return      Returns List of Application-Officer object
    **************************************************************************************/ 
    public List<FNS_ApplicationWithOfficer__c> selectByExternalId(Set<Id> externalIdSet) {
		fflib_QueryFactory query = newQueryFactory();
      	return (List<FNS_ApplicationWithOfficer__c>) Database.query( query.toSOQL() );
	}
	
    /*************************************************************************************
        * @description Method to return Application-Officer object records based on 
        			   Application Id 
        * @param 	   Set of Application Id 
        * @return      Returns List of Application-Officer object
    **************************************************************************************/ 
    public List<FNS_ApplicationWithOfficer__c> getApplicationOfficersByAppId(Set<Id> appIdSet) {
		fflib_QueryFactory query = newQueryFactory(true, true, true);
		String baseNamespace = FNS_Util.getBasePackageNamepace();
 		if(appIdSet != null && !appIdSet.isEmpty()){
            query.setCondition(baseNamespace+'FNS_Application__c IN :appIdSet');
        }        
        fflib_SObjectSelector officerSelector = new FNS_OfficersSelector();
      	officerSelector.configureQueryFactoryFields(query, baseNamespace+'FNS_Officer__r');      	
      	fflib_SObjectSelector applicationelector = new FNS_ApplicationSelector();
      	applicationelector.configureQueryFactoryFields(query, baseNamespace+'FNS_Application__r');
        
      	return (List<FNS_ApplicationWithOfficer__c>) Database.query( query.toSOQL() );
	}
    
}