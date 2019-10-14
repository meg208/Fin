public with sharing class FNS_UpsertUnitOfWorkHelper implements fflib_SObjectUnitOfWork.IDoWork
{   
    string baseNamespace= FNS_Util.getBasePackageNamepace();
    string extNamespace= FNS_Util.getExtensionPackageNamespace(); 
    string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
    
    public Database.UpsertResult[] accUpsertResult {get; private set;}
    public Database.UpsertResult[] oppUpsertResult {get; private set;}
    
    public Database.UpsertResult[] taxUpsertResult {get; private set;}
    public Database.UpsertResult[] customerProfileUpsertResult {get; private set;}
    public Database.UpsertResult[] contactUpsertResult {get; private set;}
    
    public Database.UpsertResult[] finAccUpsertResult {get; private set;}
    public Database.UpsertResult[] pricngUpsertResult {get; private set;}
    public Database.UpsertResult[] feeUpsertResult {get; private set;}
    public Database.UpsertResult[] finLoanUpsertResult {get; private set;}
    public Database.UpsertResult[] finAccRoleUpsertResult {get; private set;}
    //Keerthi - START - Config Data
    public Database.UpsertResult[] bankUpsertResult {get; private set;}
    public Database.UpsertResult[] feeTypeUpsertResult {get; private set;}
    public Database.UpsertResult[] processCenterUpsertResult {get; private set;}
    public Database.UpsertResult[] processGroupUpsertResult {get; private set;}
    public Database.UpsertResult[] productTypeUpsertResult {get; private set;}
    public Database.UpsertResult[] activityUpsertResult {get; private set;}
    public Database.UpsertResult[] configDataUpsertResult {get; private set;}
    //Keerthi - END - Config Data
    public Database.UpsertResult[] documentUpsertResult {get; private set;}
    
    String finAccountObjName = 'FinServ__FinancialAccount__c' ;
    String finFinancialAccountTransactionObjName = 'FinServ__FinancialAccountTransaction__c' ;
    String finFinancialAccountRoleObjName = 'FinServ__FinancialAccountRole__c' ;
    
    Schema.SObjectType finAccountObject ;
    Schema.SObjectType finFinancialAccountTransactionObject ;
    Schema.SObjectType finFinancialAccountRoleObject ;
    
    private List<Account> accList;
    private List<Opportunity> oppList ;
    private List<FNS_TaxDetails__c> taxList;
    private List<FNS_CustomerProfile__c> customerProfileList;
    private List<Contact> contactList;
    
    private List<FNS_Pricing__c> pricingList;
    private List<FNS_Fee__c> feeList;
    private List<Sobject> finAccList ;
    private List<Sobject> finLoanList ;
    private List<Sobject> finAccRoleList ;
    
    // praneeth - TrackingDocs
     private List<FNS_TrackingDocs__c> documentsList;
     
    //Keerthi - START - Config Data
    private List<FNS_Bank__c> banksList;
    private List<FNS_FeeType__c> feeTypeList;
    private List<FNS_ProcessCenter__c> processCenterList;
    private List<FNS_ProcessGroup__c> processGroupList;
    private List<FNS_ProductType__c> productTypeList;
    private List<FNS_Activity__c> activityList;
    private List<FNS_ConfigurationType__c> configDataList;
    //Keerthi - END - Config Data
    
    
    public FNS_UpsertUnitOfWorkHelper()
    {  
        accList = new List<Account>();
        oppList = new List<Opportunity>();
        taxList = new List<FNS_TaxDetails__c>();
        customerProfileList = new List<FNS_CustomerProfile__c>();
        contactList = new List<Contact>();
        pricingList = new List<FNS_Pricing__c>();
        feeList = new List<FNS_Fee__c>();
        
        // praneeth - Tracking Docs
        documentsList = new List<FNS_TrackingDocs__c>();
        
        //Keerthi - START - Config Data
        banksList = new List<FNS_Bank__c>();
        feeTypeList = new List<FNS_FeeType__c>();
        processCenterList = new List<FNS_ProcessCenter__c>();
        processGroupList = new List<FNS_ProcessGroup__c>();
        productTypeList = new List<FNS_ProductType__c>();
        activityList = new List<FNS_Activity__c>();   
        configDataList = new List<FNS_ConfigurationType__c>();     
        //Keerthi - END - Config Data
        
        finAccList = new List<Sobject>();
        finLoanList = new List<Sobject>();
        finAccRoleList = new List<Sobject>();
        
        finAccountObject = Schema.getGlobalDescribe().get(finAccountObjName);
        finFinancialAccountTransactionObject = Schema.getGlobalDescribe().get(finFinancialAccountTransactionObjName);
        finFinancialAccountRoleObject = Schema.getGlobalDescribe().get(finFinancialAccountRoleObjName);
    }
    
    public void registerAccountUpsert(Account record)
    {
        accList.add(record);
    }
    public void registerOpportunityUpsert(Opportunity record)
    {
        oppList.add(record);
    }
    public void registerTaxUpsert(FNS_TaxDetails__c record)
    {
        taxList.add(record);
    }
    public void registerCustomerProfileUpsert(FNS_CustomerProfile__c record)
    {
        customerProfileList.add(record);
    }
     public void registerContactUpsert(Contact record)
    {
        contactList.add(record);
    }
    public void registerPricingUpsert(FNS_Pricing__c record)
    {
        pricingList.add(record);
    }
    public void registerFeeUpsert(FNS_Fee__c record)
    {
        feeList.add(record);
    }
    
    //praneeth - Tracking Docs
     public void registerDocumentUpsert(FNS_TrackingDocs__c record)
    {        
        documentsList.add(record);
    }
    //Keerthi - START - Config Data    
    public void registerBankUpsert(FNS_Bank__c record)
    {        
        banksList.add(record);
    }
    public void registerFeeTypeUpsert(FNS_FeeType__c record)
    {
        feeTypeList.add(record);
    }
    public void registerProcessCenterUpsert(FNS_ProcessCenter__c record)
    {
        processCenterList.add(record);
    }
    public void registerProcessGroupUpsert(FNS_ProcessGroup__c record)
    {
        processGroupList.add(record);
    }
    public void registerProductTypeUpsert(FNS_ProductType__c record)
    {
        productTypeList.add(record);
    }
    public void registerActivityUpsert(FNS_Activity__c record)
    {
        activityList.add(record);
    }
    public void registerConfigDataUpsert(FNS_ConfigurationType__c record)
    {
        configDataList.add(record);
    }
    //Keerthi - END - Config Data
    public void registerFinAccUpsert(Sobject record)
    {
        finAccList.add(record);
    }
    public void registerFinLoanUpsert(Sobject record)
    {
        finLoanList.add(record);
    }
    public void registerFinAccRoleUpsert(Sobject record)
    {
        finAccRoleList.add(record);
    }
    
    public void doWork()
    {
        if(!accList.isEmpty()){
            accUpsertResult = Database.upsert(accList,Account.FNS_CustomerExtId__c, false); 
            logExceptions(accUpsertResult);
        }
        if(! oppList.isEmpty()) {
            oppUpsertResult = Database.upsert(oppList,Opportunity.FNS_ApplicationExtId__c, false);
            logExceptions(oppUpsertResult);
 
        }
       if(! taxList.isEmpty()) {
            taxUpsertResult = Database.upsert(taxList,FNS_TaxDetails__c.FNS_TaxDetailsExtId__c, false); 
        }
        if(! customerProfileList.isEmpty()) {
            customerProfileUpsertResult = Database.upsert(customerProfileList,FNS_CustomerProfile__c.FNS_CustomerProfileExternalId__c, false); 
        }
        if(! contactList.isEmpty()) {
            contactUpsertResult = Database.upsert(contactList,Contact.FNS_ContactExternalId__c, false);
            logExceptions(contactUpsertResult);
        }
        if(! pricingList.isEmpty()) {
            // pricngUpsertResult = Database.upsert(pricingList,FNS_Pricing__c.FNS_ApplicationExtId__c, false); 
        }
        if(! feeList.isEmpty()) {
            // feeUpsertResult = Database.upsert(feeList,FNS_Fee__c.FNS_ApplicationExtId__c, false); 
        }
        
        // praneeth document
         if(! documentsList.isEmpty()) {
            documentUpsertResult = Database.upsert(documentsList, FNS_TrackingDocs__c.FNS_DocumentExtId__c, false); 
        }
        //Keerthi - START - Config Data        
        if(! banksList.isEmpty()) {
            bankUpsertResult = Database.upsert(banksList, FNS_Bank__c.FNS_BankExternalId__c, false); 
        }
        if(! feeTypeList.isEmpty()) {
            feeTypeUpsertResult = Database.upsert(feeTypeList, FNS_FeeType__c.FNS_FeeTypeExternalId__c, false); 
        }
        if(! processCenterList.isEmpty()) {
            processCenterUpsertResult = Database.upsert(processCenterList, FNS_ProcessCenter__c.FNS_ProcessCenterExtId__c, false); 
        }
        if(! processGroupList.isEmpty()) {
            processGroupUpsertResult = Database.upsert(processGroupList, FNS_ProcessGroup__c.FNS_ProcessGroupExtId__c, false);
        }
        if(! productTypeList.isEmpty()) {
            productTypeUpsertResult = Database.upsert(productTypeList, FNS_ProductType__c.FNS_ProductTypeExternalId__c, false);
        }
        if(! activityList.isEmpty()) {
            activityUpsertResult = Database.upsert(activityList, FNS_Activity__c.FNS_ActivityExternalId__c, false); 
        }
        if(! configDataList.isEmpty()){
            configDataUpsertResult = Database.upsert(configDataList, FNS_ConfigurationType__c.FNS_ConfigurationExternalId__c, false);
        }
        //Keerthi - END - Config Data
        
        if(!finAccList.isEmpty()){
            String listType = 'List<' + finAccountObjName + '>';
            List<SObject> sObjRecordsFinAccList = (List<SObject>)Type.forName(listType).newInstance();
            sObjRecordsFinAccList.addAll(finAccList);
            finAccUpsertResult = Database.upsert(sObjRecordsFinAccList,finAccountObject.getDescribe().fields.getMap().get(namespace+'FNS_FinancialProductExtId__c'));              
        } 
        if(!finLoanList.isEmpty()){
            String listTypeLoan = 'List<' + finFinancialAccountTransactionObject + '>';
            List<SObject> sObjRecordsFinLoanList = (List<SObject>)Type.forName(listTypeLoan).newInstance();
            sObjRecordsFinLoanList.addAll(finLoanList);
            finLoanUpsertResult = Database.upsert(sObjRecordsFinLoanList,finFinancialAccountTransactionObject.getDescribe().fields.getMap().get(namespace+'FNS_FinancialAccountTransaction__c'));              
        }
        if(!finAccRoleList.isEmpty()){
            String listTypeAccRole = 'List<' + finFinancialAccountRoleObject + '>';
            List<SObject> sObjRecordsFinAccRoleList = (List<SObject>)Type.forName(listTypeAccRole).newInstance();
            sObjRecordsFinAccRoleList.addAll(finAccRoleList);
            finAccRoleUpsertResult = Database.upsert(sObjRecordsFinAccRoleList,finFinancialAccountTransactionObject.getDescribe().fields.getMap().get('FinServ__SourceSystemId__c'));              
        } 
    }
    
    public void printDebug(){
        System.debug(LoggingLevel.Error + '>>>accUpsertResult >>' +  accUpsertResult);
        System.debug(LoggingLevel.Error + '>>>contactUpsertResult >>' + contactUpsertResult);
        System.debug(LoggingLevel.Error + '>>>taxUpsertResult >>' + taxUpsertResult);
    }

    public void logExceptions(Database.UpsertResult[] resultList){
        // Inspect publishing results
        FNS_ErrorLog logger = new FNS_ErrorLog();
        for (Database.UpsertResult result : resultList) {
            if (!result.isSuccess()) {
                for (Database.Error error : result.getErrors()) {
                    System.debug('Error returned: ' + error.getStatusCode() +' - '+ error.getMessage());
                    logger.addLogRecord('FNS_UpsertUnitOfWorkHelper', 'Error logExceptions ', error.getMessage());
                }
            }
        }
    }
}