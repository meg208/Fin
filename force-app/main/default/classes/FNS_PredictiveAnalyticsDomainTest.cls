/*****************************************************************************************
* @description This class is test class for FNS_PredictiveAnalyticsDomain
* @author Kavya Papasani
* @date April 26 2019
* @Support Email kavya@comitydesigns.com
******************************************************************************************/
@IsTest
public class FNS_PredictiveAnalyticsDomainTest {
    
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
    /*
     * Test method to cover get Callout 
     */
    @isTest static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        SObject LoanRecord; 
        FNS_TestDataSetup testsetup = new FNS_TestDataSetup(); 
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
        Account accountRecord = testsetup.createAccount('Neptune Inc'); 
        insert accountRecord; 
        
        Opportunity applicationRecord = testsetup.createOpportunityRecord(accountRecord.Id); 
        insert applicationRecord;
        
        if(FNS_Util.isFSCInstalled){
            SObject fscProductRecord = testsetup.createFSCProductRecord(applicationRecord.Id, accountRecord.Id);
            fscProductRecord.put('Name', '50MM Revolver');
            insert fscProductRecord; 
            
            LoanRecord = testsetup.createFSCLoanRecord(fscProductRecord.Id); 
            LoanRecord.put('FNS_Account__c', accountRecord.Id);
            LoanRecord.put('FNS_FinancialAccountTransactionExtId__c', '567567');
             
            insert LoanRecord; 
        }
        else{
            SObject nonfscProductRecord = testsetup.createProductRecord(applicationRecord.Id); 
             nonfscProductRecord.put('Name', '50MM Revolver');
            insert nonfscProductRecord; 
            
            LoanRecord = testsetup.createLoanRecord(nonfscProductRecord.Id);
            LoanRecord.put('FNS_Account__c', accountRecord.Id);
            LoanRecord.put('FNS_FinancialAccountTransactionExtId__c', '567567');
            insert LoanRecord;
        }
        
        test.startTest();
        FNS_PredictiveAnalyticsDomain.getConfigurations();
        test.stopTest();
        }
        FNS_PredictiveAnalytics__c obj = [Select Id from FNS_PredictiveAnalytics__c limit 1]; 
        System.assertNotEquals(null, obj);
    }
    
}