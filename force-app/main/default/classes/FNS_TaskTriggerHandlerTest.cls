/*****************************************************************************************
* @description Test class to test FNS_TaskTriggerHandler and FNS_TaskTrigger
* @author Kavya Papasani
* @date Apr 29 2019
* @Support Email kavya@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_TaskTriggerHandlerTest {
  public static Task taskRecord; 
  public static Account accountRecord; 
  public static Opportunity opportunityRecord;  
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
        opportunityRecord = testsetup.createOpportunityRecord(accountRecord.Id); 
        insert opportunityRecord;
       
        taskRecord = testsetup.createTaskRecord(opportunityRecord.Id); 

    }
    
    /* Test Method to test DML insert for Task trigger */
  @isTest static void testInsert(){
      User rm = [Select Id from User where Username ='test@tes999.com'];
      List<Task> records = new List<Task>();  
      System.runAs(rm){
        setup();
        taskRecord.FNS_CustomerExtIds__c = '12, 13, 14'; 
        test.startTest(); 
        insert taskRecord; 
        test.stopTest(); 
        records = [Select Id from Task]; 
      }
      System.assertNotEquals(0, records.size());
  }

   /* Test Method to test DML update for Task trigger */ 
  @isTest static void testUpdate(){
     User rm = [Select Id from User where Username ='test@tes999.com'];
      Task rec = new Task();
      System.runAs(rm){
      setup(); 
      insert taskRecord; 
      
      rec.Id = taskRecord.Id; 
      test.startTest();
      rec.Status = 'In Progress'; 
      update rec;
      test.stopTest(); 
      }
      System.assertEquals('In Progress', rec.Status);
  }

}