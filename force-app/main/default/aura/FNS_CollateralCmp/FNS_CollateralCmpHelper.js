({
	doInit:function(component, event, helper) {
        console.log('test');
		component.set('v.columnNames', [
            {label: 'COLLATERAL FILE', fieldName: 'CollateralDocuments[0].FNS_DocumentId__c', type: 'text', typeAttributes: { target: '_self'}},
            {label: 'COLLATERAL TYPE', fieldName: 'Collateral.FNS_CollateralType__c', type: 'text'},
            {label: 'PRODUCT RELATED', fieldName: 'Collaterl.FNS_Product__c', type: 'url', typeAttributes: { target: '_self'}},
            {label: 'PRIMARY COLLATERAL', fieldName: 'Collateral.FNS_CollateralCategory__c', type: 'text'}
        ]);

        helper.getCollateralData(component, event, helper);
        helper.setTableHeadings(component, event, helper);
        
         //component.set('v.showCollMoreFields', false);
        // Setting products required error
        var reqFieldObj = [{'apiName':'FNS_ProductsList__c', 'label':'Related Products'}];
        helper.setErrorList(component, helper, reqFieldObj);
        component.set('v.isScriptLoaded', true);
    },
    
    getCollateralData : function(component, event, helper) {
        var action = component.get('c.getComponentData');
        action.setParams({ "applicationId" : component.get('v.recordId') }); 
        action.setCallback(this, 
                           function(response) {
                               console.log("Collateral response");
                               var state = response.getState();
                               console.log("Collateral callback");
                               console.log("Collateral state: " + state);
                               
                               if (component.isValid() && state === "SUCCESS") {
                                   var response = response.getReturnValue();
                                   console.log("callback state: " , response);
                                   
                                   component.set('v.wrapper', response.collateralBaseWrapper);
                                   component.set('v.addressWrapper', response.addressWrapper);
                                   component.set('v.collateraTypeWrapper', response.collateralTypeWrapper);
                                   
                                   var action2 = component.get('c.getCollateralsByApplicationId');
                                   action2.setParams({ "applicationId" : component.get('v.recordId') }); 
                                   action2.setCallback(this, 
                                                       function(response) {
                                                           var state = response.getState();
                                                           console.log("Collateral callback");
                                                           console.log("Collateral state: " + state);
                                                           
                                                           if (component.isValid() && state === "SUCCESS") {
                                                               var result = response.getReturnValue();
                                                               component.set('v.collateralList', result); 
                                                               component.set('v.collateralCount', result.length);     
                                                           }
                                                       }
                                                      );
                                   $A.enqueueAction(action2);
                               }
                           }
                          );
        $A.enqueueAction(action);
    },
    
    getProductsList:function(component, event, helper) {
        var action = component.get('c.getProductsByApplication');
        action.setParams({ "applicationId" : component.get('v.recordId') }); 
        action.setCallback(this, 
                           function(response) {
                               var state = response.getState();
                               
                               if (component.isValid() && state === "SUCCESS") {
                                   var response = response.getReturnValue();
                                   var prodList = new Array();
                                   console.log("callback state: " , response);
                                   if (!$A.util.isEmpty(response)) {
                                       for(var i in response) {
                                           var item = response[i];
                                           var product = {'label':item.FNS_ProductSummary__c, 'value': item.Id};
                                            prodList.push(product);
                                       } 
                                   }
                                   component.set('v.productsList', prodList);
                               }
                            }
                        );
        $A.enqueueAction(action);
        helper.setTableHeadings(component, event, helper);
        component.set('v.isScriptLoaded', true); 
    },
    setTableHeadings: function(component, event, helper) {
        var pathsForTableHeadings = [
            {
                path: 'Id',
                label: 'Id',
                type: 'text'
            },
            {
                path: 'FNS_CollateralType__c',
                label: 'Collateral Type',
                type: 'text'
            }
        ];
        component.set( 'v.tableHeadings', pathsForTableHeadings );
    },
    
    showCollMoreFields:function(component,event,helper){
        let showMoreFields = !component.get('v.showCollMoreFields');
        let btnShowMoreFieldsTitle = showMoreFields ? 'SHOW LESS COLLATERAL FIELDS' : 'SHOW MORE COLLATERAL FIELDS';
        var btnShowMoreFields = component.find("btnShowCollMoreFields"); // get button component
        btnShowMoreFields.set("v.label", btnShowMoreFieldsTitle); // set the title
        btnShowMoreFields.set("v.iconName", showMoreFields ? "utility:dash" : "utility:add");
        
        component.set('v.showCollMoreFields',showMoreFields);
    },
    
    showFieldSet:function(component, event, helper){
        console.log('test showFieldSet');
        var val = event.getSource().get("v.value");
        console.log('val'+val);
        //alert('### val ' +val);
        if (!$A.util.isEmpty(val)) {
            var action = component.get('c.getComponentDataFromType');
            action.setParams({"categoryName": val }); 
            action.setCallback(this, 
                function(response) {
                    console.log("Collateral response");
                    var state = response.getState();
                    console.log("Collateral state: " + state);
                    if (component.isValid() && state === "SUCCESS") {
                        var response = response.getReturnValue();
                        console.log("callback state: " , response);
                        component.set('v.collateraTypeWrapper', response);
                        component.set('v.showCollateralTypeForm', true);
                    } else {
                       // alert('Error');
                    }
                }
            );
            $A.enqueueAction(action);
        } else {
            component.set('v.showCollateralTypeForm', false);
        }
    },
    
    /* Method to create collateral json object for save*/
    createCollateralObjToSave: function(component, collateral, fields) {
        _.forEach(fields, function(field) {
            collateral[field.APIName] = field.Value;
        });
        
        return collateral;
    },
    
    uploadDocument: function(component, event, helper) {
        let uploadedFiles = event.getParam("files");
        let documentId = uploadedFiles[0].documentId;
        let fileName = uploadedFiles[0].name;
        component.set("v.documentId", documentId);
        component.set("v.fileName", fileName);
        component.set("v.uploaded", "true");
    },

    saveCollateralRec: function(component, event, helper, collateralObjToSave){
        //alert('saveCollateralRec');
        var action = component.get('c.createCollateralsWithChildRecs');
			action.setParams({"collateralJson": collateralObjToSave }); 
			action.setCallback(this, 
                function(response) {
                    console.log("Collateral response");
                    var state = response.getState();
                    console.log("Collateral state: " + state);
                    component.set('v.spinner', false);
                               
                    if (component.isValid() && state === "SUCCESS") {
                        var response = response.getReturnValue();
                        console.log("callback state: " , response);
                        if( response.isSuccess) {
                            helper.showToast(component,event,"Success","success",  'Collateral Submitted Successfully');
                            
                            $A.get("e.force:refreshView").fire();
                            component.set("v.errorMessages", []);
                            component.set("v.showModal", false);
                        } else {
                            helper.showToast(component,event,"Error","error", 'There was some Error. Collateral is not submitted.');
                        }
                    } else {
                        helper.showToast(component,event,"Error","Error",'There was some Error. Collateral is not submitted.');
                    }
                }
            );
        $A.enqueueAction(action);


    },
    handleProductSelectedChangeEvent:function(component, event, helper) {
        var items = component.get("v.items");
        items = event.getParam("values");
        var reqFieldObj = {'apiName':'FNS_ProductsList__c', 'label':'Related Products'};
        if($A.util.isEmpty(items)) {
            helper.addError(component, helper, reqFieldObj);
        } else {
            helper.removeError(component, helper, reqFieldObj);
        }
        component.set("v.selectedProductsList", items);
    },
    showToast : function(component, event, title, type, msg) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": msg
        });
        toastEvent.fire();
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
            
            default:
            break;
        }
    
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
})