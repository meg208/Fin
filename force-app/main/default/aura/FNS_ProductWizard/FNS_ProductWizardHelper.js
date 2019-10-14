({
    doInit:function(component, event, helper){
        var action = component.get('c.getComponentData');
        action.setParams({ "applicationId" : component.get('v.recordId') });
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log('FieldSetFormController getFormAction callback');
            console.log("callback state: " + state);
            
            if (component.isValid() && state === "SUCCESS") {
                var response = response.getReturnValue();
                console.log("callback state: " , response);
                component.set('v.wrapper', response);
                component.set('v.isLoading', false);
            }
        });
        $A.enqueueAction(action);
        helper.getProductData(component,event,helper);
    },
    handleCompEvent: function( component, event, helper ) {
        var action = event.getParam( 'action' );
        var payload = event.getParam( 'payload' );
        switch ( action ) {
            case 'SET_ERROR':
                helper.setErrorList(component, helper, payload);
                event.stopPropagation();
                break;
            case 'ADD_ERROR':
                helper.addError(component, helper, payload);
                event.stopPropagation();
                break;
            case 'REMOVE_ERROR':
                helper.removeError(component, helper, payload);
                event.stopPropagation();
                break;
            case 'DEL_REC':
                helper.removeDeleteError(component, helper, payload);
                event.stopPropagation();
                break;   
                
            default:
                break;
        }
        
    },
    getProductData :function(component,event,helper){
        let action = component.get('c.getProductData');
        action.setParams({ "applicationId" : component.get('v.recordId') });
        action.setCallback(this, function(response) {
            //store state of response
            let state = response.getState();
            if (state === "SUCCESS") {
                let productData = response.getReturnValue();
                let productList = [];
                if(!$A.util.isEmpty(productData.error)){
                    component.set("v.responseError",  component.get("v.responseError") + productData.error);
                    component.set('v.productList', productList);
                }else{
                    let totalProducts = productData.productWrapperList.length;
                    productList = productData.productWrapperList;
                    component.set('v.productCount', totalProducts);
                    component.set('v.productList', productList);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    
    populateInitialData : function( component, event, helper) { 
        let wrapper = component.get('v.wrapper');
        let productList = component.get('v.productList');
        
        if ($A.util.isUndefinedOrNull(wrapper) || $A.util.isUndefinedOrNull(productList))
            return;
        
        component.set('v.isLoading', false);
    },
    
    openModal:function(component, event, helper){
        component.set('v.showModal', true);
    },
    closeModal:function(component, event, helper){
        document.body.setAttribute('style','overflow:visible');
        component.set('v.showModal', false);
        component.set('v.isLoanEdit', false);
        component.set('v.loanList', []);
        component.set('v.loanListToSave', []);
        // Caused an issue similar to : https://success.salesforce.com/issues_view?id=a1p3A0000018BVpQAM
        //component.set('v.pricingList', []);
        component.set("v.productId",'');
        component.set('v.errorMessages',[]);
        component.set('v.errorLst',[]);
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
    addLoan:function(component,event,helper){
        component.set('v.showLoanTable', true);
        component.set('v.showLoanFields', true);
        loanForm.clearFields();
    },
    addPricing:function(component,event,helper){
        component.set('v.showPricingFields', true);
        let pricingList = component.get('v.pricingList');
        if($A.util.isUndefinedOrNull(pricingList)){
            pricingList = [];            
        }
        pricingList.push('1');
        component.set('v.pricingList',pricingList);
        
    /*var fields = component.get("v.wrapper.pricing.fields");
        if(!$A.util.isUndefinedOrNull(fields)) {
            for (var key in fields) {
                let fieldAPIName = fields[key].APIName;
                fields[key].Value ='';
            }
            component.set("v.fields", fields);
        }
        var moreFields = component.get("v.wrapper.pricing.moreFields");
        if(!$A.util.isUndefinedOrNull(moreFields)) {
            for (var key in moreFields) {
                let fieldAPIName = moreFields[key].APIName;
                moreFields[key].Value ='';
            }
            component.set("v.moreFields", moreFields);
        }*/
    },
    deletePricing: function(component,event,helper, record) {
        let rowIndex = record.rowNo;
        let allPricingList = component.get("v.pricingList");
        if(rowIndex.length > 15){
            let counter=0;
            _.forEach(allPricingList, function(value) {
                if(rowIndex === value){
                  allPricingList.splice(counter,1);
                }
                counter++;
            });
        }else {
            allPricingList.splice(rowIndex, 1);
        }
        component.set('v.allPricingList',allPricingList);
        if(!$A.util.isUndefinedOrNull(rowIndex.length)) {
            let action = component.get('c.deletePricingRecords'); 
            action.setParams({
                "recordId" : rowIndex,
                "objName" : component.get("v.wrapper.pricing.ObjectName")
            });
            action.setCallback(this, function(response){
                var state = response.getState(); // get the response state
                if(state == 'SUCCESS') {
                    let result = response.getReturnValue();
                    if(!$A.util.isEmpty(result.error)){
                        helper.showToast(component,event, helper,"Error","Error", $A.get("$Label.c.FNS_RECORD_DELETE_ERROR")+result.error);
                    }
                    else{
                        helper.showToast(component,event, helper,"Success","Success", $A.get("$Label.c.FNS_RECORD_DELETE_SUCCESS"));
                    }
                }
                else{
                    helper.showToast(component,event, helper,"Error","Error", $A.get("$Label.c.FNS_RECORD_DELETE_ERROR"));
                }
            });
            $A.enqueueAction(action);
        }
        component.set("v.pricingList",allPricingList);
    },
    submit:function(component,event,helper){
        component.set('v.allSaveMethodsCalled',false);
        component.set('v.saveMethodsCalled',[]);
        let formtoSubmit;
        if(component.get('v.isLoanEdit')){
             formtoSubmit = component.find('loanFormEdit');
          
        }else{
            formtoSubmit = component.find('productForm');
            let uniqformID = component.find('productForm').get('v.uniqFormId');
            helper.addSaveCalledList(component,helper,uniqformID)            
        }
        let param = {};
        param.productId = component.get("v.productId");
        param.oppId = component.get("v.recordId");
        console.log('recordId',param);
        
        let errLst = component.get('v.errorLst');
        if($A.util.isEmpty(errLst)){
            component.set('v.spinner',true);
            formtoSubmit.saveForm(param); 
        }else {
            helper.displayErrorMessages(component,event,helper);
            helper.scrollToTop(component,event,helper);
        }
    },
    getResponse:function(component,event,helper){
        let response = event.getParam("response");
        if(response.uniqformId){
            helper.removeSaveCalledList(component,helper,response.uniqformId);
        }
        if (response.status=='error'){
            component.set('v.spinner',false);
        }
        if(!$A.util.isEmpty(response.table)){
            if(!$A.util.isEmpty(response.picklistValues)){
                component.set('v.picklistValues',response.picklistValues);
            }
            component.set('v.showLoanTable',true);
            var loanList = component.get('v.loanList'); 
            var tableToSave = _.cloneDeep(response.table);
            var loanListToSave =  component.get('v.loanListToSave'); 
            var picklistValues = response.picklistValues;
            loanListToSave = _.cloneDeep(loanList);
            
            let currentRowIndex = response.currentRowIndex;
            if(!$A.util.isEmpty(response.picklistResult)){
                var tableToSave = _.cloneDeep(response.table);
                for(var pickKey in response.picklistResult){
                    var fieldName = response.picklistResult[pickKey].fieldName;
                    tableToSave[fieldName] = response.picklistResult[pickKey].value;
                    for(var loanKey in loanListToSave){ 
                        let picValues = picklistValues[fieldName].values;
                        let fieldValuetest = _.find(picValues, function(keyVal) {
                            return ((keyVal.value === loanListToSave[loanKey][fieldName] || keyVal.label === loanListToSave[loanKey][fieldName]) && loanKey != currentRowIndex)
                        });
                        if(!$A.util.isEmpty(fieldValuetest))
                            loanListToSave[loanKey][fieldName] = fieldValuetest.value;
                    }
                }
                if(currentRowIndex != -1 ) {
                    loanListToSave[currentRowIndex] = tableToSave;                    
                }
                else{                
                    loanListToSave.push(tableToSave);
                }
                component.set('v.loanListToSave',JSON.parse(JSON.stringify(loanListToSave)));
            }
            if(currentRowIndex != -1){
                loanList[currentRowIndex] = response.table;
            }
            else{                
                loanList.push(response.table);
            }
            component.set('v.loanList',JSON.parse(JSON.stringify(loanList)));
            console.log('loanList>>>',loanList[0]);
            component.set('v.showLoanFields', false);
            //$A.get('e.force:refreshView').fire();
        }
        if(response.object==component.get('v.wrapper.product.ObjectLabel')){
            let action = component.get('c.insertLoanRecords');
            let loanList = JSON.stringify(component.get('v.loanListToSave'));
            
            if(!$A.util.isEmpty(component.get('v.loanList'))){
                action.setParams({ "productId" : response.recordID,
                                  "applicationId": component.get('v.recordId'),
                                  "loanListToUpdate":loanList});
                action.setCallback(this, function(response) {
                    //store state of response
                    let state = response.getState();
                    //component.set('v.spinner',false);
                    
                    if (state === "SUCCESS") {
                        this.updateAmountonApplication(component,event,helper);
                    }else{
                    }
                });
                $A.enqueueAction(action);
            }
            if(!$A.util.isEmpty(response.recordID)){
                //let param = {};
                component.set('v.productId', response.recordID);
                let formtoSubmit = component.find('productFormMore');
                formtoSubmit.saveForm(response);
                
                let param1 = {};
                let pricingReqFlds = component.get('v.wrapper.pricing.requiredFields');
                for(let fld in pricingReqFlds){
                    let fieldAPIName = pricingReqFlds[fld].APIName;
                    console.log('fieldAPIName = '+fieldAPIName);
                    if(fieldAPIName.includes('FNS_FinancialAccount')){
                        pricingReqFlds[fld].Value = component.get('v.productId');
                    }
                }
                component.set('v.pricingReqFlds',pricingReqFlds);
                param1.productId = component.get("v.productId");
                //component.set('v.newProductId', response.recordID);
                let pricingFormLst = component.find('pricingForm');
                if(pricingFormLst) {
                    if(pricingFormLst.length) {
                        pricingFormLst.forEach(function(form,index) {
                            let uniqformID = form.get('v.uniqFormId');
                            helper.addSaveCalledList(component,helper,uniqformID);    
                            form.saveForm(param1);
                        });
                    } else {
                        let uniqformID = pricingFormLst.get('v.uniqFormId');
                        helper.addSaveCalledList(component,helper,uniqformID);  
                        pricingFormLst.saveForm(param1);
                    }
                };
                
                this.updateAmountonApplication(component,event,helper);
                helper.showToast(component,event, helper,"Success","Success", $A.get("$Label.c.FNS_RECORD_UPDATE_SUCCESS")); 
            } 
        }
        if(component.get('v.isLoanEdit')){
            component.set('v.spinner',false);
            this.closeModal(component, event, helper);
            $A.get('e.force:refreshView').fire();
            helper.showToast(component,event, helper,"Success","Success", $A.get("$Label.c.FNS_RECORD_UPDATE_SUCCESS"));  
        }
        else if(response.object==component.get('v.wrapper.loan.ObjectLabel')){
            component.set('v.showLoanFields', false);
            let loanList=component.get("v.loanList");
            if(!(loanList.indexOf(response.recordID) > -1)){
                loanList.push(response.recordID);
            }
            component.set('v.loanList',loanList);   
            console.log('>>>>',component.get('v.loanList')); 
            if(response.createNewLoan){
                component.set('v.showLoanFields', true);
            }
            // $A.get('e.force:refreshView').fire();
        }
        
        if($A.util.isUndefinedOrNull(response.table) || $A.util.isEmpty(response.table))
            component.set('v.allSaveMethodsCalled',true);
        //component.set('v.spinner',false);
    },
    editProductRecord: function(component,event,helper) {
        console.log('inside editProductRecord from parent'); 
        let productId = event.getParam("productId");
        let productSummary = event.getParam("productSummary");
        let loanList = event.getParam("loanList");
        let roleList = event.getParam("roleList");
        let feeList = event.getParam("feeList");
        let pricingList = event.getParam("pricingList");
        let error = event.getParam("error");
        
        if(!$A.util.isEmpty(error)){
            component.set("v.responseError", error);
        }else{
            component.set('v.productId', productId);
            component.set('v.loanList', loanList);
      		component.set('v.pricingList', []);//setting it to empty first to lose earlier values
            component.set('v.pricingList', pricingList);
            component.set('v.popupHeader', productSummary);
            component.set('v.showLoanTable', loanList.length > 0);
            component.set('v.showModal', true);
            helper.openModal(component,event,helper);
        }
        
    },
    deleteProductRecord: function(component,event,helper) {
        let response = event.getParam("productDeleteResponse");
        console.log('productId>>>',response['productId']);
        console.log('error>>>>>',response['error']);
        if($A.util.isEmpty(response['error'])){
            $A.get('e.force:refreshView').fire();
        }
    },
    editLoanRecord: function(component,event,helper) {
        console.log('inside editLoanRecord from parent'); 
        console.log('event = '+event); 
        let loanId = event.getParam("loanId");
        let isLoanEdit = event.getParam("isLoanEdit");
        let loanHeader = event.getParam("loanSummary");
        console.log('loanId = '+loanId);
        console.log('isLoanEdit = '+isLoanEdit);
        console.log('loanHeader = '+loanHeader);
        
        component.set('v.loanIdToEdit', loanId);
        component.set('v.isLoanEdit', isLoanEdit);
        component.set('v.popupHeader', loanHeader);
        component.set('v.showModal', true);
        helper.openModal(component,event,helper);
        
    },
    deleteLoanRecord: function(component,event,helper) {
        let response = event.getParam("productDeleteResponse");
        console.log('productId>>>',response['productId']);
        console.log('error>>>>>',response['error']);
        if($A.util.isEmpty(response['error'])){
            $A.get('e.force:refreshView').fire();
            helper.getProductData(component,event,helper);
        }
    },
    editRecord : function(component,event,helper) {
        let rowData = event.getParam("rawData");
        let rowIndex = event.getParam("rowIndex");
        component.set('v.loanRowData', rowData);
        component.set('v.loanRowIndex', rowIndex);
        
        component.set("v.showLoanFields", true);
        component.set('v.isCalledAfterEdit', true);
    },
    closeLoanEditor : function(component,event,helper) {
        component.set("v.showLoanFields", false);
    },
    clearFields:function(component,event,helper){
        var fields = component.get("v.wrapper.product.fields");
        if(!$A.util.isUndefinedOrNull(fields)) {
            for (var key in fields) {
                let fieldAPIName = fields[key].APIName;
                fields[key].Value ='';
            }
            component.set("v.fields", fields);
        }
        var moreFields = component.get("v.wrapper.product.moreFields");
        if(!$A.util.isUndefinedOrNull(moreFields)) {
            for (var key in moreFields) {
                let fieldAPIName = moreFields[key].APIName;
                moreFields[key].Value ='';
            }
            component.set("v.moreFields", moreFields);
        }
    },
    updateAmountonApplication :function(component,event,helper){
        let action = component.get('c.updateAmountonApplication');
        action.setParams({"applicationId": component.get('v.recordId')
                         });
        action.setCallback(this, function(response) {
            //store state of response
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.spinner',false);
                //this.closeModal(component, event, helper);
                //helper.showToast(component,event, helper,"Success","Success", $A.get("$Label.c.FNS_RECORD_UPDATE_SUCCESS"));
            }else
            {
                 component.set('v.spinner',false);
                 //this.closeModal(component, event, helper);
                 //helper.showToast(component,event, helper,"Error","Error", 'Record Failed to update');
            }
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    setErrorList : function(component,helper,newErrorLst){
        let errLst = component.get('v.errorLst');
        let index ;
        _.forEach(newErrorLst, function(fldObj) {
            index = _.findIndex(errLst, function(err) { return err.apiName === fldObj.apiName; });
            if(index === -1){
                errLst.push(fldObj);
            }
        });
        //errLst.push.apply(errLst, newErrorLst);
        component.set('v.errorLst',errLst);
    },
    addError : function(component,helper,fldObj){
        let errLst = component.get('v.errorLst');
        let index = _.findIndex(errLst, function(err) { return err.apiName === fldObj.apiName; });
        if(index !== -1){
            return;
        }
        errLst.push(fldObj);
        component.set('v.errorLst',errLst);
        //helper.displayErrorMessages(component,event,helper);
    },
    removeError : function(component,helper,fldObj){
        let errMSgLst = component.get('v.errorMessages');
        let errLst = component.get('v.errorLst');
        let index = _.findIndex(errLst, function(err) { return err.apiName === fldObj.apiName; });
        if(index !== -1){
            errLst.splice(index,1);
        }
        component.set('v.errorLst',errLst);
        //helper.displayErrorMessages(component,event,helper);
    },
    
    removeDeleteError : function(component,helper,fldObj){
        console.log('inside removeDeleteError');
        console.log('fldObj = '+JSON.stringify(fldObj));
        
        let errMSgLst = component.get('v.errorMessages');
        let errLst = component.get('v.errorLst');
        let fldFind;
        let counter=0;
        _.forEach(errLst, function(err) {
            fldFind = _.startsWith(err.apiName, fldObj.uniqformId, 0);
            if(fldFind){
                errLst.splice(counter,1);
            }
            counter++;
        });
        component.set('v.errorLst',errLst);
        //helper.displayErrorMessages(component,event,helper);
        if(fldObj.object === 'PRICING'){
            helper.deletePricing(component,event,helper, fldObj);
        }
    },
    addSaveCalledList: function(component,helper,uniqformId){
        let saveMethodsCalled= component.get('v.saveMethodsCalled');
        if($A.util.isEmpty(saveMethodsCalled)){
            saveMethodsCalled = [];
        }
        saveMethodsCalled.push(uniqformId);
        component.set('v.saveMethodsCalled',saveMethodsCalled);
        
    },
    removeSaveCalledList: function(component,helper,uniqformId){
        let saveMethodsCalled= component.get('v.saveMethodsCalled');
        if($A.util.isEmpty(saveMethodsCalled)){
            return;
        }
        let index = _.findIndex(saveMethodsCalled, function(methodId) { return methodId == uniqformId; });
        saveMethodsCalled.splice(index,1);
        component.set('v.saveMethodsCalled',saveMethodsCalled);
    },
    
    processingCompleted: function (component, event, helper) {
        let saveMethodsCalled= component.get('v.saveMethodsCalled');
        let savesCalled = component.get('v.allSaveMethodsCalled');
        if(!$A.util.isEmpty(saveMethodsCalled) || (!savesCalled)){
            return;
        }
        helper.closeModal(component, event, helper);
    },
    
    displayErrorMessages: function(component, event, helper){
        let errLst = component.get('v.errorLst');
        let erroMsgLst = [];//component.get('v.errorMessages');
        _.forEach(errLst, function(fldObj) {
            erroMsgLst.push({"type":"error", "message": $A.get("$Label.c.FNS_REQUIRED")+' '+fldObj.label});
        });
        component.set('v.errorMessages',erroMsgLst);
    },
    
    scrollToTop: function(component, event, helper){
        let elements = component.find("sectionHeader").getElement()
        var contentSection = elements.getElementsByClassName('slds-modal__content');
        contentSection[0].scrollTop = 0;
        
    },
    showToast : function(component, event, helper,title,type,msg) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": msg
        });
        toastEvent.fire();
    }
    
})