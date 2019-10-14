({
    doInit : function(component, event, helper) {
        helper.fetchOppWrapper(component, event, helper);
        //helper.filterSelected(component, event, helper);
    },
    handleComponentEvent : function(component, event, helper){
        helper.handleComponentEvent(component, event, helper);
    },
    ShowFilter : function(component, event, helper){
        component.set("v.hideFilter", false); 
    },
    handleTrackingItems : function(component, event, helper){
        helper.handleTrackingItems(component, event, helper);
    },
    showHover : function(component, event, helper){
        helper.showHover(component, event, helper);
    },
    viewAll : function(component, event, helper) {
        helper.viewAll(component, event, helper);
    },
    filter : function(component, event, helper){
        helper.filter(component, event, helper);
    },
    filterSelected : function(component, event, helper){
        let selectecResoruce = component.find("filterSelectedResource").get("v.value");
        helper.filterSelected(component, event, helper, selectecResoruce);
    },
    cancel : function(component, event, helper){
        helper.cancel(component, event, helper);
    },
    applyFilter : function(component, event, helper) {
        helper.applyFilter(component, event, helper);
    },
    clearFilters : function(component, event, helper){
        helper.clearFilters(component, event, helper);
    },
    
    opportunityView : function(component, event, helper){
        helper.opportunityView(component, event, helper);
    },
	accountView: function(component, event, helper){
        helper.accountView(component, event, helper);
    },
    hidePopover : function(component, event, helper) {
        helper.hidePopover(component, event, helper);
    }
    
})