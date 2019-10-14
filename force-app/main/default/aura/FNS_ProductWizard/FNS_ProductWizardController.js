({
    openModal : function(component, event, helper) {
        component.set('v.showLoanTable',false);
        //helper.clearFields(component, event, helper);
        component.set('v.popupHeader', $A.get("$Label.c.FNS_NEW_PRODUCT")); 
		component.set('v.pricingList', []);
        helper.openModal(component, event, helper);
    },
    closeModal : function(component, event, helper) {
        component.set('v.showLoanFields',false);
        component.set('v.loanList', []);
        //component.set('v.pricingList', []);
        component.set('v.productId','');
        helper.closeModal(component, event, helper);
    },
    handleCompEvent: function( component, event, helper ) {
        var action = event.getParam( 'action' );
        var willHandle = _.find( component.get( 'v.willHandleCompActions' ), function( a ) {
            return a === action
        });
        if ($A.util.isEmpty( action ) || $A.util.isEmpty( willHandle ))
            return;        
        helper.handleCompEvent( component, event, helper );
    },
    doInit:function(component,event,helper){
        helper.doInit(component,event,helper);
    },
    submit:function(component,event,helper){
        helper.submit(component,event,helper);
    },
    showMoreFields: function(component,event,helper){
        helper.showMoreFields(component,event,helper);
    },
    getResponse: function(component,event,helper){
        helper.getResponse(component,event,helper);
    },
    showMoreProductFields:function(component,event,helper){
        helper.showMoreProductFields(component,event,helper);
    },
    addLoan:function(component,event,helper) {
        component.find('addLoanHeader').set('v.disabled',true);
        helper.addLoan(component,event,helper);
    },
    addPricing:function(component,event,helper) {
        helper.addPricing(component,event,helper);
    },
    deletePricing: function(component,event,helper) {
        helper.deletePricing(component,event,helper);
    },
    showMoreLoanFields:function(component,event,helper){
        helper.showMoreLoanFields(component,event,helper);
    },
    editProductRecord: function(component,event,helper){
        helper.editProductRecord(component,event,helper);
    },
    deleteProductRecord: function(component,event,helper){
        helper.deleteProductRecord(component,event,helper);
    },
    editLoanRecord: function(component,event,helper){
        helper.editLoanRecord(component,event,helper);
    },
    deleteLoanRecord: function(component,event,helper){
        helper.deleteLoanRecord(component,event,helper);
    },
    editRecord: function(component,event,helper){
        console.log('inside editRecord child');
        helper.editRecord(component,event,helper);
    },
    closeLoanEditor: function (component, event, helper) {
        helper.closeLoanEditor(component,event,helper);
    },
    processingCompleted: function (component, event, helper) {
        helper.processingCompleted(component,event,helper);
    }
})