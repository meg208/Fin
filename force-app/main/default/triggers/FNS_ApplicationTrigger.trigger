trigger FNS_ApplicationTrigger on Opportunity (
  after delete, after insert, after update, after undelete, before delete, before insert, before update) {
   // Creates Domain class instance and calls appropriate methods
   fflib_SObjectDomain.triggerHandler(FNS_ApplicationTriggerHandler.class);
}