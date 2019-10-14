/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Test Class
* @description This test class is used for FNS_UserSelector
****************************************************************************/
@isTest
private class FNS_UserSelectorTest { 
    public static User userRecord;
    
    static void setup() {
        FNS_TestDataSetup test = new FNS_TestDataSetup();
        userRecord = test.createUser('abc@brillio.com');
        insert userRecord;
    }
   static testMethod void selectByIdTest() {
        Test.startTest();
        setup();
        Test.stopTest();
        List<User> usersById = new FNS_UserSelector().selectById(new SET<Id>{userRecord.Id});
        System.assertNotEquals(usersById, null);
    }
    static testMethod void selectUserListTest() {
        Test.startTest();
        setup();
        Test.stopTest();
        List<User> selectedUsers = new FNS_UserSelector().selectUserList(new List<String>{userRecord.Email});
        System.assertNotEquals(selectedUsers, null);
    }
     static testMethod void selectUserByExtIdTest() {
        Test.startTest();
        setup();
        Test.stopTest();
        Set<String> extIds = new Set<String>{'extId'};
        List<User> selectedUsers = new FNS_UserSelector().getUsersByExtId(extIds);
        System.assertNotEquals(selectedUsers, null);
    }

    static testMethod void selectUserByTextTest() {
        Test.startTest();
        setup();
        Test.stopTest();
        List<User> selectedUsers = new FNS_UserSelector().getUsersBySearchtext('User');
        System.assertNotEquals(selectedUsers, null);
    }


}