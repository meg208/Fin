/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Object Selector
  * @description This class is used to Query on ContentDocuments
****************************************************************************************/
public with sharing class FNS_DocumentUploadSelector extends fflib_SObjectSelector{
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   none
        * @return      none
    **************************************************************************************/
    public FNS_DocumentUploadSelector() {
        super(true, true, true);
    }
    
    /*************************************************************************************
        * @description Constructor to set boolean values to TRUE of Super class.We are 
                       setting includeFieldsetFields, enforceCRUD, enforceFLS in param 
                       constructor to TRUE
        * @param 	   Boolean variable for enforcing FLS
        * @return      none
    **************************************************************************************/
    public FNS_DocumentUploadSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
        * @description Method to return Schema.SObjectField list of contentdocuments object
        * @param 	   none
        * @return      List of Schema.SObjectField of Custom versionIds object
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            contentdocument.Id,
            contentdocument.title,
            contentdocument.fileExtension,
            contentdocument.fileType
        };
    }
    
    /*************************************************************************************
        * @description Method to return SObject type of contentdocuments object
        * @param 	   none
        * @return      Returns SObjecttype of Custom versionIds object
    **************************************************************************************/
    public Schema.SObjectType getSObjectType() {
        return contentdocument.sObjectType;
    }
    
    /*************************************************************************************
        * @description Method to return Custom versionIds records based on contentdocument
        * @param 	   nonSet of Custom versionIds idse
        * @return      Returns List of Custom versionIds object
    **************************************************************************************/
    public List<contentdocument> selectById(Set<Id> versionIds) {
        return (List<contentdocument>) selectSObjectsById(versionIds);
    }
    
    /*************************************************************************************
        * @description Method to return contentdocuments records based on activityIds
        * @param 	   fileId ids
        * @return      Returns List of contentdocuments object
    **************************************************************************************/
    public List<contentdocument> getDocItems(String fileId) {
        fflib_QueryFactory versionQueryFactory = newQueryFactory(true, true, true);
        versionQueryFactory.assertIsAccessible();
        versionQueryFactory.setEnforceFLS(true);
        versionQueryFactory.selectField('Id');
        String versionQueryCondition; 
        if(!String.isEmpty(fileId)){
            versionQueryCondition= 'Id =:fileId'; 
            versionQueryFactory.setCondition(versionQueryCondition);
        }
        return (List<contentdocument>) Database.query(versionQueryFactory.toSOQL());
    }    
}