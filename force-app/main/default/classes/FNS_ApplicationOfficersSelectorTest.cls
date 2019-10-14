/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_ApplicationOfficersSelector 
****************************************************************************/
@isTest
private class FNS_ApplicationOfficersSelectorTest { 
    
    public static Account accountRecord; 
    public static Opportunity  opportunityRecord;
    public static FNS_Officer__c officerRecord;
    public static FNS_ApplicationWithOfficer__c appWithOfficerRecord;
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
        
        officerRecord = test.createOfficerRecord('Primary Officer');
        insert officerRecord;
        
        appWithOfficerRecord = test.createApplicationWithOfficerRecord(opportunityRecord.Id,officerRecord.Id);
        insert appWithOfficerRecord;
    }
    
    
    /**
    * @description: This Method is used to validate the getApplicationOfficersByAppId method.
    */ 
    static testMethod void getApplicationOfficersByAppIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            new FNS_ApplicationOfficersSelector(true);
            List<FNS_ApplicationWithOfficer__c> appWithOfficerList = new FNS_ApplicationOfficersSelector().getApplicationOfficersByAppId(new Set<Id>{opportunityRecord.Id});
            System.assertNotEquals(appWithOfficerList, null);
            Test.stopTest();
        }
    }
}