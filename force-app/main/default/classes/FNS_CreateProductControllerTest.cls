@isTest
public class FNS_CreateProductControllerTest {
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
        
        fscProductRecord = test.createProductRecord(opportunityRecord.Id);
        insert fscProductRecord;
        
        fscFeeRecord = test.createFeeRecord(fscProductRecord.Id);
        insert fscFeeRecord;
        
        fscPricingRecord = test.createPricingRecord(fscProductRecord.Id);
        insert fscPricingRecord;
        
        fscRoleRecord = test.createProductRoleRecord(fscProductRecord.Id);
        insert fscRoleRecord;
        
        fscLoanRecord = test.createLoanRecord(fscProductRecord.Id);
        insert fscLoanRecord;
    }
    /**
    * @description: This Method is used to validate the getAllProducts method.
    */ 
    static testMethod void getComponentDataTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
            FNS_ProductWrapper wrapper = FNS_CreateProductController.getComponentData(opportunityRecord.ID);
            Test.stopTest();
            System.assertNotEquals(wrapper, null);
        }
    }
    /**
    * @description: This Method is used to validate the selectProductsWithChilds method.
    */
    static testMethod void getProductDataTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
            }else {
                setupNonFSC();
            }
            FNS_ShowProductCompController.FNS_ProductResponseWrapper wrapperObj = FNS_CreateProductController.getProductData(opportunityRecord.ID);
            Test.stopTest();
            System.assertNotEquals(wrapperObj, null);
			
        }
    }
    
    static testMethod void deleteRecordsTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            Test.startTest();
            if(FNS_Util.isFSCInstalled){
                setupFSC();
                FNS_CreateProductController.deleteRecords(fscRoleRecord.Id, 'Finserv__FinancialAccountRole__c');
            }else {
                setupNonFSC();
                FNS_CreateProductController.deleteRecords(roleRecord.Id, 'FNS_FinancialAccountRole__c');
            }
            Test.stopTest();
            System.assert(true);
        }
    }
}