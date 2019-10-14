/*****************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Access Handler
 * @description Class is used to insert all errors in Error Log object.
 ******************************************************************************************/
public with sharing class FNS_ErrorLog {

	/*************************************************************************************
	 * @description  Method to insert error record based on apex class, method and error message.
	 * @Params       Name of apex class
	 * @Params       Name of Method
	 * @Params       Error message
	 * @Returns      none
	 *************************************************************************************/
	public void addLogRecord(String apexClass, String methodName, String errorMsg){
		// Set up the unit of work
		fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
				new List<Schema.SObjectType>{
					FNS_ErrorLog__c.sObjectType
				}
		);

		FNS_ErrorLog__c errorLogRecord = new FNS_ErrorLog__c (
				FNS_ApexClass__c = apexClass,
				FNS_Method__c = methodName,
				FNS_ErrorMessage__c = errorMsg
		);

		uow.registerNew(errorLogRecord);
		FNS_ObjectAccessContainer.checkErrorLogAccess(FNS_AccessController.DML_OPERATION_INSERT);
		uow.commitWork();
	}
	
	public void addErrorLogList(List<FNS_ErrorLog__c> errorLogList){
		fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
				new List<Schema.SObjectType>{
					FNS_ErrorLog__c.sObjectType
				}
		);
		uow.registerNew(errorLogList);
		FNS_ObjectAccessContainer.checkErrorLogAccess(FNS_AccessController.DML_OPERATION_INSERT);
		uow.commitWork();
	}
}