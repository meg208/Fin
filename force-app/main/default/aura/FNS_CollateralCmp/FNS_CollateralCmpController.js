({
    doInit:function(component,event,helper){
        helper.doInit(component,event,helper);
    },
    openModal: function(component, event, helper) {
        component.set("v.showModal", true);
        component.set("v.uploaded",'false');
        component.set('v.popupHeader', $A.get("$Label.c.FNS_NEW_COLLATERAL")); 
        helper.getProductsList(component, event, helper);
    },
    
    closeModal: function(component, event, helper) {
        component.set("v.errorMessages", []);
        component.set("v.showModal", false);
    },
    showCollMoreFields: function(component,event,helper){
        helper.showCollMoreFields(component,event,helper);
    },
    
    showFieldSet: function(component, event, helper) {
        helper.showFieldSet(component,event,helper);
    },
    
    saveRecord: function(component, event, helper) {
        var collateralCategory = component.find('FNS_CollateralCategory__c').get('v.value');
        var collateralType = component.find('FNS_CollateralType__c').get('v.value');
        var selectedProductIdsList = component.get("v.selectedProductsList");
        var application = component.find('FNS_CollateralOwner__c').get('v.value');
        var description = component.find('FNS_Description__c').get('v.value');
        var collateral = {'FNS_CollateralType__c' :collateralType, 'FNS_CollateralOwner__c' : application,
                          'FNS_Description__c' : description,'FNS_CollateralCategory__c' : collateralCategory};
  
        var collateralBaseForm = component.find('collateralBaseForm');
        var collateralBaseFormObj = collateralBaseForm.get('v.objectToSave');
        
        var selectedProductIds = "";
        for (var i in selectedProductIdsList) {
            selectedProductIds += selectedProductIdsList[i] + ",";
        }
        selectedProductIds = selectedProductIds.substr(0, selectedProductIds.length-1);
        if(!$A.util.isEmpty(collateralBaseFormObj)) {
            collateral = _.assign(collateral, collateralBaseFormObj);
        }
        
        var collateralForm = component.find('collateralForm');
        var collateralFormObj = collateralForm.get('v.objectToSave');
        if(!$A.util.isEmpty(collateralBaseFormObj)) {
            collateral = _.assign(collateral, collateralFormObj);
        }
        var documentIdValue = component.get('v.documentId');
        //alert('documentIdValue'+ documentIdValue);
        var collateralAddressForm = component.find('collateralAddressForm');
        var collateralAddressFormObj = collateralAddressForm.get('v.objectToSave') || {};

        var collateralObjToSave = {'collateral':collateral, 'address':collateralAddressFormObj, 'document': documentIdValue, 'ProductIdSet': selectedProductIds};
        console.log('collateralObjToSave==='+JSON.stringify(collateralObjToSave));
        
        let errLst = component.get('v.errorLst');
        if($A.util.isEmpty(errLst)) {
            component.set('v.spinner', true);
        	helper.saveCollateralRec(component, event, helper, JSON.stringify(collateralObjToSave));
        } else {
            helper.displayErrorMessages(component,event,helper);
            helper.scrollToTop(component,event,helper);
        }
        
    },
    
    handleSuccess: function(component, event, helper) {
        let payload = event.getParams().response;
        component.set('v.collateralId', payload.Id);
        var collateralId = component.find('collateralId');
        collateralForm.saveForm(collateralId);
    },
    
    handleError: function(component,event,helper) {
    	let payload = event.getParams();
        console.debug('error - ');
    },
    handleUploadFinished : function(component, event, helper) {
        component.set("v.hasNoVals",true);
        helper.uploadDocument(component,event,helper); 
    },
    handleProductSelectedChangeEvent:function(component, event, helper) {
        helper.handleProductSelectedChangeEvent(component, event, helper);
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
})