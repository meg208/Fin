({
     doInit:function(component,event,helper){
        helper.doInit(component,event,helper);
    },
    savePricing: function(component, event, helper) {
        let params = event.getParam('arguments');
        component.find('finProduct').set('v.value', params.finAccount);
        component.find("pricingEditForm").submit();
    },
    handleSuccess : function(component, event, helper) {
        let payload = event.getParams().response;
        console.log('Pricing Payload',JSON.stringify(payload));
        console.log('Payload',payload.id);
        component.set("v.pricingId",payload.id);
        let cmpEvent = component.getEvent("showStatus");
        let msg =  new Object();
        msg.object="Pricing";
        msg.error="";
        msg.status="success";
        msg.recordID = payload.id;
        cmpEvent.setParams({"message" : msg});
        cmpEvent.fire();
    },
    onError : function(component, event, helper) {
        let cmpEvent = component.getEvent("showStatus");
        let msg =  new Object();
        msg.object="Pricing";
        msg.error="Record Failed to Create";
        msg.status="Error";
        cmpEvent.setParams({ "message" : msg});
        cmpEvent.fire();
    },
    removeCmp : function(component, event, helper) {
        let cmpEvent = component.getEvent("deletedPricing");
        cmpEvent.setParams({ "rowNo" : component.get("v.pricingRow")});
        cmpEvent.fire();
        component.destroy();
    }
    
})