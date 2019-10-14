({
    doInit:function(component,event,helper){
        helper.doInit(component,event,helper);
    },
    saveFees : function(component, event, helper) {
        let params = event.getParam('arguments');
        component.find('finProduct').set('v.value', params.finAccount);
        let amount = component.find("amount").get("v.value");
        if(!$A.util.isEmpty(amount) && amount<=0){
            component.set("v.errorMessage", $A.get("$Label.c.FNS_ERROR"));
            let cmpEvent = component.getEvent("handleError");
            cmpEvent.fire();
            return;
        }
        else{
            component.set("v.errorMessage", "");
        }
        component.find("feeForm").submit();
    },
    removeCmp : function(component, event, helper) {
        let cmpEvent = component.getEvent("deletedFee");
        cmpEvent.setParams({ "rowNo" : component.get("v.feeRow")});
        cmpEvent.fire();
        component.destroy();
    },
    handleSuccess : function(component, event, helper) {
        let payload = event.getParams().response;
        //console.log('Fee Payload',JSON.stringify(payload));
        console.log('Payload',payload.id);
        component.set("v.feeId",payload.id);
        let cmpEvent = component.getEvent("showStatus");
        let msg =  new Object();
        msg.object="Fee";
        msg.error="";
        msg.status="success";
        msg.recordID=payload.id;
        cmpEvent.setParams({"message" : msg});
        cmpEvent.fire();
    },
    onError : function(component, event, helper) {
        let cmpEvent = component.getEvent("showStatus");
        let msg =  new Object();
        msg.object="Fee";
        msg.error="Record Failed to Create";
        msg.status="Error";
        cmpEvent.setParams({ "message" : msg});
        cmpEvent.fire();
    }
})