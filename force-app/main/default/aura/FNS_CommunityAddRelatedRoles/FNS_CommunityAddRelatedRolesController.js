({
	/*doInit : function(component, event, helper) {
		var action = component.get('c.fetchApplicationRelatedRoles'); //pointer to apex method
        action.setCallback(this, function(response){
            var state= response.getState(); // fetch the response state
            if(component.isValid() && state === 'SUCCESS'){
				component.set('v.applicationRelatedRoleslist', response.getReturnValue()); //set the attribute value	                
                /*if(!$A.util.isEmpty(response.getReturnValue()) && response.getReturnValue().length > 2){
                    component.set('v.showViewAll', true);
                	component.set('v.applicationRelatedRoleslistToDisplay', response.getReturnValue().slice(0, 2)); //set the attribute value    
                }else{
                    component.set('v.showViewAll', false);
                    component.set('v.applicationRelatedRoleslistToDisplay', response.getReturnValue()); //set the attribute value	                
                }
            }
        });
        $A.enqueueAction(action); // Invoke the apex method                                                                                                      
	},*/
    
    openRecord : function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        var recordId = event.currentTarget.id;
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "related"
        });
        navEvt.fire();
    }/*,
    
    viewAll: function(component, event, helper) {
        debugger;
        var action = component.get('c.getListViews');
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var listviews = response.getReturnValue();
                var navEvent = $A.get('e.force:navigateToList');
                navEvent.setParams({
                    'listViewId': listviews.Id,
                    'listViewName': null,
                    'scope': 'FNS_RelatedRoles__c'
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }*/
})