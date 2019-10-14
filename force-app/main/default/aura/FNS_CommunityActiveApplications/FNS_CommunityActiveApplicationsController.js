({
    updateRecord : function (component, event, helper) {
        var currentRecordIndex = event.currentTarget.id;
        var activeApplicationsList = component.get('v.activeApplicationsList');
        var oppLists = activeApplicationsList['oppList'];
       // console.log('oppLists' + JSON.stringify(oppLists));
        if($A.util.isEmpty(oppLists)) return;
        
        helper.setApplicationData(component, helper, currentRecordIndex, activeApplicationsList, oppLists);
    }   
    
})