/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Domain Class
* @description This class acts as domain class for Bank object 
****************************************************************************/
public with sharing class FNS_BankDomain {

    static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    /***********************************************************************
    * @description This method insert bank records
    * @param none
    * @return returns response of inserted record object 
    ************************************************************************/
    public static Object getConfigurations(){

        Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
            FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
            };

        try {
            fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { FNS_Bank__c.SObjectType });
            FNS_UpsertUnitOfWorkHelper upsertBanks = new FNS_UpsertUnitOfWorkHelper();
            uow.registerWork(upsertBanks);
                
            FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
            param.objectName = FNS_Constants.CLASS_BANKS;
            param.endPoint = FNS_Constants.URL_BANKS;
            param.methodName = FNS_Constants.METHOD_GET;
            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            HttpResponse jsonResponse = router.getPostRequest(param);
            if(jsonResponse.getStatusCode() == 200){
               if (!String.isEmpty(jsonResponse.getBody())){
               		FNS_ObjectContainer bankConfigList = (FNS_ObjectContainer)JSON.deserialize(jsonResponse.getBody(), FNS_ObjectContainer.class);
    				List<FNS_Bank__c> bankList = new List<FNS_Bank__c>();
                    for (FNS_ObjectContainer.FNS_Bank bankConfig : bankConfigList.banksList){
                        FNS_Bank__c bank = new FNS_Bank__c();
                        bank = FNS_BankDomain.assignJSONToBank(bankConfig);
                        upsertBanks.registerBankUpsert(bank);
                    }
                    
                    FNS_ObjectAccessContainer.checkBankAccess(FNS_AccessController.DML_OPERATION_UPSERT);
                    uow.commitWork();
                    
                }
                objValue.put(FNS_Constants.API_RESPONSE,jsonResponse.getBody());		
            }
        } catch (DMLException ex){
            logger.addLogRecord('FNS_BankDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        } catch (Exception ex){
            logger.addLogRecord('FNS_BankDomain', 'getConfigurations', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        }
        return objValue;
    }
  
    /***********************************************************************
    * @description This method assigns data to bank object record
    * @param instance of FNS_ObjectContainer.FNS_Bank
    * @return return instance of Bank object 
    ************************************************************************/
    public static FNS_Bank__c assignJSONToBank(FNS_ObjectContainer.FNS_Bank bankType){
        FNS_Bank__c bankObj = new FNS_Bank__c();

        try{
            bankObj.FNS_BankExternalId__c = bankType.bankId;
            bankObj.Name = bankType.bankName;
            bankObj.FNS_BankValue__c = bankType.value;
            bankObj.FNS_BankNumber__c = bankType.bankNumber;
            bankObj.FNS_GoverningState__c = bankType.governingState;
            bankObj.FNS_RegionNumber__c = bankType.regionNumber;
            bankObj.FNS_Branch__c = bankType.branch;
            bankObj.FNS_RCNumber__c = bankType.rcNumber;
        } catch (Exception ex){
            logger.addLogRecord('FNS_BankDomain', 'assignJSONToBank', ex.getMessage() + ex.getStackTraceString());
        }
        
        return bankObj;
    } 
}