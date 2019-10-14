@isTest 
public class FNS_TestDataSetup {
    
    public User userObj;
    public Account accountRecord;
    public Contact contactRecord;
    public FNS_Address__c addressRecord;
    public FNS_CustomerProfile__c customerProfileRecord;
    public FNS_TaxDetails__c taxDetailsRecord;
    public Opportunity opportunityRecord;
    public Task taskRecord;
    public FNS_Officer__c officerRecord;
    public FNS_ApplicationWithOfficer__c appWithOfficerRecord;
    public FNS_FinancialAccount__c nonFSCProductRecord;
    public FNS_Fee__c nonFSCfeeRecord;
    public FNS_Pricing__c nonFSCpricingRecord;
    public FNS_FinancialAccountRole__c nonFSCProductRoleRecord;
    public FNS_FinancialAccountTransaction__c nonFSCLoanRecord;
    public Lead leadRecord;
    public FNS_RelatedRoles__c relatedRole;
    public FNS_Activity__c activityRecord; 
    public FNS_ApplicationWithQueueActivity__c appWithQueueActivityRecord; 
    public FNS_PredictiveAnalytics__c predAnalyticsRecord;
    public FNS_ConfigurationType__c configRecord;
    
    public String fscProductObjName = 'FinServ__FinancialAccount__c';
    public String fscObjName = 'FNS_Fee__c';
    public String fscPricingObjName = 'FNS_Pricing__c';
    public String fscLoanObjName = 'FinServ__FinancialAccountTransaction__c';
    public String fscProductRoleObjName = 'FinServ__FinancialAccountRole__c';
    public SObject fscProductRecord;
    public SObject fscFeeRecord;
    public SObject fscPricingRecord;
    public SObject fscProductRoleRecord;
    public SObject fscLoanRecord;
    
    public static string baseNamespace = FNS_Util.getBasePackageNamepace();
    public static string extNamespace = FNS_Util.getExtensionPackageNamespace();
    public static string namespace = FNS_Util.isFSCInstalled?extNamespace:baseNamespace;

    public Id getUserProfileId(String profileName){
        Profile p = [Select p.Name, p.Id From Profile p where p.Name = :profileName];
        
        return p.Id;
    }

    public User createUser(String emailId){
        String profileName;
        if(FNS_Util.isFSCInstalled){
            profileName = 'Relationship Manager FSC';
        }else {
            profileName = 'Relationship Manager';
        }
        Id pId = getUserProfileId(profileName);
        userObj = new User(Username = emailId,
                           LastName = emailId.substring(0, emailId.indexOf('@') - 1),
                           Email = emailId,
                           alias=emailId.substring(0, emailId.indexOf('@') - 1),
                           TimeZoneSidKey='America/New_York',
                           LocaleSidKey='en_US',
                           FNS_UserExternalId__c = emailId,
                           EmailEncodingKey='ISO-8859-1',
                           LanguageLocaleKey = 'en_US',
                           FNS_IsOfficer__c = true
                          );
        userObj.ProfileId = pId;
        return userObj;
    }
    
    public Account createAccount(String accountName){
        String recordTypeName = 'FNS_Customer' ;
        ID accountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
        
        accountRecord = new Account(
            Name = accountName,
            AccountNumber = accountName+'100',
            FNS_CustomerExtId__c = accountName+'101',
            FNS_IdentityNumber__c = accountName+'102',
            FNS_IdentityType__c = 'TIN' ,
            AnnualRevenue = 1000,
            //FNS_OfficialType__c = 'Legal',
            RecordTypeId = accountRecordTypeID,
            FNS_CustomerDescription__c = accountName+'Account description'
        );
        return accountRecord;
    }
    
    public Contact createContact(Id accountId, String contactName){
        contactRecord = new Contact(
            FirstName = contactName+'FName',
            LastName = contactName+'LName',
            Email = contactName+'@email.com',
            Phone = '111-222-3333',
            Title = 'Mr.',
            HomePhone = '444-555-6666',
            MobilePhone = '777-888-9999',
            Department = 'Department',
            AccountId = accountId
        );
        return contactRecord;
    }
    
