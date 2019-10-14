/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_ProductsSelector
****************************************************************************/
@isTest
private class FNS_ProductsSelectorTest { 
    
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
        insert accountRecord;
        
        opportunityRecord = test.createOpportunityRecord(accountRecord.Id);
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
        insert accountRecord;
        
        opportunityRecord = test.createOpportunityRecord(accountRecord.Id);
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
    * @description: This Method is used to validate the getAllProducts method.
    */ 
    static testMethod void getAllProductsTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
            List<Sobject> productList =  new FNS_ProductsSelector().getAllProducts();
            System.assertNotEquals(productList, null);
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the selectProductsWithChilds method.
    */
    static testMethod void selectProductsWithChildsTest() {
        List<Sobject> productWithChildrenList = new List<Sobject>();
        Set<Id> productIdSet = new Set<Id>();
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
                productIdSet.add(fscProductRecord.Id);
            }else {
                setupNonFSC();
                productIdSet.add(productRecord.Id);
            }
			
            productWithChildrenList =  new FNS_ProductsSelector().selectProductsWithChilds(productIdSet);
            System.assertNotEquals(productWithChildrenList, null);
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the selectProductsWithLoans method.
    */
    static testMethod void selectProductsWithLoansTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
			
            List<Sobject> productWithLoansList =  new FNS_ProductsSelector().selectProductsWithLoans((String)opportunityRecord.Id);
            System.assertNotEquals(productWithLoansList, null);
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the selectProductsWithFee method.
    */
    static testMethod void selectProductsWithFeeTest() {
        List<Sobject> productWithLoansList = new List<Sobject>();
        String productIdValue;
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
                productIdValue = (String)fscProductRecord.Id;
            }else {
                setupNonFSC();
                productIdValue = (String)productRecord.Id;
            }
			
            productWithLoansList =  new FNS_ProductsSelector().selectProductsWithFee(productIdValue);
            System.assertNotEquals(productWithLoansList, null);
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the selectProductWithChilds method.
    */
    static testMethod void selectProductWithChildsTest() {
        List<Sobject> productWithChildrenList = new List<Sobject>();
        Set<Id> productIdSet = new Set<Id>();
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
                productIdSet.add(fscProductRecord.Id);
            }else {
                setupNonFSC();
                productIdSet.add(productRecord.Id);
            }
			
            productWithChildrenList =  new FNS_ProductsSelector().selectProductWithChilds(productIdSet);
            System.assertNotEquals(productWithChildrenList, null);
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the selectApplicationProductWithChilds method.
    */
    static testMethod void selectApplicationProductWithChildsTest() {
        List<Sobject> productWithChildrenList = new List<Sobject>();
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
			
            productWithChildrenList =  new FNS_ProductsSelector().selectApplicationProductWithChilds(new Set<Id>{opportunityRecord.Id});
            System.assertNotEquals(productWithChildrenList, null);
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the selectProductsWithChilds method.
    */
    static testMethod void selectProductsWithChildsFSCTest() {
        List<Sobject> productWithChildrenList = new List<Sobject>();
        Set<Id> productIdSet = new Set<Id>();
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
                productIdSet.add(fscProductRecord.Id);
            }else {
                setupNonFSC();
                productIdSet.add(productRecord.Id);
            }
			
            productWithChildrenList =  new FNS_ProductsSelector().selectProductsWithChilds(productIdSet);
            System.assertNotEquals(productWithChildrenList, null);
            Test.stopTest();
        }
    }
    
}