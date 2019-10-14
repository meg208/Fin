/*****************************************************************************************
* @description Class is used to handle all request from FNS_trackingItems.cmp.
* @author Praneeth Aitharaju
* @date 25/03/2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_DocumentUploadAPIService extends FNS_JSONAPIBusinessLayer{
    public override HttpResponse getResponse(FNS_IntegrationUtil.FNS_RequestParam param){
        return FNS_IntegrationUtil.getPostRequest(param);
    }

    public override HttpResponse postRequest(FNS_IntegrationUtil.FNS_RequestParam param){
        return FNS_IntegrationUtil.getPostRequest(param);
    }
}