/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Router Class
* @description This class Provides a router support to get and post response 
****************************************************************************/
public with sharing class FNS_BanksAPIService extends FNS_JSONAPIBusinessLayer{
    /***********************************************************************
    * @description This method creates appropriate request for get Bank API call
    * @param Instance of FNS_IntegrationUtil.FNS_RequestParam
    * @return returns instance of FNS_IntegrationUtil.getPostRequest 
    ************************************************************************/
    public override HttpResponse getResponse(FNS_IntegrationUtil.FNS_RequestParam param){
        return FNS_IntegrationUtil.getPostRequest(param);
    }

    /***********************************************************************
    * @description This method creates appropriate request for post Bank API call
    * @param Instance of FNS_IntegrationUtil.FNS_RequestParam
    * @return null 
    ************************************************************************/
    public override HttpResponse postRequest(FNS_IntegrationUtil.FNS_RequestParam param){
        return null;
    }
}