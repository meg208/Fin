/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_ContactSelector
****************************************************************************/
@isTest
private class FNS_ContactSelectorTest {
    
    public static Account accRecord;
    public static Contact contactRecord1;
    public static Contact contactRecord2;
    public static List<Contact> contactList;
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
        
        contactRecord1 = test.createContact(accRecord.Id, 'Contact1');
        contactRecord2 = test.createContact(accRecord.Id, 'Contact2');
        
        contactList = new List<Contact>();
        contactList.add(contactRecord1);
        contactList.add(contactRecord2);
        insert contactList;
    }
    
    /**
    * @description: This Method is used to validate the selectContactsByCustomer method.
    */ 
    static testMethod void selectContactsByCustomerTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<Contact> conList = new FNS_ContactSelector().selectContactsByCustomer(new Set<Id>{(String)accRecord.Id});
            System.assertNotEquals(conList, null);
            Test.stopTest();
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
            List<Contact> conList = new FNS_ContactSelector().selectById(new Set<Id>{contactRecord1.Id, contactRecord2.Id});
            System.assertNotEquals(conList, null);
            Test.stopTest();
        }
    }
}