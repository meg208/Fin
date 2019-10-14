/**
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group API Service
 * @description Helps in invoking appropriate API service class based on parameters.
 */  
public with sharing class FNS_JSONAPIRouter {
	
	public FNS_JSONAPIRouter() { }

	/*************************************************************************************
	 * @description  Method to perform get or a post request based on the payload request sent 
	 * @Params       none
	 * @Returns      HTTPResponse
	 *************************************************************************************/
	// Perform get or a post request based on the payload request sent 
    public HttpResponse getPostRequest(FNS_IntegrationUtil.FNS_RequestParam param) {
        HttpResponse jsonResponse = null;
        
        // Check the payload
        if (param!=null){
            // Deserialize the payload to the payload class
            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            
            // Get the object name and id
            if (param.objectName != null){
                // Instantiate the class based on the object name retrieved
                String className = 'FNS_' + param.objectName+ 'APIService';
                // Create the instance of the class and invoke GET or POST
                Type typeObj = type.forName(className);
                Object handler = typeObj.newInstance();
                if (handler instanceof FNS_JSONAPIBusinessLayer) {
                    //param.bypassEndPoint = true;
                    //string accessToken = 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJYTEJpUk5ZMkRvWS0wREVkQVBsMmJxUGpJWXZRUjVqalhBMmczZzczQzYwIn0.eyJqdGkiOiIxZjAxNzNjMi01OWJjLTQ3NWMtODFkZC0zNDUzMzVmMDdjZTIiLCJleHAiOjE1NjA5NzcxMzgsIm5iZiI6MCwiaWF0IjoxNTYwOTczNTM4LCJpc3MiOiJodHRwczovL2FwaS5sb2JkZXYuZnVzaW9uZmFicmljLmNsb3VkL2xvZ2luL3YxIiwic3ViIjoiYWI2NmNmOTktNGRkNy00NTM0LTlhN2MtNzNiZTE2ZTMwMDAzIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiNzBmNDYxZjktZjQ2MC00Y2RmLWFhMTQtNDk5NjdlYTM3ODgzIiwiYXV0aF90aW1lIjoxNTYwOTczNDg3LCJzZXNzaW9uX3N0YXRlIjoiN2Q3MzEzZWQtZTZiYi00ZTY5LWIyMjAtOTBiMDk5YmI4YTZkIiwiYWNyIjoiMCIsInNjb3BlIjoiY29ycG9yYXRlLWxlbmRpbmctcHJlZGljdGl2ZS1hbmFseXRpY3MtdjAuOC04NjFhNDNjNC04N2IzLTQzNGItODBkYS03MmE4Nzc1ZjAxM2UgY29ycG9yYXRlLWxlbmRpbmctd29ya2Zsb3ctdjAuOC03YmMxMGM4ZC1lNmFkLTRmYjctYTQzZC04ZTMzMzY3MDAwNTIgY29ycG9yYXRlLWxlbmRpbmctY3VzdG9tZXItdjAuOC1iNGE5NjhkNy0yZjgwLTRmZDctODRjMi01NWVkYzhiMmU3ZDggY29ycG9yYXRlLWxlbmRpbmctY3JlZGl0LWFncmVlbWVudC12MC44LTZkODVmZGEzLTdhODctNDMyMy05M2ZjLTg4NWQ5ODgxMmZkYyBjb3Jwb3JhdGUtbGVuZGluZy1jb25maWd1cmF0aW9uLXYwLjgtNjQ1NTJmMjYtZTU5NC00YTcwLWFiYjUtMDk0NjRjMDU5MTZmIiwiYXBwIjoiOWJlZThiM2MtZThkMS00NTc1LTlhOTEtZGVkZDBlMDlmMmVjIiwidGVuYW50Ijoic2FuZGJveCIsInVzZXJuYW1lIjoiZmZkY3VzZXIxIn0.etkgyz-8CwK0iNTp7b1EfbzFDDAftY-p4ZmcOMQhpVDTkywdgdfY2wlDeUAzC4eZ2KIUFt16FuOvowRDQnXg2MqCirbu3WiKJOFEpyv2QsgMFovGqCC3dUO3cmBs_w0_KP9Jkte7jAF7hVhFAWWpIcvWC5_n2C_tcsRVFM3fOzYXgGcEge36aa9GPUtiozfr5I56WBxLqutaFGU06mQFLI6sgXLZxj_EB-7b_ijR3s_ev_Gve-l_IyT_Ftz00fX_LhPpUgdKyImUVLhaliupbrapymJ2CfvdOrpx06iMB4gnoSJTzm8mf7S19JvwxByb8LSnzBdYEux-l_hOz4-mrA';
                    //param.endPoint = 'https://api.lobdev.fusionfabric.cloud/corporate-lending/origination/credit-agreement/v0.8/applications';
                    //
                    if (param.headerMap == null){
                        param.headerMap = new Map<String,String>();
                    }
                    //param.headerMap.put('Authorization', 'Bearer '+accessToken);
                    System.debug('ZZZ customer params - '+param);

                    if (param.methodName == null || param.methodName == 'GET'){
                        param.methodName = FNS_Constants.METHOD_GET;
                        jsonResponse = ((FNS_JSONAPIBusinessLayer) handler).getResponse(param);
                    } else {
                        //param.methodName = FNS_Constants.METHOD_POST;
                        jsonResponse = ((FNS_JSONAPIBusinessLayer) handler).postRequest(param);
                    }
                }
            }
        }   
        return jsonResponse;
    }
}