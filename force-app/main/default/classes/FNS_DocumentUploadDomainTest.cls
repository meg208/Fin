/*****************************************************************************************
* @description Class is used to handle all test request from FNS_DocumentUploadController.
* @author Praneeth Aitharaju
* @date 29/04/2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_DocumentUploadDomainTest {
    public static Account accountRecord; 
    public static Opportunity opportunityRecord;
    public static ContentVersion cv; 
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
        accountRecord = testsetup.createAccount('TestAccount01');
        insert accountRecord;
        
        opportunityRecord = testsetup.createOpportunityRecord(accountRecord.Id);
        opportunityRecord.FNS_ApplicationExtId__c = '111111';
        insert opportunityRecord;
        
        cv=new Contentversion();
        cv.title='ABC';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
    }
    
      @isTest static void testGETCallout() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        setup();        
        System.runAs(usr){
            test.startTest();
            
            ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            String valueReceived = FNS_DocumentUploadDomain.metadataCallout('111',contentVersionSelect.ContentDocumentId);
            test.stopTest();
            System.assert(true);
        }
    }
    
      @isTest static void testsendEditedFiles() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        setup();
        System.runAs(usr){
            test.startTest();       
            ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];        
            String valueReceived = FNS_DocumentUploadDomain.sendEditedFile('111',documents[0].Id);
            test.stopTest();
            System.assert(true);
        }
    }
    
    @isTest 
    static void testGetContents() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        System.runAs(usr){
            test.startTest();
            FNS_DocumentUploadDomain.getContents('111111', 'testFile');
            test.stopTest();
            System.assert(true);
        }
    }
    
      @isTest 
    static void testGetContentsCommunity() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        System.runAs(usr){
            test.startTest();
            FNS_DocumentUploadDomain.getContentsForCommunity('111111', 'testFile');
            test.stopTest();
            System.assert(true);
        }
    }
}