({
    getSetupData : function(component, event, helper) {
        
        let action = component.get("c.getSetupData");
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                console.log('Connect Response>>',response.getReturnValue());
                component.set('v.connectData', response.getReturnValue()/*.FFDC_SFDC*/);  
            }else if(response.getState() === 'ERROR'){
                console.log('ERROR');
                if(response.getState()){
                    helper.showToast(component,event, helper,"Error","Error",$A.get("$Label.c.FNS_RECORD_NOT_FOUND"));
                }
            }
        });
        $A.enqueueAction(action);  
    },
    showToast : function(component, event, helper,title,type,msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": msg
        });
        toastEvent.fire();
    },
    doValid : function(component, event, helper) {
        var validData = component.find('setup').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (validData) {
            helper.saveSetup(component,event,helper);
        }
        console.log('>>>>>',component.get("v.connectData"));
        
    },
    saveSetup : function(component,event,helper){
        let action = component.get("c.saveSetupData");
        let connectData = component.get('v.connectData');
        action.setParams({
            'connectData' : JSON.stringify(connectData),
            'connectType': 'FFDC_SFDC'
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                helper.showToast(component,event, helper,"Success","Success", 'Record updated Successfully'/*$A.get("$Label.c.FNS_RECORD_NOT_FOUND")*/);
                component.set("v.edit",false);
            }else if(response.getState() === 'ERROR'){
                helper.showToast(component,event, helper,"Error","Error", 'Something wrong while updating Record'/*$A.get("$Label.c.FNS_RECORD_NOT_FOUND")*/);
            }
        });
        $A.enqueueAction(action);  
    },
    authenticate : function(component,event,helper){
        console.log('Success11');
        let sessionAction = component.get("c.getSessionId");
         sessionAction.setCallback(this, function(response){
             let sessionRes = response.getReturnValue();
             console.log('sessioAction>>',response.getReturnValue());
          });
        $A.enqueueAction(sessionAction);    //return; 
        var urlAddress = 'https://test.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG954MqIw6FnnMN3LfIsfd8tLlrjmvEe1dAOGf2IH3lF4iAa1NsoU3.sGyTP7Pz1KL7hqs.w64Z.g8MwXVH&redirect_uri=https://connect-enterprise-4016-dev-ed.lightning.force.com/lightning/n/FNS_FinastraSetup&un=test-vo8w5ya4x2ay@example.com';
        let action = component.get("c.authenticateConnection");
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                console.log('Success>>',response.getReturnValue());
                /**Redirect URL Start**/
                	var navEvt = $A.get("e.force:navigateToURL");
                    navEvt.setParams({
                      "url": urlAddress
                    });
                     //navEvt.fire();
                	window.open(urlAddress, '_self');
                /**Redirect URL End**/
                //window.location.href = response.getReturnValue();
            }else if(response.getState() === 'ERROR'){
                 console.log('Failed');
            }
        });
        $A.enqueueAction(action);  
    },
    authenticatesfdc : function(component,event,helper){
       let action = component.get("c.saveSetupData");
        action.setParams({
            'connectData' : JSON.stringify(connectData),
            'connectType': 'FFDC_SFDC'
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                helper.showToast(component,event, helper,"Success","Success", 'Record updated Successfully'/*$A.get("$Label.c.FNS_RECORD_NOT_FOUND")*/);
                component.set("v.edit",false);
            }else if(response.getState() === 'ERROR'){
                helper.showToast(component,event, helper,"Error","Error", 'Something wrong while updating Record'/*$A.get("$Label.c.FNS_RECORD_NOT_FOUND")*/);
            }
        });
        $A.enqueueAction(action);  
    }
    
    
})