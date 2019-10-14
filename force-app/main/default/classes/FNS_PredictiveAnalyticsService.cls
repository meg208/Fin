/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Predictive analytics
    * @description This class is for DML insert and delete records
  */
public with sharing class FNS_PredictiveAnalyticsService {    
    
    /*************************************************************************************
	 * @description  Method for insert Records 
	 * @Params       List<FNS_PredictiveAnalytics__c>
	 * @Returns      null
	 **************************************************************************************/
    public void insertRecords(List<FNS_PredictiveAnalytics__c> predAnalyticsList){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_PredictiveAnalytics__c.sObjectType
            }
        );
        uow.registerNew(predAnalyticsList);
        FNS_ObjectAccessContainer.checkPredictiveAnalyticsAccess(FNS_AccessController.DML_OPERATION_INSERT);
        uow.commitWork();
    } 

    /*************************************************************************************
	 * @description  Method for delete Records 
	 * @Params       List<SObject>
	 * @Returns      null
	 **************************************************************************************/
    public void deleteRecords(List<SObject> allRecords){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_PredictiveAnalytics__c.sObjectType
            }
        );
        uow.registerDeleted(allRecords);
        FNS_ObjectAccessContainer.checkPredictiveAnalyticsAccess(FNS_AccessController.DML_OPERATION_DELETE);
        uow.commitWork();
    }
}