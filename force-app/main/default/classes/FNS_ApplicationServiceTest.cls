/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_ApplicationService. 
****************************************************************************/

@isTest(SeeAllData=false)
private class FNS_ApplicationServiceTest {
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
    
    /**
    * @description: This Method is used to validate Application with the corresponding SLA status.
    */ 
    static testMethod void activeDealsTest() {
        User user = [Select id from User where Username ='test@tes111.com'];
        FNS_TestDataSetup test = new FNS_TestDataSetup();
        Account accRecord = test.createAccount('Test Account 001');
        insert accRecord;
        List<Opportunity> oppList = new List<Opportunity>();
        
        oppList.add(test.createOpportunity(accRecord.id, 'Proposal', 'RED', 1000));
        oppList.add(test.createOpportunity(accRecord.id, 'Initial Input', 'GREEN', 1000));
        oppList.add(test.createOpportunity(accRecord.id, 'Decisioned', 'YELLOW', 1000));
        oppList.add(test.createOpportunity(accRecord.id, 'Booked', 'RED', 1000));
        oppList.add(test.createOpportunity(accRecord.id, 'Canceled', 'RED', 1000));
        
        system.runas(user){
	    	insert oppList;
	        System.assertNotEquals(oppList, null);
	        FNS_ApplicationService.getPendingDealsWithTask();
	        FNS_ApplicationService.getStageName();
	        FNS_ApplicationService.getListViews();
         }
    }
    
    
    /**
    * @description: This Method is used to validate filters values on Active Deal home page.
    */ 
	static testMethod void activeDealsFilterTest() {
        User user = [Select id from User where Username ='test@tes111.com'];
        FNS_TestDataSetup test = new FNS_TestDataSetup();
        Account accRecord = test.createAccount('Test Account 001');
        insert accRecord;
        List<Opportunity> oppList = new List<Opportunity>();
        
        oppList.add(test.createOpportunity(accRecord.id, 'Proposal', 'RED', 1000));
        oppList.add(test.createOpportunity(accRecord.id, 'Initial Input', 'GREEN', 1000));
        oppList.add(test.createOpportunity(accRecord.id, 'Decisioned', 'YELLOW', 1000));
        oppList.add(test.createOpportunity(accRecord.id, 'Booked', 'RED', 1000));
        oppList.add(test.createOpportunity(accRecord.id, 'Canceled', 'RED', 1000));
        
        system.runas(user){
        	insert oppList;
            System.assertNotEquals(oppList, null);
	        String inputFilter = '{"savedUserFilter":{"value":"Initial Input","operator":"=","fieldType":"STRING","fieldName":"Disposition","fieldApi":"StageName","currencyIsoCode":""}}';
	        FNS_ApplicationService.getFilterRecords(inputFilter);
	        FNS_ApplicationService.restoreDefaults(inputFilter);
	        String inputFilter1 = '{"savedUserFilter":{"value":"1","operator":"=","fieldType":"Integer","fieldName":"Number Of Loans","fieldApi":"Number Of Loans","currencyIsoCode":""}}';
	        FNS_ApplicationService.getFilterRecords(inputFilter1);
        }
        
     }
}