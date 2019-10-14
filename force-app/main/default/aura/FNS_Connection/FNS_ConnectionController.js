({
    doInit : function(component, event, helper) {
        helper.getSetupData(component, event, helper);
        
        var sessionState = helper.getUrlParameter('fcc__session_state');
        var code = helper.getUrlParameter('fcc__code');

        if(component.get("v.authType")==="SFDC_FFDC" && !$A.util.isUndefinedOrNull(sessionState) && !$A.util.isUndefinedOrNull(code)) {
			//helper.getFFDCAccessToken(component, event, helper, sessionState, code);
        }
        else if(component.get("v.authType")=== "FFDC_SFDC" && $A.util.isUndefinedOrNull(sessionState) && !$A.util.isUndefinedOrNull(code)){
            component.set("v.authCode", code);
            helper.getSFDCAccessToken(component, event, helper);
        }
    },
    authorize : function(component, event, helper){
        if(component.get("v.authType")==="SFDC_FFDC")
            helper.checkAuthSFDCConnection(component, event, helper);
        else if(component.get("v.authType")=== "FFDC_SFDC"){
            helper.generateAuthURL(component, event, helper);
        }
    },
    edit : function(component, event, helper){
        component.set("v.edit",true);
    },
    save : function(component, event, helper){
        helper.doValid(component, event, helper);
    },
    cancel: function(component, event, helper){
        component.set("v.edit",false);
    }
})