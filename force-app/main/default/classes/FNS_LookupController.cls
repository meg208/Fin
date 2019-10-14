/*****************************************************************************************
* @description Class is used to handle all request from FNS_activitylookup.cmp.
* @author Praneeth Aitharaju
* @date 25/03/2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/

public with sharing class FNS_LookupController {
//TODO Praneeth to change it to Query selector
@AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from ' +String.escapeSingleQuotes(ObjectName) + ' where Name LIKE: searchKey order by createdDate DESC';
        List < sObject > lstOfRecords = Database.query(sQuery);
        if(lstOfRecords != null){
            for (sObject obj: lstOfRecords) {
                returnList.add(obj);
            }
        }
        return returnList;
    }
}