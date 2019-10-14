({
	initHelper : function(component, event, helper) {	
        var action = component.get('c.getfromCommunity');
        
         action.setParams({
            stageName : component.get("v.selectedRecordStage")
        });       
        action.setCallback(this, function(res) { 
            helper.handleCallback(component, event, helper,res); 
        }); 
        $A.enqueueAction(action);  
	},
    
    handleCallback : function(component, event, helper,res){
        if (res.getState() === 'SUCCESS') { 
            let apiResponse = res.getReturnValue();
            if (apiResponse.Error !== 'Empty'){
                helper.showToast(component,event, helper,"Error","Error",apiResponse.Error);
            }
            var retJSON = JSON.parse(apiResponse.ApiResponse);  
            component.set("v.records",retJSON);
        }        
    },

    showToast : function(component, event, helper,title,type,msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": msg
        });
        toastEvent.fire();
    }
})