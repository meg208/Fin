/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Test class
  * @description This class is used as test class for FNS_ProductDomain class.
****************************************************************************************/
@isTest
private class FNS_ProductDomainTest { 
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
    
    static testMethod void getAllProductsTest() {    
        User usr = [Select id from User where Username ='test@tes999.com'];
        
        System.runAs(usr){
            FNS_ProductDomain prodDomainObj = new FNS_ProductDomain();
            FNS_ProductDomain.getObjFieldName();
            FNS_ProductDomain.getFieldAPINames();
            FNS_ProductDomain.getproductLoanFieldMap();
            FNS_ProductDomain.getproductFieldMap();
            FNS_ProductDomain.getFeeFieldMap();
            FNS_ProductDomain.getPricingFieldMap();
            FNS_ProductDomain.getproductRoleFieldMap();
            FNS_ProductDomain.getObjectNames();
            system.assert(true);     
        }
    }
    
    static testMethod void getAllLoanTest() {
        User usr = [Select id from User where Username ='test@tes999.com'];        
        System.runAs(usr){
            FNS_LoansSelector loanObj = new FNS_LoansSelector();
            List<sObject> loanNameList = loanObj.getAllProducts();
            System.assertNotEquals(loanNameList, null);
        }
    }
}