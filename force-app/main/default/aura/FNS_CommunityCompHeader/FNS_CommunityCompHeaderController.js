({

    openPicker: function(component,event,handler){
        var communityDomainURL = window.location.href;
        var pos = communityDomainURL.indexOf(".com") + 4;
        var cnt = communityDomainURL.lastIndexOf("/");
        var communityDomain = communityDomainURL.substring(0,communityDomainURL.substring(0,cnt).lastIndexOf("/"));
        //console.log('>>>',k);
        component.set('v.isOpen', true);
        //component.set('v.communityDomain', communityDomainURL.substring(0, pos));
        component.set('v.communityDomain', communityDomain);
    },
     
    fireComponentEvent : function(component , event) {
        console.log('fireComponentEvent');
        //component.set('v.isHomeTab', true);
        //var cmpEvent = component.getEvent("cmpCommunityCompHeaderEvent");
        var cmpEvent = $A.get("e.c:FNS_CommunityCompHeaderEvent");
        // Get the value from Component and set in Event
        //cmpEvent.setParams( { "showHomeTabContent" : component.get("v.isHomeTab") } );
        cmpEvent.setParams( { "tabName" : "Home" } );
        cmpEvent.fire();
    },
    
    setTabContent : function(component , event) {
        console.log('setTabContent');
        //component.set('v.isHomeTab', false);
        var cmpEvent = $A.get("e.c:FNS_CommunityCompHeaderEvent");
        // Get the value from Component and set in Event
        //cmpEvent.setParams( { "showHomeTabContent" : component.get("v.isHomeTab") } );
        cmpEvent.setParams( { "tabName" : "ContactUs" } );
        cmpEvent.fire();
    }
})