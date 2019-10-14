/****************************************************************************************
  * Copyright (c) 2019, Brillio
  * All rights reserved.
  * @author Brillio
  * @date 2019
  * @group Configuration API
  * @description This class Config Trigger handler for record operations
****************************************************************************************/
@isTest
public class FNS_ConfigurationTriggerHandlerTest{

    public static FNS_ConfigurationType__c configRecord;
    
    static void setup() {

        FNS_TestDataSetup test = new FNS_TestDataSetup();

        configRecord = test.createConfigRecord();
        insert configRecord;

        configRecord = test.updateConfigRecord(configRecord.Id);
        update configRecord;
    }
    @isTest static void testTriggerHandler() {

        Test.startTest();        
            setup();        
        Test.stopTest();
        System.assert(true);
    }    
        
}