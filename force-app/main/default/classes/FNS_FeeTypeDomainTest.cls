/*****************************************************************************************
* @description This class is used to perform DML using json for an Application.
* @author Keerthi Kambhampati
* @date Apr 26 2019
* @Support Email keerthi@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_FeeTypeDomainTest {
    
    @isTest static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://finastra-api.herokuapp.com/corporate-lending/origination/v0.8/configuration/banks');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        
        Object valueReceived = FNS_FeeTypeDomain.getConfigurations();
        
        System.assertNotEquals(null, valueReceived);
        System.assertEquals(200, res.getStatusCode());
    }
    
}