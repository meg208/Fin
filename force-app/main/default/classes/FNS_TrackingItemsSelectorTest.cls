/*****************************************************************************************
* @description This class is test class for  FNS_ApplicationWithQueueActivitySelector 
* @author Praneeth Aitharaju
* @date April 24 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_TrackingItemsSelectorTest {
    public static User userRecord;   
	public static Account accountRecord;   
    public static Opportunity  opportunityRecord;
    public static Task taskRecord;
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

        userRecord = test.createUser('Testtrac@trtest.com');
        insert userRecord;

        accountRecord = test.createAccount('TestAccount01');
        insert accountRecord;
           
        opportunityRecord = test.createOpportunityRecord(accountRecord.Id);
        insert opportunityRecord;
        
        taskRecord = test.createTaskRecord(opportunityRecord.Id);
        insert taskRecord;
         
    }
     /*****************************************************************************************
        * @description This test method is  for  selectById method on selector 
        * @author Praneeth Aitharaju
        * @date April 24 2019
        * @Support Email praneeth.aitharaju@comitydesigns.com
        ******************************************************************************************/
    static testMethod void selectByIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        setup();
        System.runAs(usr){
            Test.startTest();
            List<Task> taskList = new FNS_TrackingItemsSelector().selectById(new Set<Id>{taskRecord.Id});
            Test.stopTest();
            System.assertNotEquals(taskList, null);
        }
        
    }
        /*****************************************************************************************
        * @description This class is  for  getAllItems method on selector
        * @author Praneeth Aitharaju
        * @date April 24 2019
        * @Support Email praneeth.aitharaju@comitydesigns.com
        ******************************************************************************************/
     static testMethod void getAllItemsTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        setup();
        System.runAs(usr){
            Test.startTest();
            List<Task> taskList = new FNS_TrackingItemsSelector().getAllItems(opportunityRecord.Id);
            Test.stopTest();
            System.assertNotEquals(taskList, null);
        }
    }

     /*****************************************************************************************
        * @description This class is  for  updateUser method on selector
        * @author Praneeth Aitharaju
        * @date April 24 2019
        * @Support Email praneeth.aitharaju@comitydesigns.com
        ******************************************************************************************/
    static testMethod void updateUserTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        setup();
        System.runAs(usr){
            Test.startTest();
         		List<Task> taskList = new FNS_TrackingItemsSelector().updateUser(taskRecord.Id,userRecord.Id);
            Test.stopTest();
            System.assertNotEquals(taskList, null);
        }
    }
}