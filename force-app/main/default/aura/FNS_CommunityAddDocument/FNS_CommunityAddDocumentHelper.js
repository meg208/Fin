({
    getApplicationDocs : function(component,event,helper) {
        //let recordid = component.get("v.recordId");
        let recordid = component.get("v.applicationId");
        let action = component.get("c.getCommunityApplicationDocIds");
        let docList = component.get("v.docsList");
        action.setParams({
            "appId":recordid
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                if(response.length >0 ) {
                    var totalLength = response.length;
                    component.set("v.Vals",true);
                    component.set("v.documentsList" , response);
                    component.set("v.totalDocumentsCount",totalLength);  
                } else
                    component.set("v.Vals",false);
            }
        });        
        $A.enqueueAction(action);
    },
    
    handleSelectmenu : function(component,event,helper) {
        let val = event.getParam("value");
        component.set("v.documentSelectedExtId",val);
        component.set("v.isEdit",true);

    },
    
    getDocumentCalloutContentFromCME:function(component,event,helper) {
        let ctarget = event.currentTarget;
        var index = ctarget.dataset.record; 
        var selectedDocument = component.get("v.docsList")[index]
        let documentId = selectedDocument.FNS_DocumentExtId__c;
        let documentFileName = selectedDocument.FNS_FileName__c;
        let actionDocumentContentFromCME = component.get("c.callDocumentContent");
        actionDocumentContentFromCME.setParams({
            "documentId":documentId,
            "documentFileName": documentFileName
        });
        component.set("v.spinner",true);
        actionDocumentContentFromCME.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {     
                var documentContent = response.getReturnValue();
                component.set("v.spinner",false);
                if (documentContent != null) {
 	                var element = document.createElement('a');
	                // Make element downloadable
					var fileExt = documentFileName.slice((Math.max(0, documentFileName.lastIndexOf(".")) || Infinity) + 1);

                    if (fileExt == "") {
                        fileExt = "txt";
                    }
                    element.setAttribute(
                        "href",
                        "data:application/" + fileExt + ";base64," + documentContent
                    );    
	                element.setAttribute('download', documentFileName);
	                element.style.display = 'none';
	                document.body.appendChild(element);
	                
	                element.click();
	                document.body.removeChild(element);
                }else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Document',
                        message: $A.get("$Label.c.FNS_DOCUMENT_DOWNLOAD_ERROR"),
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }    
            } else {
                let error = response.getError();
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
        });
        $A.enqueueAction(actionDocumentContentFromCME);         
    },
    
     closeModel: function(component, event, helper) {
        component.set("v.isEdit",false);
    }, 
    
    uploadDocument : function(component,event,helper) {
        let uploadedFiles = event.getParam("files");
        let documentId = uploadedFiles[0].documentId;
        let fileName = uploadedFiles[0].name;
        component.set("v.documentId" , documentId);
        component.set("v.fileName",fileName);
        component.set("v.uploaded",'true');
    },
    
    sendEditValstoCME : function(component,event,helper) {
        let docSelected = component.get("v.documentSelectedExtId");
       	let documentId = component.get("v.documentId");
        let recordid = component.get("v.applicationId");

        
        let filename = component.get("v.fileName");
        let action = component.get("c.sendEditValues");
        action.setParams({
            "OpportunityExtId":recordid,
            "documentId": documentId,
            "docExtId":docSelected,
            "trackingId":null,
            "docName":filename
        });
        component.set("v.spinner",true);
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                helper.closeModel(component,event,helper);
                component.set("v.spinner",false);
                $A.get('e.force:refreshView').fire();
			}
        });        
        $A.enqueueAction(action);
    }
})