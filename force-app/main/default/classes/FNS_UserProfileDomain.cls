/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Domain Class
* @description This class acts as domain class for User object 
****************************************************************************/
public with sharing class FNS_UserProfileDomain {
    
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    /***********************************************************************
    * @description This method update User records
    * @param none
    * @return returns json response  
    ************************************************************************/
    public static String getConfigurations(){
       
        Map<String, FNS_ObjectContainer.FNS_UserProfile> usrConfigDataMap = new Map<String, FNS_ObjectContainer.FNS_UserProfile>();
        Set<String> matchingEmailSet = new Set<String>();
        List<String> emailList = new List<String>();
        FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
        param.objectName = FNS_Constants.CLASS_USER_PROFILES;
        param.endPoint = FNS_Constants.URL_USER_PROFILES;
        param.methodName = FNS_Constants.METHOD_GET;
        FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
        HttpResponse jsonResponse = router.getPostRequest(param);
        if(jsonResponse.getStatusCode() == 200){
            if (!String.isEmpty(jsonResponse.getBody())){
                try{
                    //List<FNS_ObjectContainer.FNS_UserProfile> userConfigList = (List<FNS_ObjectContainer.FNS_UserProfile>)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_UserProfile>.class);
                    FNS_ObjectContainer userConfig = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);
                    
                    //put external ids and email from response into a map 
                    for(FNS_ObjectContainer.FNS_UserProfile Config: userConfig.userProfilesList){
                        emailList.add(Config.email); 
                        usrConfigDataMap.put(Config.email, Config); 
                    }
                   
                    //Query to get the users list matching the emails from the response 
                    FNS_UserSelector userProfileSelector = new FNS_UserSelector(); 
                    List<User> userList = userProfileSelector.selectUserList(emailList);
                    List<User> listToUpdate = new List<User>();
                    fflib_ISObjectUnitOfWork uow = getUnitOfWork();

                    //add to update the external id on user for users matching the email from response
                    for(User u: userList){
                        u.FNS_UserExternalId__c = usrConfigDataMap.get(u.email).userProfileId; 
                        u.FNS_IsOfficer__c = usrConfigDataMap.get(u.email).officerIndicator;  
                        listToUpdate.add(u);
                        uow.registerDirty(u);
                                
                        matchingEmailSet.add(u.email);
                    }
                    if(!listToUpdate.isEmpty()){
                        new FNS_UserProfileService().updateRecords(listToUpdate);
                    }
                    FNS_OfficersSelector officerSelector = new FNS_OfficersSelector(); 
                    List<FNS_Officer__c> officerList = officerSelector.getAllOfficers(); 
                    Map<String, FNS_Officer__c> officerMap = new Map<String, FNS_Officer__c>(); 
                    for(FNS_Officer__c officer: officerList){
                        officerMap.put(officer.FNS_OfficerId__c, officer); 
                    }
                    List<String> officerIdList = new List<String>(officerMap.keyset()); 
                    if(! matchingEmailSet.isEmpty()){
                        for(String email : matchingEmailSet){
                            FNS_ObjectContainer.FNS_UserProfile configData = usrConfigDataMap.get(email);
                            FNS_Officer__c officer = new FNS_Officer__c();
                            if(officerIdList != null){
                                if(officerIdList.contains(configData.userProfileId)){
                                    officer.Id = officerMap.get(configData.userProfileId).Id; 
                                }
                            }
                            officer.FNS_OfficerId__c = configData.userProfileId;
                            officer.FNS_PhoneNumber__c = configData.phone;
                            officer.FNS_Email__c = configData.email;
                            officer.FNS_FirstName__c = configData.firstName;
                            officer.FNS_LastName__c = configData.lastName;
                            uow.registerUpsert(officer);
                        }
                    }
                    FNS_ObjectAccessContainer.checkUserAccess(FNS_AccessController.DML_OPERATION_UPDATE);
                    uow.commitWork();
                }
                catch(Exception ex){
                    logger.addLogRecord('FNS_UserProfileDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString()); 
                }
            } 
            return jsonResponse.getBody(); 
        }
        return null;
    }
    
    public static fflib_ISObjectUnitOfWork getUnitOfWork(){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                User.sObjectType,
                FNS_Officer__c.sObjectType
            }
        );
        
        return uow;
    }
}