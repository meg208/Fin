/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_LoansSelector
****************************************************************************/
@isTest
private class FNS_LoansSelectorTest {
    
    public static Account accRecord;
    public static Opportunity oppRecord;
    public static FNS_FinancialAccount__c finAccRecord;
    public static FNS_FinancialAccountTransaction__c  loanRecord;
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
        
        accRecord = test.createAccount('Test Account 001');
        insert accRecord;
 
        oppRecord = test.createOpportunityRecord(accRecord.Id);
        insert oppRecord;
        
        finAccRecord = test.createProductRecord(oppRecord.Id);
        insert finAccRecord;
        
        loanRecord = test.createLoanRecord(finAccRecord.Id);
        insert loanRecord;
    }
    
    static testMethod void getAllProductsTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<Sobject> allProducts =  new FNS_LoansSelector().getAllProducts();
            System.assertNotEquals(allProducts, null);
            Test.stopTest();
        }
    }
    static testMethod void getLoanDetailsWithFilterTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<sObject> loanList = new FNS_LoansSelector().getLoanDetailsWithFilter(0,'>');
            System.assertNotEquals(loanList, null);
            Test.stopTest();
        }
    }
    static testMethod void getLoansTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<sObject> getloanList = new FNS_LoansSelector().getLoans(new Set<Id>{finAccRecord.Id});
            System.assertNotEquals(getloanList, null);
            Test.stopTest();
        }
    }
    static testMethod void selectLoanNameTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            setup();
            List<sObject> loanNameList = new FNS_LoansSelector().selectLoanName(new List<String>{loanRecord.Id});
            System.assertNotEquals(loanNameList, null);
            Test.stopTest();
        }
    }
    
    static testMethod void getAllProdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            setup();
            Test.startTest();
            List<sObject> loanNameList = new FNS_LoansSelector().getAllProducts();
            System.assertNotEquals(loanNameList, null);
            Test.stopTest();
        }
    }
}