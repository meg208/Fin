/***************************************************************************************
* @description Class This test class is used for FNS_TasksSelector
* @author ANKIT PAL
* @date 04/24/2019
* @Support Email ankit.pal@comitydesigns.com
****************************************************************************************/
@isTest
private class FNS_TasksSelectorTest { 
    public static Task taskRecord;    
    public static Opportunity  opportunityRecord;    
    public static Account accountRecord;    
    public static Contact contactRecord;    
    public static User userRecord;
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
        contactRecord = test.createContact(accountRecord.Id, 'TestContact01');
        insert contactRecord;
        userRecord = test.createUser('abc@brillio.com');
        insert userRecord;
        taskRecord = test.createTaskRecord(opportunityRecord.Id);
        insert taskRecord;
    }
    static testMethod void selectByIdTest() {
        setup();
        List<Task> taskById = new List<Task>();
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            Test.startTest();
            taskById =  new FNS_TasksSelector().selectById(new Set<Id>{taskRecord.Id});
            Test.stopTest();
        }
        System.assertNotEquals(taskById, null);
    }
    static testMethod void selectOpenTasksTest() {
        setup();
        List<Task> openTasks1 = new List<Task>();
        List<Task> openTasks2 = new List<Task>();
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            Test.startTest();
            openTasks1 =  new FNS_TasksSelector().selectOpenTasks(userRecord.Id, opportunityRecord.Id, contactRecord.Id, true);
            openTasks2 =  new FNS_TasksSelector().selectOpenTasks(userRecord.Id, opportunityRecord.Id, contactRecord.Id, false);
            Test.stopTest();
        }
        System.assertNotEquals(openTasks1, null);
        System.assertNotEquals(openTasks2, null);
    }
}