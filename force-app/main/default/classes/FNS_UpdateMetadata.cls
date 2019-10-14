public with sharing class FNS_UpdateMetadata {
    public static void CreateUpdateCustomMetaData(String fullName, String label, Map<String, Object> fieldWithValuesMap){
        System.debug('>>>fullName>>'+fullName+'>>>label>>'+label);

        try{
            Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
            //Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();

            customMetadata.fullName = fullName;
            customMetadata.label = label;
			for(String fieldName: fieldWithValuesMap.keyset()){
                 Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = fieldName;
            	customField.value = fieldWithValuesMap.get(fieldName); 
                system.debug('fieldName>>>'+fieldName+'value>>>'+String.valueOf(fieldWithValuesMap.get(fieldName)));
            	customMetadata.values.add(customField);
            }

            /*customField.field = 'FNS_AccessToken__c';
            customField.value = String.valueOf(fieldWithValuesMap.get('FNS_AccessToken__c')); 
            customMetadata.values.add(customField);

            customField = new Metadata.CustomMetadataValue();
            customField.field = 'FNS_AccessTokenValidityTime__c';
            customField.value = Datetime.valueOf(fieldWithValuesMap.get('FNS_AccessTokenValidityTime__c')); 
            customMetadata.values.add(customField);

            customField = new Metadata.CustomMetadataValue();
            customField.field = 'FNS_RefreshToken__c';
            customField.value = String.valueOf(fieldWithValuesMap.get('FNS_RefreshToken__c')); 
            customMetadata.values.add(customField);

            customField = new Metadata.CustomMetadataValue();
            customField.field = 'FNS_RefreshTokenValidityTime__c';
            customField.value = Datetime.valueOf(fieldWithValuesMap.get('FNS_RefreshTokenValidityTime__c')); 
            customMetadata.values.add(customField);

            customField = new Metadata.CustomMetadataValue();
            customField.field = 'FNS_Scope__c';
            customField.value = String.valueOf(fieldWithValuesMap.get('FNS_Scope__c')); 
            customMetadata.values.add(customField);*/

            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            mdContainer.addMetadata(customMetadata);
            FNS_CustomMetadataCallback callback = new FNS_CustomMetadataCallback();
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);

        }catch(Exception ex){
            System.debug('error = '+ex.getMessage()); 
        }
    }
    
    public static void UpdateRecordType(String objectName, String fieldName, String recordTypeDeveloperName){
        System.debug('>>>objectName>>'+objectName+'>>>fieldName>>'+fieldName+'>>>recordTypeDeveloperName>>'+recordTypeDeveloperName);
        //1. Create a Service
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.timeout_x=99999;
        //2. Fetch recordtype details based on the record type for the object and assign it to MetadataService.RecordType  
        //RecordType recordType = [select id,Name,SobjectType,developername from RecordType where name=:recordTypeName limit 1];
            
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Schema.RecordTypeInfo recordType =objResult.getRecordTypeInfosByDeveloperName().get(recordTypeDeveloperName);
            
        System.debug(LoggingLevel.ERROR,'recordType>>>>'+recordType);
        MetadataService.RecordType recType = new MetadataService.RecordType();
        recType.fullName = objectName+'.'+recordType.developername; /*recordType.SobjectType*/
        System.debug(LoggingLevel.ERROR,'fullName>>>>'+recType.fullName);
        //3. Should be object Type with developername
        recType.label = recordType.Name;
        recType.active = true;
        recType.picklistValues = new List<MetadataService.RecordTypePicklistValue>();
        
        // Get the field dynamically
		DescribeFieldResult fieldResult = objResult.fields.getMap().get(fieldName).getDescribe();
        System.debug(LoggingLevel.ERROR,'>>>>'+fieldResult);
        //Schema.DescribeFieldResult fieldResult = Contact.FNS_ContactType__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        List<MetadataService.PicklistValue> pvList = new List<MetadataService.PicklistValue>();
        MetadataService.RecordTypePicklistValue rtPV = new MetadataService.RecordTypePicklistValue();
        rtPV.picklist = fieldName; 
        
        //4. Picklist value name of the contact object
        
        for(Schema.PicklistEntry f : ple){ 
            MetadataService.PicklistValue pval = new MetadataService.PicklistValue();
            pval.fullName = f.getValue();
            pval.default_x = false;
            pvList.add(pval);
        }   
        
        rtPV.values = pvList; 
        
        //5. Add it to the record type
        recType.picklistValues.add(rtPV);
        
        List<MetadataService.SaveResult> results = service.updateMetadata(new MetadataService.Metadata[] { recType });
        //6. Execute it
        System.debug('results::'+results);
    }
    
}