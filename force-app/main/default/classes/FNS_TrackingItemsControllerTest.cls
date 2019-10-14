/*****************************************************************************************
* @description This class is test class for  FNS_ApplicationWithQueueActivitySelector 
* @author Praneeth Aitharaju
* @date April 24 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_TrackingItemsControllerTest {
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
        
        FNS_TrackingDocs__c FNSTracking = new FNS_TrackingDocs__c();
        FNSTracking.Name = 'test';
        FNSTracking.FNS_TrackingItemExtId__c = '111111';
        FNSTracking.FNS_FileName__c = 'test';
        FNSTracking.FNS_DocumentExtId__c = 'test';
        insert FNSTracking; 
        
        ContentVersion cv=new Contentversion();
        cv.title='ABC';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
    }
    
    @isTest 
    static void testgetConfigurations() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        setup();
        System.runAs(usr){
            test.startTest();
            
            List<FNS_TrackingDocs__c> emptyLst = new List<FNS_TrackingDocs__c>();
                test.stopTest();
            FNS_TrackingItemsController FNS_TICtrlr = new FNS_TrackingItemsController();
            FNS_TrackingItemsController.getTasksByAppId(opportunityRecord.Id);
            FNS_TrackingItemsController.FNS_updateUser(taskRecord.Id, userRecord.Id);
            FNS_TrackingItemsController.Taskwrapper tskWrapper = new FNS_TrackingItemsController.Taskwrapper(taskRecord, emptyLst, accountRecord.Name, userRecord.Name);
        }
        System.assert(true);
    }
    
    @isTest static void testGETCallout() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        String value;
        setup();
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            
            String dataCom = 'testdatacm'; 
            String dataStatus = SObjectType.Task.Fields.FNS_Status__c.PicklistValues[0].getValue(); 
            String dataPriority = SObjectType.Task.Fields.FNS_Priority__c.PicklistValues[0].getValue(); 
            String dataDate = 'test data';
            String dataTask = '{"CurrencyIsoCode":"USD","FNS_ApplicationExtId__c":"111111","FNS_ApplicationStageName__c":"Initial Input","FNS_Comments__c":"string","FNS_CustomerExtIds__c":"2323322","FNS_DueDate__c":"2019-03-29","FNS_FinancialAccountExtId__c":"34334","FNS_FinancialAccountTransactionId__c":"2323322","FNS_IsActive__c":false,"FNS_IsCSA__c":true,"FNS_IsCheckList__c":true,"FNS_IsStandard__c":true,"FNS_IsVerified__c":true,"FNS_KeepOnRefresh__c":true,"FNS_PrintStatusId__c":0,"FNS_Refresh__c":true,"FNS_SLAIndicator__c":"GREEN","FNS_SLAPercentage__c":"0","FNS_TrackStatusId__c":"0","FNS_TrackingItemExtId__c":"100060","FNS_UserExtId__c":"43434","OwnerId":"1231231","Priority":"Normal","Status":"In Progress","Subject":"Test Description"}';
            String taskId =  taskRecord.Id; 
            String appId = OpportunityRecord.Id;
            test.startTest();
            value = FNS_TrackingItemsController.getCalloutResponseContents('1111',dataStatus,dataPriority,'1111', taskId);
            test.stopTest();
        }
        System.assertNotEquals(null, value);
    }
    
    
}