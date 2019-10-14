/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_ProductRolesSelector
****************************************************************************/
@isTest
private class FNS_ProductRolesSelectorTest { 
    public static FNS_FinancialAccountRole__c roleRecord;    
    public static FNS_FinancialAccount__c productRecord;    
    public static Opportunity  opportunityRecord;    
    public static Account accountRecord;
    public static SObject fscProductRecord;
    public static SObject fscRoleRecord;
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
	
    static void setupNonFSC() {
        FNS_TestDataSetup test = new FNS_TestDataSetup();
        accountRecord = test.createAccount('TestAccount01');
        insert accountRecord;
        
        opportunityRecord = test.createOpportunityRecord(accountRecord.Id);
        insert opportunityRecord;
        
        productRecord = test.createProductRecord(opportunityRecord.Id);
        insert productRecord;
        
        roleRecord = test.createProductRoleRecord(productRecord.Id);
        insert roleRecord;
    }
	
	static void setupFSC() {
        FNS_TestDataSetup test = new FNS_TestDataSetup();
        accountRecord = test.createAccount('TestAccount01');
        insert accountRecord;
        
        opportunityRecord = test.createOpportunityRecord(accountRecord.Id);
        insert opportunityRecord;
        
        fscProductRecord = test.createFSCProductRecord(opportunityRecord.Id, accountRecord.Id);
        insert fscProductRecord;
        
        fscRoleRecord = test.createFSCProductRoleRecord(fscProductRecord.Id, accountRecord.Id);
        insert fscRoleRecord;
    }
	
    static testMethod void getAllProductsTest() {
        User usr = [Select id from User where Username ='test@tes999.com'];
        
        System.runAs(usr){
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
            Test.startTest();
            List<Sobject> allProducts =  new FNS_ProductRolesSelector().getAllProducts();
            System.assertNotEquals(allProducts, null);
            Test.stopTest();
        }
    }
    static testMethod void getProductRolesTest() {
		User usr = [Select id from User where Username ='test@tes999.com'];
        Set<Id> productIdSet = new Set<Id>();
        
        System.runAs(usr){
            if(FNS_Util.isFSCInstalled){
                setupFSC();
                productIdSet.add(fscProductRecord.Id);
            }else {
                setupNonFSC();
                productIdSet.add(productRecord.Id);
            }
            Test.startTest();
            List<Sobject> productRoles =  new FNS_ProductRolesSelector().getProductRoles(productIdSet);
            System.assertNotEquals(productRoles, null);
            Test.stopTest();
		}
    }
    static testMethod void getProductRolesWithParentsInfoTest() {
        User usr = [Select id from User where Username ='test@tes999.com'];
        Set<Id> productIdSet = new Set<Id>();
        System.runAs(usr){
            if(FNS_Util.isFSCInstalled){
                setupFSC();
                productIdSet.add(fscProductRecord.Id);
            }else {
                setupNonFSC();
                productIdSet.add(productRecord.Id);
            }
            Test.startTest();
            List<Sobject> productRolesWithParentsInfo =  new FNS_ProductRolesSelector().getProductRolesWithParentsInfo(productIdSet);
            System.assertNotEquals(productRolesWithParentsInfo, null);
            Test.stopTest();
        }
    }
}