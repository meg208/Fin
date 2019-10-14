({
    getSetupData : function(component, event, helper) {
        let action = component.get("c.getSetupData");
        action.setParams({connectType:component.get("v.authType")});
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                //console.log('getSetupData>>',response.getReturnValue());
                component.set('v.connectData', response.getReturnValue());
            }else if(response.getState() === 'ERROR'){
                helper.showToast(component,event, helper,"Error","Error",$A.get("$Label.c.FNS_RECORD_NOT_FOUND"));
            }
        });
        $A.enqueueAction(action);  
    },
    getSFDCAccessToken : function(component, event, helper) {
        let action = component.get("c.getSFDCAccessToken");
        action.setParams({"authCode":component.get('v.authCode')});
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                console.log('SFDC Access Token>>',JSON.parse(response.getReturnValue()));
                let result = JSON.parse(response.getReturnValue());
                if (!$A.util.isUndefinedOrNull(result.access_token) /*result.statusCode==200*/){
                    helper.showToast(component,event, helper,"SUCCESS","SUCCESS",$A.get("$Label.c.FNS_AUTH_SUCCESSFUL"));
                }else 
                    helper.showToast(component,event, helper,"Error","Error",$A.get("$Label.c.FNS_AUTH_FAILED"));
            }else if(response.getState() === 'ERROR'){
                console.log('Failed');
                helper.showToast(component,event, helper,"Error","Error",$A.get("$Label.c.FNS_AUTH_FAILED"));
                
            }
        });
        $A.enqueueAction(action);  
    },
    getFFDCAccessToken : function (component, event, helper, sessionState, code) {
        let action = component.get("c.getFFDCValues");
        action.setParams({
            "sessionState":sessionState, 
            "code": code
        });
        
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                helper.showToast(component,event, helper,"SUCCESS","SUCCESS",$A.get("$Label.c.FNS_AUTH_SUCCESSFUL"));
            }else if(response.getState() === 'ERROR'){
                helper.showToast(component,event, helper,"Error","Error",$A.get("$Label.c.FNS_AUTH_FAILED"));                
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
    },
    saveSetup : function(component,event,helper){
        let action= component.get("c.saveSetupData");
        let connectData = component.get('v.connectData');
        action.setParams({
            'connectData' : JSON.stringify(connectData),
            'connectType': component.get("v.authType")
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                helper.showToast(component,event, helper,"Success","Success", $A.get("$Label.c.FNS_RECORD_UPDATE_SUCCESS"));
                component.set("v.edit",false);
            }else if(response.getState() === 'ERROR'){
                helper.showToast(component,event, helper,"Error","Error", $A.get("$Label.c.FNS_RECORD_UPDATE_FAILED"));
            }
        });
        $A.enqueueAction(action);  
    },
    getUrlParameter :function(sParam){
        let sPageURL = window.location.search.substring(1),
            sURLVariables = sPageURL.split('&'),sParameterName,i;
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            console.log('sParameterName>>',sParameterName);
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? '' : sParameterName[1];
            }
        }
    },
    checkAuthSFDCConnection : function(component,event,helper){
        let action = component.get("c.checkAuthSFDCConnection");
        let connectData = component.get('v.connectData');
        action.setParams({
        });
        
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                var decURL = decodeURIComponent(response.getReturnValue());
                window.open(decURL, "_self"); 
            }
            /*   let result = JSON.parse(response.getReturnValue());
                if (result.statusCode==200){
                    helper.showToast(component,event, helper,"SUCCESS","SUCCESS",$A.get("$Label.c.FNS_AUTH_SUCCESSFUL"));
                }else 
                    helper.showToast(component,event, helper,"Error","Error",$A.get("$Label.c.FNS_AUTH_FAILED"));
            }else if(response.getState() === 'ERROR'){
                console.log(response.getState());
                helper.showToast(component,event, helper,"Error","Error",$A.get("$Label.c.FNS_AUTH_FAILED"));
                
            }
            */
            
        });
        $A.enqueueAction(action);  
    },
    //We do not restrict user to authorize multiple time. Thus this is removed.
    /*doAuth:function(component, event, helper){
        component.set("v.authCode", helper.getUrlParameter('code'));
        console.log('authcode>>',component.get('v.authCode'));
        if($A.util.isUndefinedOrNull(component.get('v.authCode'))){
            console.log('Call Authorize method>>');
            helper.generateAuthURL();
        }
    },*/
    generateAuthURL:function(component,event,helper){
        let action= component.get("c.generateAuthURL");
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                console.log('generateAuthURL>>>',response.getReturnValue());
                if(response.getReturnValue()){
                    let navEvt = $A.get("e.force:navigateToURL");
                    navEvt.setParams({
                        "url": response.getReturnValue()
                    });
                    navEvt.fire();
                }
            }else if(response.getState() === 'ERROR'){
                helper.showToast(component,event, helper,"Error","Error", $A.get("$Label.c.FNS_GENERATE_URI_FAILED"));
            }
        });
        $A.enqueueAction(action); 
    }
})