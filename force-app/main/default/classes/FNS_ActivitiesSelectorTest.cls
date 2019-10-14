/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_ActivitiesSelector 
****************************************************************************/
@IsTest
public class FNS_ActivitiesSelectorTest {
    public static SObject activityRecord;  
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
        activityRecord = test.createActivityRecord();
        insert activityRecord;
        
    }
    /**
    * @description: This Method is used to validate the selectById method.
    */
    static testMethod void selectByIdTest() {
		User usr = [Select id from User where Username ='test@tes111.com'];
        
		System.runAs(usr){
			Test.startTest();
			setup();
			Test.stopTest();
			List<SObject> actList = new FNS_ActivitiesSelector().selectById(new Set<Id>{activityRecord.Id});
			
			System.assertNotEquals(actList, null);
		}
    }
    /**
    * @description: This Method is used to validate the getAllActivities method.
    */
    static testMethod void getAllActivitiesTest() {
		User usr = [Select id from User where Username ='test@tes111.com'];
        
		System.runAs(usr){
			Test.startTest();
			setup();
			Test.stopTest();
			List<SObject> actList = new FNS_ActivitiesSelector().getAllActivities();
			
			System.assertNotEquals(actList, null);
		}
    }
    /**
	* @description: This Method is used to validate the getActivityWithId method.
	*/
    static testMethod void getActivityWithIdTest() {
		User usr = [Select id from User where Username ='test@tes111.com'];
        
		System.runAs(usr){
			Test.startTest();
			setup();
			Test.stopTest();
			List<String> activityIds = new List<String>();
			activityIds.add('ExtId');
			List<SObject> actList = new FNS_ActivitiesSelector().getActivityWithId(activityIds);
			
			System.assertNotEquals(actList, null);
		}
    }
}