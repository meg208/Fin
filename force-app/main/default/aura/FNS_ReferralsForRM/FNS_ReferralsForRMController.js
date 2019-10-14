({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    navigateToContact : function(component, event, helper) {
        helper.navigateRMToContactDetailspage(component, event, helper);
    },
    navigateToLead : function(component, event, helper) {
        helper.navigateRMToLeadDetailspage(component, event, helper);
    },
    filterDataByDate : function(component, event, helper) {
        helper.filterReferralsData(component, event, helper);
    }, 
    viewAll : function(component, event, helper) {
        helper.showListData(component, event, helper);
    }
})