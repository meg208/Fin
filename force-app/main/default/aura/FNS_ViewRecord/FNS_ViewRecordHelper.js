({
    doInit:function(component,event,helper){
        let getFormAction = component.get('c.getObjectDetails');
        getFormAction.setParams({  "recordId" : component.get('v.recordId')  });
        getFormAction.setCallback(this, function(response) {
            let state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log('result2',result);
                if(!$A.util.isEmpty(result.error)){
                    component.set("v.responseError", result.error);
                }else{
                    component.set('v.objName',result.objName);
                    component.set('v.objRecordTypeId',result.recordTypeId);
                    component.set('v.isLoadSuccess',true);
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
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
        $A.enqueueAction(getFormAction);
    }
})