@isTest
public with sharing class FNS_ProfileSelectorTest {
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
    @isTest 
    static void testSelectByName(){
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        Profile p= new Profile(); 
        System.runAs(rm){
            test.startTest(); 
            FNS_ProfileSelector selector = new FNS_ProfileSelector(); 
            p = selector.selectByName('System Administrator'); 
            test.stopTest(); 
        }
        System.assertNotEquals(null, p);
    }
}
