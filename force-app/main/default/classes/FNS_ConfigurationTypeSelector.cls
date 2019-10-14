/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Configuration Type
****************************************************************************************/
public with sharing class FNS_ConfigurationTypeSelector extends fflib_SObjectSelector{
    static FNS_ErrorLog logger = new FNS_ErrorLog();
 
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_ConfigurationTypeSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_ConfigurationTypeSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Configuration Type 
                       object
        * @param 	   none
        * @return      List of Schema.SObjectField of Configuration Type object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> { 
            FNS_ConfigurationType__c.Id,
            FNS_ConfigurationType__c.Name,
            FNS_ConfigurationType__c.FNS_ConfigurationExternalId__c,
            FNS_ConfigurationType__c.FNS_ConfigurationType__c,
            FNS_ConfigurationType__c.FNS_ConfigurationValue__c,
            FNS_ConfigurationType__c.FNS_Description__c,
            FNS_ConfigurationType__c.FNS_SystemId__c,
            FNS_ConfigurationType__c.FNS_SystemOrder__c,
            FNS_ConfigurationType__c.FNS_ConfigurationId__c,
            FNS_ConfigurationType__c.FNS_DMLType__c
        };
     }
    
    /*************************************************************************************
        * @description Method to return SObject type of Configuration Type object
        * @param 	   none
        * @return      Returns SObjecttype of Configuration Type object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return FNS_ConfigurationType__c.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Configuration Type records based on set of 
                       Set of Configuration Type Ids
        * @param 	   Set of Configuration Type ids 
        * @return      Returns List of Configuration Type object
    **************************************************************************************/
    public List<FNS_ConfigurationType__c> selectById(Set<Id> conTypeIds) {
        return (List<FNS_ConfigurationType__c>) selectSObjectsById(conTypeIds);
    }
    
    /*************************************************************************************
        * @description Method to return List of Configuration Type records
        * @param 	   Configuration Type 
        * @return      Returns List of Configuration Type records
    **************************************************************************************/
    public List<FNS_ConfigurationType__c> getConfigTypeRecordsByType(String configType) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        fflib_QueryFactory configTypeQueryFactory = newQueryFactory(true, true, true);
        List<FNS_ConfigurationType__c> configTypeRecordsByTypeList = new List<FNS_ConfigurationType__c>();

        try {
            configTypeQueryFactory.assertIsAccessible();
            configTypeQueryFactory.setEnforceFLS(true);
            if(configType != null){
                configTypeQueryFactory.setCondition(baseNamespace+'FNS_ConfigurationType__c = :configType');
            }
            configTypeQueryFactory.setOrdering('FNS_SystemOrder__c', fflib_QueryFactory.SortOrder.ASCENDING, true); 
            configTypeRecordsByTypeList = (List<FNS_ConfigurationType__c>) Database.query( configTypeQueryFactory.toSOQL());
        }
        catch (Exception ex){
            logger.addLogRecord('FNS_ConfigurationTypeSelector', 'getConfigTypeRecordsByType', ex.getMessage() + ex.getStackTraceString()); 
            throw new FNS_CustomException(Label.FNS_CustomException);
        }
        return configTypeRecordsByTypeList;
    }
    /*************************************************************************************
        * @description Method to return List of Configuration Type records
        * @param 	   Configuration Type 
        * @return      Returns List of Configuration Type records
    **************************************************************************************/
    public List<FNS_ConfigurationType__c> getConfigTypeRecordsByType(List<String> configType) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        fflib_QueryFactory configTypeQueryFactory = newQueryFactory(true, true, true);
        List<FNS_ConfigurationType__c> configTypeRecordsByTypeList = new List<FNS_ConfigurationType__c>();

        try {
            configTypeQueryFactory.assertIsAccessible();
            configTypeQueryFactory.setEnforceFLS(true);
            if(configType != null){
                configTypeQueryFactory.setCondition(baseNamespace+'FNS_ConfigurationType__c IN :configType');
            }
            configTypeRecordsByTypeList = (List<FNS_ConfigurationType__c>) Database.query( configTypeQueryFactory.toSOQL());
        }
        catch (Exception ex){
            logger.addLogRecord('FNS_ConfigurationTypeSelector', 'getConfigTypeRecordsByType', ex.getMessage() + ex.getStackTraceString()); 
            throw new FNS_CustomException(Label.FNS_CustomException);
        }
        return configTypeRecordsByTypeList;
    }
}