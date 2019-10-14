({
    getRecords : function(component, event, helper) {
        let action = component.get("c.getRecords");
        action.setParams({connectType:component.get("v.authType")});
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                let resp = response.getReturnValue(); 
                if(resp.Error !== 'Empty'){
                    component.set('v.paError', resp.Error);
                }  
                else{
                    component.set('v.paError', 'Empty');
                    let jsonData = JSON.parse((resp.ApiResponse));
                    component.set('v.predictiveAnalytics', jsonData);
                }
               
            }else if(response.getState() === 'ERROR'){
                helper.showToast(component,event, helper,"Error","Error",'test');
            }
        });
        $A.enqueueAction(action);  
    },
    viewAll: function(component, event, helper) {
        debugger;
        var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews.Id,
                    "listViewName": null,
                    "scope": "FNS_PredictiveAnalytics__c"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }, 
    showHover : function(component, event, helper){
        let predAnalytics = component.get("v.predictiveAnalytics");
        let idx = event.currentTarget.getAttribute('data-index');
        let clickedRecord = component.get("v.predAnalytics")[idx];
        for(let i=0; i<predAnalytics.length; i++){
            if(i==idx){
                if(predAnalytics[i].FNS_RecommendationDescription__c){
                    predAnalytics[i].Clicked = false;
                }
                else{
                    predAnalytics[i].Clicked = true;
                }
            }
            else{
                predAnalytics[i].Clicked = false;
            }
        }
        component.set("v.predictiveAnalytics", predAnalytics);
       
    },
})