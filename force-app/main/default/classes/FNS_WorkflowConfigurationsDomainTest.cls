/*********************************************************************************************************************************
    * @description This class is used to insert workflow configuration data into FNS_Activity__c object common for all applications
    * @author Keerthi Kambhampati
    * @date April 25th 2019
    * @Support Email Keerthi@comitydesigns.com
    **********************************************************************************************************************************/
	@isTest
    public class FNS_WorkflowConfigurationsDomainTest {

        @isTest static void testCallout() {
            Test.setMock(HttpCalloutMock.class, new FNS_GetAPIMockResponse());
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://finastra-api.herokuapp.com/corporate-lending/origination/v0.8/workflow-process/workflow-configurations');
            req.setMethod('GET');
            Http h = new Http();
            HttpResponse res = h.send(req);
            
            String contentType = res.getHeader('Content-Type');
            System.assert(contentType == 'application/json');
            String actualValue = res.getBody();
            
            Object valueReceived = FNS_WorkflowConfigurationsDomain.getConfigurations();
            
            System.assertNotEquals(null, valueReceived);
            System.assertEquals(200, res.getStatusCode());
        }

	}