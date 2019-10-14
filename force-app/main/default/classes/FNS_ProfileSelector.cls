/****************************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Object Selector
* @description This class is used to Query on Profile
****************************************************************************************/
public with sharing class FNS_ProfileSelector extends fflib_SObjectSelector{
    
    /*************************************************************************************
* @description Constructor to set boolean values to TRUE of Super class.We are 
setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
constructor to TRUE
* @param 	   none
* @return      none
**************************************************************************************/
    public FNS_ProfileSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
* @description Constructor to set boolean values to TRUE of Super class.We are 
setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
constructor to TRUE
* @param 	   Boolean variable for enforcing FLS
* @return      none
**************************************************************************************/ 
    public FNS_ProfileSelector(Boolean enforceFLS){
        super(true, true, false);
    }
    
    /*************************************************************************************
* @description Method to return Schema.SObjectField list of Profile object 
* @param 	   none
* @return      List of Schema.SObjectField of Profile object
**************************************************************************************/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> { 
            Profile.Id,
                Profile.Name
                };
                    }
    
    /*************************************************************************************
* @description Method to return SObject type of Profile object
* @param 	   none
* @return      Returns SObjecttype of Profile object
**************************************************************************************/
    public Schema.SObjectType getSObjectType(){
        return Profile.sObjectType;
    }
    /*************************************************************************************
* @description Method to return Profile record based on profile name
* @param 	   profile name
* @return      Returns Profile Object  
**************************************************************************************/
    public Profile selectByName(String profileName) {
        Profile loggedInProfile = new Profile(); 
        fflib_QueryFactory profileQuery = newQueryFactory();
        
        if(profileName != null){
            profileQuery.setCondition('Name = :profileName');
        }
        profileQuery.setLimit(1); 
        
        return (Profile) Database.query(profileQuery.toSOQL());
    }
    
}