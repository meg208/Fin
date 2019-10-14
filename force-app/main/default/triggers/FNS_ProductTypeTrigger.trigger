/*****************************************************************************************
* @description This trigger to perform DML operations for FNS_ProductType__c object
* @author Keerthi Kambhampati
* @date Apr 22 2019
* @Support Email Keerthi@comitydesigns.com
******************************************************************************************/
trigger FNS_ProductTypeTrigger on FNS_ProductType__c (
    after delete, after insert, after update, after undelete, before delete, before insert, before update) {
    fflib_SObjectDomain.triggerHandler(FNS_ProductTypeTriggerHandler.class);
}