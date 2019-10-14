({
    
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.set("v.isModalOpen", false);
    },
    handleSelect: function (component, event, helper) {
        console.log('inside handleSelect');
        let selectedOption = event.getParam("value").split(',');
        let selectedRecordId = selectedOption[0];
        let selectedMenu = selectedOption[1];
        let productSummary = selectedOption[2];
        console.log('selectedMenu = '+selectedMenu);
        if(selectedMenu == 'Edit'){
            helper.editProductRecord(component, event, helper, selectedRecordId, productSummary);
        }else if(selectedMenu == 'Delete'){
            helper.deleteProductRecord(component, event, helper, selectedRecordId);
        }else if(selectedMenu == 'Add Pricing'){
            helper.addPricingRecord(component, event, helper, selectedRecordId);
        }
    },
    handleLoanSelect: function (component, event, helper) {
        console.log('inside handleSelect');
        let selectedOption = event.getParam("value").split(',');
        let selectedRecordId = selectedOption[0];
        let selectedMenu = selectedOption[1];
        let loanSummaryValue = selectedOption[2];
        console.log('selectedMenu = '+selectedMenu);
        console.log('loanSummary = '+loanSummaryValue);
        if(selectedMenu == 'Edit'){
            helper.editLoanRecord(component, event, helper, selectedRecordId, loanSummaryValue);
        }else if(selectedMenu == 'Delete'){
            helper.deleteLoanRecord(component, event, helper, selectedRecordId);
        }
    },
	sortData: function (component, fieldName, sortDirection) {
        let data = component.get("v.productList");
        let reverse = sortDirection !== true;
        data.sort(this.sortBy(fieldName, reverse));
        component.set("v.productList", data);
        component.set('v.sortAsc', reverse);
    },
    sortBy: function (field, reverse, primer) {
        let key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    viewAll : function(component, event, helper){
        let action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                let listview = response.getReturnValue();
                if(listview != undefined){
                    let navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "listViewId": listview['listViewId'],
                        "listViewName": null,
                        "scope": listview['objName']
                    });
                    navEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    editProductRecord : function(component, event, helper, recordId, productSummary) {
        let action = component.get("c.editProduct");
        action.setParams({ "productId" : recordId });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let productList = [];
            if (state === "SUCCESS") {
                let productData = response.getReturnValue();
                let editProductEvent = component.getEvent("editProductEvent");
                if(!$A.util.isEmpty(productData.error)){
                     editProductEvent.setParams({
                    	"error" : productData.error
                    });
                }else{
                    editProductEvent.setParams({
                    "productId" : recordId,
                    "productSummary" : productSummary,    
                    "loanList"  : productData.loanRecords,
                    "roleList"  : productData.roleRecordIds,
                    "feeList"   : productData.feesRecordIds,
                    "pricingList" : productData.pricingRecordIds
                	});
                }
                
                
                editProductEvent.fire();
            }else if (state === "ERROR") {
            }
        });
        $A.enqueueAction(action);
    },
    deleteProductRecord : function(component, event, helper, recordId) {
        component.set("v.spinner", true);
        let action = component.get("c.deleteProduct");
        action.setParams({ "productId" : recordId });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                let deleteProductEvent = component.getEvent("deleteProductEvent");
                if(!$A.util.isEmpty(result.error)){
                    deleteProductEvent.setParams({
                    	productDeleteResponse:{error:result.error} 
                	});
                    helper.showToast(component,event, helper,"Error","Error", $A.get("$Label.c.FNS_RECORD_DELETE_SUCCESS")+result.error);
                }else{
                    helper.showToast(component,event, helper,"Success","Success", $A.get("$Label.c.FNS_RECORD_DELETE_SUCCESS"));
               		deleteProductEvent.setParams({
                    	productDeleteResponse:{productId : recordId} 
                	});
                }
                component.set("v.spinner", false);
                deleteProductEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(component, event, helper,title,type,msg) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": msg
        });
        toastEvent.fire();
    },
    editLoanRecord : function(component, event, helper, recordId, summaryValue) {
        let editLoanEvent = component.getEvent("editLoanEvent");
        editLoanEvent.setParams({
            "loanId" : recordId,
            "isLoanEdit" : true,
            "loanSummary" : summaryValue
        });
        editLoanEvent.fire();
    },
    deleteLoanRecord : function(component, event, helper, recordId) {
        component.set("v.spinner", true);
        let action = component.get("c.deleteLoan");
        action.setParams({ "loanId" : recordId });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                let deleteLoanEvent = component.getEvent("deleteLoanEvent");
                if(!$A.util.isEmpty(result.error)){
                    deleteLoanEvent.setParams({
                    	loanDeleteResponse:{error:result.error} 
                	});
                    helper.showToast(component,event, helper,"Error","Error", $A.get("$Label.c.FNS_RECORD_DELETE_SUCCESS")+result.error);
                }else{
                    helper.showToast(component,event, helper,"Success","Success", $A.get("$Label.c.FNS_RECORD_DELETE_SUCCESS"));
               		deleteLoanEvent.setParams({
                    	loanDeleteResponse:{productId : recordId} 
                	});
                }
                component.set("v.spinner", false);
                deleteLoanEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})