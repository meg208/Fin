({
	doInit : function(component, event, helper) {
        helper.getRecords(component, event, helper);
    },
    viewAll: function(component, event, helper) {
        helper.viewAll(component, event, helper);
    }, 
    showHover: function(component, event, helper) {
        helper.showHovercmp(component, event, helper); 
    }, 
    showempinfo : function(component, event, helper){
        var bool = component.get('v.ispopovershown');
        bool = true; 
    },
    hideempinfo : function(component, event, helper){
        component.set('v.ispopovershown', false);
    },
    
    /*To navigate on same page*/
    openRecord : function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        var recordId = event.currentTarget.id;
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "related"
        });
        navEvt.fire();
    }
})