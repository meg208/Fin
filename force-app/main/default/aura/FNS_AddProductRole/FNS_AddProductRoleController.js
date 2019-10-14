({
     doInit:function(component,event,helper){
        helper.doInit(component,event,helper);
    },
    saveProductRole: function(component, event, helper) {
        let params = event.getParam('arguments');
        component.find('finAccount').set('v.value', params.finAccount);
        let guaranteeDollar = component.find("guaranteedollar").get("v.value");
        let guaranteePercent = component.find("guaranteepercent").get("v.value");
        if(($A.util.isEmpty(guaranteeDollar) && $A.util.isEmpty(guaranteePercent)) || (!$A.util.isEmpty(guaranteeDollar) && !$A.util.isEmpty(guaranteePercent))){
            component.set("v.errorMessage", $A.get("$Label.c.FNS_GURANTEE_ERROR"));
            let cmpEvent = component.getEvent("handleError");
            cmpEvent.fire();
            return;
        }
        else{
            component.set("v.errorMessage", "");
        }
        component.find("productRoleEditForm").submit();
    },
    removeCmp : function(component, event, helper) { 
        let cmpEvent = component.getEvent("deletedProductRole");
        cmpEvent.setParams({ "rowNo" : component.get("v.productRoleRow")});
        cmpEvent.setParams({ "productRoleId" : component.get("v.productRoleId")});
        cmpEvent.fire();
        component.destroy();
    },
    handleSuccess : function(component, event, helper) {
        let payload = event.getParams().response;
        //console.log('Product Role Payload',JSON.stringify(payload));
        console.log('Payload',payload.id);
        component.set("v.productRoleId",payload.id);
        let cmpEvent = component.getEvent("showStatus");
        let msg =  new Object();
        msg.object="Product Role";
        msg.error="";
        msg.status="success";
        msg.recordID=payload.id;
        cmpEvent.setParams({"message" : msg});
        cmpEvent.fire();
    },
    onError : function(component, event, helper) {
        let cmpEvent = component.getEvent("showStatus");
        let msg =  new Object();
        msg.object="Product Role";
        msg.error="Record Failed to Create";
        msg.status="Error";
        cmpEvent.setParams({ "message" : msg});
        cmpEvent.fire();
    }
})