@isTest
public with sharing class FNS_CommunityPathControllerTest {
    public static User user; 
    public static FNS_ConfigurationType__c configRecord; 

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

    static void setup(){
        FNS_TestDataSetup test = new FNS_TestDataSetup(); 
        configRecord = test.createConfigRecord(); 
        configRecord.FNS_ConfigurationType__c = 'DISPOSITION'; 
        configRecord.FNS_Description__c = 'Initial Input'; 
        configRecord.FNS_SystemOrder__c = '2.0';
        insert configRecord;
    }


    @isTest static void testGetFromCommunity(){
        Object response; 
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
            setup();
            test.startTest(); 
            response = FNS_CommunityPathController.getfromCommunity('Initial Input'); 
            test.stopTest(); 
        }

    }
    

}