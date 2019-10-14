/*****************************************************************************************
* @description Class is used to handle all DML requests from FNS_DocumentUploadController.
* @author Praneeth Aitharaju
* @date 29/04/2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/

public class FNS_DocumentUploadService {
    public void deleteRecords(List<contentdocument> doclist){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                contentdocument.sObjectType
                    }
        );
        uow.registerDeleted(doclist);
        uow.commitWork();
    }  
    
    public void insertRecords(contentVersion doclist){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                contentVersion.sObjectType
                    }
        );
        uow.registerNew(doclist);
        uow.commitWork();
        
    } 
    
    public void insertRecordsforDocs(FNS_TrackingDocs__c uploadDocs){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_TrackingDocs__c.sObjectType
                    }
        );
        uow.registerNew(uploadDocs);
        FNS_ObjectAccessContainer.checkTrackingDocsAccess(FNS_AccessController.DML_OPERATION_INSERT);
        uow.commitWork();
        
    } 
    
    public void updateDocsRecords(FNS_TrackingDocs__c uploadDocs){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_TrackingDocs__c.sObjectType
                    }
        );
        uow.registerDirty(uploadDocs);
        FNS_ObjectAccessContainer.checkTrackingDocsAccess(FNS_AccessController.DML_OPERATION_UPDATE);
   		uow.commitWork();
        
    } 
    
    public void updateRecordsforDocs(List<FNS_TrackingDocs__c> uploadDocs){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_TrackingDocs__c.sObjectType
                    }
        );
        uow.registerDirty(uploadDocs);
        FNS_ObjectAccessContainer.checkTrackingDocsAccess(FNS_AccessController.DML_OPERATION_UPDATE);
   		uow.commitWork();
        
    } 
}