({
    initiateAllApplicationAPIcalls : function(component, event, helper){
       
        let action = component.get("c.initiateApplicationAPIs");
        var recordId = component.get("v.recordId");
        action.setParams({ appRecordId: recordId}); 
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if(state === "SUCCESS"){
               let result = response.getReturnValue();
               if(!$A.util.isEmpty(result.error)){
                    component.set("v.responseError",result.error);
               }else{
                    component.set("v.isReadOnly",result.isReadOnly);
               }
            }
           
        })        
        $A.enqueueAction(action);
    },
    checkCondition : function(component, event, helper) {
        let action = component.get("c.verifyApplicationConditions");
        action.setParams({ "applicationId" : component.get('v.recordId') });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                 let conditionValues = response.getReturnValue();
                 if(!$A.util.isEmpty(conditionValues.error)){
                    component.set("v.responseError", conditionValues.error);
                }else{
                    component.set("v.productCnt", conditionValues['productCount']);
                	if(conditionValues['productCount'] > 0 && component.get("v.OpptyRecord.FNS_QuipFinalized__c")){
                    	component.set("v.message", $A.get("$Label.c.FNS_APPLICATION_SUBMIT_MESSAGE"));
                         component.set("v.isDisabled", false);
                	}else {
                    if(component.get("v.OpptyRecord.FNS_QuipFinalized__c")==false){
                        component.set("v.message", $A.get("$Label.c.FNS_APPLICATION_SUBMIT_QUIP_ERROR"));
                    }else if(conditionValues['productCount'] == 0){
                        component.set("v.message", $A.get("$Label.c.FNS_APPLICATION_SUBMIT_ERROR"));
                    }
                    component.set("v.isDisabled", true);
                	}
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleYes : function(component, event, helper){
         component.set("v.spinner", true);
        let action = component.get("c.submitApplication");
        action.setParams({ "applicationId" : component.get('v.recordId') });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                if(!$A.util.isEmpty(result.error)){
                   helper.showToast(component,event, helper,"Error","Error", $A.get("$Label.c.FNS_APPLICATION_SUBMIT_ERROR_MSG")+result.error);
                }else {
                    helper.showToast(component,event, helper,"Success","Success", $A.get("$Label.c.FNS_APPLICATION_SUBMIT_SUCCESS"));
                    $A.get("e.force:refreshView").fire();
                }
            }
            else if (state === "ERROR") {
               component.set("v.spinner", false);
               helper.showToast(component,event, helper,"Error","Error", $A.get("$Label.c.FNS_APPLICATION_SUBMIT_ERROR_MSG"));
            }
            component.set("v.isOpen", false);
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    showToast : function(component, event, helper,title,type,msg){
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": msg
        });
        toastEvent.fire();
    }
})