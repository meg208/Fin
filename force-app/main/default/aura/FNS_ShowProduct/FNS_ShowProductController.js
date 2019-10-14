({
    sortColumnData: function (component, event, helper) {
        let sortDirection = component.get('v.sortAsc');
        helper.sortData(component, 'productSummary', sortDirection);
    },
    viewAll : function(component, event, helper) {
        helper.viewAll(component, event, helper);
    },
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        helper.openModel(component, event, helper);
    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        helper.closeModel(component, event, helper);
    },
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        helper.submitDetails(component, event, helper);
    },
    handleSelect: function (component, event, helper) {
        helper.handleSelect(component, event, helper);
    },
    handleLoanSelect: function (component, event, helper) {
        helper.handleLoanSelect(component, event, helper);
    }
})