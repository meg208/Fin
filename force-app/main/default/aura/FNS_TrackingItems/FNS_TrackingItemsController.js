({
    
    doInit: function(component, event, helper) {
        component.set("v.modalContext", "New");
        helper.callTrackingItemsandTrackingDocs(component, event, helper);
        
    },
    
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    openModel: function(component, event, helper) {
        helper.openModel(component, event, helper)
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    handleSelectMenu: function(component, event, helper) {
        helper.handleSelectmenu(component, event, helper);
        
    },
    
    closeNewTask:function(component,event,helper) {
        component.set("v.isOpenforTask",false);
    },
    
    
    addtoWeekMask : function(component, event, helper) {
        helper.addtoRecurrenceWeekMask(component, event);
    },
    
    onEditform: function(component, event, helper) {
        var taskselected = event.getSource().get("v.name");
        component.set("v.modalContext", "Edit");
    },
    
    
    closeEdit: function(component, event, helper) {
        component.set("v.modalContext", "New");
    },
    
    openModelForComments: function(component, event, helper) {
        component.set("v.isOpenForComments", true);
    },
    
    reAssignOwner: function(component, event, helper) {
        helper.reAssignowner(component, event, helper);
        
    },
    
    closeModelForComments: function(component, event, helper) {
        component.set("v.isOpenForComments", false);
    },
    
    showFiles: function(component, event, helper) {
        helper.files(component, event, helper);
    },
    
    onStatusChange: function(component, event, helper) {
        var eve = event.getSource().get("v.value");
        var key = event.getSource().get("v.text");
        var keys = event.getSource().get("v.key");
        component.set("v.statusvaluesSelected", eve);
        
    },
    
    onPriorityChange: function(component, event, helper) {
        var eve = event.getSource().get("v.value")
        component.set("v.priorityvaluesSelected", eve);
        
    },
    
    onCommentEntered: function(component, event, helper) {
        var eve = event.getSource().get("v.value")
        component.set("v.commentvaluesSelected", eve);
    },
    
    onDateSelected: function(component, event, helper) {
        var eve = event.getSource().get("v.value");
        component.set("v.datevalueSelected", eve);
    },
    
    onTaskId: function(component, event, helper) {
        var eve = event.getSource().get("v.value")
        component.set("v.taskIdselected", eve);
    },
    
    getDocumentCalloutContentFromCME: function(component, event, helper) {
        helper.getDocumentCalloutContentFromCME(component, event, helper);
    },
    
    sendToCME: function(component, event, helper) {
        helper.sendToCME(component, event, helper);
        helper.initializingFunc(component, event, helper);
    },
    
    openModelDocument : function(component,event,helper){
        component.set("v.isOpenDocument", true);
        component.set("v.uploaded",'false');
        helper.initializingFunc(component,event,helper);
    },
    
    onTaskChange: function(component, event, helper) {
        let eve = event.getSource().get("v.value");
        component.set("v.TaskextIdvaluesSelected", eve);
    },
    
    closeModelDocument: function(component, event, helper) {
        component.set("v.isOpenDocument", false);
    },
    
    doSaveDocument : function(component,event,helper) {
        helper.doSaveDocument(component,event,helper);
    },
    
    handleUploadFinished : function(component, event, helper) {
        component.set("v.hasNoVals",true);
        helper.uploadDocument(component,event,helper);
      
    },
    
})