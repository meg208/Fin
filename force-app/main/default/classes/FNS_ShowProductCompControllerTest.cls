/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_ShowProductCompController
****************************************************************************/
@isTest
private class FNS_ShowProductCompControllerTest { 
    
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
    * @description: This Method is used to validate the getAllRelatedProductsForWrapper method.
    */ 
    static testMethod void getAllRelatedProductsForWrapperTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
            List<FNS_ShowProductCompController.FNS_ProductWrapper> productList = FNS_ShowProductCompController.getAllRelatedProductsForWrapper(opportunityRecord.Id);
            System.assertNotEquals(productList, null);
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the getListViews method.
    */
    static testMethod void getListViewsTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
            FNS_ShowProductCompController.FNS_ListViewWrapper listViewWrapperObject =  FNS_ShowProductCompController.getListViews();
            System.assertNotEquals(listViewWrapperObject, null);
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the deleteProduct method.
    */
    static testMethod void deleteProductTest() {
        String productIdValue;
        String productObjName = '';
        
        String baseNamespace = FNS_Util.getBasePackageNamepace();
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
                productObjName = 'FinServ__FinancialAccount__c'; 
                productIdValue = fscProductRecord.Id;
            }else {
                setupNonFSC();
                productObjName = baseNamespace+'FNS_FinancialAccount__c' ;
                productIdValue = productRecord.Id;
            }
            
            FNS_ShowProductCompController.deleteProduct(productIdValue);
            String query = 'SELECT Id FROM ' + productObjName + ' Where Id = :productIdValue';
            List<sObject> sobjList = Database.query(query);
            System.assertEquals(sobjList.isEmpty(), true);
            Test.stopTest();
        }
    }
    /**
    * @description: This Method is used to validate the editProduct method.
    */
    static testMethod void editProductTest() {
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
            FNS_ShowProductCompController.FNS_ProductWithChildWrapper  wrapperObject =  FNS_ShowProductCompController.editProduct(productIdValue);
            System.assertNotEquals(wrapperObject, null);
            Test.stopTest();
        }
    }
}