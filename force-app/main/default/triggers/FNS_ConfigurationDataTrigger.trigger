/*****************************************************************************************
* @description This trigger to perform DML operations for Configuration Type object
* @author Keerthi Kambhampati
* @date Apr 16 2019
* @Support Email Keerthi@comitydesigns.com
******************************************************************************************/
trigger FNS_ConfigurationDataTrigger on FNS_ConfigurationType__c (
    after delete, after insert, after update, after undelete, before delete, before insert, before update) {
    fflib_SObjectDomain.triggerHandler(FNS_ConfigurationTriggerHandler.class);
}