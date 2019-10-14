/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Test class
  * @description This class is used as test class for FNS_FFDCToSFDCService class.
****************************************************************************************/
@isTest
public class FNS_FFDCToSFDCServiceTest {
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
  
    /**
    * @description: This Method is used to validate the insertSFDCToFFDCConfig method.
    */ 
    static testMethod void insertFFDCToSFDCConfigTest() {
        User usr = [Select id from User where Username ='test@tes999.com'];
        
        System.runAs(usr){
        	Test.startTest();
            FNS_FFDCSFDCSetup__c setupObject = new FNS_FFDCSFDCSetup__c();
            setupObject.FNS_ConsumerKey__c = 'Test Consumer Key';
            setupObject.FNS_ConsumerSecret__c = 'Test Consumer Secret';
            setupObject.FNS_OrganisationId__c = 'Test Org Id';
            setupObject.FNS_RedirectURI__c = 'Test Redirect URI';
            
            FNS_FFDCToSFDCService.insertFFDCToSFDCConfig(setupObject);
            
            List<FNS_FFDCSFDCSetup__c> setupDataList = [Select Id From FNS_FFDCSFDCSetup__c];
            System.assertEquals(setupDataList.size(), 1);
            
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the updateFFDCToSFDCConfig method.
    */ 
    static testMethod void updateFFDCToSFDCConfigTest() {
        User usr = [Select id from User where Username ='test@tes999.com'];
        
        System.runAs(usr){
            Test.startTest();
            FNS_FFDCSFDCSetup__c setupObject = new FNS_FFDCSFDCSetup__c();
            setupObject.FNS_ConsumerKey__c = 'Test Consumer Key';
            setupObject.FNS_ConsumerSecret__c = 'Test Consumer Secret';
            setupObject.FNS_OrganisationId__c = 'Test Org Id';
            setupObject.FNS_RedirectURI__c = 'Test Redirect URI';
            insert setupObject;
            
            setupObject.FNS_OrganisationId__c = 'Test Org1 Id';
            FNS_FFDCToSFDCService.updateFFDCToSFDCConfig(setupObject);
            
            Test.stopTest();
            
            FNS_FFDCSFDCSetup__c setupDataObj = [Select Id, FNS_OrganisationId__c From FNS_FFDCSFDCSetup__c];
            System.assertEquals('Test Org1 Id', setupDataObj.FNS_OrganisationId__c);
        }
    }
}