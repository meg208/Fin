/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on User object
****************************************************************************************/
public with sharing class FNS_UserSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_UserSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_UserSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of User object
        * @param 	   none
        * @return      List of Schema.SObjectField of User object
    **************************************************************************************/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> { 
			User.Id,
			User.FirstName,
			User.LastName,
			User.Name,
			User.Email,
			User.Phone,
			User.Title,
			User.EmployeeNumber,
			User.FNS_UserExternalId__c,
			User.FNS_IsOfficer__c,
            User.ContactId
		};
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of User object
        * @param 	   none
        * @return      Returns SObjecttype of User object 
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return User.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return User object records based on userId
        * @param 	   User Id
        * @return      Returns User object 
    **************************************************************************************/
    public User selectById(Id userId) {
        List<User> userList = new List<User>();
        User loggedInUser;
        fflib_QueryFactory query = newQueryFactory();
        
        if(userId != null){
            query.setCondition('Id = :userId');
        }
        userList =  (List<User>) Database.query( query.toSOQL());
        if(! userList.isEmpty()){
            loggedInUser = userList[0];
        }
        
        return loggedInUser;
    }

    /*************************************************************************************
        * @description Method to return User records based on user ids
        * @param 	   none
        * @return      Returns List of User object
    **************************************************************************************/
    public List<User> selectById(Set<Id> userIds) {
        return (List<User>) super.selectSObjectsById(userIds);
    }
    
    /*************************************************************************************
        * @description Method to Query User records based on emails list
        * @param 	   email List
        * @return      Returns List of User object
    **************************************************************************************/
    public List<User> selectUserList(List<String> emailList) {
        
        fflib_QueryFactory usersQueryFactory = newQueryFactory(true, true, true); 
        usersQueryFactory.assertIsAccessible(); 
        usersQueryFactory.setEnforceFLS(true); 
        String usersQueryCondition; 
        
        if(emailList != null){
            usersQueryCondition = 'Email IN :emailList';
            usersQueryFactory.setCondition(usersQueryCondition);
        }
        
        usersQueryFactory.setLimit(5); // to be updated based on json response 
        return (List<User>) Database.query(usersQueryFactory.toSOQL());  
    }

	/*************************************************************************************
        * @description Method to Query User records based on emails list
        * @param      email List
        * @return      Returns List of User object
    **************************************************************************************/
	public List<User> getUsersByExtId(Set<String> userExtIds) {
        
        fflib_QueryFactory usersQueryFactory = newQueryFactory(true, true, true); 
        usersQueryFactory.assertIsAccessible(); 
        usersQueryFactory.setEnforceFLS(true); 
        String usersQueryCondition; 
        
        if(userExtIds != null){
            usersQueryCondition = 'FNS_UserExternalId__c IN :userExtIds';
            usersQueryFactory.setCondition(usersQueryCondition);
        }
        
        return (List<User>) Database.query(usersQueryFactory.toSOQL());  
    } 
    
    
    /*************************************************************************************
        * @description Method to Query User records based on search list
        * @param      email List
        * @return      Returns List of User object
    **************************************************************************************/
	public List<User> getUsersBySearchtext(String searchKey) {
        
        fflib_QueryFactory usersQueryFactory = newQueryFactory(true, true, true); 
        usersQueryFactory.assertIsAccessible(); 
        usersQueryFactory.setEnforceFLS(true); 
        String usersQueryCondition; 
        
        if(searchKey != null){
            usersQueryCondition = 'Name LIKE :searchKey';
            usersQueryFactory.setCondition(usersQueryCondition);
        }
        
        return (List<User>) Database.query(usersQueryFactory.toSOQL());  
    }
	
	
}