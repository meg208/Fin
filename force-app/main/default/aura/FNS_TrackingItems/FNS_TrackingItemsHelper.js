({
    initializingFunc : function(component,event,helper) {
        var recordid = component.get("v.recordId");
        var action = component.get("c.getTasksByAppId");
        action.setParams({
            "appId":recordid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var response = response.getReturnValue();
                if(response.length === 0) {
                    component.set("v.isavailable",'none');
                } else {
                    component.set("v.isavailable",'available');
                    var stage = response[0].task.FNS_ApplicationStageName__c;
                    component.set("v.relatedTo",name);
                    if(stage === "Proposal" || stage === undefined) {
                        component.set("v.stagename",'proposal');
                    } else {
                        component.set("v.stagename",'rest');
                        component.set("v.taskWrapperList",response); 
                    }  
                }   
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    callTrackingItemsandTrackingDocs : function(component,event,helper) {
        var recordid = component.get("v.recordId");
        var action = component.get("c.callTrackingItemsandDocsDomain");
        action.setParams({
            "appId":recordid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let apiResponse = response.getReturnValue();
				if(apiResponse.Error !== 'Empty'){
					component.set("v.ItemsError", apiResponse.Error);
				} 	
                helper.initializingFunc(component,event,helper);
                component.set('v.showSpinner', false);
            }
        });
        $A.enqueueAction(action);
    },
    
     getDocumentCalloutContentFromCME:function(component,event,helper) {
        let ctarget = event.currentTarget;
        let id_str = ctarget.dataset.value.split(',');
        let documentId = id_str[1];
        let documentFileName = id_str[0];
        let actionDocumentContentFromCME = component.get("c.callDocumentContent");
        actionDocumentContentFromCME.setParams({
            "documentId":documentId,
            "documentFileName": documentFileName
        });
        actionDocumentContentFromCME.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {     
                var decodedString;
                var documentContent = response.getReturnValue();
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
            }
        });
        $A.enqueueAction(actionDocumentContentFromCME);      
        
    },
    
    openModel : function(component,event,helper) {
        component.set("v.isOpen", true);
        component.set('v.isActive', true);
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value.split(',');
        let taskid = id_str[0];
        let subject = id_str[1];
        component.set("v.tskIds", taskid);
        component.set("v.subjectIds", subject);
    },
    
    uploadDocument : function(component,event,helper) {
        let uploadedFiles = event.getParam("files");
        let documentId = uploadedFiles[0].documentId;
        let fileName = uploadedFiles[0].name;
        component.set("v.documentId" , documentId);
        component.set("v.fileName",fileName);
        component.set("v.uploaded",'true');
    },
    
    handleSelectmenu : function(component,event,helper) {
        let parcedValue = event.getParam("value").split(',');
        let value = parcedValue[0];
        let label = parcedValue[1];
        
        if (label == "Edit") {
            helper.editScreen(component,event,helper,value);
        } else {
            var createAcountContactEvent = $A.get("e.force:createRecord");
            createAcountContactEvent.setParams({
                "entityApiName": "Task",
                "defaultFieldValues": {
                    
                }
            });
            createAcountContactEvent.fire();
            
        }  
    },
    
    reAssignowner : function(component,event,helper) {
        var taskId = component.get("v.tskIds");
        var uservariables = component.get("v.selectedLookUpRecord");
        var userId = uservariables.Id;
        var actionuserAction = component.get("c.FNS_updateUser");
        actionuserAction.setParams({
            "taskId": component.get("v.tskIds"),
            "userId": userId
        });
        actionuserAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if(res[0].OwnerId === userId) {
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Re-Assigned Task',
                        message: 'Tracking Item has been re-assigned.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    component.set("v.isOpen", false);
                }
                helper.initializingFunc(component, event, helper);
            }
            else {
                var errortoast = $A.get("e.force:showToast");
                errortoast.setParams({
                    "message": "There is some problem, Please try later.",
                    "type": "error"
                });
                errorToast.fire();
            }
            
        });
        $A.enqueueAction(actionuserAction);
    },
    
    showSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    editScreen : function(component,event,helper,value) {
        var menuValue = value;
        component.set("v.modalContext", menuValue);
        component.set("v.Spinner",true);
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": 'FNS_Status__c'
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                var industryMap = [];
                for(var key in allValues){
                    industryMap.push({key: key, value: allValues[key]});
                }
                component.set("v.statusMap", industryMap);
            } // priorityMap
        });
        $A.enqueueAction(action);
        
        var actionPriority = component.get("c.getselectOptions");
        actionPriority.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": 'FNS_Priority__c'
        });
        
        
        actionPriority.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allPriorityValues = response.getReturnValue();
                var priorityMap = [];
                for(var key in allPriorityValues){
                    priorityMap.push({key: key, value: allPriorityValues[key]});
                }
                component.set("v.priorityMap", priorityMap);
            }
        });
        $A.enqueueAction(actionPriority);
    },
    
    // formats, validates and create task
    addTask : function(component,event) {
        var assignedto = component.get("v.selectedLookUpRecordTask").Id; 
        var relatedto = component.get("v.selectedLookUpRecordTask").Id;
        var subject = component.get("v.newTask.Subject");
        var priority = 'Normal';
        var status = 'Not started';
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "Task",
            "defaultFieldValues": {
                'OwnerId' : assignedto,
                'WhatId' : relatedto,
                'Priority':priority,
                'Status':status,
                'Subject':'Email'
            }
        });
        createAcountContactEvent.fire();
    },
    
    doSaveDocument : function(component,event,helper) {
        let uploadedFiles = event.getParam("files");
        let documentId = component.get("v.documentId");
        let recordid = component.get("v.recordId");
        let taskselected = component.get("v.TaskextIdvaluesSelected");
        let taskvalue = String(taskselected);
        var content = {
            OpportunityId : recordid,
            documentId: documentId,
            trackingid:taskvalue
        };
        
        var wrapperContent = JSON.stringify(content);
        let action = component.get("c.sendMetadata");
        
        action.setParams({
            "jsonWrapper" : wrapperContent
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                 helper.initializingFunc(component,event,helper);
                 var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Document',
                        message: 'Document has been successfully sent to CME.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                //let response = response.getReturnValue();
                component.set("v.isOpenDocument", false);
                component.set("v.hasNoVals",false);
                component.set("v.fileName",fileName);
            }
        });        
        $A.enqueueAction(action);
    },
    
    sendToCME : function(component,event,helper) {
        var ctarget = event.currentTarget;
        var taskvalues = ctarget.dataset.value;
        var dateselected = component.get("v.datevalueSelected");
        var commentsselected = component.get("v.commentvaluesSelected");
        var statusselected = component.get("v.statusvaluesSelected");
        var priorityselected = component.get("v.priorityvaluesSelected");
        var taskselected = taskvalues;
        var commentToServicecall = String(commentsselected);
        var statusToServicecall = String(statusselected);
        var priorityToServicecall = String(priorityselected);
        var dateToServicecall = String(dateselected);
        var taskselectedcall = JSON.stringify(taskselected);
        var action = component.get("c.getCalloutResponseContents");
        action.setParams({
            dataCom: commentToServicecall,
            dataStatus: statusToServicecall,
            dataPriority: priorityToServicecall,
            dataDate : dateToServicecall,
            dataTask: taskselected,
            
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState(); 
            if (state === "SUCCESS") {    
                
                component.set("v.modalContext",'New');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Tracking Item',
                    message: 'Tracking Items have been successfully sent to CME.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                
            }
            component.set("v.modalContext", "New");
        });
        $A.enqueueAction(action);
    }
    
    
})