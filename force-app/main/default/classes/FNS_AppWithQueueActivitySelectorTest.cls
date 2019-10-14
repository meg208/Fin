/*****************************************************************************************
* @description This class is test class for  FNS_ApplicationWithQueueActivitySelector 
* @author Kavya Papasani
* @date April 24 2019
* @Support Email kavya@comitydesigns.com
******************************************************************************************/
@IsTest
public class FNS_AppWithQueueActivitySelectorTest {
 	public static SObject activityRecord; 
    public static SObject appWithQueueActivityRecord; 
    public static User user; 
    public static Contact contactRecord; 
    public static Account accountRecord; 
    public static Opportunity applicationRecord; 

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
    static void setup() {
        FNS_TestDataSetup test = new FNS_TestDataSetup();
        activityRecord = test.createActivityRecord();
        insert activityRecord;
        
        appWithQueueActivityRecord = test.createApplicationWithQueueActivityRecord(activityRecord.Id, '10028','ExtId'); 
        insert appWithQueueActivityRecord; 
        
        accountRecord = test.createAccount('ABC company'); 
        insert accountRecord; 

        contactRecord = test.createContact(accountRecord.Id, 'contactName'); 
        insert contactRecord; 

        applicationRecord = test.createOpportunityRecord(accountRecord.Id); 
        insert applicationRecord; 
        
        
    }
    /**
    * @description: This Method is used to validate the selectById method.
    */
    static testMethod void selectByIdTest() {
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        Test.startTest();
        setup();
        Test.stopTest();
        List<SObject> appList = new FNS_ApplicationWithQueueActivitySelector().selectById(new Set<Id>{appWithQueueActivityRecord.Id});
        
        System.assertNotEquals(appList, null);
        }
    }
    /**
    * @description: This Method is used to validate the getAllActivities method.
    */
    static testMethod void getAllqueueActivitiesTest() {
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        Test.startTest();
        setup();
        Test.stopTest();
        List<SObject> appList = new FNS_ApplicationWithQueueActivitySelector().getAllqueueActivities();
        
        System.assertNotEquals(appList, null);
        }
    }

    /**
    * @description: This Method is used to validate the getActivities method.
    */
    static testMethod void getActivitiesRecordsTest() {
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        Test.startTest();
        setup();
        Test.stopTest();
        List<SObject> appList = new FNS_ApplicationWithQueueActivitySelector().getActivitiesRecords('ExtId','appId');
        
        System.assertNotEquals(appList, null);
        }
    }
    /**
    * @description: This Method is used to validate the getActivities method.
    */
    static testMethod void getActivitiesWithApplicationTest() {
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        Test.startTest();
        setup();
        Test.stopTest();
        List<SObject> appList = new FNS_ApplicationWithQueueActivitySelector().getActivitiesWithApplication('appId');
        
        System.assertNotEquals(appList, null);
        }
    }
    /**
    * @description: This Method is used to validate the getActivitiesByApp method.
    */
    static testMethod void getActivitiesByAppTest() {
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        Test.startTest();
        setup();
            Set<Id> oppIdSet = new Set<Id>{applicationRecord.Id};
        Test.stopTest();
        List<SObject> appList = new FNS_ApplicationWithQueueActivitySelector().getActivitiesByApp(oppIdSet);
        
        System.assertNotEquals(appList, null);
        }
    }
    /**
    * @description: This Method is used to validate the getActivitiesByApp method.
    */
    static testMethod void getActivitiesTest() {
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        Test.startTest();
        setup();
        Test.stopTest();
        List<SObject> appList = new FNS_ApplicationWithQueueActivitySelector().getActivitiesfromContact(contactRecord.Id); 
        
        System.assertNotEquals(appList, null);
        }
    }
}