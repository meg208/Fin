/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Fee Type
    * @description Fee Type Trigger
  */
trigger FNS_FeeTypeTrigger on FNS_FeeType__c (
    after delete, after insert, after update, after undelete, before delete, before insert, before update) {
    fflib_SObjectDomain.triggerHandler(FNS_FeeTypeTriggerHandler.class);
}