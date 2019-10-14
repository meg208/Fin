/***************************************************************************************
* @description Class This test class is used for FNS_SFDCToFFDCSelector
* @author Swanand Mulay
* @date 04/29/2019
* @Support Email swanandm@comitydesigns.com
****************************************************************************************/
@isTest
public class FNS_SFDCToFFDCSelectorTest {
  
    public static FNS_SFDCFFDCSetup__c  setupObject;
    public static List<FNS_SFDCFFDCSetup__c>  setupObjRecordList;
    
    static void setup() {
        
        FNS_SFDCFFDCSetup__c setupObject = new FNS_SFDCFFDCSetup__c();
        setupObject.FNS_ConsumerKey__c = 'Test Consumer Key';
        setupObject.FNS_ConsumerSecret__c = 'Test Consumer Secret';
        setupObject.FNS_AccessTokenUrl__c = 'Test Access Token';
        setupObject.FNS_OrganisationId__c = 'Test Org Id';
        
        insert setupObject;
        
    }
    static testMethod void getAllRecords() {
        Test.startTest();
        setup();
        Test.stopTest();
        new FNS_SFDCToFFDCSelector(true);
        List<FNS_SFDCFFDCSetup__c> sfdctoFfdcRecordList = new FNS_SFDCToFFDCSelector().getAllRecords();
        System.assertNotEquals(sfdctoFfdcRecordList, null);
    }
}