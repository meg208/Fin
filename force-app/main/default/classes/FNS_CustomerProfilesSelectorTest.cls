/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_CustomerProfilesSelector
****************************************************************************/
@isTest
private class FNS_CustomerProfilesSelectorTest {
    
    public static Account accRecord;
    public static FNS_CustomerProfile__c custProfileRecord1;
    public static FNS_CustomerProfile__c custProfileRecord2;
    public static List<FNS_CustomerProfile__c> custProfileList;
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
        
        custProfileRecord1 = test.createCustomerProfileRecord(accRecord.Id, 'BORROWER');
        custProfileRecord2 = test.createCustomerProfileRecord(accRecord.Id, 'GUARANTOR');
        
        custProfileList = new List<FNS_CustomerProfile__c>();
        custProfileList.add(custProfileRecord1);
        custProfileList.add(custProfileRecord2);
        insert custProfileList;
    }
    
    /**
    * @description: This Method is used to validate the selectCustomerProfilesByCustomer method.
    */ 
    static testMethod void selectCustomerProfilesByCustomerTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<FNS_CustomerProfile__c> custProfileList = new FNS_CustomerProfilesSelector().selectCustomerProfilesByCustomer(new Set<Id>{accRecord.Id});
            Test.stopTest();
            System.assertNotEquals(custProfileList, null);
        }
        
    }
    
    /**
    * @description: This Method is used to validate the selectById method.
    */ 
    static testMethod void selectByIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<FNS_CustomerProfile__c> custProfileList = new FNS_CustomerProfilesSelector().selectById(new Set<Id>{custProfileRecord1.Id, custProfileRecord2.Id});
            Test.stopTest();
            System.assertNotEquals(custProfileList, null);
        }
    }
}