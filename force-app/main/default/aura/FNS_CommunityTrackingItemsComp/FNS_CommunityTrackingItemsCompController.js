({
    doInit: function(component, event, helper) {
        var test = component.get("v.trackingItemsList");		
    },
    
    openModel : function(component,event,helper){
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        var appExtId = component.get("v.applicationId");
        
        component.set("v.taskIds",id_str);
        component.set("v.isOpen", true);
        component.set('v.isActive', true);
        component.set("v.uploaded",'false');
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    handleUploadFinished : function(component, event, helper) {
        helper.uploadDocument(component,event,helper);
    },
    
    doSave : function(component, event, helper) {
        helper.doSave(component,event,helper);
    }
})