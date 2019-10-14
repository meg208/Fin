/***********************************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Object Selector
 * @description Class This class is used to handle all the DML operations for FFDC APIConfiguration metadata.
 ***********************************************************************************************************/
public with sharing class FNS_FFDCToSFDCSelector extends fflib_SObjectSelector {

	/*************************************************************************************************************************************************************
	 * @description  Constructor to set boolean values to TRUE of Super class.We are setting includeFieldsetFields, enforceCRUD, enforceFLS in param constructor to 
                     TRUE
	 * @Params       none
	 * @Returns      none
	 **************************************************************************************************************************************************************/
	public FNS_FFDCToSFDCSelector() {
		super(true, true, true);
	}

	/*************************************************************************************************************************************************************
	 * @description  Constructor to set boolean values to TRUE of Super class.We are setting includeFieldsetFields, enforceCRUD, enforceFLS in param constructor to 
                     TRUE
	 * @Params       Boolean value for enforceFLS
	 * @Returns      none
	 **************************************************************************************************************************************************************/
	public FNS_FFDCToSFDCSelector(Boolean enforceFLS) {
		super(true, true, false);
	}

	/****************************************************************************************************
	 * @description  Method to return Schema.SObjectField list of FFDC APIConfiguration metadata object
	 * @Params       none
	 * @Returns      List of Schema.SObjectField of FFDC APIConfiguration metadata object
	 ****************************************************************************************************/ 
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			FNS_FFDCSFDCSetup__c.FNS_ConsumerKey__c,
			FNS_FFDCSFDCSetup__c.FNS_ConsumerSecret__c,
			FNS_FFDCSFDCSetup__c.FNS_OrganisationId__c,
			FNS_FFDCSFDCSetup__c.FNS_RedirectURI__c
		};
	}

	/*************************************************************************************
	 * @description  Method to return SObject type of Custom Activity object
	 * @Params       none
	 * @Returns      Returns SObjecttype of custom activity object
	 **************************************************************************************/ 
	public Schema.SObjectType getSObjectType() {
		return FNS_FFDCSFDCSetup__c.sObjectType;
	}

	/*************************************************************************************
	 * @description  Method to return Custom Activity records based on activityIds.
	 * @Params       Set of Custom Activity ids
	 * @Returns      Returns List of Custom Activity object
	 **************************************************************************************/
	public List<FNS_FFDCSFDCSetup__c> getAllRecords() {
		return Database.query(newQueryFactory().toSOQL());
	}
}