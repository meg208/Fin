/*****************************************************************************************
* @description This class is test class for  FNS_ApplicationWithQueueActivitySelector 
* @author Praneeth Aitharaju
* @date April 24 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_TrackingItemsDomainTest {
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
        accountRecord = testsetup.createAccount('TestAccount01');
        insert accountRecord;
        
        opportunityRecord = testsetup.createOpportunityRecord(accountRecord.Id);
        opportunityRecord.FNS_ApplicationExtId__c = '111111';
        insert opportunityRecord;
    }
   
    /*****************************************************************************************
    * @description This method is test class for  FNS_TrackingItemsDomain
    * @author Praneeth Aitharaju
    * @date April 24 2019
    * @Support Email praneeth.aitharaju@comitydesigns.com
    ******************************************************************************************/
    @isTest static void testGETCallout() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        setup();
        System.runAs(usr){
            test.startTest();
            Object valueReceived = FNS_TrackingItemsDomain.getConfigurations(opportunityRecord.Id);
            test.stopTest();
            System.assert(true);
        }
    }
    
    /*****************************************************************************************
    * @description This method is test class for FNS_TrackingItemsDomain 
    * @author Praneeth Aitharaju
    * @date April 24 2019
    * @Support Email praneeth.aitharaju@comitydesigns.com
    ******************************************************************************************/
     @isTest static void testPOSTCallout() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        setup();
        System.runAs(usr){
            test.startTest();
            String valueReceived = FNS_TrackingItemsDomain.calloutToCME('111111','testbody');
            test.stopTest();
            System.assert(true);
        }
    }
}