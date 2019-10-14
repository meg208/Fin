/**
 * Created Date     : March 12, 2019
 * Developed By     : Vishal Patel, Comity Designs, Inc.
 *
 * Function         : Provides a router support to get and post response
 * Support Email    : email
 * Version          : 1.0
 *
 * Modification Log
 *
 * Developer Name           User Story              Date            Version             Description
 *____________________________________________________________________________________________________
 *
 * Vishal                   User Story              March 12, 2019          1.1                 @description
 *
 */
public with sharing abstract class FNS_JSONAPIBusinessLayer {
    public abstract HttpResponse getResponse(FNS_IntegrationUtil.FNS_RequestParam param);
    public abstract HttpResponse postRequest(FNS_IntegrationUtil.FNS_RequestParam param);
}