({
	refreshActivities: function(component, event, helper) {
		let action = component.get("c.refreshActivities");
		// Add callback behavior for when response is received
		action.setCallback(this, function(response) {
			component.set("v.isActivityRefreshCalled", true);
			component.set("v.isActivityRefreshed", true);
			if (response.getState() === "SUCCESS") {
				let apiResponse = response.getReturnValue();
				if (apiResponse.Error !== 'Empty'){
					component.set("v.activitiesError", apiResponse.Error);
					component.set("v.isActivityRefreshed", false);
				}
			}			
			helper.refreshBankDomains(component, event, helper);
		});
		$A.enqueueAction(action);
	},
    
	refreshBankDomains: function(component, event, helper) {
		let action = component.get("c.refreshBankDomains");
		action.setCallback(this, function(response) {
			component.set("v.isBankDomainRefreshCalled", true);
			component.set("v.isBankDomainRefreshed", true);
			if (response.getState() === "SUCCESS") {
				let apiResponse = response.getReturnValue();
				if(apiResponse.Error !== 'Empty'){
					component.set("v.banksError", apiResponse.Error);
					component.set("v.isBankDomainRefreshed", false);
				} 				
			}
			helper.refreshFeeTypes(component, event, helper);
		});
		$A.enqueueAction(action);
	},
    
	refreshFeeTypes: function(component, event, helper) {
		let action = component.get("c.refreshFeeTypes");
		action.setCallback(this, function(response) {
			component.set("v.isFeeRefreshCalled", true);
			component.set("v.isFeeRefreshed", true);
			if (response.getState() === "SUCCESS") {
				let apiResponse = response.getReturnValue();
				if (apiResponse.Error !== 'Empty'){
					component.set("v.feeTypeError", apiResponse.Error);
					component.set("v.isFeeRefreshed", false);
				} 				
			}
			helper.refreshProcessCenterDomain(component, event, helper);
		});
		$A.enqueueAction(action);
	},
    
	refreshProcessCenterDomain: function(component, event, helper) {
		let action = component.get("c.refreshProcessCenterDomain");
		action.setCallback(this, function(response) {			
			component.set("v.isProcessCenterRefreshCalled", true);
			component.set("v.isProcessCenterRefreshed", true);
			if (response.getState() === "SUCCESS") {
				let apiResponse = response.getReturnValue();
				if (apiResponse.Error !== 'Empty'){
					component.set("v.processCenterError", apiResponse.Error);
					component.set("v.isProcessCenterRefreshed", false);
				}				
			}
			helper.refreshProcessGroup(component, event, helper);
		});
		$A.enqueueAction(action);
	},
    
	refreshProcessGroup: function(component, event, helper) {
		let action = component.get("c.refreshProcessGroup");
		action.setCallback(this, function(response) {
			component.set("v.isProcessGroupRefreshCalled", true);
			component.set("v.isProcessGroupRefreshed", true);
			if (response.getState() === "SUCCESS") {
				let apiResponse = response.getReturnValue();
				if (apiResponse.Error !== 'Empty'){
					component.set("v.processGroupError", apiResponse.Error);
					component.set("v.isProcessGroupRefreshed", false);
				}				
			}
			helper.refreshProductType(component, event, helper);
		});
		$A.enqueueAction(action);
	},
    
	refreshProductType: function(component, event, helper) {
		let action = component.get("c.refreshProductType");
		action.setCallback(this, function(response) {
			component.set("v.isProductTypeRefreshCalled", true);
			component.set("v.isProductTypeRefreshed", true);
			if (response.getState() === "SUCCESS") {
				let apiResponse = response.getReturnValue();
				if (apiResponse.Error !== 'Empty'){
					component.set("v.productTypeError", apiResponse.Error);
					component.set("v.isProductTypeRefreshed", false);
				}			
			} 
			//helper.refreshConfigurationType(component, event, helper);
            helper.scheduleRecordTypeUpdate(component, event, helper);
		});
		$A.enqueueAction(action);
	},

	refreshConfigurationType: function(component, event, helper) {
		let action = component.get("c.refreshConfigurationType");
		action.setCallback(this, function(response) {
			component.set("v.isConfigurationTypeRefreshCalled", true);
			component.set("v.isConfigurationTypeRefreshed", true);
			if (response.getState() === "SUCCESS") {
				let apiResponse = response.getReturnValue();
				if (apiResponse.Error !== 'Empty'){
					component.set("v.ConfigTypeError", apiResponse.Error);
					component.set("v.isConfigurationTypeRefreshed", false);
				}				
			}
            //helper.scheduleRecordTypeUpdate(component, event, helper);
            helper.refreshActivities(component, event, helper);
		});
		$A.enqueueAction(action);
	},
    scheduleRecordTypeUpdate: function(component, event, helper) {
		let action = component.get("c.scheduleRecordTypeUpdate");
		action.setCallback(this, function(response) {
			if (response.getState() === "SUCCESS") {
				let apiResponse = response.getReturnValue();
				if (apiResponse.Error !== 'Empty'){
				}			
			}
		});
		$A.enqueueAction(action);
	},
})