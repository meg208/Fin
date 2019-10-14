({
    doInit : function(component, event, helper) {
        helper.getApplicationDocs(component,event,helper);
    },
    
    handleSelectMenu: function(component, event, helper) {
        helper.handleSelectmenu(component, event, helper);    
    },
    
    getDocumentContentFromCME: function(component,event,helper) {
        
        helper.getDocumentCalloutContentFromCME(component,event,helper);
    },
    
    handleOnClick : function(component, event, helper) {
        $A.util.toggleClass(component.find("divHelp"), 'slds-hide');
    },
    
    handleMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("divHelp"), 'slds-hide');
    },
    
    handleMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("divHelp"), 'slds-hide');
    },
    
    closeModel: function(component, event, helper) {
        helper.closeModel(component,event,helper);
    },
    
    handleUploadFinished : function(component, event, helper) {
        helper.uploadDocument(component,event,helper);
    },
    
    sendeditToCME : function(component, event, helper) {
        helper.sendEditValstoCME(component,event,helper);
    }   
})