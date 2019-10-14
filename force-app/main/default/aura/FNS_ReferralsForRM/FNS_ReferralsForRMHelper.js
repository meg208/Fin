({
    doInit : function(component, event, helper) {
        helper.fetchReferralsForRM(component, event, helper);        
    },

    navigateRMToContactDetailspage : function(component, event, helper) {
        component.find("navigation").navigate({
            "type" : "standard__recordPage",
            "attributes": {
                "recordId"      : event.target.dataset.fieldName,
                "actionName"    : "view"  
            }
        }, true);
    },
    
    navigateRMToLeadDetailspage : function(component, event, helper) {
        component.find("navigation").navigate({
            "type" : "standard__recordPage",
            "attributes": {
                "recordId"      : event.target.dataset.fieldName,
                "actionName"    : "view" 
            }
        }, true);
    },

    showListData : function(component, event, helper){
        var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = []; 
                listviews = response.getReturnValue();
                var listId = listviews.Id; 
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews[0].Id,
                    "listViewName": null,
                    "scope": "Lead"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    fetchReferralsForRM : function(component, event, helper) {
        let action = component.get("c.getReferralsForRelationshipManager");
        action.setParams({filterCondition : component.get("v.filterValue")});
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state=="SUCCESS"){
                let resp = response.getReturnValue(); 
                if(resp.Error !== 'Empty'){
                    component.set('v.leadsError', resp.Error);
                }  
                else{
                    component.set('v.leadsError', 'Empty');
                    let jsonData = JSON.parse((resp.ApiResponse));
                    component.set('v.LeadDetails', jsonData);
                }
            }
        });
        $A.enqueueAction(action);
    },

    filterReferralsData : function(component, event, helper) {
        var triggerCmp = component.find("menu");
        var label = '';
        if (triggerCmp) {
            label = event.getParam("value");
        }
        component.set("v.filterValue",label);
        helper.fetchReferralsForRM(component, event, helper);
    } 
})