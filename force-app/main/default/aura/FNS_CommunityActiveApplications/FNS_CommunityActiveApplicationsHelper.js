({
    setApplicationData: function(component, helper, currentRecordIndex, activeApplicationsList, oppLists) {        
        var relatedRoles = activeApplicationsList['relatedRoles'];
        var relatedItems = activeApplicationsList['Tasklist'];
        var relatedDocs = activeApplicationsList['doclist'];
        var relatedApplicationRoles = relatedRoles[oppLists[currentRecordIndex]['FNS_ApplicationExtId__c']];
        var relatedTrackingItems = relatedItems[oppLists[currentRecordIndex]['FNS_ApplicationExtId__c']];
        var relatedTrackingDocs = relatedDocs[oppLists[currentRecordIndex]['FNS_ApplicationExtId__c']];
        for(var i=0; i<oppLists.length;i++){
            if(i === parseInt(currentRecordIndex))
                oppLists[i].isSelected = true;    
            else
                oppLists[i].isSelected = false;    
        }
        
        component.set('v.activeApplicationsList', activeApplicationsList);
        helper.fireCompEvent(component, helper, 'LOAD_APPLICATION_DATA', {selectedApplication: oppLists[currentRecordIndex],
                                                                          relatedApplicationRoles: relatedApplicationRoles,
                                                                          relatedTrackingItems:relatedTrackingItems,
                                                                          relatedDocs:relatedTrackingDocs});
    },
    
    fireCompEvent: function(component, helper, action, payload) {        
        var compEvent = component.getEvent('communityCompEvent');
        compEvent.setParams({
            action: action,
            payload: payload || null
        });
        compEvent.fire();
    }
})