    public FNS_Address__c createAddressRecord(Id accountId, String addressType){
        String recordTypeName = 'FNS_Address' ;
        ID addressRecordTypeID = Schema.SObjectType.FNS_Address__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
        
        addressRecord = new FNS_Address__c(
            FNS_Address1__c = 'Address 1',
            FNS_Address2__c = 'Address 2',
            FNS_Address3__c = 'Address 3',
            FNS_AddressType__c = addressType,
            FNS_City__c = 'New York',
            FNS_CountryCode__c = SObjectType.FNS_Address__c.Fields.FNS_CountryCode__c.PicklistValues[0].getValue(),
            FNS_PostalCode__c = '10',
            FNS_PostalCodeExtension__c = '10',
            FNS_ProvinceCode__c = SObjectType.FNS_Address__c.Fields.FNS_ProvinceCode__c.PicklistValues[0].getValue(),
            FNS_Account__c = accountId,
            RecordTypeId = addressRecordTypeID
        );
        return addressRecord;
    }
    
    public FNS_CustomerProfile__c createCustomerProfileRecord(Id accountId, String profileType){
        String recordTypeName = 'FNS_Customer' ;
        ID cpID = Schema.SObjectType.FNS_CustomerProfile__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
        
        customerProfileRecord = new FNS_CustomerProfile__c(
            FNS_CreditComment__c = 'Credit Comment',
            FNS_CreditReviewDate__c = System.now(),
            FNS_CustomerProfileExternalId__c = profileType+'ExtId',
            FNS_ProfileType__c = profileType,
            FNS_CustomerBusiness__c = accountId,
            RecordTypeId = cpID
        );
        return customerProfileRecord;
    }
    
    public FNS_TaxDetails__c createTaxDetailsRecord(Id accountId, String taxType){
        String recordTypeName = 'FNS_TaxDetails' ;
        ID taxdetailsID = Schema.SObjectType.FNS_TaxDetails__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
        
        taxDetailsRecord = new FNS_TaxDetails__c(
            FNS_TaxCountry__c = 'USA',
            FNS_TaxDetailsExtId__c = System.now()+taxType,
            FNS_TaxExmptCode__c = 'Y',
            FNS_TaxNumber__c = '123'+taxType,
            FNS_TaxPayerId__c = '3434555',
            FNS_TaxRegion__c = 'TEXAS',
            FNS_TaxType__c = taxType,
            FNS_AccountName__c = accountId,
            recordTypeId = taxdetailsID
        );
        return taxDetailsRecord;
    }
    
    public Opportunity createOpportunityRecord(Id accountId){
        String recordTypeName = FNS_Constants.OPPORTUNITY_EDITABLERECORDTYPE;
        ID oppEditableID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
       
        opportunityRecord = new Opportunity(
            Name = 'Opportunity Record',
            Amount = 15000,
            StageName = 'Proposal',
            CloseDate = Date.Today().addDays(30),
            FNS_SLAStatus__c = 'GREEN',
            FNS_ApplicationExtId__c = 'ExtId',
            Description = 'Opportunity Description',
            FNS_StartDateTime__c = Date.Today(),
            AccountId = accountId,
            recordTypeId = oppEditableID
        );
        return opportunityRecord;
    }
    
    public Task createTaskRecord(Id opportunityId){
        taskRecord = new Task(
            Subject = 'Call',
            ActivityDate = Date.Today().addDays(-30),
            Status =SObjectType.Task.Fields.Status.PicklistValues[0].getValue(),
            WhatId = opportunityId,
            FNS_PrimaryRelationship__c = 'NA',
            FNS_Refresh__c = false,
            FNS_SLAIndicator__c = 'Green',
            FNS_SLAPercentage__c = '1.00',
            FNS_TrackingItemExtId__c = '11121',
            FNS_TrackStatusId__c = '11',
            FNS_ApplicationStageName__c = 'proposal',
            FNS_ApplicationExtId__c = '111111',
            FNS_IsActive__c = false ,
            FNS_CustomerExtIds__c = '111',
            FNS_UserExtId__c = '12345',
            Priority = SObjectType.Task.Fields.Priority.PicklistValues[0].getValue(),
            FNS_DueDate__c = '05/12/2048',
            FNS_IsCSA__c = false,
            FNS_IsStandard__c = false,
            FNS_IsVerified__c = false,
            FNS_KeepOnRefresh__c = false,
            FNS_PrintStatusId__c = 123,
            FNS_PackageExtId__c = '123',
            FNS_Status__c = SObjectType.Task.Fields.FNS_Status__c.PicklistValues[0].getValue(),
            FNS_Priority__c = SObjectType.Task.Fields.FNS_Priority__c.PicklistValues[0].getValue()
        );
        return taskRecord;
    }
    
