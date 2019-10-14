/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_ApplicationSelector 
****************************************************************************/
@isTest
private class FNS_ApplicationSelectorTest { 
        
    public static Account accountRecord;   
    public static Opportunity  opportunityRecord;
    public static FNS_FinancialAccountRole__c roleRecord;
    public static FNS_FinancialAccount__c productRecord;  
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
        accountRecord = test.createAccount('TestAccount01');
        insert accountRecord;
        
        opportunityRecord = test.createOpportunityRecord(accountRecord.Id);
        insert opportunityRecord;
    }
    /**
    * @description: This Method is used to validate the selectById method.
    */ 
    static testMethod void selectByIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            Test.stopTest();
            List<Opportunity> oppList = new FNS_ApplicationSelector().selectById(new Set<Id>{opportunityRecord.Id});
            System.assertNotEquals(oppList, null);
        }
        
    }
    /**
    * @description: This Method is used to validate the selectApplicationById method.
    */ 
    static testMethod void selectApplicationByIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            Test.stopTest();
            List<Opportunity> oppList = new FNS_ApplicationSelector().selectApplicationById(new Set<Id>{opportunityRecord.Id});
            System.assertNotEquals(oppList, null);
        }
        
    }
    /**
    * @description: This Method is used to validate the selectPendingDealsWithTasks method.
    */ 
    static testMethod void selectPendingDealsWithTasksTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            Task taskRecord = new FNS_TestDataSetup().createTaskRecord(opportunityRecord.Id);
            insert taskRecord;
            Test.stopTest();
            
            List<Opportunity> oppList = new FNS_ApplicationSelector().selectPendingDealsWithTasks(new Set<Id>{opportunityRecord.Id}, true, UserInfo.getUserId(), false);
            System.assertNotEquals(oppList, null);
        }
    }
    /**
    * @description: This Method is used to validate the pendingDealsWithTasksByFilter method.
    */ 
    static testMethod void pendingDealsWithTasksByFilterTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            Task taskRecord = new FNS_TestDataSetup().createTaskRecord(opportunityRecord.Id);
            insert taskRecord;
            Test.stopTest();
            
            List<Opportunity> oppList = new FNS_ApplicationSelector().pendingDealsWithTasksByFilter(null, true, UserInfo.getUserId());
            System.assertNotEquals(oppList, null);
        }
    }
    /**
    * @description: This Method is used to validate the selectApplicationWithProducts method.
    */ 
    static testMethod void selectApplicationWithProductsTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            FNS_FinancialAccount__c productRecord = new FNS_TestDataSetup().createProductRecord(opportunityRecord.Id);
            insert productRecord;
            Test.stopTest();
            
            List<Opportunity> oppList = new FNS_ApplicationSelector().selectApplicationWithProducts(new Set<Id>{opportunityRecord.Id});
            System.assertNotEquals(oppList, null);
        }
    }
    /**
    * @description: This Method is used to validate the selectByApplicationtage method.
    */ 
    static testMethod void selectByApplicationtageTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<Opportunity> oppList = new FNS_ApplicationSelector().selectByApplicationtage('Proposal', UserInfo.getUserId());
            Test.stopTest();
            System.assertNotEquals(oppList, null);
            System.assertEquals(oppList[0].Id, opportunityRecord.Id);
        }
    }
    /**
    * @description: This Method is used to validate the getRestrictedDispositionValues method.
    */ 
    static testMethod void getRestrictedDispositionValuesTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            FNS_AdminConfiguration__c adminConfig = new FNS_AdminConfiguration__c();
            adminConfig.FNS_RestrictedDispositionValues__c = 'Proposal;Initial Input';
            insert adminConfig;
            
            Set<String> valueSet = new FNS_ApplicationSelector().getRestrictedDispositionValues();
                
            System.assertNotEquals(valueSet, null);
        }
    }
    /**
    * @description: This Method is used to validate the selectByExternalId method.
    */ 
    static testMethod void selectByExternalIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<Opportunity> oppList = new FNS_ApplicationSelector().selectByExternalId(new Set<String>{opportunityRecord.FNS_ApplicationExtId__c});
            System.assertNotEquals(oppList, null);
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the getApplicationId method.
    */ 
    static testMethod void getApplicationIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<Opportunity> oppList = new FNS_ApplicationSelector().getApplicationId((String)opportunityRecord.Id);
            
            System.assertNotEquals(oppList, null);
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the getApplicationRecordType method.
    */ 
    static testMethod void getApplicationRecordTypeTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            
            setup();
            Map<String, String> getApplicationRecordType = new FNS_ApplicationSelector().getApplicationRecordType(new Set<String>{opportunityRecord.Id});
            System.assertNotEquals(getApplicationRecordType, null);
            
            Test.stopTest();
            
        }
    }
}