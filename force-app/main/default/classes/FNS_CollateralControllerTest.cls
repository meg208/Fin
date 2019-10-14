public class FNS_CollateralControllerTest {
    
    @AuraEnabled
    public static List <FNS_Collateral__c> fetchCollateralData() {
        //Qyery 10 accounts
        List<FNS_Collateral__c> collateralList = [SELECT FNS_Application__r.name, FNS_Application__c,FNS_CollateralCategory__c,FNS_CollateralType__c FROM FNS_Collateral__c WHERE FNS_Application__c !=null];
        //return list of accounts
        return collateralList;
    }

}