    public FNS_Officer__c createOfficerRecord(String officerType){
        String recordTypeName = 'FNS_Officer';
        ID officerID = Schema.SObjectType.FNS_Officer__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
               
        officerRecord = new FNS_Officer__c(
            FNS_OfficerDescription__c = 'Business Center Manager',
            FNS_OfficerId__c = '324',
            FNS_PhoneNumber__c = '344-333-1122',
            recordTypeId = officerID
        );
        return officerRecord;
    }
    
    public FNS_ApplicationWithOfficer__c createApplicationWithOfficerRecord(Id opportunityId, Id officerId){
        String recordTypeName = 'FNS_ApplicationWithOfficer';
        ID appOfficerID = Schema.SObjectType.FNS_ApplicationWithOfficer__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
           
        appWithOfficerRecord = new FNS_ApplicationWithOfficer__c (
            FNS_Application__c = opportunityId,
            FNS_Officer__c = officerId,
            FNS_OfficerRole__c = SObjectType.FNS_ApplicationWithOfficer__c.Fields.FNS_OfficerRole__c.PicklistValues[0].getValue(),
            recordTypeId = appOfficerID
        );
        return appWithOfficerRecord;
    }
    
    public FNS_FinancialAccount__c createProductRecord(Id applicationId){
        String recordTypeName = 'FNS_FinancialAccount';
        ID financialAccountID = Schema.SObjectType.FNS_FinancialAccount__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
         
        nonFSCProductRecord = new FNS_FinancialAccount__c (
            FNS_ProductType__c = SObjectType.FNS_FinancialAccount__c.Fields.FNS_ProductType__c.PicklistValues[0].getValue(),
            FNS_Purpose__c = SObjectType.FNS_FinancialAccount__c.Fields.FNS_Purpose__c.PicklistValues[0].getValue(),
            FNS_RateType__c = 'Fixed',
            FNS_RequestedClosingDate__c = Date.Today().addDays(60),
            FNS_MaturityDate__c = Date.Today().addDays(60),
            FNS_Amount__c = 15000,
            FNS_Term__c = '6',
            FNS_TermUnit__c = 'Months',
            FNS_RiskType__c = 'None',
            FNS_EffectiveDate__c = System.now(),
            FNS_Application__c = applicationId,
            recordTypeId = financialAccountID
        );
        return nonFSCProductRecord;
    }
    
    public FNS_Fee__c createFeeRecord(Id productId){
        String recordTypeName = 'FNS_Fee';
        ID feeID = Schema.SObjectType.FNS_Fee__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
         
        nonFSCfeeRecord = new FNS_Fee__c (
            FNS_CurrencyCode__c = 'USD',
            FNS_Amount__c = 100,
            FNS_FeeRate__c = 2,
            FNS_FeeType__c = SObjectType.FNS_Fee__c.Fields.FNS_FeeType__c.PicklistValues[0].getValue(),
            FNS_FinancialAccount__c = productId,
            recordTypeId = feeID
        );
        return nonFSCfeeRecord;
    }
    
    public FNS_Pricing__c createPricingRecord(Id productId){
        String recordTypeName = 'FNS_Pricing';
        ID pricingID = Schema.SObjectType.FNS_Pricing__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
        
        nonFSCpricingRecord = new FNS_Pricing__c (
            FNS_PricingType__c = SObjectType.FNS_Pricing__c.Fields.FNS_PricingType__c.PicklistValues[0].getValue(),
            FNS_Frequencies__c = SObjectType.FNS_Pricing__c.Fields.FNS_Frequencies__c.PicklistValues[0].getValue(),
            FNS_FinancialAccount__c = productId,
            recordTypeId = pricingID
        );
        return nonFSCpricingRecord;
    }
    
