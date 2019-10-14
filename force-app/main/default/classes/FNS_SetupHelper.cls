/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Access Handler
    * @description Helps in evaluating CRUD Access
  */
public with sharing class FNS_SetupHelper {

    /**
	* @description Save SFDC_FFDC__c Custom Setting
	* @param SFDC_FFDC__c Custom Setting data
	* @return null
	*/ 
    public static void saveSFDCFFDCConfig(string connectData){
        FNS_SFDCFFDCSetup__c configObj = (FNS_SFDCFFDCSetup__c)JSON.deserialize(connectData, FNS_SFDCFFDCSetup__c.class);
        /*System.debug('setup>>'+configObj);
		Boolean isCreate = false;
        FNS_SFDCFFDCSetup__c  config = FNS_SFDCFFDCSetup__c.getOrgDefaults();
		if(config.id == null){
			isCreate = true;
		} 
        config.FNS_ConsumerKey__c = configObj.FNS_ConsumerKey__c;
        config.FNS_ConsumerSecret__c = configObj.FNS_ConsumerSecret__c;
        config.FNS_AccessTokenUrl__c = configObj.FNS_AccessTokenUrl__c;
        config.FNS_OrganisationId__c = configObj.FNS_OrganisationId__c;
		
		if(isCreate){
			FNS_SFDCToFFDCService.insertSFDCToFFDCConfig(config);
		} else {
			FNS_SFDCToFFDCService.updateSFDCToFFDCConfig(config);
		}*/
        system.debug('>>>>>'+configObj);
          		String customMetaDataName = 'FNS_SFDCFFDCConnection';
                String customMetaDataLabel = 'Authorization';
                Map<String, Object> dataMap = new Map<String, Object>();
                dataMap.put('FNS_ConsumerKey__c',configObj.FNS_ConsumerKey__c);
                dataMap.put('FNS_ConsumerSecret__c',configObj.FNS_ConsumerSecret__c);
                dataMap.put('FNS_AccessTokenUrl__c',configObj.FNS_AccessTokenUrl__c);
           		dataMap.put('FNS_AuthorizationURL__c',configObj.FNS_AuthorizationURL__c);
                dataMap.put('FNS_RedirectURI__c',URL.getSalesforceBaseUrl().toExternalForm() +'/apex/FNS_AuthorizeFFDC');
        
        	FNS_UpdateMetadata.CreateUpdateCustomMetaData(customMetaDataName+'.'+customMetaDataLabel,customMetaDataLabel,dataMap);
    }
    
	/**
	* @description Save FFDC_SFDC__c Custom Setting
	* @param FFDC_SFDC__c Custom Setting data
	* @return null
	*/ 
    public static void saveFFDCSFDCConfig(string connectData){
        FNS_FFDCSFDCSetup__c setup = (FNS_FFDCSFDCSetup__c)JSON.deserialize(connectData, FNS_FFDCSFDCSetup__c.class);
        System.debug('setup>>'+setup);
		Boolean isCreate = false;
        FNS_FFDCSFDCSetup__c setupObj = FNS_FFDCSFDCSetup__c.getOrgDefaults();
		if(setupObj.id == null){
			isCreate = true;
		} 
        setupObj.FNS_ConsumerKey__c = setup.FNS_ConsumerKey__c;
        setupObj.FNS_ConsumerSecret__c = setup.FNS_ConsumerSecret__c;
        setupObj.FNS_OrganisationId__c=setup.FNS_OrganisationId__c;
        setupObj.FNS_RedirectURI__c=setup.FNS_RedirectURI__c;
		
		if(isCreate){
			FNS_FFDCToSFDCService.insertFFDCToSFDCConfig(setupObj);
		} else {
			FNS_FFDCToSFDCService.updateFFDCToSFDCConfig(setupObj);
		}
    }
}