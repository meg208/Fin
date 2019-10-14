/*********************************************************************************************
* @description This class is map JSON values to the Object
* @author Keerthi Kambhampati
* @date March 5th 2019
* @Support Email Keerthi@comitydesigns.com
*********************************************************************************************/
public with sharing class FNS_WorkflowConfigurationsAPIService extends FNS_JSONAPIBusinessLayer{
    public override HttpResponse getResponse(FNS_IntegrationUtil.FNS_RequestParam param){
        return FNS_IntegrationUtil.getPostRequest(param);
    }

    public override HttpResponse postRequest(FNS_IntegrationUtil.FNS_RequestParam param){
        return null;
    }
}