({
    doInit : function(component, event, helper) {
        helper.getSetupData(component, event, helper);
    },
    authorize : function(component, event, helper){
        //helper.authenticate(component, event, helper);
        helper.authenticatesfdc(component, event, helper);
    },
    edit : function(component, event, helper){
     component.set("v.edit",true);
	},
    save : function(component, event, helper){
        helper.doValid(component, event, helper);
    },
    cancel: function(component, event, helper){
     component.set("v.edit",false);
	}
})