/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description This class is used to update the picklist value in the Record Types.
****************************************************************************************/
public class FNS_RecordTypeUpdate{
    @future(callout=true)
    public static void UpdateRecordType(List<String> configList) {
        //FNS_ConfigurationDomain configDomain =new FNS_ConfigurationDomain();
          Map<String,List<RecordTypeWrapper>> globalValRecordTypeMap =getMapOfObjAndRecordType();
       // List<String> configList = New List<String>{'Structure','ConfigCurrency','TrackingItemStatus','State','Disposition','Role','FeeType','ProductType','DocumentPriority','PricingType','Frequency','Purpose','PaymentType','ContactType','Province','Country'};
          for(String configType : configList){
                if(globalValRecordTypeMap !=null && globalValRecordTypeMap.containsKey(configType)){
                    List<RecordTypeWrapper> recordTypeWrapList= globalValRecordTypeMap.get(configType);
                    system.debug('recordTypeWrapList>>'+recordTypeWrapList);
                    for(RecordTypeWrapper recordType : recordTypeWrapList){
                        for(String recordTypeDevName : recordType.recordTypeDeveloperName){
                        FNS_UpdateMetadata.UpdateRecordType(recordType.objectName, recordType.fieldName, recordTypeDevName);
                        }
                    }
        		}
          }
    }
    public class RecordTypeWrapper{
        String objectName;
        String fieldName;
		List<String> recordTypeDeveloperName;
    }
    /*************************************************************************************
    * @description  Method to get List of Object and Record Type map 
    * @Params       none
    * @Returns      List of Object and Record Type map 
    * @author       Brillio
    **************************************************************************************/ 
    public static Map<String,List<RecordTypeWrapper>> getMapOfObjAndRecordType(){
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        String finAccountObjName;
        String finFinancialAccountTransactionObjName;
        string finFinancialAccountRoleObjName;
        if(FNS_Util.isFSCInstalled){
            finAccountObjName = 'FinServ__FinancialAccount__c' ;
            finFinancialAccountTransactionObjName ='FinServ__FinancialAccountTransaction__c' ;
            finFinancialAccountRoleObjName = 'FinServ__FinancialAccountRole__c'; 
        }
        else{
            finAccountObjName = baseNamespace+'FNS_FinancialAccount__c' ;
            finFinancialAccountTransactionObjName = baseNamespace+'FNS_FinancialAccountTransaction__c' ;
            finFinancialAccountRoleObjName = baseNamespace+'FNS_FinancialAccountRole__c'; 
        }
        Map<String,List<RecordTypeWrapper>> constructGlobalValRecordTypeMap = new Map<String,List<RecordTypeWrapper>>();
        
        //Fee Type
        RecordTypeWrapper feeRecordType= new RecordTypeWrapper();
        feeRecordType.objectName =baseNamespace+'FNS_Fee__c';
        feeRecordType.fieldName=baseNamespace+'FNS_FeeType__c';
        feeRecordType.recordTypeDeveloperName=new List<String>{baseNamespace+'FNS_Fee',baseNamespace+'FNS_FeeReadOnly'};
        constructGlobalValRecordTypeMap.put('FeeType',new List<RecordTypeWrapper>{feeRecordType});
       
        //Contact Type
        RecordTypeWrapper contactRecordType= new RecordTypeWrapper();
        contactRecordType.objectName ='Contact';
        contactRecordType.fieldName='FNS_ContactType__c';
        contactRecordType.recordTypeDeveloperName=new List<String>{'FNS_Contact'};
        constructGlobalValRecordTypeMap.put('ContactType',new List<RecordTypeWrapper>{contactRecordType});
        
        //Pricing Type
        RecordTypeWrapper pricingTypRecordType= new RecordTypeWrapper();
        pricingTypRecordType.objectName ='FNS_Pricing__c';
        pricingTypRecordType.fieldName='FNS_PricingType__c';
        pricingTypRecordType.recordTypeDeveloperName=new List<String>{'FNS_Pricing','FNS_PricingReadOnly'};
            
        RecordTypeWrapper finAccpricingTypRecordType= new RecordTypeWrapper();
        finAccpricingTypRecordType.objectName =finFinancialAccountTransactionObjName;
        finAccpricingTypRecordType.fieldName='FNS_PricingType__c';
        finAccpricingTypRecordType.recordTypeDeveloperName=new List<String>{'FNS_FinancialAccountTransaction','FNS_FinancialAccountTransactionReadOnly'};
        constructGlobalValRecordTypeMap.put('PricingType',new List<RecordTypeWrapper>{pricingTypRecordType,finAccpricingTypRecordType});
        
        //Pricing Feequency
        RecordTypeWrapper pricingFreRecordType= new RecordTypeWrapper();
        pricingFreRecordType.objectName ='FNS_Pricing__c';
        pricingFreRecordType.fieldName='FNS_Frequencies__c';
        pricingFreRecordType.recordTypeDeveloperName=new List<String>{'FNS_Pricing','FNS_PricingReadOnly'};
            
        RecordTypeWrapper finAccpricingFreRecordType= new RecordTypeWrapper();
        finAccpricingFreRecordType.objectName =finFinancialAccountTransactionObjName;
        finAccpricingFreRecordType.fieldName='FNS_PricingFrequency__c';
        finAccpricingFreRecordType.recordTypeDeveloperName=new List<String>{'FNS_FinancialAccountTransaction','FNS_FinancialAccountTransactionReadOnly'};
        constructGlobalValRecordTypeMap.put('Frequency',new List<RecordTypeWrapper>{pricingFreRecordType,finAccpricingFreRecordType});
        
        
        
        //Product Type Fin Account
        RecordTypeWrapper productTypeRecordType= new RecordTypeWrapper();
        productTypeRecordType.objectName = finAccountObjName;
        productTypeRecordType.fieldName='FNS_ProductType__c';
        productTypeRecordType.recordTypeDeveloperName=new List<String>{'FNS_FinancialAccount','FNS_FinancialAccountReadOnly'};
        
        //Product Type Fin Account Transaction
        RecordTypeWrapper finAccTranProductTypeRecordType= new RecordTypeWrapper();
        finAccTranProductTypeRecordType.objectName = finFinancialAccountTransactionObjName;
        finAccTranProductTypeRecordType.fieldName='FNS_LoanProductType__c';
        finAccTranProductTypeRecordType.recordTypeDeveloperName=new List<String>{'FNS_FinancialAccountTransaction','FNS_FinancialAccountTransactionReadOnly'};
        constructGlobalValRecordTypeMap.put('ProductType',new List<RecordTypeWrapper>{productTypeRecordType,finAccTranProductTypeRecordType});
       
        //Purpose Fin Account
        RecordTypeWrapper PurposeRecordType= new RecordTypeWrapper();
        PurposeRecordType.objectName = finAccountObjName;
        PurposeRecordType.fieldName='FNS_Purpose__c';
        PurposeRecordType.recordTypeDeveloperName=new List<String>{'FNS_FinancialAccount','FNS_FinancialAccountReadOnly'};
        
        //Purpose Fin Account Transaction
        RecordTypeWrapper finAccTranPurposeRecordType= new RecordTypeWrapper();
        finAccTranPurposeRecordType.objectName = finFinancialAccountTransactionObjName;
        finAccTranPurposeRecordType.fieldName='FNS_LoanPurpose__c';
        finAccTranPurposeRecordType.recordTypeDeveloperName=new List<String>{'FNS_FinancialAccountTransaction','FNS_FinancialAccountTransactionReadOnly'};
        constructGlobalValRecordTypeMap.put('Purpose',new List<RecordTypeWrapper>{PurposeRecordType,finAccTranPurposeRecordType});
        
        //Purpose Fin Account Transaction
        RecordTypeWrapper productRelationshipRoleRecordType= new RecordTypeWrapper();
        productRelationshipRoleRecordType.objectName = finFinancialAccountRoleObjName;
        productRelationshipRoleRecordType.fieldName='FNS_ProductRelRole__c';
        productRelationshipRoleRecordType.recordTypeDeveloperName=new List<String>{'FNS_FinancialAccountRole','FNS_FinancialAccountRoleReadOnly'};
            
        RecordTypeWrapper typeofProductRoleRecordType= new RecordTypeWrapper();
        typeofProductRoleRecordType.objectName = finFinancialAccountRoleObjName;
        typeofProductRoleRecordType.fieldName='FNS_TypeofProdRole__c';
        typeofProductRoleRecordType.recordTypeDeveloperName=new List<String>{'FNS_FinancialAccountRole','FNS_FinancialAccountRoleReadOnly'};
            
        RecordTypeWrapper applicationwithOfficerRecordType= new RecordTypeWrapper();
        applicationwithOfficerRecordType.objectName = 'FNS_ApplicationWithOfficer__c';
        applicationwithOfficerRecordType.fieldName='FNS_OfficerRole__c';
        applicationwithOfficerRecordType.recordTypeDeveloperName=new List<String>{'FNS_ApplicationWithOfficer','FNS_ApplicationWithOfficerReadOnly'};
        constructGlobalValRecordTypeMap.put('Role',new List<RecordTypeWrapper>{productRelationshipRoleRecordType,typeofProductRoleRecordType,applicationwithOfficerRecordType});
        
        RecordTypeWrapper finAccSupporCurrencyRecordType= new RecordTypeWrapper();
        finAccSupporCurrencyRecordType.objectName = finAccountObjName;
        finAccSupporCurrencyRecordType.fieldName='FNS_SuppCurrencies__c';
        finAccSupporCurrencyRecordType.recordTypeDeveloperName=new List<String>{'FNS_FinancialAccount','FNS_FinancialAccountReadOnly'};
        constructGlobalValRecordTypeMap.put('ConfigCurrency',new List<RecordTypeWrapper>{finAccSupporCurrencyRecordType});
        
        RecordTypeWrapper addressStateRecordType= new RecordTypeWrapper();
        addressStateRecordType.objectName = 'FNS_Address__c';
        addressStateRecordType.fieldName='FNS_State__c';
        addressStateRecordType.recordTypeDeveloperName=new List<String>{'FNS_Address','FNS_AddressReadOnly'};
        constructGlobalValRecordTypeMap.put('State',new List<RecordTypeWrapper>{addressStateRecordType});
        
        RecordTypeWrapper taskStatusRecordType= new RecordTypeWrapper();
        taskStatusRecordType.objectName = 'Task';
        taskStatusRecordType.fieldName='FNS_Status__c';
        taskStatusRecordType.recordTypeDeveloperName=new List<String>{'FNS_Task'};
		
        constructGlobalValRecordTypeMap.put('TrackingItemStatus',new List<RecordTypeWrapper>{taskStatusRecordType});
        
        RecordTypeWrapper accStructureRecordType= new RecordTypeWrapper();
        accStructureRecordType.objectName = 'Account';
        accStructureRecordType.fieldName='FNS_CustomerStruct__c';
        accStructureRecordType.recordTypeDeveloperName=new List<String>{'FNS_Customer'};
        constructGlobalValRecordTypeMap.put('Structure',new List<RecordTypeWrapper>{accStructureRecordType});
        
        RecordTypeWrapper taskPriorityRecordType= new RecordTypeWrapper();
        taskPriorityRecordType.objectName = 'Task';
        taskPriorityRecordType.fieldName='FNS_Priority__c';
        taskPriorityRecordType.recordTypeDeveloperName=new List<String>{'FNS_Task'};
        constructGlobalValRecordTypeMap.put('DocumentPriority',new List<RecordTypeWrapper>{taskPriorityRecordType});
		
        RecordTypeWrapper addressProvinceRecordType= new RecordTypeWrapper();
        addressProvinceRecordType.objectName = 'FNS_Address__c';
        addressProvinceRecordType.fieldName='FNS_ProvinceCode__c';
        addressProvinceRecordType.recordTypeDeveloperName=new List<String>{'FNS_Address','FNS_AddressReadOnly'};
        constructGlobalValRecordTypeMap.put('Province',new List<RecordTypeWrapper>{addressProvinceRecordType});
		
        RecordTypeWrapper addressCountryRecordType= new RecordTypeWrapper();
        addressCountryRecordType.objectName = 'FNS_Address__c';
        addressCountryRecordType.fieldName='FNS_CountryCode__c';
        addressCountryRecordType.recordTypeDeveloperName=new List<String>{'FNS_Address','FNS_AddressReadOnly'};
        constructGlobalValRecordTypeMap.put('Country',new List<RecordTypeWrapper>{addressCountryRecordType});		
		
        return constructGlobalValRecordTypeMap;
    }
}