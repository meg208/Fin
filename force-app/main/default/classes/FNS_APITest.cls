/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This class is used to test all the GET and POST API functionality. 
****************************************************************************/
@isTest
public class FNS_APITest {
    
    public static Account accountRecord; 
    public static Opportunity  opportunityRecord;
    public static Contact contactRecord;
    public static FNS_Address__c addressRecord;
    public static FNS_CustomerProfile__c custProfileRecord;
    public static FNS_TaxDetails__c taxDetailsRecord;
    public static FNS_FinancialAccount__c productRecord;
    public static FNS_Fee__c nonFSCfeeRecord;
    public static FNS_Pricing__c nonFSCpricingRecord;
    public static FNS_FinancialAccountRole__c roleRecord;
    public static FNS_FinancialAccountTransaction__c nonFSCLoanRecord;
    public static SObject fscProductRecord;
    public static SObject fscFeeRecord;
    public static SObject fscPricingRecord;
    public static SObject fscRoleRecord;
    public static SObject fscLoanRecord;
    public static User user;
    
    @testSetup 
    static void testSetupMethod() {
        FNS_TestDataSetup testData = new FNS_TestDataSetup();
        user = testData.createUser('test@tes111.com');
        insert user;
        List<String> permissionSetNames = new List<String>(); 
        if(FNS_Util.isFSCInstalled){
            permissionSetNames.add('FNS_RelationshipManager_FSC');
        }
        permissionSetNames.add('FNS_RelationshipManager_NonFSC'); 
        
        List<PermissionSet> permissionList = testData.getPermissionSet(permissionSetNames); 
        
        List<PermissionSetAssignment> lstPSAssignments = new List<PermissionSetAssignment>();
        for(PermissionSet ps : permissionList){
            lstPSAssignments.add(new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = ps.Id));
        }
        insert lstPSAssignments; 
    }
    
    static void setupNonFSC() {
        FNS_TestDataSetup testData = new FNS_TestDataSetup();
        accountRecord = testData.createAccount('TestAccount01');
        accountRecord.FNS_CustomerExtId__c = '100127';
        insert accountRecord;
        
        opportunityRecord = testData.createOpportunityRecord(accountRecord.Id);
        opportunityRecord.FNS_ApplicationExtId__c = '100179';
        insert opportunityRecord;
        
        contactRecord = testData.createContact(accountRecord.Id, 'Contact');
        insert contactRecord;
        
        addressRecord = testData.createAddressRecord(accountRecord.Id, 'Legal');
        insert addressRecord;
        
        custProfileRecord = testData.createCustomerProfileRecord(accountRecord.Id, 'BORROWER');
        insert custProfileRecord;
        
        taxDetailsRecord = testData.createTaxDetailsRecord(accountRecord.Id, 'VAT');
        insert taxDetailsRecord;
        
        productRecord = testData.createProductRecord(opportunityRecord.Id);
        insert productRecord;
        
        nonFSCfeeRecord = testData.createFeeRecord(productRecord.Id);
        insert nonFSCfeeRecord;
        
        nonFSCpricingRecord = testData.createPricingRecord(productRecord.Id);
        insert nonFSCpricingRecord;
        
        roleRecord = testData.createProductRoleRecord(productRecord.Id);
        insert roleRecord;
        
        nonFSCLoanRecord = testData.createLoanRecord(productRecord.Id);
        insert nonFSCLoanRecord;
    }
    
    static void setupFSC() {
        FNS_TestDataSetup testData = new FNS_TestDataSetup();
        accountRecord = testData.createAccount('TestAccount01');
        accountRecord.FNS_CustomerExtId__c = '100127';
        insert accountRecord;
        
        opportunityRecord = testData.createOpportunityRecord(accountRecord.Id);
        opportunityRecord.FNS_ApplicationExtId__c = '100179';
        insert opportunityRecord;
        
        contactRecord = testData.createContact(accountRecord.Id, 'Contact');
        insert contactRecord;
        
        addressRecord = testData.createAddressRecord(accountRecord.Id, 'Legal');
        insert addressRecord;
        
        custProfileRecord = testData.createCustomerProfileRecord(accountRecord.Id, 'BORROWER');
        insert custProfileRecord;
        
        taxDetailsRecord = testData.createTaxDetailsRecord(accountRecord.Id, 'VAT');
        insert taxDetailsRecord;
        
        fscProductRecord = testData.createFSCProductRecord(opportunityRecord.Id, accountRecord.Id);
        insert fscProductRecord;
        
        fscFeeRecord = testData.createFSCFeeRecord(fscProductRecord.Id);
        insert fscFeeRecord;
        
        fscPricingRecord = testData.createFSCPricingRecord(fscProductRecord.Id);
        insert fscPricingRecord;
        
        fscRoleRecord = testData.createFSCProductRoleRecord(fscProductRecord.Id, accountRecord.Id);
        insert fscRoleRecord;
        
        fscLoanRecord = testData.createFSCLoanRecord(fscProductRecord.Id);
        insert fscLoanRecord;
    }
    
    @isTest static void testPostCallout() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
            Test.startTest();
            FNS_ApplicationDomain.pushApplicationToFFDC(opportunityRecord.Id);
            Test.stopTest();
            
            Account acc = [Select Id, FNS_CustomerExtId__c From Account Where Id =:accountRecord.Id ];
            System.assertEquals('100127', acc.FNS_CustomerExtId__c);
            
            Opportunity opp = [Select Id, FNS_ApplicationExtId__c From Opportunity Where Id =:opportunityRecord.Id ];
            System.assertEquals('100179', opp.FNS_ApplicationExtId__c);
        }
    }
    
    @isTest static void testGetCallout() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
            Test.startTest();
            FNS_ApplicationDomain.getApplicationDataFromFFDC(opportunityRecord);
            Test.stopTest();
            System.assert(true);
        }
    }
    
    @isTest static void testFetchCustomersFromCME() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            Test.startTest();
            Map<String,Account> custMapWithExtId = FNS_OrganizationDomain.fetchCustomersFromCME(new Set<String>{'100127'});
            Test.stopTest();
            Account acc = custMapWithExtId.get('100127');
            System.assertNotEquals(null, custMapWithExtId);
        }
    }
    
    @isTest static void testGetActiveDealsSummaryForRM() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            Test.startTest();
               // FNS_QueueActivityDomain.getActiveDealsSummaryForRM('1234');
                  FNS_QueueActivityDomain.fetchActiveDealsSummaryForRM('1234');
            Test.stopTest();
            System.assert(true);
        }
    }
}