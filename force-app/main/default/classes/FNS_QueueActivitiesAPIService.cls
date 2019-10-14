public with sharing class FNS_QueueActivitiesAPIService extends FNS_JSONAPIBusinessLayer {
     public override HttpResponse getResponse(FNS_IntegrationUtil.FNS_RequestParam param){
        return FNS_IntegrationUtil.getPostRequest(param);
    }

    public override HttpResponse postRequest(FNS_IntegrationUtil.FNS_RequestParam param){
        return FNS_IntegrationUtil.getPostRequest(param);
    }
}