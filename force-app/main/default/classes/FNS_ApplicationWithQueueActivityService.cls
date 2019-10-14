/************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Activities
 * @description Class for DML operations on FNS_ApplicationWithQueueActivity__c object 
 ****************************************************************************************/
public with sharing class FNS_ApplicationWithQueueActivityService {
    
    /***********************************************************************************
	 * @description Method to insert records
	 * @param List of Records 
	 * @return none
	 **************************************************************************************/
    public void insertRecords(List<FNS_ApplicationWithQueueActivity__c> queueActivityList){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_ApplicationWithQueueActivity__c.sObjectType
            }
        );
        uow.registerNew(queueActivityList);
        FNS_ObjectAccessContainer.checkApplicationWithQueueActivityAccess(FNS_AccessController.DML_OPERATION_INSERT);
   		uow.commitWork();
    }
    /***********************************************************************************
	 * @description Method to delete records
	 * @param List of Records 
	 * @return none
	 **************************************************************************************/
    public void deleteRecords(List<FNS_ApplicationWithQueueActivity__c> queueActivityList){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_ApplicationWithQueueActivity__c.sObjectType
            }
        );
        uow.registerDeleted(queueActivityList);
        FNS_ObjectAccessContainer.checkApplicationWithQueueActivityAccess(FNS_AccessController.DML_OPERATION_DELETE);
   		uow.commitWork();
    }  
    /***********************************************************************************
	 * @description Method to update records
	 * @param List of Records 
	 * @return none
	 **************************************************************************************/
    public void updateRecord(List<FNS_ApplicationWithQueueActivity__c> queueActivityList){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_ApplicationWithQueueActivity__c.sObjectType
            }
        );
        uow.registerDirty(queueActivityList);
        FNS_ObjectAccessContainer.checkApplicationWithQueueActivityAccess(FNS_AccessController.DML_OPERATION_UPDATE);
   		uow.commitWork();
    }  
}