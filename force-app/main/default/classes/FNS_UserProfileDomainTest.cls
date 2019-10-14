/*****************************************************************************************
* @description This class is used to perform DML using json for an Application.
* @author Keerthi Kambhampati
* @date Apr 25 2019
* @Support Email keerthi@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_UserProfileDomainTest {
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
    @isTest static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        String valueReceived; 
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
            test.startTest();
            valueReceived = FNS_UserProfileDomain.getConfigurations();
            test.stopTest();
        }
        System.assertNotEquals(null, valueReceived);
    }
}