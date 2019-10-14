/*****************************************************************************************
* @description This class Provides a router support to get and post response
* @author Keerthi Kambhampati
* @date Mar 22 2019
* @Support Email keerthi@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_UserProfileService {    
    public void updateRecords(List<User> userList){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                User.sObjectType
            }
        );
        uow.registerDirty(userList);
        FNS_ObjectAccessContainer.checkUserAccess(FNS_AccessController.DML_OPERATION_UPDATE);
        uow.commitWork();
    } 
}