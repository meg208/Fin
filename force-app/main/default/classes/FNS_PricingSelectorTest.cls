/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_PricingSelector
****************************************************************************/
@isTest
private class FNS_PricingSelectorTest { 
    public static FNS_Pricing__c pricingRecord;
    public static FNS_FinancialAccount__c productRecord;    
    public static Opportunity  opportunityRecord;    
    public static Account accountRecord;   
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
    
    static void setup() {
        FNS_TestDataSetup test = new FNS_TestDataSetup();
        
        accountRecord = test.createAccount('TestAccount01');
        insert accountRecord;
        opportunityRecord = test.createOpportunityRecord(accountRecord.Id);
        insert opportunityRecord;
        productRecord = test.createProductRecord(opportunityRecord.Id);
        insert productRecord;
        pricingRecord = test.createPricingRecord(productRecord.Id);
        insert pricingRecord;
    }
    static testMethod void selectByIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<FNS_Pricing__c> pricingRecordsById =  new FNS_PricingSelector().selectById(new SET<Id>{pricingRecord.Id});
            System.assertNotEquals(pricingRecordsById, null);
            Test.stopTest();
        }
    }
    static testMethod void getPricingsTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<FNS_Pricing__c> pricingRecords =  new FNS_PricingSelector().getPricings(new SET<Id>{productRecord.Id});
            System.assertNotEquals(pricingRecords, null);
            Test.stopTest();
        }
    }
}