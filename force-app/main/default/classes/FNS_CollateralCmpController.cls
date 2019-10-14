public class FNS_CollateralCmpController {
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    static Map<String, String> categoryToFieldSetMap = new Map<String, String>();
 	
   Static {
        categoryToFieldSetMap = getMapOfCategoryFieldSet();
    }
   
    @AuraEnabled
    public static FNS_ObjectFieldSetWrapper getComponentData(String applicationId){
        FNS_ObjectFieldSetWrapper wrapper = new FNS_ObjectFieldSetWrapper();
        
        FNS_ObjectFieldSetWrapper.FNS_ObjectWrapper collateralBaseWrapper = new FNS_ObjectFieldSetWrapper.FNS_ObjectWrapper();
        collateralBaseWrapper.fields = FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Collateral__c','FNS_BaseCollateral');
        collateralBaseWrapper.moreFields=FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Collateral__c','FNS_BaseCollateral');
        collateralBaseWrapper.objectName = 'FNS_Collateral__c';
        collateralBaseWrapper.requiredFields= FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Collateral__c','FNS_BaseCollateral');
        collateralBaseWrapper.objectLabel='COLLATERAL';
        
        FNS_ObjectFieldSetWrapper.FNS_ObjectWrapper addressWrapper = new FNS_ObjectFieldSetWrapper.FNS_ObjectWrapper();
        addressWrapper.fields = FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Address__c','FNS_CollateralAddress');
        addressWrapper.moreFields=FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Address__c','FNS_CollateralAddress');
        addressWrapper.objectName = 'FNS_Address__c';
        addressWrapper.requiredFields= FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Address__c','FNS_CollateralAddress');
        addressWrapper.objectLabel='Address';
        
        FNS_ObjectFieldSetWrapper.FNS_ObjectWrapper collateralTypeWrapper = new FNS_ObjectFieldSetWrapper.FNS_ObjectWrapper();
        collateralTypeWrapper.fields = FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Collateral__c','FNS_RealEstate');
        collateralTypeWrapper.moreFields=FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Collateral__c','FNS_RealEstate');
        collateralTypeWrapper.objectName = 'FNS_Collateral__c';
        collateralTypeWrapper.requiredFields= FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Collateral__c','FNS_RealEstate');
        collateralTypeWrapper.objectLabel='COLLATERAL';
        
        wrapper.collateralBaseWrapper = collateralBaseWrapper;
        wrapper.addressWrapper = addressWrapper;
        wrapper.collateralTypeWrapper = collateralTypeWrapper;
        //wrapper.sObjectList = getColateralsByApplicationId(applicationId);
        system.debug('wrapper>>>>'+wrapper);
        return wrapper;
    }
        
    public static Map<String, String> getMapOfCategoryFieldSet(){
        Map<String, String> categoryFieldSetMapping = new Map<String, String>();
        List<FNS_CollateralCategoryFieldSetMapping__mdt> categoryFieldSetList = new FNS_CollateralCategoryMappingSelector().getAllRecords();
        for (FNS_CollateralCategoryFieldSetMapping__mdt mdtobj : categoryFieldSetList){
            categoryFieldSetMapping.put(mdtobj.FNS_CollateralCategory__c,mdtobj.FNS_FieldSetName__c);
        }
        return categoryFieldSetMapping;
    }
    
    @AuraEnabled
    public static FNS_ObjectFieldSetWrapper.FNS_ObjectWrapper getComponentDataFromType(String categoryName){
        String fieldSetName;
        system.debug('@@ categoryName ' + categoryName);
        if(categoryName == null) {
                categoryName ='Real Estate';
        } 
        fieldSetName =  categoryToFieldSetMap.get(categoryName);
        FNS_ObjectFieldSetWrapper.FNS_ObjectWrapper wrapper = new FNS_ObjectFieldSetWrapper.FNS_ObjectWrapper();
        wrapper.fields = FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Collateral__c',fieldSetName);
        wrapper.moreFields = FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Collateral__c',fieldSetName);
        wrapper.objectName = 'FNS_Collateral__c';
        wrapper.requiredFields = FNS_CollateralDomain.getFieldsFromFieldSet('FNS_Collateral__c',fieldSetName);
        wrapper.objectLabel = 'COLLATERAL';
        system.debug('wrapper>>>>'+wrapper);
        return wrapper; 
    }
        
    @AuraEnabled
    public static FNS_CollateralWrapper createCollateralsWithChildRecs(String collateralJson){
        //String collateralJson ='{"collateral":{"FNS_CollateralType__c":"Base_Collateral","FNS_Application__c":"0062E00001EhWL8QAN","FNS_Description__c":"Test","FNS_PledgedDate__c":"07/10/2019","FNS_PurchasedDate__c":"07/11/2019","FNS_ValueFairMarket__c":"200","FNS_ValueDate__c":"100","FNS_ValueSource__c":"07/20/2019","FNS_AppraisalDate__c":"06/22/2019"},"address":{"FNS_Street2__c":"Mariot Hotels","FNS_Street__c":"5th Avenue","FNS_City__c":"Delaware","FNS_PostalCode__c":"11111","FNS_State__c":"DE","FNS_CountryCode__c":"53237"}}';
        system.debug('@@@ collateralJson :: ' + collateralJson);
        FNS_CollateralWrapper wrapper = new FNS_CollateralWrapper();
        wrapper.isSuccess = true;
        system.debug('### createCollateralsWithChildRecs');
        try{
            List<String> collObj = collateralJson.split('\\}');
            String collateralJsonToConvert = '{' + (collObj[0].substringAfterLast('{')) + '}';
            String addressJson = '{' + (collObj[1].substringAfter('{')) + '}';
                
            Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(collateralJson);
            System.debug('@@ test ' + jsonMap);
            String documentId = String.valueOf(jsonMap.get('document')) ;
            system.debug('@@ documentId :: ' + documentId);
            sObject collateralObj = FNS_ProductWizardController.parseSOjects('FNS_Collateral__c', collateralJsonToConvert);
            insert collateralObj;
                
            sObject addressObj = FNS_ProductWizardController.parseSOjects('FNS_Address__c', addressJson);
            addressObj.put('FNS_Collateral__c',collateralObj.id );
            addressObj.put('FNS_Address1__c','tyty');
            insert addressObj;
            
            String prodIDs = String.valueOf(jsonMap.get('ProductIdSet')) ;
            if(prodIDs != null){
                List<String> prodIdList = prodIDs.split(',');
                List<FNS_CollateralWithProduct__c> collateralProdList = new List<FNS_CollateralWithProduct__c>();
                for(String prdId : prodIdList){
                    FNS_CollateralWithProduct__c prodObj = new FNS_CollateralWithProduct__c();
                    prodObj.FNS_Product__c = prdId;
                    prodObj.FNS_Collateral__c = collateralObj.id;
                    collateralProdList.add(prodObj);
                }
                insert collateralProdList;
            }
                
            if(documentId != null){
                FNS_CollateralDocument__c collDocObj = new FNS_CollateralDocument__c();
                collDocObj.FNS_Collateral__c = collateralObj.id;
                collDocObj.FNS_DocumentId__c = documentId;
                insert collDocObj;
            }
            wrapper.collateral = collateralObj;
            system.debug('### createCollateralsWithChildRecs 33 ');
        }catch(DMLException ex){
            logger.addLogRecord('FNS_CollateralCmpController', 'createCollateralsWithChildRecs', ex.getMessage() + ex.getStackTraceString());
            wrapper.errorMsg=ex.getMessage();
            wrapper.isSuccess = false;
        } catch (Exception ex){
            logger.addLogRecord('FNS_CollateralCmpController', 'createCollateralsWithChildRecs', ex.getMessage() + ex.getStackTraceString());
            wrapper.errorMsg=ex.getMessage();
            wrapper.isSuccess = false;
        }
        return wrapper;
    }
    
    @AuraEnabled
    public static List<sObject> getAllColaterals(){
        List<sObject> colletralList = [SELECT id,FNS_CollateralType__c,FNS_CollateralCategory__c FROM FNS_Collateral__c];
        //string collateralJson = JSON.serialize(colletralList);
        //return collateralJson;
        return colletralList;
    }

    @AuraEnabled
    public static List<FNS_CollateralWithDocumentsWrapper> getCollateralsByApplicationId(String applicationId){
        //sObject wrapper = new Sobject();
        List<FNS_CollateralWithDocumentsWrapper> collateralWrapper = new List<FNS_CollateralWithDocumentsWrapper>();
        List<FNS_CollateralWithProduct__c> collateralProductList = (List<FNS_CollateralWithProduct__c>) (new FNS_CollateralWithProductSelector().getCollateralsByApplicationId(applicationId));
        Set<String> collateralIdSet = new Set<String>();
        Map<String, String> categoryPickListMap = getPickListOptionsMap('FNS_Collateral__c', 'FNS_CollateralCategory__c');
        Map<String, String> collTypePickListMap = getPickListOptionsMap('FNS_Collateral__c', 'FNS_CollateralType__c');
        string documentName = '';
        for (FNS_CollateralWithProduct__c collateralProduct : collateralProductList) {
            if(collateralProduct.Id != null) {  
                System.Debug('>>>collateralProduct.Id>>>:'+collateralProduct.Id);
                List<FNS_CollateralDocument__c> collDocs = new FNS_CollateralDocumentSelector().getRecordsByCollateralId(collateralProduct.FNS_Collateral__c);
                FNS_CollateralWithDocumentsWrapper collWrapper = new FNS_CollateralWithDocumentsWrapper(collateralProduct, collDocs);
                collWrapper.collateralCatName = categoryPickListMap.get(collateralProduct.FNS_Collateral__r.FNS_CollateralCategory__c);
                collWrapper.collateralTypeName = collTypePickListMap.get(collateralProduct.FNS_Collateral__r.FNS_CollateralType__c); 
                collateralWrapper.add(collWrapper); 
            }                        
        }
        return collateralWrapper;
    }

    @AuraEnabled
    public Static List<sObject> getProductsByApplication(String applicationId){
        Map<String,String> prodNameIDMap = new Map<String,String>();
        List<sObject> productRecList = new FNS_ProductsSelector().selectApplicationProductWithChilds(new Set<ID>{ApplicationId});
        if(productRecList != null && !productRecList.isEmpty()) {
            for(Sobject productObj : productRecList) {
                prodNameIDMap.put(String.valueOf(productObj.get('Id')), String.valueOf(productObj.get('FNS_ProductSummary__c')));
            }
        }
        return productRecList;
    }

	public static Map<String, String> getPickListOptionsMap(String objApiName, String picklistApiName){
		Map<String, String> pickListOptionsMap = new Map<String, String>();
		Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objApiName).getDescribe().fields.getMap().get(picklistApiName).getDescribe();
        List<Schema.PicklistEntry> pleList = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : pleList){
            pickListOptionsMap.put(f.getValue(), f.getLabel());
        }
		return pickListOptionsMap;
	}
    
    public with sharing class FNS_CollateralWithDocumentsWrapper {
        @AuraEnabled public sObject Collateral {get; set;}
        @AuraEnabled public List<FNS_CollateralDocument__c> CollateralDocuments {get; set;} 
        @AuraEnabled public String collateralTypeName {get; set;}
        @AuraEnabled public String collateralCatName{get; set;}
        
        public FNS_CollateralWithDocumentsWrapper(sObject collateral, List<FNS_CollateralDocument__c> collateralDocuments) {
            this.Collateral = collateral;
            this.CollateralDocuments = collateralDocuments;
        }
    }

    public with sharing class FNS_CollateralWrapper {
            @AuraEnabled public Boolean isSuccess{get;set;}
            @AuraEnabled public String errorMsg{get;set;}
            @AuraEnabled public sObject collateral{get;set;}
    }
}