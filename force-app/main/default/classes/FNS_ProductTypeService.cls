/*****************************************************************************************
* @description This class Provides a router support to get and post response
* @author Keerthi Kambhampati
* @date Mar 22 2019
* @Support Email keerthi@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_ProductTypeService {    
    public void insertRecords(List<FNS_ProductType__c> productTypeList){
        FNS_ErrorLog logger = new FNS_ErrorLog();

        try{
            fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
                new List<Schema.SObjectType>{
                    FNS_ProductType__c.sObjectType
                }
            );
            uow.registerNew(productTypeList);
            FNS_ObjectAccessContainer.checkProductTypeAccess(FNS_AccessController.DML_OPERATION_INSERT);
            uow.commitWork();
        } catch (DMLException ex){
            logger.addLogRecord('FNS_ProductTypeService', 'insertRecords', ex.getMessage() + ex.getStackTraceString()); 
            throw new FNS_CustomException(Label.FNS_CustomException);
        }
    } 
}