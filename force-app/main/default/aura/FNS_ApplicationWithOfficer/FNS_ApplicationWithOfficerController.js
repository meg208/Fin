({
	doInit : function(component, event, helper) {
		let action = component.get('c.getApplicationWithOfficer');
        action.setParams({  "opportunityId" : component.get('v.recordId')  });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log('Officer Wrapper',result);
                if(!$A.util.isEmpty(result.error)){
                    component.set("v.responseError", result.error);
                }else{
                    component.set('v.wrapperList',result);
                	let officerCount = result.officerList.length;
                	component.set('v.officerCount', officerCount);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action);
	}
    
})