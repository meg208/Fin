/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on FNS_ActivitiesSelector
****************************************************************************************/
public with sharing class FNS_ActivitiesSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are  
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param  
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/  
    public FNS_ActivitiesSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are  
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param  
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/  
    public FNS_ActivitiesSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Custom Activity object
        * @param 	   none
        * @return      List of Schema.SObjectField of Custom Activity object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_Activity__c.Id,
            FNS_Activity__c.FNS_ActivityExternalId__c,
            FNS_Activity__c.FNS_Description__c, 
            FNS_Activity__c.FNS_NextAvailableActivityIds__c, 
            FNS_Activity__c.FNS_NextDefaultActivityId__c, 
            FNS_Activity__c.FNS_ActivityNotes__c, 
            FNS_Activity__c.FNS_SequenceNumber__c
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Custom Activity object
        * @param 	   none
        * @return      Returns SObjecttype of Custom Activity object
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        return FNS_Activity__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Custom Activity records based on activityIds
        * @param 	   Set of Custom Activity ids
        * @return      Returns List of Custom Activity object
    **************************************************************************************/ 
    public List<FNS_Activity__c> selectById(Set<Id> activityIds) {
        return (List<FNS_Activity__c>) selectSObjectsById(activityIds);
    }
    
    /*************************************************************************************
        * @description Method to return Custom Activity records 
        * @param 	   none
        * @return      Returns List of Custom Activity object
    **************************************************************************************/ 
    public List<FNS_Activity__c> getAllActivities() {
        String baseNamespace = FNS_Util.getBasePackageNamepace();
        fflib_QueryFactory activitiesQueryFactory = newQueryFactory(true, true, true); 
        activitiesQueryFactory.setOrdering(baseNamespace+'FNS_SequenceNumber__c', fflib_QueryFactory.SortOrder.ASCENDING); 
        return (List<FNS_Activity__c>) Database.query(activitiesQueryFactory.toSOQL());
    }
    
    /*************************************************************************************
        * @description Method to return Custom Activity records based on activityIds
        * @param 	   Set of Custom Activity ids
        * @return      Returns List of Custom Activity object
    **************************************************************************************/ 
    public List<FNS_Activity__c> getActivitywithId(List<String> activityIds){
        String baseNamespace = FNS_Util.getBasePackageNamepace();
        fflib_QueryFactory activitiesQueryFactory = newQueryFactory(true, true, true);
        activitiesQueryFactory.assertIsAccessible();
        activitiesQueryFactory.setEnforceFLS(true);
        activitiesQueryFactory.selectField('Id');
        activitiesQueryFactory.selectField(baseNamespace+'FNS_ActivityExternalId__c');
        String activityQueryCondition; 
        if(activityIds != null){
             activityQueryCondition = baseNamespace +'FNS_ActivityExternalId__c IN :activityIds AND ' + baseNamespace +'FNS_ActivityExternalId__c != null'; 
             activitiesQueryFactory.setCondition(activityQueryCondition);
        }
        return (List<FNS_Activity__c>) Database.query(activitiesQueryFactory.toSOQL());
    }
    
}