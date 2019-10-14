/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Component Controller
* @description Helps in updating records in SFDC from FFDC using Config API calls
****************************************************************************/
public with sharing class FNS_RefreshDataFromCMEController {
    /***********************************************************************
    * @description This methods updates FNS_Activity__c object records from FFDC 
    * @param none
    * @return String
    ************************************************************************/
    @AuraEnabled
    public static Object refreshActivities() {
        return FNS_WorkflowConfigurationsDomain.getConfigurations();
    }
    
    /***********************************************************************
    * @description This methods updates FNS_Bank__c object records from FFDC 
    * @param none
    * @return String
    ************************************************************************/
    @AuraEnabled
    public static Object refreshBankDomains() {
        return FNS_BankDomain.getConfigurations();
    }
    
    /***********************************************************************
    * @description This methods updates FNS_FeeType__c object records from FFDC 
    * @param none
    * @return String
    ************************************************************************/
    @AuraEnabled
    public static Object refreshFeeTypes() {
        //return FNS_FeeTypeDomain.getConfigurations();
        return FNS_FeeType.getConfigurations();
    }
    
    /***********************************************************************
    * @description This methods updates FNS_ProcessCenter__c object records from FFDC 
    * @param none
    * @return String
    ************************************************************************/
    @AuraEnabled
    public static Object refreshProcessCenterDomain() {
        return FNS_ProcessCenterDomain.getConfigurations();
    }
    
    /***********************************************************************
    * @description This methods updates FNS_ProcessGroup__c object records from FFDC 
    * @param none
    * @return String
    ************************************************************************/
    @AuraEnabled
    public static Object refreshProcessGroup() {
        return FNS_ProcessGroupDomain.getConfigurations();
    }
    
    /***********************************************************************
    * @description This methods updates FNS_ProductType__c object records from FFDC 
    * @param none
    * @return String
    ************************************************************************/
    @AuraEnabled
    public static Object refreshProductType() {
        // return FNS_ProductTypeDomain.getConfigurations();
           return FNS_ProductType.getConfigurations();
    }

    /***********************************************************************
    * @description This methods updates FNS_ConfigurationType__c object records from FFDC 
    * @param none
    * @return String
    ************************************************************************/
    @AuraEnabled
    public static Object refreshConfigurationType() {
        return FNS_ConfigurationDomain.getConfigurations();
    } 
    /***********************************************************************
    * @description This methods updates picklist values to Record Types 
    * @param none
    * @return none
    ************************************************************************/
     @AuraEnabled
    public static void scheduleRecordTypeUpdate(){
         //new FNS_ConfigurationDomain().updateCountryPurpose();
           List<String> configList = New List<String>{'Structure','ConfigCurrency','TrackingItemStatus','State','Disposition','Role','FeeType','ProductType','DocumentPriority','PricingType','Frequency','Purpose','PaymentType','ContactType','Province','Country'};
           for(String str : configList  )
           {
             List <String> config = new List<String>();
             config.add(str);
             FNS_RecordTypeUpdate.UpdateRecordType(config);
        
          } 
    }
}