/****************************************************************************************
* @description Class This class is used to select for Custom Metadata Type Disposition.
* @author Swanand Mulay
* @date 25/03/2019
* @Support Email swanandm@comitydesigns.com
****************************************************************************************/
public with sharing class FNS_DispositionSelector extends fflib_SObjectSelector {
    
    /*************************************************************************************
    * @description  Constructor to set boolean values to TRUE of Super class.We are setting 
                    includeFieldsetFields, enforceCRUD, enforceFLS in param constructor to 
                    TRUE
    * @Params       none
    * @Returns      none
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/
    public FNS_DispositionSelector() {
        super(true, true, true);
    }
    
    public FNS_DispositionSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
    * @description  Method to return Schema.SObjectField list of Custom Metadata Type Disposition
    * @Params       none
    * @Returns      List of Schema.SObjectField of Custom Metadata Type Disposition
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            FNS_Disposition__mdt.Id,
            FNS_Disposition__mdt.MasterLabel,
            FNS_Disposition__mdt.FNS_DispositionId__c,
            FNS_Disposition__mdt.FNS_DispositionValue__c
        };
    }
    
    /*************************************************************************************
    * @description  Method to return SObject type of Custom Metadata Type Disposition
    * @Params       none
    * @Returns      Returns SObjecttype of Custom Metadata Type Disposition
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        return FNS_Disposition__mdt.sObjectType;
    }
    
    /*************************************************************************************
    * @description  Method to return all Custom Metadata records.
    * @Params       none
    * @Returns      Returns List of Custom Metadata Type Disposition
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/
    public List<FNS_Disposition__mdt> getAllDispositions() {
        system.debug('query = '+ newQueryFactory().toSOQL());
        return Database.query(newQueryFactory().toSOQL());
    }
    
    /*************************************************************************************
    * @description  Method to return disposition Id.
    * @Params       disposition value
    * @Returns      Returns Disposition Id
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/
    public String getDispositionIdByValue(String value) {
        String dispositionId = '';
                   
        for(FNS_Disposition__mdt record : Database.query(newQueryFactory().toSOQL())) {
            if(record.FNS_DispositionValue__c.equalsignorecase(value)) {
                dispositionId = record.FNS_DispositionId__c;
                break;
            }
        }
        
        return dispositionId;
    }
    
    /*************************************************************************************
    * @description  Method to return disposition Id.
    * @Params       disposition value
    * @Returns      Returns disposition value
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/
    public String getDispositionValueById(String Id) {
        String dispositionValue = '';
                    
        for(FNS_Disposition__mdt record : Database.query(newQueryFactory().toSOQL())) {
            if(record.FNS_DispositionId__c == Id) {
                dispositionValue = record.FNS_DispositionValue__c;
                break;
            }
        }
        
        return dispositionValue;
    }
}