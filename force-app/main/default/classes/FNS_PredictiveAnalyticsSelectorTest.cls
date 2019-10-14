/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description This class handles DML operations for Predictive Analytics
****************************************************************************************/
@isTest
public class FNS_PredictiveAnalyticsSelectorTest {

    public static Account accountRecord;
    public static Contact contactRecord;  
    public static Lead leadRecordWithContact; 
    public static Lead leadRecordWithUser;
    public static User userRecord; 
    public static User user; 
    public static FNS_PredictiveAnalytics__c predAnalyticsRecord; 

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

        accountRecord = test.createAccount('TestAccountLead');
        insert accountRecord;

        contactRecord = test.createContact(accountRecord.Id, 'TestContactLead');
        insert contactRecord;

        userRecord = test.createUser('testLead@abc.com');
        insert userRecord;

        leadRecordWithContact = test.createLeadRecordWithContact(contactRecord.Id);
        insert leadRecordWithContact;

        leadRecordWithUser = test.createLeadRecordWithUser(userRecord.Id);
        insert leadRecordWithUser;

        
    }

    static testMethod void getAllPredictiveAnalytics() {
        
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        List<SObject> predAnalyticsList = new List<SObject>(); 
        List<SObject> predAnalyticsTotalList = new List<SObject>(); 
        setup();   
        System.runAs(rm){
            Test.startTest();
            predAnalyticsList = new FNS_PredictiveAnalyticsSelector().getAllPredictiveAnalytics();   
            predAnalyticsTotalList = new FNS_PredictiveAnalyticsSelector().getPredictiveAnalytics(); 
            Test.stopTest();   
        }     
         System.assertNotEquals(predAnalyticsList, null);
        System.assertNotEquals(predAnalyticsTotalList, null);
    }
}