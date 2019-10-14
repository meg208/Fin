/***************************************************************************************
* @description Class This test class is used for FNS_SFDCToFFDCService
* @author Swanand Mulay
* @date 04/29/2019
* @Support Email swanandm@comitydesigns.com
****************************************************************************************/
@isTest
public class FNS_SFDCToFFDCServiceTest {
  
    /**
    * @description: This Method is used to validate the insertSFDCToFFDCConfig method.
    */ 
    static testMethod void insertSFDCToFFDCConfigTest() {
        Test.startTest();
        FNS_SFDCFFDCSetup__c setupObject = new FNS_SFDCFFDCSetup__c();
        setupObject.FNS_ConsumerKey__c = 'Test Consumer Key';
        setupObject.FNS_ConsumerSecret__c = 'Test Consumer Secret';
        setupObject.FNS_AccessTokenUrl__c = 'Test Access Token';
        setupObject.FNS_OrganisationId__c = 'Test Org Id';
        
        FNS_SFDCToFFDCService.insertSFDCToFFDCConfig(setupObject);
        
        List<FNS_SFDCFFDCSetup__c> setupDataList = [Select Id From FNS_SFDCFFDCSetup__c];
        System.assertEquals(setupDataList.size(), 1);
        
        Test.stopTest();
    }
    /**
    * @description: This Method is used to validate the updateSFDCToFFDCConfig method.
    */ 
    static testMethod void updateSFDCToFFDCConfigTest() {
        Test.startTest();
        FNS_SFDCFFDCSetup__c setupObject = new FNS_SFDCFFDCSetup__c();
        setupObject.FNS_ConsumerKey__c = 'Test Consumer Key';
        setupObject.FNS_ConsumerSecret__c = 'Test Consumer Secret';
        setupObject.FNS_AccessTokenUrl__c = 'Test Access Token';
        setupObject.FNS_OrganisationId__c = 'Test Org Id';
        insert setupObject;
        
        setupObject.FNS_OrganisationId__c = 'Test Org1 Id';
        FNS_SFDCToFFDCService.updateSFDCToFFDCConfig(setupObject);
        
        Test.stopTest();
        
        FNS_SFDCFFDCSetup__c setupDataObj = [Select Id, FNS_OrganisationId__c From FNS_SFDCFFDCSetup__c];
        System.assertEquals('Test Org1 Id', setupDataObj.FNS_OrganisationId__c);
    }
}