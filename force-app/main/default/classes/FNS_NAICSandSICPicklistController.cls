/**
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Account
* @description This class is for all DML operations for FNS_NAICSandSICPicklist component 
*/
public class FNS_NAICSandSICPicklistController {
    
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    /*************************************************************************************
* @description  Method to get picklist values for all fields 
* @Params       sObject, fieldName
* @Returns      List<String>
**************************************************************************************/
    @auraEnabled
    public static List<String> getselectOptions(sObject objObject, string fld) {
        List <String> allOpts = new list <String>();
        try{
            Schema.sObjectType objType = objObject.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            
            list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
            for (Schema.PicklistEntry a: values) {
                allOpts.add(a.getValue());
            }
        }
        catch(Exception ex){
            logger.addLogRecord('FNS_NAICSandSICPicklistController', 'getselectOptions', ex.getMessage() + ex.getStackTraceString());
            throw new FNS_CustomException(Label.FNS_CustomException); 
        }
        return allOpts;
    }
    
    /*************************************************************************************
* @description  Method to update Account with NAICS Code and SIC code
* @Params       naicsCode, sicCode, accountRecordId
* @Returns      null
**************************************************************************************/
    @AuraEnabled
    public static void saveNAICSandSICCode( String naicsCode, String sicCode, String subNaicsCode, String subSicCode, Id accountRecordId){
        Account acc = new Account();
        FNS_AccountSelector  accountSelector = new FNS_AccountSelector(); 
        try{
            acc = accountSelector.getAccountRecord(accountRecordId); 
            
            List<String> codeList = new List<String>(); 
            codeList = subNaicsCode.split(' '); 
            
            List<String> sicCodeList = new List<String>(); 
            sicCodeList = subSicCode.split(' '); 
            
            if(FNS_Util.isFSCInstalled){
                acc.put('NaicsDesc', subNaicsCode); 
                acc.put('NaicsCode', codeList[0]); 
            }
            else{
                acc.put('FNS_NaicsDescription__c', subNaicsCode); 
                acc.put('FNS_Naics__c', codeList[0]); 
            }
            
            acc.FNS_NAICSCode__c = naicsCode; 
            acc.Sic = sicCodeList[0]; 
            acc.SicDesc = subSicCode; 
            acc.FNS_SICCode__c = sicCode;
            
            new FNS_AccountService().updateRecords(acc); 
        }
        catch(Exception ex){
            logger.addLogRecord('FNS_NAICSandSICPicklistController', 'saveNAICSandSICCode', ex.getMessage() + ex.getStackTraceString());
            throw new FNS_CustomException(Label.FNS_CustomException); 
        }
    }
    
    /*************************************************************************************
* @description  Method to get NaicsCode, Sic Code from Account
* @Params       accountRecordId
* @Returns      Wrapper as String
**************************************************************************************/
    @AuraEnabled
    public static String getNaicsSicCodes(Id accountRecordId){
        Account acc = new Account(); 
        FNS_AccountSelector  accountSelector = new FNS_AccountSelector(); 
        try{
            acc = accountSelector.getAccountRecord(accountRecordId); 
            PicklistWrapper wrap = new PicklistWrapper(); 
            if(FNS_Util.isFSCInstalled){
                wrap.subNaicsCode =(String)acc.get('NaicsDesc'); 
            }
            else{
                wrap.subNaicsCode = (String)acc.get('FNS_NaicsDescription__c'); 
            }
            wrap.naicsCode = acc.FNS_NAICSCode__c;
            wrap.sicCode = acc.FNS_SICCode__c;
            wrap.subSicCode = acc.SicDesc; 
            return JSON.serialize(wrap, true); 
        }
        catch(Exception ex){
            logger.addLogRecord('FNS_NAICSandSICPicklistController', 'getNaicsSicCodes', ex.getMessage() + ex.getStackTraceString());
            throw new FNS_CustomException(Label.FNS_CustomException); 
        }
    }
    
    /*************************************************************************************
* @description  Wrapper for getNaicsSicCodes method
* @Params       null
* @Returns      null
**************************************************************************************/
    public with sharing class PicklistWrapper{
        String naicsCode; 
        String subNaicsCode; 
        String sicCode; 
        String subSicCode; 
    }
}