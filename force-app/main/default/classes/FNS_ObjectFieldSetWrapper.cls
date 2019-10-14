public class FNS_ObjectFieldSetWrapper {
    
    @AuraEnabled public FNS_ObjectWrapper objWrapper{get;set;}
    @AuraEnabled public FNS_ObjectWrapper collateralBaseWrapper{get;set;}
    @AuraEnabled public FNS_ObjectWrapper addressWrapper{get;set;}
    @AuraEnabled public FNS_ObjectWrapper collateralTypeWrapper{get;set;}
    @AuraEnabled public List<sObject> sObjectList{get;set;} 

    public class FNS_ObjectWrapper{
        @AuraEnabled public List<FNS_Field> fields{get;set;}
        @AuraEnabled public List<FNS_Field> moreFields{get;set;}
        @AuraEnabled public String objectName{get;set;}
        @AuraEnabled public List<FNS_Field> requiredFields{get;set;}
        @AuraEnabled public String objectLabel{get;set;}  
    }
}