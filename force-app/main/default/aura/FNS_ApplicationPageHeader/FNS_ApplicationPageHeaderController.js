({
    doInit: function(component, event, helper){
       helper.initiateAllApplicationAPIcalls(component, event, helper);
    },
	submit: function(component, event, helper) {
      helper.checkCondition(component, event, helper);
      component.set("v.isOpen", true);
   },
    closeModel: function(component, event, helper) {
       component.set("v.isOpen", false);
   },
    handleYes: function(component, event, helper) {
       helper.handleYes(component, event, helper);
   },
   render: function(component, event, helper) {
      component.find('record').reloadRecord({ skipCache: true }); 
   }
})