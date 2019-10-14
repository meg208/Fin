({
    doInit : function (component, event, helper) {
        let action = component.get('c.getActiveApplication'); //pointer to apex method
        //let action = component.get('c.getActiveApplication');
        action.setCallback(this, function(response){
            let state= response.getState(); // fetch the response state
            if(component.isValid() && state === 'SUCCESS'){
                let activeApplicationsList = response.getReturnValue();
                if(!$A.util.isEmpty(activeApplicationsList.error)){
                    component.set("v.responseError", activeApplicationsList.error);
                }else{
                    let oppList = activeApplicationsList['oppList'];
                	console.log('activeApplicationsList',activeApplicationsList);
                	if($A.util.isEmpty(oppList)){
                    	component.set('v.showSpinner', false);
                    	return;
                	}
                
                helper.setUpApplicationData(component, helper, activeApplicationsList, oppList);
                }                
            }
            
        });
        $A.enqueueAction(action); // Invoke the apex method  
    },
    
    handleCommunityCompEvent : function(component, event, helper){
        helper.handleCompEvent( component, event, helper );
        
    }, 
    
    handleComponentEvent : function(component, event, helper){
        var tabName = event.getParam("tabName");
        console.log('handleComponentEvent', tabName);
        if(tabName == "Home"){
            component.set("v.showComponent", true);
        }else{
            component.set("v.showComponent", false);
        }
        
        
    }, 
    changeApplication : function(component, event, helper){
        var pathChildCmp = component.find("pathValue");
        if(pathChildCmp != undefined){
            pathChildCmp.changeRecordId();
        }       
    }
})