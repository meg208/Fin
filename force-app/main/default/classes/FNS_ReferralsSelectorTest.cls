/***************************************************************************************
* @description Class This class is to handle all DML Operations for Referrals
* @author Keerthi Kambhampati
* @date 02/21/2019
* @Support Email Keerthi@comitydesigns.com
****************************************************************************************/
@isTest
public class FNS_ReferralsSelectorTest {
    
    public static Account accountRecord;
    public static Contact contactRecord;  
    public static Lead leadRecordWithContact; 
    public static Lead leadRecordWithUser;
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
    static void setup() {
        
        FNS_TestDataSetup test = new FNS_TestDataSetup();
        
        accountRecord = test.createAccount('TestAccountLead');
        insert accountRecord;
        
        contactRecord = test.createContact(accountRecord.Id, 'TestContactLead');
        insert contactRecord;
        
        userRecord = test.createUser('testLead@abc.com');
        insert userRecord;
        
        leadRecordWithContact = test.createLeadRecordWithContact(contactRecord.Id);
        insert leadRecordWithContact;
        
        leadRecordWithUser = test.createLeadRecordWithUser(userRecord.Id);
        insert leadRecordWithUser;
    }
    
    static testMethod void getLeadsWithContact() {
        
        List<Lead> leadList = new List<Lead>(); 
        List<Lead> leadListWithToday = new List<Lead>(); 
        List<Lead> leadListWithLastWeek = new List<Lead>(); 
        List<Lead> leadListWithLastMonth  = new List<Lead>(); 
        List<Lead> leadListWithLast90Days  = new List<Lead>();       
        List<Lead> leadListWithLast15Days  = new List<Lead>();
        setup();    
        User rm = [Select Id from User where Username ='test@tes999.com']; 
        System.runAs(rm){
            Test.startTest();   
            
            leadList = new FNS_ReferralsSelector().getReferralsForRM('null'); 
            
            leadListWithToday = new FNS_ReferralsSelector().getReferralsForRM('Today');   
            
            leadListWithLastWeek = new FNS_ReferralsSelector().getReferralsForRM('Last Week');   
            
            leadListWithLastMonth = new FNS_ReferralsSelector().getReferralsForRM('Last Month');   
            
            leadListWithLast90Days = new FNS_ReferralsSelector().getReferralsForRM('Last 90 Days');
            
            leadListWithLast15Days = new FNS_ReferralsSelector().getReferralsForRM('Last 15 Days');
            Test.stopTest(); 
            
        }
        System.assertNotEquals(leadList, null);
        System.assertNotEquals(leadListWithToday, null);
        System.assertNotEquals(leadListWithLastWeek, null);
        System.assertNotEquals(leadListWithLastMonth, null);
        System.assertNotEquals(leadListWithLast90Days, null);
        System.assertNotEquals(leadListWithLast15Days, null);
        
    }
}