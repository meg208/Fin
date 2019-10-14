({
    doInit : function(component, event, helper){
        let action = component.get('c.getApplication');
        action.setParams({ "applicationId" : component.get('v.recordId') });
        action.setCallback(this, function(response) {
            //store state of response
            let state = response.getState();
            if (state === "SUCCESS") {
                //let productData = JSON.parse(response.getReturnValue());
                let result = response.getReturnValue();
               
                if(!$A.util.isEmpty(result.error)){
                    component.set("v.responseError", result.error);
                }else{
                    let totalProducts = result.isReadOnly;
                    if(result.isReadOnly)
                    	component.set('v.applicationMode', 'readonly');
                    else
                        component.set('v.applicationMode', 'View');         
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    onSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been Saved successfully."
        });
        toastEvent.fire();
    },
    onSubmit : function(component, event, helper) {
    },
    onLoad : function(component, event, helper) {
       /* var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Loaded!",
            "message": "The record has been Loaded successfully ."
        });
        toastEvent.fire();*/
    },
    onError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Error."
        });
        toastEvent.fire();
    }
    
    
})