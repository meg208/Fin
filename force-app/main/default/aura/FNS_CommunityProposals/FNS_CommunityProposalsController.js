({
    doInit : function(component, event, helper) {
        var proposal = component.get("v.proposalUrl"); 
        if(proposal != null){
            component.set('v.isProposalURL', true); 
        }
    }
})