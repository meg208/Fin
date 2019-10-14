/************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Account
 * @description This class handles DML operations for Account 
 ****************************************************************************************/
public with sharing class FNS_AccountService {    
    
    /***********************************************************************************
	 * @description Method to update records
	 * @param List of Records 
	 * @return none
	 **************************************************************************************/
    public void updateRecords(Account accountRecord){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                Account.sObjectType
            }
        );
        uow.registerDirty(accountRecord);
        FNS_ObjectAccessContainer.checkAccountAccess(FNS_AccessController.DML_OPERATION_UPDATE);
        uow.commitWork();
    } 
}