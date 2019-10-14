({
    
    doInit: function(component, event, helper) {
        helper.callTrackingDocsDomain(component,event,helper);
        helper.getApplicationDocs(component,event,helper);
        helper.trackingitem(component,event,helper);
    },
    
    handleUploadFinished : function(component, event, helper) {
        component.set("v.hasNoVals",true);
        helper.uploadDocument(component,event,helper); 
    },
    
    openModel : function(component,event,helper){
        component.set("v.isOpen", true);
        component.set("v.uploaded",'false');
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    getDocumentContentFromCME: function(component,event,helper) {
        helper.getDocumentCalloutContentFromCME(component,event,helper);
    },
    
    handleSelectMenu: function(component, event, helper) {
        helper.handleSelectmenu(component, event, helper);    
        helper.getApplicationDocs(component, event, helper);  
    },
    
    closeEditModel : function(component, event, helper) {
        component.set("v.isEdit",false);
    },
    
    onTaskChange: function(component, event, helper) {
        let eve = event.getSource().get("v.value");
        component.set("v.TaskextIdvaluesSelected", eve);
    },
    
    doSave : function(component,event,helper) {
        helper.doSave(component,event,helper);
    },
    
    handleEditUploadFinished : function(component, event, helper) {
        helper.uploadEditDocument(component,event,helper);
        helper.trackingitem(component,event,helper);
    },
    
    sendeditToCME : function(component,event,helper) {
        helper.sendEditValstoCME(component,event,helper);
    }
})