/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description Test class ProcessGroup.
****************************************************************************************/
@isTest
public class FNS_ProcessGroupDomainTest {
    
    @isTest static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://finastra-api.herokuapp.com/corporate-lending/origination/v0.8/configuration/process-groups');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        
        Object valueReceived = FNS_ProcessGroupDomain.getConfigurations();
        
        System.assertNotEquals(null, valueReceived);
        System.assertEquals(200, res.getStatusCode());
    }
    
}