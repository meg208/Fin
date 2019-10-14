@isTest
public class FNS_FetchRefreshTokenBatchTest {
    
    static testMethod void FetchRefreshTokenBatch()
    {
        //FNS_SFDCFFDCConnection__mdt conRec = new FNS_SFDCFFDCConnection__mdt(FNS_Client_Id__c  = 'testIdtestststst', FNS_ClientSecret__c = 'testSecret' ,FNS_EndPointURL__c = 'testURL',FNS_GrantType__c = 'testGrant');
        //insert conRec;
        List<FNS_SFDCFFDCConnection__mdt> authRecordList = new FNS_SFDCFFDCConnectionSelector().selectRecordsByUserNames(new Set<String>{'Authorization'});
        for (FNS_SFDCFFDCConnection__mdt authObj :authRecordList){
            authObj.FNS_ConsumerKey__c='testId';
            authObj.FNS_ConsumerSecret__c='testSecret';
            authObj.FNS_EndPointURL__c='testEndPointUrl';
            //authObj.FNS_GrantType__c='TestGrantType';
        }
        Test.StartTest();
        FNS_FetchRefreshTokenBatch objBatch = new FNS_FetchRefreshTokenBatch();
        ID batchprocessid = Database.executeBatch(objBatch);
        Test.StopTest();
    }
}