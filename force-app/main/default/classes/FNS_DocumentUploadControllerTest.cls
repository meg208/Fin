/*****************************************************************************************
* @description Class is used to handle all request from FNS_DocumentUploadController.
* @author Praneeth Aitharaju
* @date 29/04/2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_DocumentUploadControllerTest {
    public static User userRecord;   
    public static Account accountRecord;   
    public static Opportunity  opportunityRecord;
    public static Task taskRecord;
    public static ContentVersion cv; 
    public static User user;
    public static FNS_TrackingDocs__c docRecord;
    
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
        opportunityRecord.FNS_ApplicationExtId__c = '111111';
        insert opportunityRecord;
        
        taskRecord = test.createTaskRecord(opportunityRecord.Id);
        insert taskRecord;
        
        docRecord = new FNS_TrackingDocs__c();
        docRecord.Name = 'test';
        docRecord.FNS_TrackingItemExtId__c = 'test';
        docRecord.FNS_FileName__c = 'test';
        docRecord.FNS_DocumentExtId__c = '1111';
        insert docRecord; 
        
        cv=new Contentversion();
        cv.title='ABC';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
    }
    
    @isTest 
    static void testGETCallout() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        setup();
        String appId = OpportunityRecord.Id;
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            test.startTest();
            FNS_DocumentUploadController.getApplicationDocIds(appId);
            test.stopTest();
        }
        System.assert(true);
    }
    
    @isTest 
    static void testFNS_tasks() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        setup();
        String appId = OpportunityRecord.Id;
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            test.startTest();
            FNS_DocumentUploadController.FNS_tasks(appId);
            test.stopTest();
        }
        System.assert(true);
    } 
    
    @isTest 
    static void testsendMetaData() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        setup();
        String appId = OpportunityRecord.Id;
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        String jsonWrapper = '{"OpportunityId":"' + appId + '","documentId":"' + contentVersionSelect.ContentDocumentId + '","trackingid":"153603"}';
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            test.startTest();
            FNS_DocumentUploadController.sendMetaData(jsonWrapper);
            test.stopTest();
        }
        System.assert(true);
    } 
    
    @isTest 
    static void testsendMetaDataCommunity() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        setup();
        String appId = OpportunityRecord.FNS_ApplicationExtId__c;
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        String jsonWrapper = '{"OpportunityExtId":"' + appId + '","documentId":"' + contentVersionSelect.ContentDocumentId + '","trackingid":"153603"}';
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            test.startTest();
            FNS_DocumentUploadController.sendMetaDataCommunity(jsonWrapper);
            test.stopTest();
        }
        System.assert(true);
    } 
    
    @isTest 
    static void testsendEditVals() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        setup();
        String appId = OpportunityRecord.FNS_ApplicationExtId__c;
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            test.startTest();
            FNS_DocumentUploadController.sendEditValues(appId,contentVersionSelect.ContentDocumentId,'1111111','111','test');
            test.stopTest();
        }
        System.assert(true);
    } 
    
    @isTest 
    static void testcallTrackingDocsDomain() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        setup();
        String appId = OpportunityRecord.Id;
        String docExtid = docRecord.FNS_DocumentExtId__c;
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            test.startTest();
            FNS_DocumentUploadController.shareDocument(true,docExtid,appId);
            test.stopTest();
        }
        System.assert(true);
    } 
    
}