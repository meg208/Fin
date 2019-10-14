/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on FFDC APIConfiguration metadata
****************************************************************************************/
public with sharing class FNS_SFDCFFDCConnectionSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param       none
        * @return      none
    **************************************************************************************/  
    public FNS_SFDCFFDCConnectionSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param       Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/ 
    public FNS_SFDCFFDCConnectionSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of FFDC APIConfiguration 
                       metadata object
        * @param       none
        * @return      List of Schema.SObjectField of FFDC APIConfiguration metadata object
    **************************************************************************************/  
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_SFDCFFDCConnection__mdt.Id,
            FNS_SFDCFFDCConnection__mdt.MasterLabel,
                FNS_SFDCFFDCConnection__mdt.FNS_AccessTokenValidityTime__c,
                FNS_SFDCFFDCConnection__mdt.FNS_RefreshToken__c,
            	FNS_SFDCFFDCConnection__mdt.FNS_RedirectURI__c,
            	FNS_SFDCFFDCConnection__mdt.FNS_AccessToken__c,
               	FNS_SFDCFFDCConnection__mdt.FNS_IsValidRefreshToken__c,
                FNS_SFDCFFDCConnection__mdt.FNS_ConsumerKey__c,
                FNS_SFDCFFDCConnection__mdt.FNS_ConsumerSecret__c,
                //FNS_SFDCFFDCConnection__mdt.FNS_EndPointURL__c,
				FNS_SFDCFFDCConnection__mdt.FNS_Scope__c,
                FNS_SFDCFFDCConnection__mdt.FNS_AccessTokenURL__c,
            	FNS_SFDCFFDCConnection__mdt.FNS_AuthorizationURL__c,
            	FNS_SFDCFFDCConnection__mdt.FNS_EndPointURL__c  
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of FFDC APIConfiguration metadata object
        * @param       none
        * @return      Returns SObjecttype of FFDC APIConfiguration metadata object
    **************************************************************************************/  
    public Schema.SObjectType getSObjectType() {
        return FNS_SFDCFFDCConnection__mdt.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return FFDC APIConfiguration metadata records 
        * @param       none
        * @return      Returns List of FFDC APIConfiguration metadata object
    **************************************************************************************/ 
    public List<FNS_SFDCFFDCConnection__mdt> getAllRecords() {
        return Database.query(newQueryFactory().toSOQL());
    }
    
    /******************************************************************************************************
        * @description Method to return FNS_SFDCFFDCSetup__c custom setting based on the provided user name
        * @param       Set of UserName
        * @return      Returns List of FFDC APIConfiguration object
    ********************************************************************************************************/
    public List<FNS_SFDCFFDCConnection__mdt> selectRecordsByUserNames(Set<String> userNameSet) {
        fflib_QueryFactory query = newQueryFactory();
        List<String> queryConditions = new List<String>();
        if(userNameSet != null){
            queryConditions.add('MasterLabel = :userNameSet');
        }
        if(!queryConditions.isEmpty()){
            query.setCondition(String.join(queryConditions, ' AND '));
        }
        system.debug('query = '+query.toSOQL());
        return (List<FNS_SFDCFFDCConnection__mdt>) Database.query(query.toSOQL() );
    }

    /******************************************************************************************************
        * @description Method to return FNS_SFDCFFDCSetup__c custom setting based on the provided user name
        * @param       Set of UserName
        * @return      Returns List of FFDC APIConfiguration object
    ********************************************************************************************************/
    public List<FNS_SFDCFFDCConnection__mdt> selectRecordsOfAdmin() {
        fflib_QueryFactory query = newQueryFactory();
        List<String> queryConditions = new List<String>();
         queryConditions.add('FNS_IsAdminUser__c = true');
        
        if(!queryConditions.isEmpty()){
            query.setCondition(String.join(queryConditions, ' AND '));
        }
        system.debug('query = '+query.toSOQL());
        return (List<FNS_SFDCFFDCConnection__mdt>) Database.query(query.toSOQL() );
    }
}