    public FNS_FinancialAccountRole__c createProductRoleRecord(Id productId){
        String recordTypeName = 'FNS_FinancialAccountRole';
        ID financialAccountRoleID = Schema.SObjectType.FNS_FinancialAccountRole__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
        
        nonFSCProductRoleRecord = new FNS_FinancialAccountRole__c (
            FNS_ProductRelRole__c = SObjectType.FNS_FinancialAccountRole__c.Fields.FNS_ProductRelRole__c.PicklistValues[0].getValue(),
            FNS_GuaranteePercent__c = 20,
            FNS_TypeofProdRole__c = SObjectType.FNS_FinancialAccountRole__c.Fields.FNS_TypeofProdRole__c.PicklistValues[0].getValue(),
            FNS_FinancialAccount__c = productId,
            recordTypeId = financialAccountRoleID
        );
        return nonFSCProductRoleRecord;
    }
    
    public FNS_FinancialAccountTransaction__c createLoanRecord(Id productId){
        String recordTypeName = 'FNS_FinancialAccountTransaction';
        ID financialAccountTransID = Schema.SObjectType.FNS_FinancialAccountTransaction__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
        
        nonFSCLoanRecord = new FNS_FinancialAccountTransaction__c (
            FNS_LoanPurpose__c = SObjectType.FNS_FinancialAccountTransaction__c.Fields.FNS_LoanPurpose__c.PicklistValues[0].getValue(),
            FNS_RequestedDate__c = Date.Today(),
            FNS_RiskType__c = 'None',
            FNS_MaturityDate__c = System.now().addDays(60),
            FNS_PricingType__c = SObjectType.FNS_FinancialAccountTransaction__c.Fields.FNS_PricingType__c.PicklistValues[0].getValue(),
            FNS_Amount__c = 15000,
            FNS_Term__c = '6',
            FNS_TermUnit__c = 'Months',
            FNS_TransactionDate__c = Date.Today(),
            FNS_EffectiveDate__c = System.now(),
            FNS_PricingFrequency__c = SObjectType.FNS_FinancialAccountTransaction__c.Fields.FNS_PricingFrequency__c.PicklistValues[0].getValue(),
            FNS_LoanProductType__c = SObjectType.FNS_FinancialAccountTransaction__c.Fields.FNS_LoanProductType__c.PicklistValues[0].getValue(),
            FNS_FinancialAccount__c = productId,
            recordTypeId = financialAccountTransID
        );
        return nonFSCLoanRecord;
    }
    
    public Lead createLeadRecordWithContact(Id contactId){
        String recordTypeName = 'FNS_Leads';
        ID leadID = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
        
        if(FNS_Util.isFSCInstalled){
            leadRecord = new Lead(LastName = 'TestContact', Email = 'testLead@gmail.com', mobilephone = '+1234567890', 
                                  Company = 'Test company', recordTypeId = leadID);
            leadRecord.put('FinServ__ReferredByContact__c', contactId);
        } else {
            leadRecord = new Lead(LastName = 'TestContact', Email = 'testLead@gmail.com', mobilephone = '+1234567890', 
                                  Company = 'Test company', recordTypeId = leadID,
                                  FNS_ExternalReferrer__c = contactId);
        }
        return leadRecord;
    }
    
    public Lead createLeadRecordWithUser(Id userId){
        String recordTypeName = 'FNS_Leads';
        ID leadID = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ; 
        
        if(FNS_Util.isFSCInstalled){
            leadRecord = new Lead(LastName = 'TestUser', Email = 'testLead@gmail.com', mobilephone = '+1234567890', 
                                  Company = 'Test company', recordTypeId = leadID);
            leadRecord.put('FinServ__ReferredByUser__c', userId);
        } else {
            leadRecord = new Lead(LastName = 'TestUser', Email = 'testLead@gmail.com', mobilephone = '+1234567890', 
                                  Company = 'Test company', recordTypeId = leadID,
                                  FNS_InternalReferrer__c = userId);
        }
        return leadRecord;
    }

    public FNS_ConfigurationType__c createConfigRecord(){
        String recordTypeName = 'FNS_ConfigurationType';
        ID configTypeID = Schema.SObjectType.FNS_ConfigurationType__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
        
        configRecord = new FNS_ConfigurationType__c(FNS_ConfigurationExternalId__c = '23CONFIGCURRENCY',
        FNS_ConfigurationId__c = '23', FNS_ConfigurationType__c = 'CONFIG_CURRENCY',
        FNS_ConfigurationValue__c = 'TEST', FNS_Description__c = 'TESTDESC',
                                                   recordTypeId = configTypeID);
        return configRecord;
    }

