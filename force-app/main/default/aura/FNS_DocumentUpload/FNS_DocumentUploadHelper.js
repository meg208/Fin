({
    uploadDocument: function(component, event, helper) {
        let uploadedFiles = event.getParam("files");
        let documentId = uploadedFiles[0].documentId;
        let fileName = uploadedFiles[0].name;
        component.set("v.documentId", documentId);
        component.set("v.fileName", fileName);
        component.set("v.uploaded", "true");
    },
    
    uploadEditDocument: function(component, event, helper) {
        let uploadedEditFiles = event.getParam("files");
        let documentEditId = uploadedEditFiles[0].documentId;
        let fileEditName = uploadedEditFiles[0].name;
        component.set("v.documentEditId", uploadedEditFiles);
        component.set("v.fileEditName", fileEditName);
        component.set("v.Edituploaded", "true");
    },
    
    getApplicationDocs: function(component, event, helper) {
        let numArr = new Array();
        for (var i = 0; i < 100; i++) {
            numArr.push(i);
        }
        component.set("v.Number", numArr);
        
        let recordid = component.get("v.recordId");
        let action = component.get("c.getApplicationDocIds");
        action.setParams({
            appId: recordid
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);
                var response = response.getReturnValue();
                if (response.length > 0) {
                    var totalLength = response.length;
                    component.set("v.Vals", true);
                    component.set("v.items", response);
                    component.set("v.totalRecordsCount", totalLength);
                } else component.set("v.Vals", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getDocumentCalloutContentFromCME: function(component, event, helper) {
        let ctarget = event.currentTarget;
        var index = ctarget.dataset.record;
        var selectedDocument = component.get("v.items")[index];
        let documentId = selectedDocument.FNS_DocumentExtId__c;
        let documentFileName = selectedDocument.FNS_FileName__c;
        let actionDocumentContentFromCME = component.get("c.callDocumentContent");
        actionDocumentContentFromCME.setParams({
            documentId: documentId,
            documentFileName: documentFileName
        });
        actionDocumentContentFromCME.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                //var decodedString;
                var documentContent = response.getReturnValue();
                if (documentContent != null) {
                    var element = document.createElement("a");
                    // Make element downloadable
					var fileExt = documentFileName.slice((Math.max(0, documentFileName.lastIndexOf(".")) || Infinity) + 1);

                    if (fileExt == "") {
                        fileExt = "txt";
                    }
                    
                    element.setAttribute(
                        "href",
                        "data:application/" + fileExt + ";base64," + documentContent
                    );    
                    element.setAttribute("download", documentFileName);
                    element.style.display = "none";
                    document.body.appendChild(element);
                    
                    element.click();
                    document.body.removeChild(element);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Document",
                        message: $A.get("$Label.c.FNS_DOCUMENT_DOWNLOAD_ERROR"),
                        duration: " 5000",
                        key: "info_alt",
                        type: "error",
                        mode: "dismissible"
                    });
                    toastEvent.fire();
                }
            }else {
                let error = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Document",
                    message: $A.get("$Label.c.FNS_DOCUMENT_DOWNLOAD_ERROR" + " " + error.message),
                    duration: " 5000",
                    key: "info_alt",
                    type: "error",
                    mode: "dismissible"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(actionDocumentContentFromCME);
  },
    
    callTrackingDocsDomain: function(component, event, helper) {
        let recordid = component.get("v.recordId");
        let action = component.get("c.callTrackingDocsDomain");
        action.setParams({
            appId: recordid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let apiResponse = response.getReturnValue();
                if (apiResponse.Error !== "Empty") {
                    component.set("v.ItemsError", apiResponse.Error);
                }
            }
        });
        let actionTracking = component.get("c.callTrackingItemsandDocsDomain");
        actionTracking.setParams({
            appId: recordid
        });
        actionTracking.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let apiResponse = response.getReturnValue();
                if (apiResponse.Error !== "Empty") {
                    component.set("v.TrackingItemsError", apiResponse.Error);
                }
            }
        });
        $A.enqueueAction(action);
        $A.enqueueAction(actionTracking);
    },
    
    trackingitem: function(component, event, helper) {
        let recordid = component.get("v.recordId");
        let action = component.get("c.FNS_tasks");
        action.setParams({
            appId: recordid
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let conts = response.getReturnValue();
                component.set("v.taskPicklist", conts);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleSelectmenu: function(component, event, helper) {
        let parcedValue = event.getParam("value").split(",");
        let recordid = component.get("v.recordId");
        let value = parcedValue[0];
        let label = parcedValue[1];
        let isSharedCurrentVal = parcedValue[2];
        if (label == "edit") {
            component.set("v.isEdit", true);
            component.set("v.Edituploaded", "false");
            component.set("v.documentExtId", value);
            component.set("v.trackingDocId", isSharedCurrentVal);
        }
        if (label == "sharedoc") {
            let docExternalId = value;
            
            let isSharedVal = "";
            if (isSharedCurrentVal === "true") {
                isSharedVal = false;
            } else {
                isSharedVal = true;
            }
            let action = component.get("c.shareDocument");
            action.setParams({
                sharedDocument: isSharedVal,
                documentExternalId: docExternalId,
                appId: recordid
            });
            action.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let conts = response.getReturnValue();
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    doSave: function(component, event, helper) {
        let uploadedFiles = event.getParam("files");
        let documentId = component.get("v.documentId");
        let recordid = component.get("v.recordId");
        let taskselected = component.get("v.TaskextIdvaluesSelected");
        let taskvalue = String(taskselected);
        var content = {
            OpportunityId: recordid,
            documentId: documentId,
            trackingid: taskvalue
        };
        
        var wrapperContent = JSON.stringify(content);
        let action = component.get("c.sendMetaData");
        
        action.setParams({
            jsonWrapper: wrapperContent
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Document",
                    message: "Document has been successfully uploaded.",
                    duration: " 5000",
                    key: "info_alt",
                    type: "success",
                    mode: "dismissible"
                });
                toastEvent.fire();
                $A.get("e.force:refreshView").fire();
                
                component.set("v.isOpen", false);
                component.set("v.hasNoVals", false);
                component.set("v.fileName", fileName);
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Document",
                    message:
                    "There is an issue while sending Document. Please contact Salesforce Administrator",
                    duration: " 5000",
                    key: "info_alt",
                    type: "error",
                    mode: "dismissible"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    sendEditValstoCME: function(component, event, helper) {
        let docextId = component.get("v.documentExtId");
        let documentId = component.get("v.documentEditId");
        let documentName = documentId[0].name;
        let docId = documentId[0].documentId;
        let recordid = component.get("v.recordId");
        let taskselected = component.get("v.TaskextIdvaluesSelected");
        let taskvalue = String(taskselected);
        let documentTrackingId = component.get("v.trackingDocId");
        let action = component.get("c.sendEdit");
        action.setParams({
            OpportunityId: recordid,
            documentId: docId,
            docExtId: docextId,
            trackingId: taskvalue,
            docName: documentName,
            documentTrackingId: documentTrackingId
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {               
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Document",
                    message: "Document has been successfully uploaded.",
                    duration: " 5000",
                    key: "info_alt",
                    type: "success",
                    mode: "dismissible"
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                
                component.set("v.isEdit", false);
                component.set("v.hasNoVals", false);
                component.set("v.fileName", fileName);
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Document",
                    message:
                    "There is an issue while sending Document. Please contact Salesforce Administrator",
                    duration: " 5000",
                    key: "info_alt",
                    type: "error",
                    mode: "dismissible"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
});