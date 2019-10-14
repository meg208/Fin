/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description This class Provides a router support to get and post response
****************************************************************************************/
public with sharing class FNS_ProcessGroupsAPIService extends FNS_JSONAPIBusinessLayer{
    public override HttpResponse getResponse(FNS_IntegrationUtil.FNS_RequestParam param){
        return FNS_IntegrationUtil.getPostRequest(param);
    }

    public override HttpResponse postRequest(FNS_IntegrationUtil.FNS_RequestParam param){
        return null;
    }
}