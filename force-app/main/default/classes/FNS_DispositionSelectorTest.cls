/***************************************************************************************
* @description Class This test class is used for FNS_DispositionSelector
* @author ANKIT PAL
* @date 04/29/2019
* @Support Email ankit.pal@comitydesigns.com
****************************************************************************************/
@isTest
private class FNS_DispositionSelectorTest {
    
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
    
    static testMethod void getAllDispositionsTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            List<FNS_Disposition__mdt> allDispositions =  new FNS_DispositionSelector().getAllDispositions();
            System.assertNotEquals(allDispositions, null);
        }
    }
    static testMethod void getDispositionIdByValueTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            String dispositionsIdById =  new FNS_DispositionSelector().getDispositionIdByValue('Proposal');
            System.assertNotEquals(dispositionsIdById, null);
        }
    }
    static testMethod void getDispositionValueByIdTest() {
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            String dispositionsValueById =  new FNS_DispositionSelector().getDispositionValueById('12345678890123456');
            System.assertNotEquals(dispositionsValueById, null);
        }
    }
}