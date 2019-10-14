/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description This class is used to perform DML using json for an Application.
****************************************************************************************/
@isTest
public class FNS_BankDomainTest {
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
    
    @isTest static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        User usr = [Select id from User where Username ='test@tes111.com'];
        
        System.runAs(usr){
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://finastra-api.herokuapp.com/corporate-lending/origination/v0.8/configuration/banks');
            req.setMethod('GET');
            Http h = new Http();
            
            Test.startTest();
            	HttpResponse res = h.send(req);
            Test.stopTest();
            
            String contentType = res.getHeader('Content-Type');
            System.assert(contentType == 'application/json');
            String actualValue = res.getBody();
            
            Object valueReceived = FNS_BankDomain.getConfigurations();
            
            System.assertNotEquals(null, valueReceived);
            System.assertEquals(200, res.getStatusCode());
        }
    }
}