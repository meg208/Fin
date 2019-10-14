/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description This class handles DML operations for Predictive Analytics
****************************************************************************************/
@isTest
public class FNS_BanksSelectorTest {
   //public static FNS_Bank__c bankRecord; 
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

    static testMethod void getBankRecordsTest() {
        
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        List<FNS_Bank__c> banklist = new List<FNS_Bank__c>(); 
        Set<String> extIds = new Set<String>{'extId'}; 
        System.runAs(rm){
            Test.startTest();
            FNS_BanksSelector selector = new FNS_BanksSelector(); 
            banklist = selector.selectByBankId(extIds); 
            Test.stopTest();   
        }     
        system.assertEquals(0, banklist.size());
    }

    
    static testMethod void selectByIdTest() {
        
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        List<FNS_Bank__c> banklist = new List<FNS_Bank__c>(); 
        FNS_Bank__c bankRecord = new FNS_Bank__c(Name= 'ABC Bank'); 
        //bankRecord.Name = 'ABC Bank'; 
        insert bankRecord;
        Set<Id> extIds = new Set<Id>{bankRecord.Id}; 
        System.runAs(rm){
            Test.startTest();
            FNS_BanksSelector selector = new FNS_BanksSelector(); 
            banklist = selector.selectById(extIds); 
            Test.stopTest();   
        }     
        system.assertEquals(1, banklist.size());
    }


}


