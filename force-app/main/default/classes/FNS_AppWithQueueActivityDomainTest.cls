/*****************************************************************************************
* @description This class is test class for  FNS_ApplicationWithQueueActivityDomain 
* @author Kavya Papasani
* @date April 24 2019
* @Support Email kavya@comitydesigns.com
******************************************************************************************/
@IsTest
public  class FNS_AppWithQueueActivityDomainTest {
    
    public static Account accountRecord; 
    public static Opportunity opportunityRecord;
    public static User user;
    public static SObject activityRecord; 
    public static SObject queueActivityRecord;
    
    @testSetup 
    static void testSetupMethod() {
        FNS_TestDataSetup testData = new FNS_TestDataSetup();
        user = testData.createUser('test@tes999.com');
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
    static void setup(){
        FNS_TestDataSetup testsetup = new FNS_TestDataSetup();
        accountRecord = testsetup.createAccount('TestAccount01');
        insert accountRecord;
        
        opportunityRecord = testsetup.createOpportunityRecord(accountRecord.Id);
        opportunityRecord.FNS_ApplicationExtId__c = '105360';
        insert opportunityRecord;
        
        activityRecord =testsetup.createActivityRecord();
        insert activityRecord; 
        
        queueActivityRecord = testsetup.createApplicationWithQueueActivityRecord(activityRecord.Id, '17422', '105360');
        insert queueActivityRecord;
    }
    /*
     * Test method to cover Get callout
     */ 
    @isTest static void testGETCallout() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        setup();
        test.startTest();
        HttpResponse valueReceived = FNS_ApplicationWithQueueActivityDomain.getActivitiesForApplication(opportunityRecord.FNS_ApplicationExtId__c);
        test.stopTest();
        System.assertNotEquals(null, valueReceived);
        }
    }
    
    /*
     * Test method to cover Get callout
     */ 
    @isTest static void testPUTCallout() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        User rm = [Select Id, FNS_UserExternalId__c from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        setup();
        test.startTest();
        FNS_ApplicationWithQueueActivityDomain.routeActivityForApplication('17422', rm, 'test notes', opportunityRecord);
        test.stopTest();
        }
    }
    
}