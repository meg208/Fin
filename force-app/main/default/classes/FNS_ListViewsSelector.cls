/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on ListView object
****************************************************************************************/
public with sharing class FNS_ListViewsSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_ListViewsSelector() {
        super(true, true, true);
    }
      
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/ 
    public FNS_ListViewsSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of ListView object 
        * @param 	   none
        * @return      List of Schema.SObjectField of ListView object
    **************************************************************************************/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            ListView.Id,
            ListView.Name,
            ListView.DeveloperName
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of ListView object 
        * @param 	   none
        * @return      Returns SObjecttype of ListView object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        
        String objectName = 'ListView';
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        
        return objectType;
    }
    
    /*************************************************************************************
        * @description Method to return ListView records based on object name and developer
        			   name
        * @param 	   Object name
        * @param 	   Set of String for Developer name
        * @return      Returns List of ListView object
    **************************************************************************************/
    public List<ListView> selectByName(String objectName, Set<String> developerName) {
        fflib_QueryFactory listViewQuery = newQueryFactory();
        List<String> queryConditions = new List<String>();
        
        queryConditions.add('SObjectType = :objectName');
        queryConditions.add('DeveloperName = :developerName');
        
        listViewQuery.setCondition(String.join(queryConditions, ' AND '));
        return (List<ListView>) Database.query( listViewQuery.toSOQL());
    }
}