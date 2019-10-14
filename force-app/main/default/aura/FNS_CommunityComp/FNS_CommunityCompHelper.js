({
    handleCompEvent : function(component, event, helper){
        let action = event.getParam( 'action' );
        let payload = event.getParam('payload');
        switch (action) {
            case 'LOAD_APPLICATION_DATA':
                component.set('v.selectedApplication', payload['selectedApplication']);
                component.set('v.relatedApplicationRoles', payload['relatedApplicationRoles']);
                component.set('v.relatedTrackingItems', payload['relatedTrackingItems']);
                component.set('v.relatedDocs', payload['relatedDocs']);
                console.log('Application ID',component.get('v.selectedApplication').Id);
                event.stopPropagation();
                break;
            default:
                break;
        }
    },
    
    setUpApplicationData : function(component, helper, activeApplicationsList, oppList){
        let relatedApplicationRolesList = activeApplicationsList['relatedRoles'];
        let relatedApplicationRoles = relatedApplicationRolesList[oppList[0]['FNS_ApplicationExtId__c']];
        let relatedTrackingItemsList   = activeApplicationsList['Tasklist']; 
        let relatedTrackingItems = relatedTrackingItemsList[oppList[0]['FNS_ApplicationExtId__c']];
        console.log('relatedTrackingItems' + relatedTrackingItems);
        let relatedDocsList = activeApplicationsList['doclist'];
		let relatedDocs = relatedDocsList[oppList[0]['FNS_ApplicationExtId__c']];
        console.log('relatedDocs' + relatedDocs);
        oppList[0]['isSelected'] = true; 
        
        component.set('v.activeApplicationsList', activeApplicationsList);
        component.set('v.selectedApplication', oppList[0]);
        component.set('v.relatedApplicationRoles', relatedApplicationRoles);
        component.set('v.relatedTrackingItems', relatedTrackingItems);
        component.set('v.relatedDocs', relatedDocs);
        component.set('v.showSpinner', false);
        component.set('v.quipUrl', oppList[0].FNS_ApplicationQuip__c);
    }
})