    public FNS_ConfigurationType__c updateConfigRecord(Id configId){
        configRecord = [select id,FNS_Description__c from  FNS_ConfigurationType__c where id =: configId limit 1];
        configRecord.FNS_Description__c = 'TEST123';
        return configRecord;
    }
    
    public SObject createFSCProductRecord(Id applicationId, Id accountId){
        String recordTypeName = 'FNS_FinancialAccount';
        ID financialAccountID = (Schema.getGlobalDescribe().get(fscProductObjName).getDescribe()).getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();        
        fscProductRecord = Schema.getGlobalDescribe().get(fscProductObjName).newSObject();
        
        String productType = Schema.getGlobalDescribe().get(fscProductObjName).getDescribe() .fields.getMap().get(extNamespace+'FNS_ProductType__c').getDescribe().getPickListValues()[0].getValue();
        
        String purpose = Schema.getGlobalDescribe().get(fscProductObjName).getDescribe() .fields.getMap().get(extNamespace+'FNS_Purpose__c').getDescribe().getPickListValues()[0].getValue();
		
        fscProductRecord.put(extNamespace+'FNS_ProductType__c', productType);
        fscProductRecord.put(extNamespace+'FNS_Purpose__c', purpose);
        fscProductRecord.put(extNamespace+'FNS_RateType__c', 'Fixed');
        fscProductRecord.put(extNamespace+'FNS_RequestedClosingDate__c', Date.Today().addDays(60));
        fscProductRecord.put(extNamespace+'FNS_MaturityDate__c', Date.Today().addDays(60));
        fscProductRecord.put(extNamespace+'FNS_Amount__c', 15000);
        fscProductRecord.put(extNamespace+'FNS_Term__c', '6');
        fscProductRecord.put(extNamespace+'FNS_TermUnit__c', 'Months');
        fscProductRecord.put(extNamespace+'FNS_RiskType__c', 'None');
        fscProductRecord.put(extNamespace+'FNS_EffectiveDate__c', System.now());
        fscProductRecord.put(extNamespace+'FNS_Application__c', applicationId);
        fscProductRecord.put('FinServ__PrimaryOwner__c', accountId);
        fscProductRecord.put('RecordTypeId', financialAccountID);
        return fscProductRecord;
    }
    
    public SObject createFSCFeeRecord(Id productId){
        fscFeeRecord = Schema.getGlobalDescribe().get(extNamespace+fscObjName).newSObject();
        
        fscFeeRecord.put(extNamespace+'FNS_CurrencyCode__c','USD');
        fscFeeRecord.put(extNamespace+'FNS_Amount__c',100);
        fscFeeRecord.put(extNamespace+'FNS_FeeRate__c',2);
        fscFeeRecord.put(extNamespace+'FNS_FeeType__c',SObjectType.FNS_Fee__c.Fields.FNS_FeeType__c.PicklistValues[0].getValue());
        fscFeeRecord.put(extNamespace+'FNS_FinancialAccountFSC__c',productId);
        
        return fscFeeRecord;
    }
    
    public SObject createFSCPricingRecord(Id productId){
        fscPricingRecord = Schema.getGlobalDescribe().get(extNamespace+fscPricingObjName).newSObject();
        fscPricingRecord.put(extNamespace+'FNS_PricingType__c',SObjectType.FNS_Pricing__c.Fields.FNS_PricingType__c.PicklistValues[0].getValue());
        fscPricingRecord.put(extNamespace+'FNS_Frequencies__c',SObjectType.FNS_Pricing__c.Fields.FNS_Frequencies__c.PicklistValues[0].getValue());
        fscPricingRecord.put(extNamespace+'FNS_FinancialAccountFSC__c', productId);
        
        return fscPricingRecord;
    }
    
