trigger FNS_FinancialProductTrigger on FNS_FinancialAccount__c (Before insert, Before update, After insert, After update, After delete) {
    fflib_SObjectDomain.triggerHandler(FNS_FinancialProductTriggerHandler.class);
}