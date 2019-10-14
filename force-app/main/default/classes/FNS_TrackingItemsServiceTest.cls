/*****************************************************************************************
* @description Test class to test FNS_TrackingItemsService
* @author Kavya Papasani
* @date Apr 29 2019
* @Support Email kavya@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_TrackingItemsServiceTest {
    public static Task taskRecord; 
    public static Account accountRecord; 
    public static Opportunity opportunityRecord;  
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
    static void setup(){
        FNS_TestDataSetup testsetup = new FNS_TestDataSetup(); 
        accountRecord = testsetup.createAccount('ABC Company'); 
        insert accountRecord; 
        opportunityRecord = testsetup.createOpportunityRecord(accountRecord.Id); 
        insert opportunityRecord;
        taskRecord = testsetup.createTaskRecord(opportunityRecord.Id); 
    }
    
    /* Test Method to test insertRecords method */
    @isTest static void testInsertRecords(){
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            setup();
            taskRecord.FNS_CustomerExtIds__c = '12, 13, 14';
            List<Task> taskList = new List<Task>(); 
            taskList.add(taskRecord);  
            test.startTest(); 
            FNS_TrackingItemsService service = new FNS_TrackingItemsService(); 
            service.insertRecords(taskList);
            test.stopTest(); 
        }
        List<Task> records = [Select Id from Task]; 
        System.assertNotEquals(0, records.size());
    }
    
    /* Test Method to test updateRecords method */ 
    @isTest static void testUpdateRecords(){
        Task rec = new Task(); 
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            setup(); 
            insert taskRecord; 
            
            rec.Id = taskRecord.Id; 
            
            test.startTest();
            rec.Status = 'In Progress'; 
            
            FNS_TrackingItemsService service = new FNS_TrackingItemsService(); 
            service.updateRecords(rec);
            test.stopTest(); 
        }
        System.assertEquals('In Progress', rec.Status);
    }
    
    /* Test Method to test deleteRecords method */ 
    @isTest static void testDeleteRecords(){
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            setup(); 
            insert taskRecord; 
            List<Task> taskList = new List<Task>(); 
            taskList.add(taskRecord);
            
            test.startTest();
            FNS_TrackingItemsService service = new FNS_TrackingItemsService(); 
            service.deleteRecords(taskList);
            test.stopTest(); 
        }
        List<Task> records = [Select Id from Task]; 
        System.assertEquals(0, records.size());
    }
    
}