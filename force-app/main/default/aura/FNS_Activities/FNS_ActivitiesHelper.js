({
    
    initHelper : function(component, event, helper) {
        //helper.getActivitiesfromSFDCCall(component, event, helper);
        component.set("v.loaded", false); 
        component.set("v.spinner", false); 
        
        //let action = component.get("c.getApplicationExternalId");
        var recordId = component.get("v.recordId");
        helper.getActivitiesfromSFDCCall(component, event, recordId);
        /*
        action.setParams({ applicationRecordId: recordId }); 
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if(state === "SUCCESS"){
                component.set("v.loaded", true); 
                var response = response.getReturnValue();  
                if(!$A.util.isUndefinedOrNull(response[0].FNS_ApplicationExtId__c)){
                }	
            }
            else {
                component.set("v.loaded", false); 
            }
        })        
        $A.enqueueAction(action);
        */
    }, 
   initiateAllApplicationAPIcalls : function(component, event, helper){
        component.set("v.loaded", false); 
        let action = component.get("c.initiateApplicationAPIs");
        var recordId = component.get("v.recordId");
        action.setParams({ applicationRecordId: recordId }); 
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if(state === "SUCCESS"){
                component.set("v.loaded", true); 
                var response = response.getReturnValue();               
                helper.getActivitiesfromSFDCCall(component, event, recordId);
            }
            else {
                component.set("v.loaded", false); 
            }
        })        
        $A.enqueueAction(action);
    },
    getActivitiesfromSFDCCall : function(component, event, applicationId) {
        let action = component.get("c.getAllActivities");
        action.setParams({applicationRecordId: applicationId});
        //action.setParams({applicationExternalId: applicationExtId});
        action.setCallback(this, function(response) {
            let resp = response.getReturnValue(); 
            if(resp.Error !== 'Empty'){
                component.set('v.activitiesError', resp.Error);
                component.set("v.spinner", false); 

            }  
            else{
                component.set("v.loaded", true); 
                component.set('v.activitiesError', 'Empty');
                let jsonData = JSON.parse((resp.ApiResponse));
                let activitiesList = [];
                let sections = []; 
                for(let i = 0; i < jsonData.activitiesListWrapper.length; i++){                
                    activitiesList.push(jsonData.activitiesListWrapper[i]);
                    sections.push(jsonData.activitiesListWrapper[i].Description);                    
                }
                component.set('v.activitySections', sections);
                var custs = [];
                var conts = jsonData.fnsRouteActivityMapValuesWrapper;
                var finalConts  = [];
                for(var key in conts){
                    for(var obj in conts[key]){
                        finalConts.push({value:conts[key][obj], key:key});
                    }
                }
               
                component.set("v.routeActivitiesList",custs);            
                if(response.getState() === 'SUCCESS'){
                    component.set('v.activitiesList', activitiesList);
                    component.set('v.routeActivitiesList', finalConts);
                } 
                else if (response.getState() === "ERROR"){
                    component.set("v.loaded", false); 
                }
                component.set("v.spinner", false); 

            }
        });
        $A.enqueueAction(action);
    },
    sendToCMEhelper: function(component, event, helper){
        component.set("v.spinner", true); 

        var uservariables = component.get("v.selectedLookUpRecord");
        var varnotes = component.get('v.notes'); 
        var varactivity= component.find("activity").get("v.value");
        var varrecId = component.get("v.recordId");
        
        var action = component.get("c.getPutCalloutResponse"); 
        action.setParams({
            dataActivityId: varactivity,
            datauser: uservariables, 
            datanotes: varnotes, 
            recId: varrecId
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();         
            if (state === "SUCCESS") {

                var resp = response.getReturnValue();
                //helper.initHelper(component, event, helper);    
                $A.get("e.force:refreshView").fire();
                component.set('v.notes', '');       
            }
        });
        $A.enqueueAction(action);
    }    
})