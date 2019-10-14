({
	doInit : function(component, event, helper) {
        let today = new Date();
        let date = today.getDate() + '/'+(today.getMonth()+1)+'/'+today.getFullYear();
        let hours = today.getHours();
        let ampm = hours >= 12 ? 'pm' : 'am';
        let time = today.getHours() + ":" + today.getMinutes() +  ampm;
        let dateTime = date+' '+time;
        component.set('v.currentTime', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
    },
    closePopup : function(component, event, helper) {
        let sectionFooter = component.find("sectionFooter");
        $A.util.removeClass(sectionFooter, "slds-backdrop_open");
        $A.util.toggleClass(sectionFooter, "slds-backdrop_close");
        
        let sectionHeader = component.find("sectionHeader");
        $A.util.removeClass(sectionHeader, "slds-fade-in-open");
        $A.util.toggleClass(sectionHeader, "slds-fade-in-close");
    },
    
    openPopup : function(component, event, helper) {
        let sectionFooter = component.find("sectionFooter");
        $A.util.removeClass(sectionFooter, "slds-backdrop_close");
        $A.util.toggleClass(sectionFooter, "slds-backdrop_open");
        
        let sectionHeader = component.find("sectionHeader");
        $A.util.removeClass(sectionHeader, "slds-fade-in-close");
        $A.util.toggleClass(sectionHeader, "slds-fade-in-open");
    },
})