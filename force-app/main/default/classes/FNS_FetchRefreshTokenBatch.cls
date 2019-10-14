/********************************************************************************************************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Batch class
* @description Batch Class is used to update the refresh and access token of all the user having IsValidRefreshToken = true in SFDCFFDCConnection custom metadata. 
As refresh token expires in 1 hour so this batch takes care to update.
********************************************************************************************************************************************************************/
public with sharing class FNS_FetchRefreshTokenBatch implements Database.Batchable<SObject>, Database.Stateful,Database.AllowsCallouts{
    private static string baseNamespace = FNS_Util.getBasePackageNamepace();
    private String clientId;
    private String clientSecret;
    private String endpointUrl;
    private Map<String,FNS_ObjectContainer.FNS_Authentication> configMap = new Map<String,FNS_ObjectContainer.FNS_Authentication>();
    
    /*****************************************************************************************
    * @description  Constructor to initialize consumer key, consumer secret and EndPoint URL.
    * @Params       null
    * @Returns      null
    *****************************************************************************************/
    public FNS_FetchRefreshTokenBatch(){
        List<FNS_SFDCFFDCConnection__mdt> authRecordList = new FNS_SFDCFFDCConnectionSelector().selectRecordsByUserNames(new Set<String>{'Authorization'});
        for (FNS_SFDCFFDCConnection__mdt authObj :authRecordList){
            clientId = authObj.FNS_ConsumerKey__c;
            clientSecret = authObj.FNS_ConsumerSecret__c;
            endpointUrl = authObj.FNS_AccessTokenURL__c ;
        }
    }
    
    /***************************************************************************************
    * @description  Method to get all the records from SFDCFFDCConnection custom metadata.
    * @Params       Database.BatchableContext object.
    * @Returns      Database.queryLocator as result from query 
    ****************************************************************************************/
    public Database.queryLocator start(Database.BatchableContext batchContext){
        try{  
            system.debug('@@@ clientId ' + clientId +' clientSecret ' +  clientSecret +' endpointUrl' + endpointUrl);
            if(clientId == null || clientSecret == null || endpointUrl == null ){
                //throw custom exception or terminate the batch job
            }
            String queryStr = 'Select Masterlabel ,FNS_UserExternalID__c,FNS_RefreshToken__c,FNS_AccessToken__c,FNS_IsValidRefreshToken__c,FNS_ConsumerKey__c,FNS_ConsumerSecret__c,FNS_AccessTokenValidityTime__c from  FNS_SFDCFFDCConnection__mdt ' ;
            system.debug('@@@' + queryStr);
            return Database.getQueryLocator(queryStr);
        }catch (Exception ex){
            System.debug('\n' + ex);
        }
        return null;
    }
    
    /*************************************************************************************
    * @description  Method to update refersh and access token based on API response.
    * @Params       Database.BatchableContext object.
    * @Params       List<sObject> as recordList.
    * @Returns      null
    *************************************************************************************/
    public void execute(Database.BatchableContext batchContext,List<SObject> recordList){
        try{ 
            system.debug('recordList ::'+ recordList + ' @@ recordList Size :: '+ recordList.size());
            for(SObject result: recordList){
                if(result.get('FNS_IsValidRefreshToken__c') != true){
                    system.debug('@@@@ test :: '+ result.get('Masterlabel'));
                    continue;
                }
                
                system.debug('@@ result Date ::' + DateTime.valueOf(result.get('FNS_AccessTokenValidityTime__c')));
                String lbl = (String) result.get(FNS_Constants.MASTER_LABEL);
                Map<String, Object> dataMap = new Map<String, Object>();
                // if(DateTime.valueOf(result.get('FNS_AccessTokenValidityTime__c')) > system.now()){
                String refreshToken = (String) result.get('FNS_RefreshToken__c');
                HttpRequest request = new HttpRequest();
                request.setEndpoint(endpointUrl);
                request.setMethod(FNS_Constants.METHOD_POST);
                request.setBody(
                    'refresh_token=' + refreshToken +
                    '&client_id=' + clientId + 
                    '&client_secret=' + clientSecret +
                    '&grant_type=' + FNS_Constants.REFRESH_TOKEN
                );
                Http http = new Http();
                HTTPResponse res = http.send(request);
                system.debug('### res'+ res.getStatusCode());
                FNS_ObjectContainer.FNS_Authentication configObj = (FNS_ObjectContainer.FNS_Authentication)JSON.deserialize(res.getBody(), FNS_ObjectContainer.FNS_Authentication.class);
                if (res.getStatusCode() == 200){
                    dataMap.put(baseNamespace+'FNS_AccessToken__c',configObj.access_token);
                    dataMap.put(baseNamespace+'FNS_RefreshToken__c',configObj.refresh_token);
                } else {
                    dataMap.put(baseNamespace+'FNS_AccessToken__c',null);
                    dataMap.put(baseNamespace+'FNS_RefreshToken__c',null);
                    dataMap.put(baseNamespace+'FNS_Error__c', res.getBody());
                    dataMap.put(baseNamespace+'FNS_IsValidRefreshToken__c',false);
                }
                /* } else {
					dataMap.put('FNS_IsValidRefreshToken__c',false);
				} */
                //Updation of custom metadata is not count against governer limit so we can use inside o for loop.
                FNS_UpdateMetadata.CreateUpdateCustomMetaData('FNS_SFDCFFDCConnection'+'.'+lbl,lbl,dataMap);
            }
        }catch (Exception ex){
            System.debug('\n' + ex);
        }
    }
    
    public void finish(Database.BatchableContext batchContext){
    }
    
}