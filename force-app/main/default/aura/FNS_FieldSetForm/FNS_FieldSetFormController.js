({
    doInit:function(component,event,helper){
        helper.doInit(component,event,helper);
    },
    saveAndCreateNewLoan:function(component,event,helper) {
        helper.saveAndCreateNewLoan(component,event,helper);
    },
    saveLoan:function(component,event,helper) {
        helper.saveLoan(component,event,helper);
    },
    cancelLoan:function (component,event,helper) {
        helper.cancelLoan(component,event,helper);
    },
    saveForm : function(component, event, helper){
        helper.saveForm(component,event,helper);
    },
    showMoreFields: function(component,event,helper){
        helper.showMoreFields(component,event,helper);
    },
    handleSuccess : function(component, event, helper) {
        helper.handleSuccess(component,event,helper);
    },
    handleError: function(component,event,helper) {
        helper.handleError(component,event,helper);
    },
    recordEditHandler : function(component, event, helper) {
        helper.recordEditHandler(component,event,helper);
    },
    handleSubmit: function(component, event, helper) {
        helper.handleSubmit(component,event,helper);
    },
    
    handleLoad: function(component, event, helper) {
        let fieldValidation = component.get('v.requireFieldValidation');
        let fieldsClone =_.cloneDeep(component.get("v.fields"));
        if(!$A.util.isEmpty(fieldsClone) && fieldValidation)
        helper.setRequiredFields(component, event, helper,fieldsClone);
        let moreFieldsClone =_.cloneDeep(component.get("v.moreFields"));
        if(!$A.util.isEmpty(moreFieldsClone) && fieldValidation)
        helper.setRequiredFields(component, event, helper,moreFieldsClone);
        
        if(component.get('v.objectLabel')=='LOAN'){
            let fields = event.getParam("picklistValues");
            component.set('v.picklistValues',fields);
            if(component.get('v.isCalledAfterEdit')){                
                let rowData = component.get('v.loanRowData');
                let rowIndex = component.get('v.loanRowIndex');
                let loanData = {};
                loanData.rawData=rowData;
                loanData.rowIndex=rowIndex;
                loanData.picklistValues=fields;
                component.saveForm(loanData);
                component.set('v.isCalledAfterEdit',false);
            }            
        }
        let scrollToLocation = component.get('v.scrollToLocation');
        if(scrollToLocation)
            helper.scrollToLocation(component);
    },
    removeCmp : function(component, event, helper) {
       helper.removeCmp(component,event,helper);
    },
    
    setFieldValue: function(component, event, helper) {
        var fieldValue = event.getParam('value');
        var fieldName = event.getSource().get('v.fieldName');
        var objectToSave = component.get('v.objectToSave') || {};
        objectToSave[fieldName] = fieldValue;
        component.set('v.objectToSave', objectToSave);
        
        // For required field validation
        let fieldValidation = component.get('v.requireFieldValidation');
        if(fieldValidation)
        	helper.resetErrorLst(component,event,helper);
    }
})