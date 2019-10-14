/************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group MetaData
 * @description Class is created for handling custom metadata.
 ****************************************************************************************/
public with sharing class FNS_CustomMetadataCallback implements Metadata.DeployCallback {
    public void handleResult(Metadata.DeployResult result,
                             Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug('success: '+ result);
        } else {
            // Deployment was not successful
            System.debug('fail: '+ result);
        }
    }
}