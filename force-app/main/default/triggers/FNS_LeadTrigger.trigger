trigger FNS_LeadTrigger on Lead (after update) {
       fflib_SObjectDomain.triggerHandler(FNS_LeadTriggerHandler.class);

}