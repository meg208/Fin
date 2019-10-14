/***************************************************************************************
* @description Class This class is to test FNS_ReferralsService
* @author Kavya Papasani
* @date 02/21/2019
* @Support Email kavya@comitydesigns.com
****************************************************************************************/
@isTest
public class FNS_ReferralsServiceTest {
    
    public static Lead leadRecord;
    public static Lead leadRecord1;
    public static Lead leadRecord2;
    public static Lead leadRecord3;
    public static Lead leadRecord4;
    public static Lead leadRecord5;
    public static Contact contactRecord; 
    public static Account accountRecord;
    public static User userRecord; 
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
    static void setup(){
        FNS_TestDataSetup testsetup = new FNS_TestDataSetup(); 
        accountRecord = testsetup.createAccount('ABC Company');
        insert accountRecord; 
        contactRecord = testsetup.createContact(accountRecord.Id, 'ContactTest');
        insert contactRecord; 
        List<Lead> leadList = new List<Lead>();  
        for(Integer i=0; i<6 ; i++){
            Lead leadRecord1 = testsetup.createLeadRecordWithContact(contactRecord.Id); 
            leadRecord1.lastName = 'lastName' +i ; 
            leadList.add(leadRecord1); 
        }
        insert leadList; 
        
        leadRecord = testsetup.createLeadRecordWithContact(contactRecord.Id);
        insert leadRecord; 
        
    }
    
    /* Test Method to test getReferralsforRelationshipManager */
    @isTest static void testGetReferralsforRM(){
        
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        Object result; 
        System.runAs(rm){
            test.startTest(); 
            setup();
            result = FNS_ReferralsService.getReferralsForRelationshipManager('LAST_WEEK'); 
            test.stopTest();
        }
        System.assertNotEquals(null, result); 
    }
    
    /* Test Method to test getListViews */
    @isTest static void testGetListViews(){
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        List<ListView> listViews = new List<ListView>(); 
        System.runAs(rm){
            test.startTest(); 
            listViews = FNS_ReferralsService.getListViews(); 
            test.stopTest(); 
        }
        System.assertNotEquals(null, listViews);
    }
}