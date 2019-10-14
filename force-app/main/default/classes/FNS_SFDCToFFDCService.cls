/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Domain Class
* @description This class is used to handle SFDCToFFDC custom setting related services 
****************************************************************************/
public with sharing class FNS_SFDCToFFDCService {
    
    public static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    /*************************************************************************************
    * @description  Method to update FNS_SFDCFFDCSetup__c custom setting values.
    * @param       Instance of FNS_SFDCFFDCSetup__c
    * @return      none
    *************************************************************************************/
    public static void updateSFDCToFFDCConfig(FNS_SFDCFFDCSetup__c sfdcObj){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_SFDCFFDCSetup__c.sObjectType
            }
        );
        uow.registerDirty(sfdcObj);
        uow.commitWork();
    }
    
    /*************************************************************************************
    * @description  Method to insert FNS_SFDCFFDCSetup__c custom setting values.
    * @param       Instance of FNS_SFDCFFDCSetup__c
    * @return      none
    *************************************************************************************/
    public static void insertSFDCToFFDCConfig(FNS_SFDCFFDCSetup__c sfdcObj){
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                FNS_SFDCFFDCSetup__c.sObjectType
            }
        );
        uow.registerNew(sfdcObj);
        uow.commitWork();
    }
}