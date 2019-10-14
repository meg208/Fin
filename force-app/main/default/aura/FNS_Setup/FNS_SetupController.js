({
    doInit : function(component, event, helper) {
        let action = component.get("c.getUserProfileInfo");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                let resp = response.getReturnValue();
                if(resp === 'ADMIN'){
                    component.set("v.showFFDCRefresh", true); 
                }
                else{
                    component.set("v.showFFDCRefresh", false); 
                }
            }
        });
        $A.enqueueAction(action); 
    }
})