({
	doInit : function(component, event, helper) {
		helper.initHelper(component, event, helper); 
    }, 
    
    onPicklistSelect : function(component, event, helper){
        helper.onPicklistSelectHelper(component, event, helper); 
    }, 

    onSubPicklistSelect : function(component, event, helper){
        component.set("v.subCode",component.find("naicsSubCode").get("v.value") )
    }, 
    
    onSicPicklistSelect : function(component, event, helper){
        helper.onSicPicklistSelectHelper(component, event, helper); 
    }, 

    onSicSubPicklistSelect: function(component, event, helper){
        component.set("v.subSicCode",component.find("sicSubCode").get("v.value") )
    }, 

    handleSave : function(component, event, helper){
        helper.handleSaveHelper(component, event, helper); 
    }, 

    handleCancel :  function(component, event, helper){
        component.set("v.editClicked", false);
    },

    handleEdit : function(component, event, helper){
        helper.fetchPicklistValues(component, 'FNS_NAICSCode__c', ''); 
        helper.fetchPicklistValues(component, 'FNS_NAICSCodeSet1__c', ''); 
        helper.fetchPicklistValues(component, 'FNS_NAICSCodeSet2__c', ''); 
        helper.fetchPicklistValues(component, 'FNS_NAICSCodeSet3__c', ''); 
        helper.fetchPicklistValues(component, 'FNS_SICCode__c', ''); 
        helper.fetchPicklistValues(component, 'FNS_SICCodeSet1__c', ''); 
        helper.fetchPicklistValues(component, 'FNS_SICCodeSet2__c', ''); 
        component.set("v.editClicked", true); 
    }, 
    itemsChange : function(component, event, helper){
    }


})