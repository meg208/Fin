/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_TaxDetailsSelector
****************************************************************************/
@isTest
private class FNS_TaxDetailsSelectorTest {
    
    public static Account accRecord;
    public static FNS_TaxDetails__c taxDetailsRecord1;
    public static FNS_TaxDetails__c taxDetailsRecord2;
    public static List<FNS_TaxDetails__c> taxDetailsList;
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
        
        taxDetailsRecord1 = test.createTaxDetailsRecord(accRecord.Id, 'VAT');
        taxDetailsRecord2 = test.createTaxDetailsRecord(accRecord.Id, 'GST');
        
        taxDetailsList = new List<FNS_TaxDetails__c>();
        taxDetailsList.add(taxDetailsRecord1);
        taxDetailsList.add(taxDetailsRecord2);
        insert taxDetailsList;
    }
    
    /**
    * @description: This Method is used to validate the selectTaxDetailsByCustomer method.
    */ 
    static testMethod void selectTaxDetailsByCustomerTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<FNS_TaxDetails__c> taxDetailsList = new FNS_TaxDetailsSelector().selectTaxDetailsByCustomer(new Set<Id>{accRecord.Id});
            Test.stopTest();
			
            System.assertNotEquals(taxDetailsList, null);
        }
        
    }
}