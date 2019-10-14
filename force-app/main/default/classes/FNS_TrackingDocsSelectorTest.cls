/*****************************************************************************************
* @description Class is used to handle all DML requests from FNS_DocumentUploadController.
* @author Praneeth Aitharaju
* @date 29/04/2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/

@isTest
public class FNS_TrackingDocsSelectorTest {
    public static User userRecord;   
    public static Account accountRecord;   
    public static Opportunity  opportunityRecord;
    public static Task taskRecord;
    public static ContentVersion cv; 
    public static FNS_TrackingDocs__c docs; 
    public static User User; 
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
        
        cv=new Contentversion();
        cv.title='ABC';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;  
        
        docs = new FNS_TrackingDocs__c();
        docs.FNS_ApplicationExtId__c = '11111';
        docs.FNS_CustomerExtId__c = '11111';
        docs.FNS_DocumentExtId__c = '11111';
        docs.FNS_FileName__c  = 'test';   
        
        insert docs;
        
    }
    
    /*****************************************************************************************
* @description This test method is  for  selectById method on selector 
* @author Praneeth Aitharaju
* @date April 24 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
    static testMethod void selectByIdTest() {
        List<FNS_TrackingDocs__c> taskList = new List<FNS_TrackingDocs__c>(); 
        User usr = [Select id from User where Username ='test@tes111.com'];
        setup();
        System.runAs(usr){
            Test.startTest();
            taskList = new FNS_TrackingDocsSelector().selectById(new Set<Id>{docs.Id});
            Test.stopTest();
        }
        System.assertNotEquals(taskList, null);
        
    }
    
    /*****************************************************************************************
* @description This test method is  for  selectById method on selector 
* @author Praneeth Aitharaju
* @date April 24 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
    static testMethod void getTasks() {
        List<FNS_TrackingDocs__c> taskList = new List<FNS_TrackingDocs__c>(); 
        User usr = [Select id from User where Username ='test@tes111.com'];
        setup();
        System.runAs(usr){
            Test.startTest();
            taskList = new FNS_TrackingDocsSelector().getTasks(OpportunityRecord.Id);
            Test.stopTest();
            
        }
        System.assertNotEquals(taskList, null);
        
    }
    
    /*****************************************************************************************
* @description This test method is  for  selectById method on selector 
* @author Praneeth Aitharaju
* @date April 24 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
    static testMethod void getTasksbysetofApplications() {
        List<FNS_TrackingDocs__c> taskList = new List<FNS_TrackingDocs__c>(); 
        User usr = [Select id from User where Username ='test@tes111.com'];
        setup();
        System.runAs(usr){
            Test.startTest();
            taskList = new FNS_TrackingDocsSelector().getTasksbysetofApplications(new Set<String>{'1111'});
            Test.stopTest();
            
        }
        System.assertNotEquals(taskList, null);
        
    }
}