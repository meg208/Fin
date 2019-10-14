/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Setup
    * @description Update SFDC_FFDC__c,FFDC_SFDC__c Custom Setting Records
  */
public with sharing class FNS_SetupUpdate {
	/**
	* @description Update SFDC_FFDC__c Custom Setting
	* @param SFDC_FFDC__c record
	* @return null
	*/ 
    public Static void updateRecords(FNS_SFDCFFDCSetup__c sfdcObj){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_SFDCFFDCSetup__c.sObjectType
            }
        );
        uow.registerDirty(sfdcObj);
        uow.commitWork();
    }
	/**
	* @description Update FFDC_SFDC__c Custom Setting
	* @param FFDC_SFDC__c record
	* @return null
	*/ 
    public Static void updateFFDC_SFDC(FNS_FFDCSFDCSetup__c sfdcObj){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_FFDCSFDCSetup__c.sObjectType
            }
        );
        uow.registerDirty(sfdcObj);
        uow.commitWork();
    }
}