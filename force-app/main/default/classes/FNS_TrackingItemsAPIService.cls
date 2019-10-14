/*****************************************************************************************
* @description This class Provides a router support to get and post response
* @author Keerthi Kambhampati
* @date Mar 22 2019
* @Support Email Keerthi@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_TrackingItemsAPIService extends FNS_JSONAPIBusinessLayer{
    public override HttpResponse getResponse(FNS_IntegrationUtil.FNS_RequestParam param){
        return FNS_IntegrationUtil.getPostRequest(param);
    }

    public override HttpResponse postRequest(FNS_IntegrationUtil.FNS_RequestParam param){
        return FNS_IntegrationUtil.getPostRequest(param);
    }
}