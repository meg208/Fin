/**
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Community
* @description Helps in evaluating CRUD Access
*/
public without sharing class FNS_CommunityUtil {
    /*****************************************************************************************************************************
    * @description  Method to create community user when contact created via lead conversion. 
                    This method is created for FCCA-326.
                    Please note this methods needs to be executed in future to avoid the mixed DML exception.
    * @Params       Set of user Id.
    * @Returns      Null
    *****************************************************************************************************************************/
    //Please do not review below code as this will be changed...currently WIP...
    
    public without sharing class CommunityDomain{
        public void createCommunityUser(Set<Id> contactList){
        FNS_CommunityUtil obj = new FNS_CommunityUtil();
           Set<Id> userIdSet = obj.createCommunityUserFromContact(contactList);
           //obj.copyAdminAccessTokenToUser(userIdSet);
        }
    }
    
    Public Set<Id> createCommunityUserFromContact(Set<Id> contactList){
        system.debug('### createCommunityUserFromContact :: ' + contactList);
        FNS_CommunityConfig__c commConfigObj = FNS_CommunityConfig__c.getOrgDefaults();
        String profileName = (String)commConfigObj.FNS_CommunityProfile__c;
        String permissionSetName = (String)commConfigObj.FNS_PermisionSetName__c;
        String emailTemplateName = (String)commConfigObj.FNS_WelcomeEmailTemplateName__c; 
        Profile pf = [Select id,name from Profile where name =: profileName limit 1];
        List<PermissionSet> listPs = [SELECT Id From PermissionSet WHERE Name =: permissionSetName];
        system.debug('$$$ pf' + pf);
        List<Contact> conList = [select id,name,email,lastname,firstname,AccountId from contact where id in : contactList];
        List<User> userList = new List<User>();
        for(Contact con : conList){
            User u = new User(contactId=con.Id, 
                    username=con.FirstName+'@'+ con.LastName +'.com', firstname=con.FirstName,
                    lastname=con.LastName, 
                    email=con.email,
                    communityNickname = con.LastName + '_' + 'And'+ String.valueOf(system.now()),
                   
                    alias = (con.FirstName.length() > 6)? con.FirstName.substring(0, 6): con.FirstName, 
                    ProfileId = pf.id,
                    emailencodingkey='UTF-8',
                    languagelocalekey='en_US', 
                    localesidkey='en_US', 
                    timezonesidkey='America/Los_Angeles');
            
            userList.add(u);
        }
        insert userList;
        system.debug('### userList:: ' + userList);
        Set<Id> userIdSet = new Set<Id>();
        List<FNS_CommunityUserManagement__e> commUserMgtList = new List<FNS_CommunityUserManagement__e>();
        for(User user : userList){
            FNS_CommunityUserManagement__e commUserObj = new FNS_CommunityUserManagement__e();
            commUserObj.FNS_UserId__c = user.id;
            commUserObj.FNS_UserName__c = user.username;
            commUserObj.FNS_ProfileName__c = pf.name;
            userIdSet.add(user.id);
            commUserMgtList.add(commUserObj);
        }
        assignPermissionSetToUser(userIdSet,listPs[0].id);
        
        List<Database.SaveResult> results = EventBus.publish(commUserMgtList);
        // Inspect publishing result for each event
    for (Database.SaveResult sr : results) {
    if (sr.isSuccess()) {
        System.debug('Successfully published event.');
    } else {
        for(Database.Error err : sr.getErrors()) {
            System.debug('Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage());
        }
    }       
     }   return userIdSet;
        
    }

    /*****************************************************************************************************************************
    * @description  Method to copy Admin User's Access and Refersh token to the community user to Access APIs.  
                    This method is created for FCCA-326.
                    Please note this methods needs to be executed in future to avoid the mixed DML exception.
    * @Params       Set of user Id.
    * @Returns      Null
    *****************************************************************************************************************************/
    @future
    public static void copyAdminAccessTokenToUser(Set<ID> userIdSet){
        system.debug('%%% userIdSet :: ' + userIdSet);
        List<User> userlist = [select id,username from user where id in: userIdSet];
        system.debug('%%% userList :: ' + userlist);
        String customMetaDataLabel;
        String customMetaDataLbl;
        String refreshToken;
        String accessToken;
        Map<String, Object> dataMap;
        List<FNS_SFDCFFDCConnection__mdt> sfdcList = new FNS_SFDCFFDCConnectionSelector().selectRecordsOfAdmin();
        system.debug('## sfdcList  ' + sfdcList);
        if(sfdcList != null){
            for(FNS_SFDCFFDCConnection__mdt sfdcobj : sfdcList){
                if(sfdcobj.FNS_AccessToken__c != null){
                    refreshToken = sfdcobj.FNS_RefreshToken__c;
                }
                if(sfdcobj.FNS_AccessToken__c != null){
                    accessToken = sfdcobj.FNS_AccessToken__c;
                }
            }
        }
        system.debug('## userlist  ' + userlist);
        for(User user : userlist){
            customMetaDataLabel = user.username ;
            customMetaDataLbl = customMetaDataLabel.replace('@','_').replace('.','_').replace('-','_');
            System.debug('customMetaDataLbl - '+customMetaDataLbl);
            dataMap = new Map<String, Object>();
            dataMap.put('FNS_AccessToken__c',accessToken);
            dataMap.put('FNS_RefreshToken__c',refreshToken);
            dataMap.put('FNS_IsValidRefreshToken__c',true);
            FNS_UpdateMetadata.CreateUpdateCustomMetaData('FNS_SFDCFFDCConnection'+'.'+customMetaDataLbl,customMetaDataLbl,dataMap);
        }
    }
    
    @future
    public static void assignPermissionSetToUser(Set<ID> userIdSet, Id permissionSetID){
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
        for(ID userId : userIdSet){
            PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = permissionSetID, AssigneeId = userId);
            permissionSetList.add(psa);
        }
        insert permissionSetList;
    }

}