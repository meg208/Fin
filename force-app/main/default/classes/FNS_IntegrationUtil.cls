/*****************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Access Handler
 * @description Class is used to handle all request from FNS_Connection.cmp.
 ******************************************************************************************/
public with sharing class FNS_IntegrationUtil {

    static Map<String, String> apiUrlMap ;
    static Map<String, String> apiVersionMap ;
    static{
        if (apiUrlMap == null){
            apiUrlMap = new Map<String, String>();
            apiVersionMap = new Map<String, String>();
            for(FNS_FFDCAPIConfiguration__mdt mdRecord : new FNS_APIConfigurationSelector().getAllRecords()){
            
                apiUrlMap.put(mdRecord.DeveloperName, mdRecord.FNS_APIName__c);
                if(String.isNotEmpty(mdRecord.FNS_APIVersion__c)){
                    apiVersionMap.put(mdRecord.DeveloperName, mdRecord.FNS_APIVersion__c);
                }
            }
        }
    }
    /*************************************************************************************
     * @description  Method used to make HTTP callout.
     * @Params       requestWrap
     * @Returns      HttpResponse.
     **************************************************************************************/
    public static string getEndpoint(String apiName, String extededAPIUrl){
        String baseApiURL;
        String baseApiVersion;
        String apiURL;
        String pattern = FNS_Constants.VERSION_NUMBER;
        String urlEndPoint;
        System.debug(LoggingLevel.ERROR,'apiName>>>'+apiName+'>>>>extededAPIUrl>>>>'+extededAPIUrl);
        System.debug(LoggingLevel.ERROR,'apiUrlMap>>>'+apiUrlMap);
        if (apiUrlMap != null && ! apiUrlMap.isEmpty()){
            if (String.isNotBlank(apiName) && apiUrlMap.containsKey(apiName)){
                apiURL = apiUrlMap.get(apiName);
                if (apiUrlMap.containsKey('FNS_BaseApiURL')){
                    baseApiURL = apiUrlMap.get('FNS_BaseApiURL');
                    if(apiVersionMap.containsKey(apiName)){
                        baseApiVersion = apiVersionMap.get(apiName);                        
                    }else{
                        baseApiVersion = apiVersionMap.get('FNS_BaseAPIVersion');
                    }
                    if(extededAPIUrl != null){
                        urlEndPoint = baseApiURL+apiURL.replace(pattern, baseApiVersion)+extededAPIUrl;
                    } else {
                        urlEndPoint = baseApiURL+apiURL.replace(pattern, baseApiVersion);
                    }
                }
            }
            System.debug(LoggingLevel.ERROR,'urlEndPoint>>>'+urlEndPoint);
            
        }
        if(String.isBlank(urlEndPoint)){
            throw new FNS_CustomException(Label.FNS_INVALID_API_URL);
        }
        return urlEndPoint;
    }

    /*************************************************************************************
     * @description  Method used to make HTTP callout.
     * @Params       requestWrap
     * @Returns      HttpResponse.
     **************************************************************************************/
    public static HttpResponse makeHTTPCallout(FNS_RequestParam param) {
       try {
            System.debug('param>>>>'+param);
            HttpRequest request = new HttpRequest();
            if (param.documentContent != null) {
                request.setBodyAsBlob(param.documentContent);
            }
            else if (param.Body != null && param.Body != '') {
                request.setBody(param.body);
            }
            // request.setEndpoint('https://www.creditconnectlending.com/corporate-lending/origination/configuration/v0.8/banks');

            request.setClientCertificateName('creditconnect01');
            //request.setEndpoint('callout:FCC/origination/analytics/v0.8/predictive-analytics');
            //request.setEndpoint('https://www.creditconnectlending.com/corporate-lending/origination/analytics/v0.8/predictive-analytics');
            //request.setClientCertificateName('creditconnectlending');
            String accessToken;
            if(param.bypassEndPoint){
                request.setEndpoint(param.endPoint);
            }else {
                request.setEndpoint(getEndPoint(param.endPoint,param.extendedAPIUrl));
                String customMetaDataLabel = UserInfo.getUserName();
                String customMetaDataLbl =customMetaDataLabel.replace('@','_').replace('.','_').replace('-','_');
                System.debug('customMetaDataLbl - '+customMetaDataLbl);
                List<FNS_SFDCFFDCConnection__mdt> meteDataRecList= new FNS_SFDCFFDCConnectionSelector().selectRecordsByUserNames(new Set<String>{customMetaDataLbl});
                System.debug('meteDataRecList - '+meteDataRecList);
                if(meteDataRecList != null && !meteDataRecList.isEmpty()){
                    for(FNS_SFDCFFDCConnection__mdt rec :meteDataRecList ){
                        accessToken = rec.FNS_AccessToken__c;       
                    }
                    //accessToken='eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJYTEJpUk5ZMkRvWS0wREVkQVBsMmJxUGpJWXZRUjVqalhBMmczZzczQzYwIn0.eyJqdGkiOiI2ZjgxZTZmMC0zYmEzLTQ3ZDktYTlhYi02Yzc4NzkxYzJlZmYiLCJleHAiOjE1NjA4NTA2MzksIm5iZiI6MCwiaWF0IjoxNTYwODQ3MDM5LCJpc3MiOiJodHRwczovL2FwaS5sb2JkZXYuZnVzaW9uZmFicmljLmNsb3VkL2xvZ2luL3YxIiwic3ViIjoiYWI2NmNmOTktNGRkNy00NTM0LTlhN2MtNzNiZTE2ZTMwMDAzIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiNzBmNDYxZjktZjQ2MC00Y2RmLWFhMTQtNDk5NjdlYTM3ODgzIiwiYXV0aF90aW1lIjoxNTYwODQyOTQyLCJzZXNzaW9uX3N0YXRlIjoiYzcwZDhmMzAtZTI0Zi00OWU0LTg0MmYtZTY1NWU5ZmI4MGZkIiwiYWNyIjoiMCIsInNjb3BlIjoiY29ycG9yYXRlLWxlbmRpbmctd29ya2Zsb3ctdjAuOC03YmMxMGM4ZC1lNmFkLTRmYjctYTQzZC04ZTMzMzY3MDAwNTIgY29ycG9yYXRlLWxlbmRpbmctcHJlZGljdGl2ZS1hbmFseXRpY3MtdjAuOC04NjFhNDNjNC04N2IzLTQzNGItODBkYS03MmE4Nzc1ZjAxM2UgY29ycG9yYXRlLWxlbmRpbmctY29uZmlndXJhdGlvbi12MC44LTY0NTUyZjI2LWU1OTQtNGE3MC1hYmI1LTA5NDY0YzA1OTE2ZiBjb3Jwb3JhdGUtbGVuZGluZy1jdXN0b21lci12MC44LWI0YTk2OGQ3LTJmODAtNGZkNy04NGMyLTU1ZWRjOGIyZTdkOCBjb3Jwb3JhdGUtbGVuZGluZy1jcmVkaXQtYWdyZWVtZW50LXYwLjgtNmQ4NWZkYTMtN2E4Ny00MzIzLTkzZmMtODg1ZDk4ODEyZmRjIiwiYXBwIjoiOWJlZThiM2MtZThkMS00NTc1LTlhOTEtZGVkZDBlMDlmMmVjIiwidGVuYW50Ijoic2FuZGJveCIsInVzZXJuYW1lIjoiZmZkY3VzZXIxIn0.aqq5bSWA-WZ9nFKq28U4aGsNVahY_LuKQK-2-U5LydSwx9wKxirO2W-OTnReqVP85sD07oWQMB91Vnr9VeVtXHxoe-X2drXh8fqubJHrh9b77VNWdZ1UoL8P5Jv3S0pUuPKdHQJfHAajc4Sn8w_dLt3S-sPNcFdVtEjMCvgxtXKblea1JHpcLDzJpgvI42ZWsIaM880lPr9d-WLMcfO8pXHf2YxNQOGaXA0D8pboIN_D4LVA_M1wLj-noNQI2dPr1jNm3WRiFsRK61DTCwBxjJQJETBv0L8tq8zHy2EfzxSZcvbxrphyPAvs93dCGZBaLI8b8ZffHhDoH_dUBaeB6w';
                    //request.setHeader(FNS_Constants.AUTHORIZATION, FNS_Constants.Bearer+' ' + accessToken); 
                }
                request.setHeader('Authorization', 'Bearer '+accessToken);
            }
            
			
			//request.setEndpoint = param.bypassEndPoint ? (param.endPoint) : getEndPoint(param.endPoint,param.extendedAPIUrl);
            request.setMethod(param.methodName);
            request.setTimeout(99999);
            for(String str:param.headerMap.keySet()){
                request.setHeader(str, param.headerMap.get(str));  
            }
            //system.debug('urlEndPoint' + request.getEndpoint());        
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug(LoggingLevel.ERROR,'response>>>>'+response);
            return response;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /*****************************************************************************************************************************
     * @description  Method to check the authorization of SFDC to FFDC connection.
                     Fetch all the required parametrs i.e Consumer Key, Consumer secret from FNS_SFDC_FFDC_Setup custom setting.
     * @Params       none
     * @Returns      HTTPResponse
     *****************************************************************************************************************************/
    public static HTTPResponse authSFDCConnection(){
        HttpResponse response;
        FNS_SFDCFFDCSetup__c sfdcSetupObj = FNS_SFDCFFDCSetup__c.getOrgDefaults();

        String consumerKey = sfdcSetupObj.FNS_ConsumerKey__c;
        String consumerSecret = sfdcSetupObj.FNS_ConsumerSecret__c;
        String endPointURL = sfdcSetupObj.FNS_AccessTokenUrl__c;
        if (consumerKey != null) {
            String generatedToken ;
            String authMessage;
            String consumerKeyEncoded = EncodingUtil.urlEncode(consumerKey, FNS_Constants.ENCODEUTF8);
            String consumerSecretEncoded = EncodingUtil.urlEncode(consumerSecret, FNS_Constants.ENCODEUTF8);
            String ketTokenCombined = consumerKeyEncoded + ':' + consumerSecretEncoded;
            HTTPResponse objResponse;
            String authHeadParam = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(ketTokenCombined));
            Map<String, String> headerMap = new Map<String, String>{FNS_Constants.AUTHORIZATION=>authHeadParam}; 

            FNS_RequestParam param = new FNS_RequestParam();
            param.endPoint=endPointURL;
            param.methodName=FNS_Constants.METHOD_POST;
            param.body=FNS_Constants.GRANT_TYPE_CLIENT_CRED;
            param.headerMap=headerMap;
            response = FNS_IntegrationUtil.makeHTTPCallout(param);
        }
        return response;

    }

    /*****************************************************************************************************************************
     * @description  Method to get SFDC access token.
     * @Params       Auth. code as string
     * @Returns      Response body
     *****************************************************************************************************************************/
    public static String getSFDCAccessToken(string authCode){
        FNS_FFDCSFDCSetup__c SFDCData = FNS_FFDCSFDCSetup__c.getOrgDefaults();
        organization orgInfo = [select IsSandbox from Organization where id=:Userinfo.getOrganizationId()];
        string salesforceLoginURL = orgInfo.IsSandbox ? FNS_Constants.SANDBOX_LOGIN_URL : FNS_Constants.PRODUCTION_LOGIN_URL;
        String endpoint = salesforceLoginURL+FNS_Constants.TOKEN_URL;
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put(FNS_Constants.CONTENT_TYPE, FNS_Constants.CONTENT_TYPE_URLENCODED);
        String body = FNS_Constants.GRANT_TYPE_AUTH_CODE + 
                FNS_Constants.client_id + SFDCData.FNS_ConsumerKey__c + 
                FNS_Constants.client_secret + SFDCData.FNS_ConsumerSecret__c  + 
                FNS_Constants.AuthCode+ authCode + 
                FNS_Constants.redirect_uri + 
                EncodingUtil.urlEncode(SFDCData.FNS_RedirectURI__c, FNS_Constants.encodeUTF8) ;

        FNS_RequestParam param = new FNS_RequestParam();
        param.endPoint=endpoint;
        param.methodName=FNS_Constants.method_GET;
        param.body=body;
        param.headerMap=headerMap;
		param.bypassEndPoint=true;
        HttpResponse resp = makeHTTPCallout(param);
        if(resp.getStatusCode() == 200){
            //createRecords(resp.getBody());
        }
        return resp.getBody();
    }

    /*****************************************************************************************************************************
     * @description  Method for HTTP callout.
     * @Params       Object for FNS_RequestParam.
     * @Returns      Response body
     *****************************************************************************************************************************/
     public static HttpResponse getPostRequest(FNS_RequestParam param){
        if (param.headerMap == null){
            param.headerMap = new Map<String, String>();
            param.headerMap.put(FNS_Constants.ACCEPT, FNS_Constants.APPLICATION_JSON);
        }
        HttpResponse resp = makeHTTPCallout(param);
        return resp;
    }

    /*****************************************************************************************************************************
     * @description  Inner class act as Wrapper class for setting for get and post request.
     * @Params       none
     * @Returns      none
     *****************************************************************************************************************************/
    public with sharing class FNS_RequestParam{
        public Map<String, String> headerMap;
        public Boolean bypassEndPoint = false;
        public string endPoint;
        public string methodName;
        public string body;
        public Blob documentContent;
        public User contextUser;
        public String objectName;
        public Boolean bypassBackSlash = false;
        public String extendedAPIUrl;
    }


}