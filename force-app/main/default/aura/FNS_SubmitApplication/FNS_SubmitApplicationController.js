({
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    handleYes : function(component, event, helper) {
        helper.handleYes(component, event, helper);
        //Call API function 
    },
    doInit:function(component,event,helper){
        helper.doInitHelper(component,event,helper);
    },
})