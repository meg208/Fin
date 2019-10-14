({
    doInit: function(component, event, helper){
        helper.initHelper(component, event, helper);
    },
    sendToCME: function(component, event, helper){
        helper.sendToCMEhelper(component, event, helper); 
    },
    clickExpandAll: function(component, event, helper){
        component.set("v.expandAccordians", true);
    }, 
    clickRefresh: function(component, event, helper){
        component.set("v.expandAccordians", false);
    }, 
    itemsChange: function(component, event, helper){
        //Nothing to do here, just to trigger an event.
    },
    errorChange: function(component, event, helper){
        //Nothing to do here, just to trigger an event.
    }
})