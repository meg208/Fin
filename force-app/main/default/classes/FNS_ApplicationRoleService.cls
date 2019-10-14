/*****************************************************************************************
* @description This class is used to insert Tracking Items.
* @author Praneeth
* @date Mar 22 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_ApplicationRoleService {

    public void upsertRecords(List<FNS_RelatedRoles__c > appRolesList){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_RelatedRoles__c.sObjectType
           	}
        );
        uow.registerUpsert(appRolesList);
        FNS_ObjectAccessContainer.checkApplicationRolesAccess(FNS_AccessController.DML_OPERATION_UPSERT);
        uow.commitWork();
    }
}