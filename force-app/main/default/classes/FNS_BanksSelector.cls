/****************************************************************************************
* @description Class This class is used to handle all the DML operations for Custom Bank.
* @author Swanand Mulay
* @date 13/03/2019
* @Support Email swanandm@comitydesigns.com
****************************************************************************************/
public with sharing class FNS_BanksSelector extends fflib_SObjectSelector {

    static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    /*************************************************************************************
    * @description  Constructor to set boolean values to TRUE of Super class.We are setting 
                    includeFieldsetFields, enforceCRUD, enforceFLS in param constructor to 
                    TRUE
    * @Params       none
    * @Returns      none
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/
    public FNS_BanksSelector() {
        super(true, true, true);
    }
    
    public FNS_BanksSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
    * @description  Method to return Schema.SObjectField list of Custom Bank object
    * @Params       none
    * @Returns      List of Schema.SObjectField of Custom Bank object
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_Bank__c.Id,
            FNS_Bank__c.FNS_BankExternalId__c,
            FNS_Bank__c.Name,
            FNS_Bank__c.FNS_BankValue__c,
            FNS_Bank__c.FNS_BankNumber__c,
            FNS_Bank__c.FNS_GoverningState__c,
            FNS_Bank__c.FNS_RegionNumber__c,
            FNS_Bank__c.FNS_Branch__c,
            FNS_Bank__c.FNS_RCNumber__c
        };
    }
    
    /*************************************************************************************
    * @description  Method to return SObject type of Custom Bank object
    * @Params       none
    * @Returns      Returns SObjecttype of Custom Bank object
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        return FNS_Bank__c.sObjectType;
    }
    
    /*************************************************************************************
    * @description  Method to return Custom Bank records based on BankIds.
    * @Params       Set of Custom Bank ids
    * @Returns      Returns List of Custom Bank object
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/
    public List<FNS_Bank__c> selectById(Set<Id> bankIds) {
        return (List<FNS_Bank__c>) selectSObjectsById(bankIds);
    }
    
    /*************************************************************************************
    * @description  Method to return Custom Bank records based on set of BankInternal Id fields.
    * @Params       Set of Custom Bank ids
    * @Returns      Returns List of Custom Bank object
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/
    public List<FNS_Bank__c> selectByBankId(Set<String> bankExternalIds) {

        try {
            String baseNamespace= FNS_Util.getBasePackageNamepace();
            fflib_QueryFactory bankQueryFactory = newQueryFactory(true, true, true);
            bankQueryFactory.assertIsAccessible();
            bankQueryFactory.setEnforceFLS(true);
            
            if(bankExternalIds != null && ! bankExternalIds.isEmpty()){
                bankQueryFactory.setCondition(baseNamespace+'FNS_BankExternalId__c IN :bankExternalIds');
            }
            return (List<FNS_Bank__c>) Database.query(bankQueryFactory.toSOQL());
        } catch (Exception ex){
            logger.addLogRecord('FNS_BanksSelector', 'selectByBankId', ex.getMessage() + ex.getStackTraceString()); 
            throw new FNS_CustomException(Label.FNS_CustomException);
        }        
        
    }
}