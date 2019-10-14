/**
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Setup
* @description Helps in evaluating CRUD Access
*/
public with sharing class FNS_SetupController {
    
    public static FNS_ErrorLog logger = new FNS_ErrorLog();
    /**
* @description get FNS_SFDCFFDCSetup__c,FNS_FFDCSFDCSetup__c Custom Setting Data
* @param connection type SFDC_FFDC,FFDC_SFDC
* @return a list of fields that are not accessible
*/ 
    @AuraEnabled
    public static sObject getSetupData(String connectType){
        if(connectType.equalsignorecase('SFDC_FFDC')){
            FNS_SFDCFFDCSetup__c connectData = FNS_SFDCFFDCSetup__c.getOrgDefaults();
            List<FNS_SFDCFFDCConnection__mdt> SFDCToFFDC = new FNS_SFDCFFDCConnectionSelector().selectRecordsByUserNames(new set<String>{'Authorization'});
            return SFDCToFFDC[0];//connectData ;
        }else{
            FNS_FFDCSFDCSetup__c connectData = FNS_FFDCSFDCSetup__c.getOrgDefaults();
            return connectData ;
        }
    }
    
    /**
* @description Method to save the updated custom setting values for authuntication based on connection type i.e SFDC_FFDC and FFDC_SFDC.
* @param connectData,connectType
* @return none
*/
    @AuraEnabled
    public static void saveSetupData(string connectData,String connectType){
        if(connectType.equalsignorecase('SFDC_FFDC')){
            FNS_SetupHelper.saveSFDCFFDCConfig(connectData);
        }else{
            FNS_SetupHelper.saveFFDCSFDCConfig(connectData);
        }
    }
    /**
* @description Method to get the Access Token and Refresh token in salesforce.
* @param authCode
* @return string
*/  
    @AuraEnabled
    public static string getSFDCAccessToken(string authCode){
        String response = FNS_IntegrationUtil.getSFDCAccessToken(authCode);       
        FNS_ResponseWrapper resWrap= (FNS_ResponseWrapper)JSON.deserialize(response, FNS_ResponseWrapper.class);
        return JSON.serialize(resWrap);
    }
    /**
* @description Method to generate Auth URI, on redirecting it will generate the Auth code in URL.
* @param none
* @return string
*/
    @AuraEnabled
    public static string generateAuthURL(){
        FNS_FFDCSFDCSetup__c SFDCData = FNS_FFDCSFDCSetup__c.getOrgDefaults();
        //String urlAddress = 'https://connect-enterprise-4016-dev-ed.cs87.my.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG954MqIw6FnnMN3LfIsfd8tLlrjmvEe1dAOGf2IH3lF4iAa1NsoU3.sGyTP7Pz1KL7hqs.w64Z.g8MwXVH&redirect_uri=https%3A%2F%2Fconnect-enterprise-4016-dev-ed.lightning.force.com%2Flightning%2Fn%2FFinastra_Setup&state=mystate';
        string authURI = System.Url.getOrgDomainUrl().toExternalForm() + FNS_Constants.AUTHORIZE_URL+FNS_Constants.RESPONSETYPE_CODE + FNS_Constants.CLIENT_ID+SFDCData.FNS_ConsumerKey__c+FNS_Constants.REDIRECT_URI+EncodingUtil.urlEncode(SFDCData.FNS_RedirectURI__c, FNS_Constants.ENCODEUTF8)+FNS_Constants.STATE_MYSTATE;
        return authURI;
    }
    
    
    /*************************************************************************************
* @description Method to validate Authuntication from SFDC-FFDC
* @param none
* @return string
**************************************************************************************/
    @AuraEnabled
    public static string checkAuthSFDCConnection(){
        //FNS_SFDCFFDCSetup__c  config = FNS_SFDCFFDCSetup__c.getOrgDefaults();
        List<FNS_SFDCFFDCConnection__mdt> SFDCFFDCconfig= new FNS_SFDCFFDCConnectionSelector().selectRecordsByUserNames(new set<String>{'Authorization'});
        FNS_SFDCFFDCConnection__mdt config = SFDCFFDCconfig[0];

        //String urlValue = config.FNS_AuthorizationURL__c + '?' + FNS_Constants.client_id + config.FNS_ConsumerKey__c + FNS_Constants.CLIENT_SECRET + config.FNS_ConsumerSecret__c + '&scope=' + config.FNS_Scope__c+'&response_type=code&'+  FNS_Constants.GRANT_TYPE_AUTH_CODE +  FNS_Constants.REDIRECT_URI + config.FNS_CallBackURL__c;
        String urlValue = config.FNS_AuthorizationURL__c + '?' + FNS_Constants.client_id + config.FNS_ConsumerKey__c + FNS_Constants.CLIENT_SECRET + config.FNS_ConsumerSecret__c + '&scope=' + config.FNS_Scope__c+'&response_type=code&'+  FNS_Constants.GRANT_TYPE_AUTH_CODE +  FNS_Constants.REDIRECT_URI + config.FNS_RedirectURI__c;
        String encodedString = EncodingUtil.urlEncode(urlValue,'UTF-8');
        return encodedString;
        /* HTTPResponse response = FNS_IntegrationUtil.authSFDCConnection();
        FNS_ResponseWrapper resWrap= (FNS_ResponseWrapper)JSON.deserialize(response.getBody(), FNS_ResponseWrapper.class);
        resWrap.statusCode=response.getStatusCode();
        return JSON.serialize(resWrap);

        /*boolean isAuthorized = false;
        if(response.getStatusCode() == 200){
        isAuthorized = true;
        FNS_SFDC_FFDCConHelper.getAccessToken(response);
        } 
        system.debug(LoggingLevel.ERROR,'@@@@@@@@@ isAuthorized : '+ isAuthorized);
        return isAuthorized;*/
    }
    
    /*************************************************************************************
* @description Method to return if Profile is Admin or not based on logged in User for FNS_Setup Component
* @param       null
* @return      Returns String ADMIN or NOT ADMIN 
**************************************************************************************/
    @AuraEnabled
    public static string getUserProfileInfo(){
        String loggedInProfileId = UserInfo.getProfileId(); 
        String resp; 
        try{
            FNS_ProfileSelector profileSelector = new FNS_ProfileSelector(); 
            Profile adminProfile = profileSelector.selectbyName(FNS_Constants.SYSTEMADMINISTRATOR); 
            
            if(adminProfile != null){
                if(adminProfile.Id == loggedInProfileId){
                    resp = FNS_Constants.ADMIN; 
                }
                else{
                    resp = FNS_Constants.NOTADMIN; 
                }
            }
        }
        catch(Exception ex){
            logger.addLogRecord('FNS_SetupController', 'getUserProfileInfo', ex.getMessage() + ex.getStackTraceString());
            throw new FNS_CustomException(Label.FNS_CustomException);
        }
        return resp; 
    }

     /*************************************************************************************
    * @description  Method used to get awaaionstate .
    * @Params       
    * @Returns      String.
    **************************************************************************************/
    @AuraEnabled
    public static void getFFDCValues(String sessionState, String code){

            //FNS_SFDCFFDCSetup__c  config = FNS_SFDCFFDCSetup__c.getOrgDefaults();
        	List<FNS_SFDCFFDCConnection__mdt> SFDCFFDCconfig= new FNS_SFDCFFDCConnectionSelector().selectRecordsByUserNames(new set<String>{'Authorization'});
            FNS_SFDCFFDCConnection__mdt config = SFDCFFDCconfig[0];
            HttpRequest req = new HttpRequest();
            req.setBody(
                'code=' + code +
                '&client_id=' + config.FNS_ConsumerKey__c  +  
                '&client_secret=' + config.FNS_ConsumerSecret__c + 
                '&session_state=' + sessionState + 
                '&redirect_uri=' + config.FNS_RedirectURI__c + 
                '&grant_type=authorization_code' 
            );
            req.setEndpoint(config.FNS_AccessTokenURL__c);
            req.setMethod('POST');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            if (res.getStatusCode() == 200) {
                FNS_ObjectContainer.FNS_Authentication configObj= (FNS_ObjectContainer.FNS_Authentication)JSON.deserialize(res.getBody(), FNS_ObjectContainer.FNS_Authentication.class);
                //FCCA-326 : Added Profile check for Admin User, to set IsAdmin value to true on FNS_SFDCFFDCConnection mdt.
                Id profileId=userinfo.getProfileId();
                String profileName=[Select Id,Name from Profile where Id=:profileId].Name;

                String userName = UserInfo.getUserName();
                String usrname = userName.replace('@','_').replace('.','_').replace('-','_');
                String customMetaDataName = 'FNS_SFDCFFDCConnection';
                String customMetaDataLabel = userName;//User name
                customMetaDataName += '.' + customMetaDataLabel.replace('@','_').replace('.','_').replace('-','_');
                Map<String, Object> dataMap = new Map<String, Object>();
                dataMap.put('FNS_AccessToken__c',configObj.access_token);
                dataMap.put('FNS_AccessTokenValidityTime__c',Datetime.now().addSeconds(configObj.expires_in));
                dataMap.put('FNS_RefreshToken__c',configObj.refresh_token);
                dataMap.put('FNS_RefreshTokenValidityTime__c',Datetime.now().addSeconds(configObj.refresh_expires_in));
                dataMap.put('FNS_IsValidRefreshToken__c',true);
                dataMap.put('FNS_Scope__c',configObj.scope);
                if(profileName.equalsIgnoreCase(FNS_Constants.SYSTEM_ADMINISTRATOR)){
                     dataMap.put('FNS_IsAdminUser__c',true);
                }
               // FNS_UpdateMetadata.CreateUpdateCustomMetaData(customMetaDataName,customMetaDataLabel,dataMap);
                FNS_UpdateMetadata.CreateUpdateCustomMetaData(customMetaDataName,usrname ,dataMap);
            }
        /*}
        catch (Exception ex) {
            logger.addLogRecord('FNS_SetupController', 'getFFDCValues', ex.getMessage() + ex.getStackTraceString());
            throw new FNS_CustomException(Label.FNS_CustomException);
        }*/
    }       
}