/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_SubmitApplicationCompController
****************************************************************************/
@isTest
private class FNS_SubmitApplicationCompControllerTest { 
    
    public static Account accountRecord; 
    public static Opportunity  opportunityRecord;
    public static FNS_FinancialAccount__c productRecord;
    public static FNS_Fee__c nonFSCfeeRecord;
    public static FNS_Pricing__c nonFSCpricingRecord;
    public static FNS_FinancialAccountRole__c roleRecord;
    public static FNS_FinancialAccountTransaction__c nonFSCLoanRecord;
    public static SObject fscProductRecord;
    public static SObject fscFeeRecord;
    public static SObject fscPricingRecord;
    public static SObject fscRoleRecord;
    public static SObject fscLoanRecord;
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
    
    static void setupNonFSC() {
        FNS_TestDataSetup test = new FNS_TestDataSetup();
        accountRecord = test.createAccount('TestAccount01');
        accountRecord.FNS_CustomerExtId__c = '100127';
        insert accountRecord;
        
        opportunityRecord = test.createOpportunityRecord(accountRecord.Id);
        opportunityRecord.FNS_ApplicationExtId__c = '100179';
        insert opportunityRecord;
        
        productRecord = test.createProductRecord(opportunityRecord.Id);
        insert productRecord;
        
        nonFSCfeeRecord = test.createFeeRecord(productRecord.Id);
        insert nonFSCfeeRecord;
        
        nonFSCpricingRecord = test.createPricingRecord(productRecord.Id);
        insert nonFSCpricingRecord;
        
        roleRecord = test.createProductRoleRecord(productRecord.Id);
        insert roleRecord;
        
        nonFSCLoanRecord = test.createLoanRecord(productRecord.Id);
        insert nonFSCLoanRecord;
    }
    
    static void setupFSC() {
        FNS_TestDataSetup test = new FNS_TestDataSetup();
        accountRecord = test.createAccount('TestAccount01');
        accountRecord.FNS_CustomerExtId__c = '100127';
        insert accountRecord;
        
        opportunityRecord = test.createOpportunityRecord(accountRecord.Id);
        opportunityRecord.FNS_ApplicationExtId__c = '100179';
        insert opportunityRecord;
        
        fscProductRecord = test.createFSCProductRecord(opportunityRecord.Id, accountRecord.Id);
        insert fscProductRecord;
        
        fscFeeRecord = test.createFSCFeeRecord(fscProductRecord.Id);
        insert fscFeeRecord;
        
        fscPricingRecord = test.createFSCPricingRecord(fscProductRecord.Id);
        insert fscPricingRecord;
        
        fscRoleRecord = test.createFSCProductRoleRecord(fscProductRecord.Id, accountRecord.Id);
        insert fscRoleRecord;
        
        fscLoanRecord = test.createFSCLoanRecord(fscProductRecord.Id);
        insert fscLoanRecord;
    }
    /**
    * @description: This Method is used to validate the getApplicationProductCount method.
    */ 
    static testMethod void getApplicationProductCountTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
            
            FNS_SubmitApplicationCompController.FNS_SubmitAppConditionWrapper result = FNS_SubmitApplicationCompController.verifyApplicationConditions(opportunityRecord.Id);
            Test.stopTest();
            System.assert(result.productCount > 0);
        }
    }
    /**
    * @description: This Method is used to validate the submitApplication method.
    */
    static testMethod void submitApplicationTest() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
            
            Test.startTest();
            FNS_SubmitApplicationCompController.submitApplication(opportunityRecord.Id);
            Test.stopTest();
            
            Account acc = [Select Id, FNS_CustomerExtId__c From Account Where Id =:accountRecord.Id ];
            System.assertEquals('100127', acc.FNS_CustomerExtId__c);
            
            Opportunity opp = [Select Id, FNS_ApplicationExtId__c From Opportunity Where Id =:opportunityRecord.Id ];
            System.assertEquals('100179', opp.FNS_ApplicationExtId__c);
        }
    }

}