    public SObject createFSCProductRoleRecord(Id productId, Id accountId){
        String recordTypeName = 'FNS_FinancialAccountRole';
        ID financialAccountRoleID = (Schema.getGlobalDescribe().get(fscProductRoleObjName).getDescribe()).getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
        
        fscProductRoleRecord = Schema.getGlobalDescribe().get(fscProductRoleObjName).newSObject();
		
        String productRelationshipRole = Schema.getGlobalDescribe().get(fscProductRoleObjName).getDescribe() .fields.getMap().get(extNamespace+'FNS_ProductRelRole__c').getDescribe().getPickListValues()[0].getValue();
        
        String productRoleType = Schema.getGlobalDescribe().get(fscProductRoleObjName).getDescribe() .fields.getMap().get(extNamespace+'FNS_TypeofProdRole__c').getDescribe().getPickListValues()[0].getValue();
        
        fscProductRoleRecord.put(extNamespace+'FNS_ProductRelRole__c', productRelationshipRole);
        fscProductRoleRecord.put(extNamespace+'FNS_GuaranteePercent__c', 20);
        fscProductRoleRecord.put(extNamespace+'FNS_TypeofProdRole__c', productRoleType);
        fscProductRoleRecord.put('FinServ__FinancialAccount__c', productId);
        fscProductRoleRecord.put('FinServ__Role__c', 'Accountant');
        fscProductRoleRecord.put('FinServ__RelatedAccount__c', accountId);
        fscProductRoleRecord.put('RecordTypeId', financialAccountRoleID);
        
        return fscProductRoleRecord;
    }
    
    public SObject createFSCLoanRecord(Id productId){
        String recordTypeName = 'FNS_FinancialAccountTransaction';
        ID financialAccountTransID = (Schema.getGlobalDescribe().get(fscLoanObjName).getDescribe()).getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
        
        fscLoanRecord = Schema.getGlobalDescribe().get(fscLoanObjName).newSObject();
		
        String loanProductType = Schema.getGlobalDescribe().get(fscLoanObjName).getDescribe() .fields.getMap().get(extNamespace+'FNS_LoanProductType__c').getDescribe().getPickListValues()[0].getValue();
        
        String loanPurpose = Schema.getGlobalDescribe().get(fscLoanObjName).getDescribe() .fields.getMap().get(extNamespace+'FNS_LoanPurpose__c').getDescribe().getPickListValues()[0].getValue();
        
        String pricingType = Schema.getGlobalDescribe().get(fscLoanObjName).getDescribe() .fields.getMap().get(extNamespace+'FNS_PricingType__c').getDescribe().getPickListValues()[0].getValue();
		
        String pricingFrequency = Schema.getGlobalDescribe().get(fscLoanObjName).getDescribe() .fields.getMap().get(extNamespace+'FNS_PricingFrequency__c').getDescribe().getPickListValues()[0].getValue();
		
        fscLoanRecord.put(extNamespace+'FNS_LoanProductType__c', loanProductType);
        fscLoanRecord.put(extNamespace+'FNS_LoanPurpose__c', loanPurpose);
        fscLoanRecord.put(extNamespace+'FNS_RequestedDate__c', Date.Today());
        fscLoanRecord.put(extNamespace+'FNS_RiskType__c', 'None');
        fscLoanRecord.put(extNamespace+'FNS_MaturityDate__c', System.now().addDays(60));
        fscLoanRecord.put(extNamespace+'FNS_PricingType__c', pricingType);
        fscLoanRecord.put('FinServ__Amount__c', 15000);
        fscLoanRecord.put(extNamespace+'FNS_Term__c', '6');
        fscLoanRecord.put(extNamespace+'FNS_TermUnit__c', 'Months');
        fscLoanRecord.put('FinServ__TransactionDate__c', Date.Today());
        fscLoanRecord.put(extNamespace+'FNS_EffectiveDate__c', System.now());
        fscLoanRecord.put(extNamespace+'FNS_PricingFrequency__c', pricingFrequency);
        fscLoanRecord.put('FinServ__FinancialAccount__c', productId);
        fscLoanRecord.put('RecordTypeId', financialAccountTransID);
        
        return fscLoanRecord;
    }    
    
    public SObject createActivityRecord(){
        String recordTypeName = 'FNS_TrackingItem';
        ID activityID = Schema.SObjectType.FNS_Activity__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
        
        activityRecord = new FNS_Activity__c(FNS_NextDefaultActivityId__c= '12', FNS_ActivityExternalId__c='ExtId', FNS_Description__c= 'New Loan', 
                                             FNS_NextAvailableActivityIds__c= '12,13,14', RecordTypeId = activityID );
        return activityRecord;
    }
    
