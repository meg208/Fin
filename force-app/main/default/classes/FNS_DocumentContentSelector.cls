/****************************************************************************************
* @description Class This class is used to handle all the DML operations for ContentDocuments.
* @author Praneeth Aitharaju
* @date 13/03/2019
* @Support Email  Praneeth.aitharaju@comitydesigns.com
****************************************************************************************/
public with sharing class FNS_DocumentContentSelector extends fflib_SObjectSelector{
    
    /*************************************************************************************
    TRUE
    * @Params       none
    * @Returns      none
    * @author        Praneeth.aitharaju@comitydesigns.com
    **************************************************************************************/
    public FNS_DocumentContentSelector() {
        super(true, true, true);
    }
    
    public FNS_DocumentContentSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
    * @description  Method to return Schema.SObjectField list of ContentVersion object
    * @Params       none
    * @Returns      List of Schema.SObjectField of Custom versionIds object
    * @author       Praneeth.aitharaju@comitydesigns.com
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            ContentVersion.Id,
            ContentVersion.title,
            ContentVersion.fileExtension,
            ContentVersion.fileType,
            ContentVersion.pathOnClient,
            ContentVersion.versiondata,
            ContentVersion.ContentDocumentId
        };
    }

    /*************************************************************************************
    * @description  Method to return SObject type ContentVersion object
    * @Params       none
    * @Returns      Returns SObjecttype of Custom versionIds object
    * @author        Praneeth.aitharaju@comitydesigns.com
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        return ContentVersion.sObjectType;
    }
    
    /*************************************************************************************
    * @description  Method to return Custom versionIds records based on ContentVersion.
    * @Params       Set of Custom versionIds ids
    * @Returns      Returns List of Custom versionIds object
    * @author       Praneeth.aitharaju@comitydesigns.com
    **************************************************************************************/
    public List<ContentVersion> selectById(Set<Id> versionIds) {
        return (List<ContentVersion>) selectSObjectsById(versionIds);
    }
    
    /*************************************************************************************
    * @description  Method to return contentdocuments records based on activityIds.
    * @Params        fileId ids
    * @Returns      Returns List of contentdocuments object
    * @author       Praneeth.aitharaju@comitydesigns.com
    **************************************************************************************/
    public List<ContentVersion> geversionItems(String versionId) {
        fflib_QueryFactory versionQueryFactory = newQueryFactory(true, true, true);
        versionQueryFactory.assertIsAccessible();
        versionQueryFactory.setEnforceFLS(true);
        versionQueryFactory.selectField('Id');
        
        String versionQueryCondition; 
        if(versionId != null){
            versionQueryCondition= 'ContentDocumentId =:versionId'; 
            versionQueryFactory.setCondition(versionQueryCondition);
        }
        return (List<ContentVersion>) Database.query(versionQueryFactory.toSOQL());
    }    
}