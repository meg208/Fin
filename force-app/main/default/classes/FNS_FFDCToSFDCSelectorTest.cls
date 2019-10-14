/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Test Class
  * @description This class is used as test class for FNS_FFDCToSFDCSelector class.
****************************************************************************************/
@isTest
public class FNS_FFDCToSFDCSelectorTest {
    
    public static FNS_FFDCSFDCSetup__c  fdctosfdcsetup;
    public static List<FNS_FFDCSFDCSetup__c>  ffdctoSfdcRecordList;
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
    
    static void setup() {
        FNS_FFDCSFDCSetup__c fdctosfdcsetup = new FNS_FFDCSFDCSetup__c();
        ffdctoSfdcRecordList = new List<FNS_FFDCSFDCSetup__c>();
        fdctosfdcsetup.FNS_ConsumerKey__c = 'Test Consumer Key';
        fdctosfdcsetup.FNS_ConsumerSecret__c = 'Test Consumer Secret';
        fdctosfdcsetup.FNS_OrganisationId__c = 'Test Organisation Id';
        fdctosfdcsetup.FNS_RedirectURI__c = 'Test Redirect Uri';
        ffdctoSfdcRecordList.add(fdctosfdcsetup);
    }
    
    static testMethod void getAllRecords() {
        User usr = [Select id from User where Username ='test@tes999.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            Test.stopTest();
            new FNS_FFDCToSFDCSelector(true);
            List<FNS_FFDCSFDCSetup__c> ffdctoSfdcRecordList = new FNS_FFDCToSFDCSelector().getAllRecords();
            System.assertNotEquals(ffdctoSfdcRecordList, null);
        }
    }
}