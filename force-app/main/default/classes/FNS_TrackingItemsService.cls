/*****************************************************************************************
* @description This class is used to insert Tracking Items.
* @author Praneeth
* @date Mar 22 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_TrackingItemsService{
    public void insertRecords(List<Task> taskList){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                Task.sObjectType
                    }
        );
        uow.registerNew(taskList);
        FNS_ObjectAccessContainer.checkTaskAccess(FNS_AccessController.DML_OPERATION_INSERT);
        uow.commitWork();
        
    } 
    
    public void deleteRecords(List<Task> taskList){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                Task.sObjectType
                    }
        );
        uow.registerDeleted(taskList);
        FNS_ObjectAccessContainer.checkTaskAccess(FNS_AccessController.DML_OPERATION_DELETE);
        uow.commitWork();
    }  
    
    public void updateRecords(Task tskRec){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                Task.sObjectType
                    }
        );
        uow.registerDirty(tskRec);
        FNS_ObjectAccessContainer.checkTaskAccess(FNS_AccessController.DML_OPERATION_UPDATE);
        uow.commitWork();
    } 

    public void upsertRecords(List<Task> taskList){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                Task.sObjectType
                    }
        );
        uow.registerUpsert(taskList);
        FNS_ObjectAccessContainer.checkTaskAccess(FNS_AccessController.DML_OPERATION_UPDATE);
        uow.commitWork();
    }
    
     public void updateTaskRecords(List<Task> taskList){
       fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                Task.sObjectType
                    }
        );
        uow.registerDirty(taskList);
        FNS_ObjectAccessContainer.checkTrackingDocsAccess(FNS_AccessController.DML_OPERATION_UPDATE);
   		uow.commitWork();
        
    } 
}