/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_AddressSelector 
****************************************************************************/
@isTest
private class FNS_AddressSelectorTest {
    
    public static Account accRecord;
    public static FNS_Address__c addressRecord1;
    public static FNS_Address__c addressRecord2;
    public static List<FNS_Address__c> addressList;
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
        
        addressRecord1 = test.createAddressRecord(accRecord.Id, 'Legal');
        addressRecord2 = test.createAddressRecord(accRecord.Id, 'Primary');
        
        addressList = new List<FNS_Address__c>();
        addressList.add(addressRecord1);
        addressList.add(addressRecord2);
        insert addressList;
    }
    
    /**
    * @description: This Method is used to validate the selectAddressByCustomer method.
    */ 
    static testMethod void selectContactsByCustomerTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            
            List<FNS_Address__c> addrList = new FNS_AddressSelector().selectAddressByCustomer(new Set<Id>{accRecord.Id});
            
            System.assertNotEquals(addrList, null);
            
            Test.stopTest();
        }
        
    }
}