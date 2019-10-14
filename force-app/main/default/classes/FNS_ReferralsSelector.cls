/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on Referrals
****************************************************************************************/
public with sharing class FNS_ReferralsSelector extends fflib_SObjectSelector{
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_ReferralsSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/ 
    public FNS_ReferralsSelector(Boolean enforceFLS){
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of Lead object 
        * @param 	   none
        * @return      List of Schema.SObjectField of Lead object
    **************************************************************************************/
    public List<Schema.SObjectField> getSObjectFieldList(){
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        List<String> fieldList;
        Map<Schema.SObjectType,List<Schema.SObjectField>> fieldsMap = new Map<Schema.SObjectType,List<Schema.SObjectField>>();      
        Map<String, List<String>> objectWithFieldsMap = new Map<String, List<String>>();        
        String sobjectName = 'Lead';
        Schema.SObjectType sObj;
        fieldList = new List<String> {'Id','Name','Phone','Email','Status','CreatedDate','Company'};
            if(FNS_Util.isFSCInstalled){
                fieldList.add('FinServ__ReferredByContact__c');
                fieldList.add('FinServ__ReferredByUser__c');
            } else {
                fieldList.add(baseNamespace+'FNS_ExternalReferrer__c');
                fieldList.add(baseNamespace+'FNS_InternalReferrer__c');
            }
        objectWithFieldsMap.put(sobjectName, fieldList);                                          
        fieldsMap = FNS_Util.getSobjectWithFields(objectWithFieldsMap);
        sobj = Schema.getGlobalDescribe().get(sobjectName);
        return fieldsMap.get(sobj);
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of Lead object
        * @param 	   none
        * @return      Returns SObjecttype of Lead object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType(){
        return Lead.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Contact records along with its associated Lead 
        			   referral records.This method returns record based on Loan Officer 
					   User Id
        * @param 	   String as filter condition
        * @return      Returns List of Lead object and its associated Contact records
    **************************************************************************************/    
    public List<Lead> getReferralsForRM(String filterCondition){
        
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        String userId = UserInfo.getUserId();
        fflib_QueryFactory referralQueryFactory = newQueryFactory();     
        List<String> refQueryConditions = new List<String>();
        refQueryConditions.add('OwnerId =: userId');
        refQueryConditions.add('IsConverted = false');
        if(!filterCondition.equalsIgnoreCase('null')){
            String value = filterCondition.trim();            
            if(value.equalsIgnoreCase('Today')){
                refQueryConditions.add('CreatedDate = TODAY');
            } else if(value.equalsIgnoreCase('Last Week')) {
                refQueryConditions.add('CreatedDate > LAST_WEEK');
            } else if(value.equalsIgnoreCase('Last Month')){
                refQueryConditions.add('CreatedDate = LAST_MONTH');
            } else if(value.equalsIgnoreCase('Last 90 Days')) {
                refQueryConditions.add('CreatedDate = LAST_90_DAYS');
            } else if(value.equalsIgnoreCase('Last 15 Days')) {
                refQueryConditions.add('CreatedDate = LAST_N_DAYS:15');
            }
        }
        if(!refQueryConditions.isEmpty()){
            referralQueryFactory.setCondition(String.join(refQueryConditions, ' AND '));
        }
        fflib_SObjectSelector contactSelector = new FNS_ContactSelector();
        fflib_SObjectSelector userSelector = new FNS_UserSelector();
        if(FNS_Util.isFSCInstalled){
        	contactSelector.configureQueryFactoryFields(referralQueryFactory, 'FinServ__ReferredByContact__r');
            userSelector.configureQueryFactoryFields(referralQueryFactory, 'FinServ__ReferredByUser__r');
        } else {
            contactSelector.configureQueryFactoryFields(referralQueryFactory, baseNamespace+'FNS_ExternalReferrer__r');
            userSelector.configureQueryFactoryFields(referralQueryFactory, baseNamespace+'FNS_InternalReferrer__r');
        }
        referralQueryFactory.setOrdering('CreatedDate', fflib_QueryFactory.SortOrder.ASCENDING);
        return (List<Lead>) Database.query(referralQueryFactory.toSOQL());
    }
}