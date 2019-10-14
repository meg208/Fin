/*****************************************************************************************
* @description Test class to test FNS_ProductTypeTriggerHandler and FNS_ProductTypeTrigger
* @author Kavya Papasani
* @date Apr 28 2019
* @Support Email kavya@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_ProductTypeTriggerHandlerTest {
    public static FNS_ProductType__c productTypeRec;
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
    /* Test Method to test DML insert for Product Type trigger */
    @isTest static void testInsert(){
        productTypeRec = new FNS_ProductType__c(Name= 'Term Loan', FNS_ProductTypeExternalId__c= 'ExtId'); 
        User usr = [Select id from User where Username ='test@tes111.com'];
        System.runAs(usr){
            test.startTest(); 
            insert productTypeRec; 
            test.stopTest();
        } 
        List<FNS_ProductType__c> records = [Select Id from FNS_ProductType__c]; 
        System.assertNotEquals(0, records.size());
    }
    
    /* Test Method to test DML update for Product Type trigger */
    @isTest static void testUpdate(){
        productTypeRec = new FNS_ProductType__c(Name= 'Term Loan', FNS_ProductTypeExternalId__c= 'ExtId', 
                                                FNS_Description__c = 'For Renovation'); 
        insert productTypeRec; 
        User usr = [Select id from User where Username ='test@tes111.com'];
        FNS_ProductType__c rec = new FNS_ProductType__c();
        System.runAs(usr){
            test.startTest(); 
            rec.Id = productTypeRec.Id; 
            rec.FNS_ProductTypeExternalId__c = 'ExtId1'; 
            update rec; 
            test.stopTest(); 
        }
        System.assertEquals('ExtId1', rec.FNS_ProductTypeExternalId__c);
    }
}