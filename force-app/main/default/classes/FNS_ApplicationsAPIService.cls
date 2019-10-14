/**
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group API Service
 * @description Helps in Application get and post request.
 */  
public with sharing class FNS_ApplicationsAPIService extends FNS_JSONAPIBusinessLayer{

	public FNS_ApplicationsAPIService() { }

	/*************************************************************************************
	 * @description  Constructs the domain class for Opportunity 
	 * @Params       FNS_RequestParam object
	 * @Returns       String as response object
	 **************************************************************************************/
	public override HttpResponse getResponse(FNS_IntegrationUtil.FNS_RequestParam param){
		return FNS_IntegrationUtil.getPostRequest(param);
	}

	/*************************************************************************************
	 * @description  Constructs the domain class for Opportunity 
	 * @Params       FNS_RequestParam object
	 * @Returns      String as response object
	 **************************************************************************************/
	public override HttpResponse postRequest(FNS_IntegrationUtil.FNS_RequestParam param){
		return FNS_IntegrationUtil.getPostRequest(param);
	}
}