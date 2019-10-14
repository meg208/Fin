/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_AccountSelector 
****************************************************************************/
@isTest
private class FNS_AccountSelectorTest {
    
    public static Account accRecord;
    public static Contact contactRecord;
    public static FNS_Address__c addressRecord;
    public static FNS_CustomerProfile__c custProfileRecord;
    public static FNS_TaxDetails__c taxDetailsRecord;
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
    
    /**
    * @description: This Method is used to create test data for unit testing.
    */ 
    static void setup() {
        FNS_TestDataSetup test = new FNS_TestDataSetup();
        
        accRecord = test.createAccount('Test Account 001');
        insert accRecord;
        
        contactRecord = test.createContact(accRecord.Id, 'Contact');
        insert contactRecord;
        
        addressRecord = test.createAddressRecord(accRecord.Id, 'Legal');
        insert addressRecord;
        
        custProfileRecord = test.createCustomerProfileRecord(accRecord.Id, 'BORROWER');
        insert custProfileRecord;
        
        taxDetailsRecord = test.createTaxDetailsRecord(accRecord.Id, 'VAT');
        insert taxDetailsRecord;
    }
    
    /**
    * @description: This Method is used to validate the selectByExternalId method.
    */ 
    static testMethod void selectByExternalIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            setup();
            
            List<Account> accList = new FNS_AccountSelector().selectByExternalId(new Set<String>{(String)accRecord.FNS_CustomerExtId__c});
            
            System.assertNotEquals(accList, null);
        }
        
    }
    
    /**
    * @description: This Method is used to validate the selectCustomerWithRelatedRecordsByExtId method.
    */ 
    static testMethod void selectCustomerWithRelatedRecordsByExtIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            setup();
            
            List<Account> accList = new FNS_AccountSelector().selectCustomerWithRelatedRecordsByExtId(new Set<String>{(String)accRecord.FNS_CustomerExtId__c});
            
            System.assertNotEquals(accList, null);
        }
    }
    
    /**
    * @description: This Method is used to validate the selectCustomerWithRelatedRecordsById method.
    */ 
    static testMethod void selectCustomerWithRelatedRecordsByIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            setup();
            
            List<Account> accList = new FNS_AccountSelector().selectCustomerWithRelatedRecordsById(new Set<String>{(String)accRecord.Id});
            
            System.assertNotEquals(accList, null);
        }
    }
}