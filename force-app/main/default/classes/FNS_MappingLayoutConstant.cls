public with sharing class FNS_MappingLayoutConstant  {
    
    
    public static Map<String,String> mapRecTypeWithLayout ;
     
     public static Map<String,String> getmapping ()
     {
        mapRecTypeWithLayout  = new Map<String,String>();
     
         mapRecTypeWithLayout.put('Account.FNS_Customer' , 'Account-FNS Account Layout');
         mapRecTypeWithLayout.put('FNS_Activity__c.FNS_TrackingItem' , 'FNS_Activity__c-FNS Activity Layout');
         mapRecTypeWithLayout.put('FNS_Activity__c.FNS_TrackingItemReadOnly' , 'FNS_Activity__c-FNS Activity Read Only Layout');
         mapRecTypeWithLayout.put('FNS_Address__c.FNS_Address' , 'FNS_Address__c-FNS Address Layout');
         mapRecTypeWithLayout.put('FNS_Address__c.FNS_AddressReadOnly' , 'FNS_Address__c-FNS Address Read Only Layout');
         mapRecTypeWithLayout.put('FNS_ApplicationWithOfficer__c.FNS_ApplicationWithOfficer' , 'FNS_ApplicationWithOfficer__c-FNS Application with Officer Layout');
         mapRecTypeWithLayout.put('FNS_ApplicationWithOfficer__c.FNS_ApplicationWithOfficerReadOnly' , 'FNS_ApplicationWithOfficer__c-FNS Application With Officer Read Only Layout');
         mapRecTypeWithLayout.put('FNS_Bank__c.FNS_Bank' , 'FNS_Bank__c-FNS Bank Layout');
         mapRecTypeWithLayout.put('FNS_Bank__c.FNS_BankReadOnly' , 'FNS_Bank__c-FNS Bank Read Only Layout');
         mapRecTypeWithLayout.put('FNS_CustomerProfile__c.FNS_Customer' , 'FNS_CustomerProfile__c-FNS Customer Profile Layout');
         mapRecTypeWithLayout.put('FNS_CustomerProfile__c.FNS_Customer_Read_Only' , 'FNS_CustomerProfile__c-FNS Customer Profile Read Only Layout');
         //mapRecTypeWithLayout.put('FNS_ErrorLog__c.FNS_Bank' , 'FNS_ErrorLog__c-FNS Error Layout');    //FNS_ErrorLog__c object does not have record types.
         //mapRecTypeWithLayout.put('FNS_ErrorLog__c.FNS_Bank' , 'FNS_ErrorLog__c-FNS Error Read Only Layout');
         mapRecTypeWithLayout.put('FNS_FeeType__c.FNS_FeeType' , 'FNS_FeeType__c-FNS Fee Type Layout');
         mapRecTypeWithLayout.put('FNS_FeeType__c.FNS_FeeType' , 'FNS_FeeType__c-FNS Fee Type Read Only Layout');
         mapRecTypeWithLayout.put('FNS_Fee__c.FNS_Fee' , 'FNS_Fee__c-FNS Fee Layout');
         mapRecTypeWithLayout.put('FNS_Fee__c.FNS_FeeReadOnly' , 'FNS_Fee__c-FNS Fee Read Only Layout');    
         mapRecTypeWithLayout.put('FNS_FinancialAccountRole__c.FNS_FinancialAccountRole' , 'FNS_FinancialAccountRole__c-FNS Financial Account Role Layout');
         mapRecTypeWithLayout.put('FNS_FinancialAccountRole__c.FNS_FinancialAccountRoleReadOnly' , 'FNS_FinancialAccountRole__c-FNS Financial Account Role Read Only Layout');
         mapRecTypeWithLayout.put('FNS_FinancialAccountTransaction__c.FNS_FinancialAccountTransaction' , 'FNS_FinancialAccountTransaction__c-FNS Loan Layout');
         mapRecTypeWithLayout.put('FNS_FinancialAccountTransaction__c.FNS_FinancialAccountTransactionReadOnly' , 'FNS_FinancialAccountTransaction__c-FNS Loan Read Only Layout');      
         mapRecTypeWithLayout.put('FNS_FinancialAccount__c.FNS_FinancialAccount' , 'FNS_FinancialAccount__c-FNS Product Layout');
         mapRecTypeWithLayout.put('FNS_FinancialAccount__c.FNS_FinancialAccountReadOnly' , 'FNS_FinancialAccount__c-FNS Product Read Only Layout');    
         mapRecTypeWithLayout.put('FNS_Officer__c.FNS_Officer' , 'FNS_Officer__c-FNS Officer Layout');
         mapRecTypeWithLayout.put('FNS_Officer__c.FNS_Officer_Read_Only' , 'FNS_Officer__c-FNS Officer Read Only Layout');    
         mapRecTypeWithLayout.put('FNS_Pricing__c.FNS_Pricing' , 'FNS_Pricing__c-FNS Pricing Layout');
         mapRecTypeWithLayout.put('FNS_Pricing__c.FNS_PricingReadOnly' , 'FNS_Pricing__c-FNS Pricing Read Only Layout');    
         mapRecTypeWithLayout.put('FNS_ProcessCenter__c.FNS_ProcessCenter' , 'FNS_ProcessCenter__c-FNS ProcessCenter Layout');
         mapRecTypeWithLayout.put('FNS_ProcessCenter__c.FNS_ProcessCenter' , 'FNS_ProcessCenter__c-FNS ProcessCenter Read Only Layout'); 
         mapRecTypeWithLayout.put('FNS_ProcessGroup__c.FNS_ProcessGroup' , 'FNS_ProcessGroup__c-FNS Process Group Layout');
         mapRecTypeWithLayout.put('FNS_ProcessGroup__c.FNS_ProcessGroup' , 'FNS_ProcessGroup__c-FNS Process Group Read Only Layout');  
         mapRecTypeWithLayout.put('FNS_ProductType__c.FNS_ProductType' , 'FNS_ProductType__c-FNS Product Type Layout');
         mapRecTypeWithLayout.put('FNS_ProductType__c.FNS_ProductType' , 'FNS_ProductType__c-FNS Product Type Read Only Layout');  
         mapRecTypeWithLayout.put('FNS_RateIndex__c.FNS_RateIndex' , 'FNS_RateIndex__c-FNS Rate Index Layout');
         mapRecTypeWithLayout.put('FNS_RateIndex__c.FNS_RateIndex' , 'FNS_RateIndex__c-FNS Rate Index Read Only Layout');  
         mapRecTypeWithLayout.put('FNS_RelatedRoles__c.FNS_Related_Roles' , 'FNS_RelatedRoles__c-FNS Related Roles Layout');
         mapRecTypeWithLayout.put('FNS_RelatedRoles__c.FNS_Related_Roles_Read_Only' , 'FNS_RelatedRoles__c-FNS Related Roles Read Only Layout');         
         mapRecTypeWithLayout.put('FNS_TaxDetails__c.FNS_TaxDetails' , 'FNS_TaxDetails__c-FNS TaxDetails Layout');
         mapRecTypeWithLayout.put('FNS_TaxDetails__c.FNS_TaxDetails_Read_Only' , 'FNS_TaxDetails__c-FNS TaxDetails Read Only Layout');  
         mapRecTypeWithLayout.put('Lead.FNS_Lead' , 'Lead-FNS Lead Layout');
         mapRecTypeWithLayout.put('Opportunity.FNS_Application' , 'Opportunity-FNS ApplicationLayout');  
         mapRecTypeWithLayout.put('Opportunity.FNS_ApplicationReadOnly' , 'Opportunity-FNS ApplicationReadOnlyLayout');			         
        return mapRecTypeWithLayout  ;     
     }   
   }