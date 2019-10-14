/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Activities
    * @description This class Provides a router support to get and post response
  */
public with sharing class FNS_PredictiveAnalyticsAPIService extends FNS_JSONAPIBusinessLayer{
    
    /*************************************************************************************
	 * @description  Method for get Callout 
	 * @Params       FNS_IntegrationUtil.FNS_RequestParam 
	 * @Returns      String
	 **************************************************************************************/
    public override HttpResponse getResponse(FNS_IntegrationUtil.FNS_RequestParam param){
        return FNS_IntegrationUtil.getPostRequest(param);
    }

    /*************************************************************************************
	 * @description  Method for put Callout 
	 * @Params       FNS_IntegrationUtil.FNS_RequestParam 
	 * @Returns      String
	 **************************************************************************************/
    public override HttpResponse postRequest(FNS_IntegrationUtil.FNS_RequestParam param){
        return null;
    }
}