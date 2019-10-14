/*****************************************************************************************
* @description This class is test class to cover FNS_PredictiveAnalyticsController
* @author Kavya Papasani
* @date April 26 2019
* @Support Email kavya@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_PredictiveAnalyticsControllerTest {
    public static FNS_PredictiveAnalytics__c predAnalyticsObj; 
    public static SObject loanRecord; 
    public static SObject productRecord; 
    public static Account accountRecord; 
    public static Opportunity appRecord; 
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
    /* Test method to cover getRecords method */
    @isTest static void testGetRecords(){
        FNS_TestDataSetup testsetup = new FNS_TestDataSetup();
        Object res;
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){ 
            accountRecord = testsetup.createAccount('ABC Company'); 
            insert accountRecord; 
            appRecord = testsetup.createOpportunityRecord(accountRecord.Id); 
            insert apprecord; 
            if(FNS_Util.isFSCInstalled){
                productRecord = testsetup.createFSCProductRecord(appRecord.Id, accountRecord.Id); 
                insert productRecord; 
                loanRecord = testsetup.createFSCLoanRecord(productRecord.Id); 
                insert loanRecord;   
            }
            else {
                productRecord = testsetup.createProductRecord(appRecord.Id); 
                insert productRecord; 
                loanRecord = testsetup.createLoanRecord(productRecord.Id); 
                insert loanRecord;  
            }
            
            predAnalyticsObj = testsetup.createPredictiveAnalyticsRecord(loanRecord.Id, accountRecord.Id, productRecord.Id); 
            insert predAnalyticsObj;
            test.startTest(); 
            res = FNS_PredictiveAnalyticsController.getRecords(); 
            test.stopTest(); 
        }
        system.assertNotEquals(null, res);
    }
    
    /* Test method to cover getListviews method */
    @isTest static void testgetListviews(){
        List<ListView> listviews = new List<ListView>(); 
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){ 
            test.starttest(); 
            listviews = FNS_PredictiveAnalyticsController.getListViews(); 
            test.stopTest(); 
        }
        system.assertNotEquals(null, listViews);
    }
}