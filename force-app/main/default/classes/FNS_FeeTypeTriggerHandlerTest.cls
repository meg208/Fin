/*****************************************************************************************
* @description Test class to test FNS_FeeTypeTriggerHandler and FNS_FeeTypeTrigger
* @author Kavya Papasani
* @date Apr 28 2019
* @Support Email kavya@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_FeeTypeTriggerHandlerTest {
    public static FNS_FeeType__c feeTypeRec;
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
    /* Test Method to test DML insert for Fee Type trigger */
    @isTest static void testInsert(){
        feeTypeRec = new FNS_FeeType__c(FNS_FeeTypeExternalId__c= 'ExtId', FNS_Description__c = 'For Renovation'); 
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            test.startTest(); 
            insert feeTypeRec; 
            test.stopTest(); 
        }
        List<FNS_FeeType__c> records = [Select Id from FNS_FeeType__c]; 
        System.assertNotEquals(0, records.size());
    }
    
    /* Test Method to test DML update for Fee Type trigger */
    @isTest static void testUpdate(){
        feeTypeRec = new FNS_FeeType__c(FNS_FeeTypeExternalId__c= 'ExtId', FNS_Description__c = 'For Renovation'); 
        insert feeTypeRec; 
        FNS_FeeType__c rec = new FNS_FeeType__c();
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            test.startTest(); 
            rec.Id = feeTypeRec.Id; 
            rec.FNS_FeeTypeExternalId__c = 'ExtId1'; 
            update rec; 
            test.stopTest();
        }
        
        System.assertEquals('ExtId1', rec.FNS_FeeTypeExternalId__c);
    }
}