({
    doInit: function(component,event,helper) {            
        var objectLabel = component.get('v.objectLabel');
        component.find("btnShowMoreFields").set("v.label", 'SHOW MORE ' + objectLabel + ' FIELDS');
        let fields =_.cloneDeep(component.get("v.fields"));
        component.set('v.fields',fields);
        let moreFields =_.cloneDeep(component.get("v.moreFields"));
        if(!$A.util.isEmpty(moreFields)) {
        	component.set('v.moreFields',moreFields);
        }
        
    },
    
    scrollToLocation: function(component){
        var locationName = component.get('v.uniqFormId');        
        if($A.util.isEmpty(locationName) || !locationName.includes('Pricing')) return;  
        component.getElement(locationName).scrollIntoView({behavior: 'smooth', block: 'end', inline: 'nearest'});
    },
    
    updateRecord : function(component, event, helper,currentRecordId){
        var action = component.get('c.getComponentData');
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log('FieldSetFormController getFormAction callback');
            console.log("callback state: " + state);
            
            if (component.isValid() && state === "SUCCESS") {
                var response = response.getReturnValue();
                console.log("callback state: " , response);
                component.set('v.wrapper', response);
            }
        });
        $A.enqueueAction(action);
    },
    showMoreFields:function(component,event,helper){
        let objectLabel = component.get('v.objectLabel');
        let showMoreFields = !component.get('v.showMoreFields');
        let btnShowMoreFieldsTitle = showMoreFields ? 'SHOW LESS ' + objectLabel + ' FIELDS' : 'SHOW MORE ' + objectLabel + ' FIELDS';
        var btnShowMoreFields = component.find("btnShowMoreFields"); // get button component
        btnShowMoreFields.set("v.label", btnShowMoreFieldsTitle); // set the title
        btnShowMoreFields.set("v.iconName", showMoreFields ? "utility:dash" : "utility:add");
        
        component.set('v.showMoreFields',showMoreFields);
    },
    cancelLoan:function(component,event,helper) {        
        component.getEvent("closeLoanEditorEvent").fire();
        helper.clearFields(component,event,helper);
    },
    clearFields:function(component,event,helper){
        var fields = component.get("v.fields");
        if(!$A.util.isUndefinedOrNull(fields)) {
            for (var key in fields) {
                let fieldAPIName = fields[key].APIName;
                fields[key].Value ='';
            }
            component.set("v.fields", fields);
        }
        var moreFields = component.get("v.moreFields");
        if(!$A.util.isUndefinedOrNull(moreFields)) {
            for (var key in moreFields) {
                let fieldAPIName = moreFields[key].APIName;
                moreFields[key].Value ='';
            }
            component.set("v.moreFields", moreFields);
        }
    },
	saveAndCreateNewLoan:function(component,event,helper) {
        component.set('v.createNewLoan',true);
        component.find("recordForm").submit();
    },
    saveLoan:function(component,event,helper) {
        component.set('v.createNewLoan',false);
        var eventFields = event.getParam("fields");
        console.log('eventFields>>>',eventFields);
        return;
        component.find("recordForm").submit();
    },
    saveForm : function(component, event, helper){
        console.log('FieldSetFormController.saveForm');
        if(component.get('v.objectLabel')=='PRODUCT'){
            let result = event.getParam('arguments');
            if(!$A.util.isUndefinedOrNull(result.param)){
                if (result.param.recordID){
	                component.set('v.currentRecordId',result.param.recordID);
                    component.set('v.productId',result.param.recordID);
                }
                
                component.find("recordForm").submit();
            }
        }
        if(component.get('v.isLoanEdit')){
               component.find("recordForm").submit();
        }
        else
        if(component.get('v.objectLabel')=='LOAN'){            
            let loanData = event.getParam('arguments');
            let result = loanData.param.rawData;
            let rowIndex = loanData.param.rowIndex;
            let picklistValues = loanData.param.picklistValues;
            component.set('v.currentRecordId', result.Id);
            let fields = component.get("v.fields");
            
            for (let key in fields) {
                let fieldAPIName = fields[key].APIName;
                if(fields[key].Type=='PICKLIST' && !$A.util.isUndefinedOrNull(picklistValues)){
                   let picValues =picklistValues[fieldAPIName].values;
                   let fieldValuetest = _.find(picValues, function(keyVal) {
                       return keyVal.label === result[fieldAPIName]
                   });
                   fields[key].Value= fieldValuetest.value;
                }
                else
                	fields[key].Value =result[fieldAPIName];
            }
            let moreFields = component.get("v.moreFields");
            for (let key in moreFields) {
                let fieldAPIName = moreFields[key].APIName;
                moreFields[key].Value =result[fieldAPIName];
            }
            let requiredFields = component.get("v.requiredFields");
      		component.set("v.fields", fields);
            component.set("v.moreFields", moreFields);
            component.set("v.requiredFields", requiredFields);
            
            component.set('v.rowResponse',result);
            component.set('v.rowIndex',rowIndex);
        }
    	else if(component.get('v.objectLabel')=='PRICING'){
            let result = event.getParam('arguments');
            let requiredFields = component.get("v.requiredFields");
            let eventFields = {};
            requiredFields.forEach(function (item, index) {
                console.log(item, index);
                eventFields[item.APIName] = item.Value;
            });
            let fields =  _.cloneDeep(component.get("v.fields"));
            fields.forEach(function (item, index) {
                console.log(item, index);
                eventFields[item.APIName] = item.Value;
            });
            let moreFields =  _.cloneDeep(component.get("v.moreFields"));
            if(!$A.util.isUndefinedOrNull(moreFields)){
                moreFields.forEach(function (item, index) {
                    console.log(item, index);
                    eventFields[item.APIName] = item.Value;
                }); 
            }
            if(!$A.util.isUndefinedOrNull(result.param)){
                if (result.param.productId){
	                component.set('v.productId',result.param.productId);
                }
                component.find("recordForm").submit(eventFields);
            }
        }
        
    },
    handleSuccess : function(component, event, helper) {
        let payload = event.getParams().response;
        let cmpEvent = component.getEvent("getResponseEvent");
        let response =  new Object();
        response.object=component.get('v.objectLabel');
        response.error="";
        response.status="success";
        response.recordID = payload.id;
        response.uniqformId = component.get('v.uniqFormId');
        response.createNewLoan = component.get('v.createNewLoan');
        cmpEvent.setParams({"response" : response});
        cmpEvent.fire();
    },
    handleError: function(component,event,helper) {
        console.debug('error - ');
        let cmpEvent = component.getEvent("getResponseEvent");
        let response =  new Object();
        response.object=component.get('v.objectLabel');
        response.error="true";
        response.status="error";
        cmpEvent.setParams({"response" : response});
        cmpEvent.fire();
    },
    recordEditHandler : function(component, event, helper) {
        component.set('v.wrapper.ObjectName','FinServ__FinancialAccountTransaction__c');/*event.getParam('rawData')*/
        var rawData = event.getParam('rawData');
    },
    handleSubmit: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        var fields = component.get("v.fields");
        var moreFields = component.get("v.moreFields");
        var requiredFields = component.get("v.requiredFields");
        var picklistValues = component.get("v.picklistValues");
        
        let tableResponse;
        
        let rowResponse = component.get('v.rowResponse');
        tableResponse={};
        let response =  new Object();
        response.saveResult = {};
        response.picklistResult = [];
        response.picklistValues = picklistValues;
       
        if(!$A.util.isUndefinedOrNull(rowResponse)){
            for (var key in fields) {
                let fieldName = fields[key].APIName;
                //added this code to store the label of picklist instead of value
                if(component.get('v.objectLabel')=='LOAN' && fields[key].Type=='PICKLIST'){
                   let picValues =picklistValues[fieldName].values;
                   let fieldValuetest = _.find(picValues, function(keyVal) {
                       return (keyVal.value === eventFields[fields[key].APIName] || keyVal.label === eventFields[fields[key].APIName])
                   });
                   rowResponse[fieldName] = fieldValuetest.label;
                   var element = {fieldName:fieldName, value: eventFields[fields[key].APIName]}
                   response.picklistResult.push(element)
                }
                else
                	rowResponse[fieldName] = eventFields[fields[key].APIName];
            }
       	 	for (var key in moreFields) {
            	let fieldName = moreFields[key].APIName;	
            	rowResponse[fieldName] =eventFields[moreFields[key].APIName];
        	}
        	for (var key in requiredFields) {
            	let fieldName = requiredFields[key].APIName;
            	rowResponse[fieldName] =eventFields[moreFields[key].APIName];
        	}
            response.table = rowResponse;
        }
        else {
            for (var key in fields) {
            	let fieldName = fields[key].APIName;
                //added this code to store the label of picklist instead of value
                if(component.get('v.objectLabel')=='LOAN' && fields[key].Type=='PICKLIST'){
                   let picValues =picklistValues[fieldName].values;
                   let fieldValuetest = _.find(picValues, function(keyVal) {
                       return keyVal.value === eventFields[fields[key].APIName]
                   });
                   tableResponse[fieldName] = fieldValuetest.label;
                   var element = {fieldName:fieldName, value: eventFields[fields[key].APIName]}
                   response.picklistResult.push(element);
                }
                else
                 tableResponse[fieldName] =eventFields[fields[key].APIName];
        	}
       	 	for (var key in moreFields) {
            	let fieldName = moreFields[key].APIName;	
            	tableResponse[fieldName] =eventFields[moreFields[key].APIName];
        	}
        	for (var key in requiredFields) {
            	let fieldName = requiredFields[key].APIName;
            	tableResponse[fieldName] =eventFields[moreFields[key].APIName];
        	}
            response.table = tableResponse;
        }
        
        let cmpEvent = component.getEvent("getResponseEvent");
        response.currentRowIndex = component.get('v.rowIndex');
        cmpEvent.setParams({"response" : response});
        cmpEvent.fire(); 

		helper.clearFields(component,event,helper);
        return;
    },

    resetErrorLst :function(component, event, helper) {
        let errorLst = component.get('v.errorLst');
        let fldName = event.getSource().get("v.fieldName")
        let uniqFormId = component.get('v.uniqFormId');
        let value = event.getSource().get("v.value")
        //console.log(event.getSource().get("v.value"));
        //console.log(event.getSource().get("v.fieldName"));
        //let index = _.findIndex(errorLst, function(err) { return err.apiName == fldName; });
        let requiredFldLst = component.get('v.requiredFldLst');
        let index = _.findIndex(requiredFldLst, function(err) { return err.APIName == fldName; });
       
        if( $A.util.isEmpty(value) && index !== -1 ){
            let reqFLd = requiredFldLst[index];
            let errorfld = {
				apiName : uniqFormId+'_'+fldName,
				label : reqFLd.Label,
			};
            helper.fireCompEvent(component, helper, 'ADD_ERROR', errorfld);
        }
        else if(!$A.util.isEmpty(value) && index !== -1){
            let reqFLd = requiredFldLst[index];
            let errorfld = {
				apiName : uniqFormId+'_'+fldName,
				label : reqFLd.Label,
			};
            helper.fireCompEvent(component, helper, 'REMOVE_ERROR', errorfld);
        }
    },
    setRequiredFields: function(component,event,helper,fields){
        var payload = event.getParams();
        let record = _.get(payload, 'recordUi.record.fields');
        //let record= event.getParam("records");
        let uniqFormId = _.cloneDeep(component.get("v.uniqFormId"));
        component.get("v.objectLabel");
        //let fieldsClone =_.cloneDeep(component.get("v.fields"));
        
        //component.set('v.fields',fields);

        let requiredLst =  _.filter(fields, function(fld) { 
            return (fld.DBRequired || fld.Required);
        });
        if($A.util.isEmpty(requiredLst)){
            return;
        }
        let requiredFldLstOld = _.cloneDeep(component.get('v.requiredFldLst'));
        if(!$A.util.isEmpty(requiredFldLstOld)){
            let requiredLstNew = requiredFldLstOld;
            let index;
            _.forEach(requiredLst, function(fldObj) {
                index = _.findIndex(requiredFldLstOld, 
                    function(err) { 
                        return err.APIName === fldObj.APIName; 
                    });
                if(index === -1){
                    requiredLstNew.push(fldObj);
                }
            });
            component.set('v.requiredFldLst',requiredLstNew);
        }
        else {
            component.set('v.requiredFldLst',requiredLst);
        }
        let errorLst = [];
        let errorfld = {};
        let fldValue ;
        _.forEach(requiredLst, function(req) {
            fldValue = _.get(record, req.APIName);
            if($A.util.isEmpty(fldValue.value)){
                errorfld = {
                    apiName : uniqFormId+'_'+req.APIName,
                    label : req.Label,
                };
                errorLst.push(errorfld);
            }
        });

        //picklistValues
        if(!$A.util.isEmpty(errorLst))
            helper.fireCompEvent(component, helper, 'SET_ERROR', errorLst);
    },
	removeCmp : function(component, event, helper) {
		let response =  new Object();
        response.object=component.get('v.objectLabel');
        response.rowNo = component.get("v.pricingIndex");
        response.uniqformId = component.get('v.uniqFormId');
        helper.fireCompEvent(component, helper, 'DEL_REC', response);
       
    },
    scrollTo: function(component, event, helper){
        let elements = component.find("fieldSetForm").getElement()
        //elements.scrollTop = 0;
        //elements[0].scrollTop = 0;
        var contentSection = elements.getElementsByClassName('fns-scroll');
        contentSection[0].scrollTop = 0;
       
    }
})