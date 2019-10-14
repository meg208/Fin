/*****************************************************************************************
* @description This trigger to perform DML operations for Configuration Type object
* @author Praneeth Aitharaju
* @date Apr 18 2019
* @Support Email Praneeth@comitydesigns.com
******************************************************************************************/
trigger FNS_TaskTrigger on Task 
   (after delete, after insert, after update, after undelete, before delete, before insert, before update) {
   fflib_SObjectDomain.triggerHandler(FNS_TaskTriggerHandler.class);
}