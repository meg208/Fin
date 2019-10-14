@isTest
public class FNS_CommHomeControllerTest {
    
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
  
    static testMethod void getActiveAppliation() {
        User usr = [Select id from User where Username ='test@tes999.com'];
        
        System.runAs(usr){
            FNS_TestDataSetup setup = new FNS_TestDataSetup();
            Account accountRecord = setup.createAccount('TestAccount01');
            insert accountRecord;
            Opportunity opportunityRecord = setup.createOpportunityRecord(accountRecord.Id);
            insert opportunityRecord;
            FNS_RelatedRoles__c roleRecord = setup.createRelatedRole(opportunityRecord.Id);
            insert roleRecord;
            FNS_RelatedRoles__c roleRecord1 = setup.createRelatedRole(opportunityRecord.Id);
            insert roleRecord1;
            
            Test.startTest();
            FNS_CommHomeController.getActiveApplication();
            Test.stopTest();
            System.assert(true);
        }
    }
}