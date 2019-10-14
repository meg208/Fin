({
    doInitHelper : function(component, event, helper) {
        let action = component.get("c.verifyApplicationConditions");
        action.setParams({ "applicationId" : component.get('v.recordId') });
        action.setCallback(this, function(response) {
            let state = response.getState();
            component.set("v.isLoaded", "true");
            if (state === "SUCCESS") {
                 let conditionValues = response.getReturnValue();
                 if(!$A.util.isEmpty(conditionValues.error)){
                    component.set("v.responseError", conditionValues.error);
                }else{
                    component.set("v.productCnt", conditionValues['productCount']);
                	if(conditionValues['productCount'] > 0 && conditionValues['quipFinalized'] === true){
                    component.set("v.isDisabled", false);
                    component.set("v.message", $A.get("$Label.c.FNS_APPLICATION_SUBMIT_MESSAGE"));
                	}else {
                    if(conditionValues['quipFinalized'] === false){
                        component.set("v.message", $A.get("$Label.c.FNS_APPLICATION_SUBMIT_QUIP_ERROR"));
                    }else if(conditionValues['productCount'] == 0){
                        component.set("v.message", $A.get("$Label.c.FNS_APPLICATION_SUBMIT_ERROR"));
                    }
                    component.set("v.isDisabled", true);
                	}
                }
            }else {
                component.set("v.productCnt", "0");
            }
        });
        $A.enqueueAction(action);
    },
  
	handleYes : function(component, event, helper) {
        component.set("v.isFilterApply", true);
        let action = component.get("c.submitApplication");
        action.setParams({ "applicationId" : component.get('v.recordId') });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isFilterApply", false);
                $A.get("e.force:closeQuickAction").fire();
                helper.showToast(component,event, helper,"Success","Success", $A.get("$Label.c.FNS_APPLICATION_SUBMIT_SUCCESS"));
                $A.get('e.force:refreshView').fire();
			}else if (state === "ERROR") {
               component.set("v.isFilterApply", false);
               $A.get("e.force:closeQuickAction").fire();
               helper.showToast(component,event, helper,"Error","Error", $A.get("$Label.c.FNS_APPLICATION_SUBMIT_ERROR_MSG"));
            }
        });
        $A.enqueueAction(action);
    },
    showToast : function(component, event, helper,title,type,msg) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": msg
        });
        toastEvent.fire();
    }
})