@isTest
public class FNS_RefreshDataFromCMEControllerTest {

    static testMethod void refreshActivitiesTest() {        
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://finastra-api.herokuapp.com/corporate-lending/origination/v0.8/workflow-process/workflow-configurations');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        Test.startTest();
        Object valueReceived = FNS_RefreshDataFromCMEController.refreshActivities();
        Test.stopTest();
        System.debug('configurations>> '+valueReceived);
        System.assertNotEquals(null, valueReceived);
        System.assertEquals(200, res.getStatusCode());
    }
    
    static testMethod void refreshBankDomainsTest() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://finastra-api.herokuapp.com/corporate-lending/origination/v0.8/configuration/banks');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        
        Object valueReceived = FNS_RefreshDataFromCMEController.refreshBankDomains();
        
        System.assertNotEquals(null, valueReceived);
        System.assertEquals(200, res.getStatusCode());
    }
    
    static testMethod void refreshProcessCenterDomainTest() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://finastra-api.herokuapp.com/corporate-lending/origination/v0.8/configuration/process-centers');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        
        Object valueReceived = FNS_RefreshDataFromCMEController.refreshProcessCenterDomain();
        
        System.assertNotEquals(null, valueReceived);
        System.assertEquals(200, res.getStatusCode());
    }
    
    static testMethod void refreshProcessGroupTest() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://finastra-api.herokuapp.com/corporate-lending/origination/v0.8/configuration/process-groups');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = (String)res.getBody();
        
        Object valueReceived = FNS_RefreshDataFromCMEController.refreshProcessGroup();
        
        System.assertNotEquals(null, valueReceived);
        System.assertEquals(200, res.getStatusCode());
    }
    
    static testMethod void refreshProductTypeTest() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://finastra-api.herokuapp.com/corporate-lending/origination/v0.8/configuration/product-types');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        
        Object valueReceived = FNS_RefreshDataFromCMEController.refreshProductType();
        
        System.assertNotEquals(null, valueReceived);
        System.assertEquals(200, res.getStatusCode());
    }
    
    static testMethod void refreshConfigurationTypeTest() {
        Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://finastra-api.herokuapp.com/corporate-lending/origination/v0.8/configuration/configuration-data');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        
        Object valueReceived = FNS_RefreshDataFromCMEController.refreshConfigurationType();
        
        System.assertNotEquals(null, valueReceived);
        System.assertEquals(200, res.getStatusCode());
    }
}