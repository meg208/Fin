({
	   
    uploadDocument : function(component,event,helper) {
        let uploadedFiles = event.getParam("files");
        let documentId = uploadedFiles[0].documentId;
        let fileName = uploadedFiles[0].name;
        component.set("v.documentId" , documentId);
        component.set("v.fileName",fileName);
        component.set("v.uploaded",'true');
    },
    
     doSave : function(component,event,helper) {
        let documentId = component.get("v.documentId");
        let appExtId =  component.get("v.applicationId");
       // let recordid = component.get("v.applicationId");
        let taskselected = component.get("v.taskIds");
        let taskvalue = String(taskselected);
          var content = {
            OpportunityExtId : appExtId,
            documentId: documentId,
            trackingid:taskvalue
        };
         var wrapperContent = JSON.stringify(content);
        let action = component.get("c.sendMetaDataCommunity");
         
        action.setParams({
           "jsonWrapper" : wrapperContent
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                 component.set("v.isOpen", false);
                 $A.get('e.force:refreshView').fire();
              let response = response.getReturnValue();
            }
        });        
        $A.enqueueAction(action);
    }    
})