    public SObject createApplicationWithQueueActivityRecord(Id activityId, String activityExtId, String applicationExtId){
        appWithQueueActivityRecord = new FNS_ApplicationWithQueueActivity__c(FNS_Activity__c = activityId, FNS_ActivityExternalId__c= activityExtId, 
                                                                             FNS_ActivityNotes__c= 'text', FNS_ApplicationExternalId__c= applicationExtId, 
                                                                             FNS_IsCurrentActivity__c= true, FNS_QueueExternalId__c= 'queueId', 
                                                                             FNS_SequenceNumber__c= 2, FNS_Status__c= 'Current'); 
        return appWithQueueActivityRecord;
    }
    
    public FNS_PredictiveAnalytics__c createPredictiveAnalyticsRecord(Id loanId, Id accountId, Id financialProductId){
        String recordTypeName = 'FNS_Predictive_Analytics';
        ID predictiveAnalysisID = Schema.SObjectType.FNS_PredictiveAnalytics__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).RecordTypeId ;     
        
        if(FNS_Util.isFSCInstalled){
            predAnalyticsRecord = new FNS_PredictiveAnalytics__c(FNS_Customer__c = accountId, FNS_CustomerName__c = 'ABC Company', 
                                                                 FNS_FinancialAccountName__c = 'Product 123', FNS_FinancialAccountTransactionName__c = 'Test Loan',
                                                                 FNS_PriorityOrder__c= 2, FNS_Recommendation__c= 'Recommendation 1', recordTypeId = predictiveAnalysisID, 
                                                                 FNS_RecommendationDescription__c= 'Description', FNS_RecommendationId__c= 1010101);
            predAnalyticsRecord.put('FNS_FinancialAccountTransactionFSC__c', loanId);
            predAnalyticsRecord.put('FNS_FinancialAccountFSC__c', financialProductId); 
        } else {
            predAnalyticsRecord = new FNS_PredictiveAnalytics__c(FNS_Customer__c = accountId, FNS_CustomerName__c = 'ABC Company', 
                                                                 FNS_FinancialAccountName__c = 'Product 123', FNS_FinancialAccountTransactionName__c = 'Test Loan', 
                                                                 FNS_PriorityOrder__c= 2, FNS_Recommendation__c= 'Recommendation 1', recordTypeId = predictiveAnalysisID,
                                                                 FNS_RecommendationDescription__c= 'Description', FNS_RecommendationId__c= 1010101);
            predAnalyticsRecord.put('FNS_FinancialAccountTransaction__c', loanId);
            predAnalyticsRecord.put('FNS_FinancialAccount__c', financialProductId); 
        }
        return predAnalyticsRecord;
    }
    
public Opportunity createOpportunity(Id accountId, String stageName, String slaStatus, Integer amount){
    
        opportunityRecord = new Opportunity(
            Name = 'Opportunity Record',
            Amount = amount,
            StageName = stageName,
            CloseDate = Date.Today().addDays(30),
            FNS_SLAStatus__c = slaStatus,
          
            Description = 'Opportunity Description',
            FNS_StartDateTime__c = Date.Today(),
            AccountId = accountId
        );
        return opportunityRecord;
    }
    
    public User createTestUser(String emailId, String profileName){
        Profile p = [Select p.Name, p.Id From Profile p where p.Name ='FNS_RelationshipManager'];
        userObj = new User(Username = emailId,
            LastName = emailId.substring(0, emailId.indexOf('@') - 1),
            Email = emailId,
            alias=emailId.substring(0, emailId.indexOf('@') - 1),
            TimeZoneSidKey='America/New_York',
            LocaleSidKey='en_US',
            FNS_UserExternalId__c = emailId,
            EmailEncodingKey='ISO-8859-1',
            ProfileId= p.id,
            LanguageLocaleKey = 'en_US'
        );
        return userObj;
    }
    
    public List<PermissionSet> getPermissionSet(List<String> permissionSets){
        List<PermissionSet> listPs = [SELECT Id From PermissionSet WHERE Name IN :permissionSets];
        return listPs;
    }
    public PermissionSet getPermissionSet(){ //To be deleted 
        return null; 
    }


    public FNS_RelatedRoles__c createRelatedRole(Id OpportuntiyId){
        relatedRole = new FNS_RelatedRoles__c(FNS_Application__c=OpportuntiyId,
                                              Name='Test Role');
        return relatedRole;
    }
}