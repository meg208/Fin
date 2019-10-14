({
    getDataHelper : function(component, event) {
        let action = component.get("c.getRecords");
        let rawData = component.get("v.rawData");
        let objectName = component.get('v.objectName');
        let fieldSetName = component.get('v.fieldSetName');
        
        var ids=new Array();
        for (var i= 0 ; i < rawData.length ; i++){
            ids.push(rawData[i]);
        }
        
        var rawDataJSON=JSON.stringify(ids);
        
        //Set the Object parameters and Field Set name
        action.setParams({
            recordIds : rawDataJSON,
            objectName : objectName,
            fieldSetName : fieldSetName
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var columns = response.getReturnValue().dataTableColumns;
                columns.push({
                    type: 'button-icon',
                    fixedWidth: 40,
                    typeAttributes: {
                        iconName: 'utility:edit',
                        name: 'Edit', 
                        title: 'Edit',
                        variant: 'border-filled',
                        alternativeText: 'edit',
                        disabled: false
                    }
                });  
                columns.push({
                    type: 'button-icon',
                    fixedWidth: 40,
                    typeAttributes: {
                        iconName: 'utility:close',
                        name: 'Delete', 
                        title: 'Delete',
                        variant: 'border-filled',
                        alternativeText: 'delete',
                        disabled: false
                    }
                });
                component.set("v.fieldSetColumns", response.getReturnValue().dataTableColumns);
                //if(!$A.util.isUndefinedOrNull(component.get('v.rawData'))){
                component.set("v.rawData", response.getReturnValue().dataTableData);
                //}
                
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);	
    },
    handleRowAction : function(component, event, helper) {
        let rows = component.get('v.rawData');
        let row = event.getParam('row');
        let rowIndex = rows.indexOf(row);
        let recId = row.Id;
        let objectName = component.get('v.objectName');
        let actionName = event.getParam('action').name;
        if ( actionName == 'Edit' ) {
            console.log('actionName = '+actionName);
            console.log('recId = '+recId);
            
            var recordEditEvent = component.getEvent("recordEditEvent");
            recordEditEvent.setParams({
                "rawData": row,
                "rowIndex":rowIndex
            });
            // This is where we want to do the edit event fired
            recordEditEvent.fire();
        } else if ( actionName == 'Delete') {
            if(!$A.util.isUndefinedOrNull(component.get('v.rawData'))){
                //New product 
                rows.splice(rowIndex,1);
                component.set('v.rawData',rows);
            }else{
                
                let action = component.get("c.deleteRecord");
                let rawData = component.get('v.rawData');
                let objectName = component.get('v.objectName');
                action.setParams({
                    recordId : rawData,
                    objectName : objectName
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === 'SUCCESS'){
                        let toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type": "success",
                            "message": "The Loan info has been deleted."
                            
                        });
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                    }else if (state === 'ERROR'){
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }else{
                        console.log('Something went wrong, Please check with your admin');
                    }
                });
                $A.enqueueAction(action);	
            }
        }
    }
})