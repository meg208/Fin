/*****************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Access Handler
 * @description Class is used to retrieve URL from Authorization Page.
 ******************************************************************************************/

public class FNS_FFDCAuthorizationController {
     /*************************************************************************************
    * @description  Method used to get awaaionstate .
    * @Params       
    * @Returns      String.
    **************************************************************************************/
    @RemoteAction
    public static string getValues(String sessionState, String code){
        String endpoint = 'https://www.creditconnectlending.com/corporate-lending/origination/configuration/v0.8/authentication/token?session_state=' + sessionState + '&code=' + code;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            FNS_ObjectContainer.FNS_Authentication configObj= (FNS_ObjectContainer.FNS_Authentication)JSON.deserialize(res.getBody(), FNS_ObjectContainer.FNS_Authentication.class);
            String customMetaDataName = 'FNS_SFDCFFDCConnection';
            String customMetaDataLabel = 'n';//User name
            Map<String, Object> dataMap = new Map<String, Object>();
            dataMap.put('FNS_AccessToken__c','accesstoken');
            dataMap.put('FNS_RefreshToken__c','FNS_RefreshToken__c');
            dataMap.put('FNS_Scope__c','FNS_Scope__c');
            FNS_UpdateMetadata.CreateUpdateCustomMetaData(customMetaDataName+'.'+customMetaDataLabel,customMetaDataLabel,dataMap);
            
            /*  List<FNS_FFDCAPIConfiguration__mdt> apiConfigList = new FNS_APIConfigurationSelector().getAllRecords();
            
            for(FNS_SFDCFFDCConnection__mdt mdRecord : new FNS_SFDCFFDCAuthSelector().getAllRecords()){
                if(mdRecord.MasterLabel == 'FFDCAuthentication'){
                    configObj.access_token = mdRecord.FNS_AccessToken__c;
                    configObj.refresh_token = mdRecord.FNS_RefreshToken__c;
                }
                FNS_SFDCToFFDCService.updateSFDCToFFDCMetadataConfig(mdRecord);
            }
            */
            
        }
        return res.getBody();
    }   
     /*************************************************************************************
     * @description  Method used to return url .
     * @Params       
     * @Returns      String.
     **************************************************************************************/
    @RemoteAction
    public static string authorizeToFFDC(){
        FNS_SFDCFFDCSetup__c  config = FNS_SFDCFFDCSetup__c.getOrgDefaults();
        String urlValue = config.FNS_AuthorizationURL__c + '?' + FNS_Constants.client_id + config.FNS_ConsumerKey__c + FNS_Constants.CLIENT_SECRET + config.FNS_ConsumerSecret__c + '&scope=' + config.FNS_Scope__c+'&response_type=code&'+  FNS_Constants.GRANT_TYPE_AUTH_CODE +  FNS_Constants.REDIRECT_URI + config.FNS_CallBackURL__c;
        String encodedString = EncodingUtil.urlEncode(urlValue,'UTF-8');
        return encodedString;
    }   
}