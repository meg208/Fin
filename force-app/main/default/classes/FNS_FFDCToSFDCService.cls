/************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Access Handler
 * @description This class is used to handle Task related services.
 ****************************************************************************************/
public with sharing class FNS_FFDCToSFDCService {

	public static FNS_ErrorLog logger = new FNS_ErrorLog();

	/*************************************************************************************
	 * @description  Method to update FFDCSFDCSetup custom setting record.
	 * @Params       FFDCSFDCSetup object
	 * @Returns      none
	 *************************************************************************************/
	public static void updateFFDCToSFDCConfig(FNS_FFDCSFDCSetup__c sfdcObj){
		fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
				new List<Schema.SObjectType>{
					FNS_FFDCSFDCSetup__c.sObjectType
				}
		);
		uow.registerDirty(sfdcObj);
		uow.commitWork();
	}

	/*************************************************************************************
	 * @description  Method to insert FFDCSFDCSetup custom setting record.
	 * @Params       FFDCSFDCSetup object
	 * @Returns      none
	 *************************************************************************************/
	public static void insertFFDCToSFDCConfig(FNS_FFDCSFDCSetup__c sfdcObj){
		fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
				new List<Schema.SObjectType>{
					FNS_FFDCSFDCSetup__c.sObjectType
				}
		);
		uow.registerNew(sfdcObj);
		uow.commitWork();
	}
}