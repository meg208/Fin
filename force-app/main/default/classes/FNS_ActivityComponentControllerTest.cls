/*****************************************************************************************
* @description This class is test class for FNS_ActivityComponentController
* @author Kavya Papasani
* @date April 26 2019
* @Support Email kavya@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_ActivityComponentControllerTest {
 
    public static Opportunity appRecord; 
    public static Account accountRecord; 
    public static SObject activityRecord;
    public static SObject queueActivityRecord;
    public static User userRecord; 
    public static User user; 

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
        
        accountRecord = testsetup.createAccount('ABC Company'); 
        insert accountRecord; 
        appRecord = testsetup.createOpportunityRecord(accountRecord.Id);
        insert appRecord; 
        
        activityRecord = testsetup.createActivityRecord(); 
        insert activityRecord; 
        
        queueActivityRecord = testsetup.createApplicationWithQueueActivityRecord(activityRecord.Id, '10028','ExtId'); 
        insert queueActivityRecord;
        
       
    }
    
    /* Test method to test initializeApis method */ 
    @isTest static void testInitializeAPIs(){
        
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        test.startTest();
        setup();
        //String appId = FNS_ActivityComponentController.initiateApplicationAPIs(appRecord.Id);
        test.stopTest(); 
		//System.assertNotEquals(null, appId);
       }
    }
    
    /*Test method to test getAllActivities method */
    @isTest static void testGetAllActivities(){
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        test.startTest(); 
        setup();
        Object result = FNS_ActivityComponentController.getAllActivities(appRecord.FNS_ApplicationExtId__c); 
        test.stopTest(); 
        System.assertNotEquals(null, result);
        }
    }
    
    /*Test method to test getPutCalloutResponse method */
    @isTest static void testPutCallout(){
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        
         User rm = [Select Id, FNS_UserExternalId__c from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        test.startTest(); 
        setup(); 
        String result = FNS_ActivityComponentController.getPutCalloutResponse('100028', rm, 'test notes', appRecord.Id); 
        test.stopTest(); 
        System.assertEquals(null, result); 
        }
    }
    
}