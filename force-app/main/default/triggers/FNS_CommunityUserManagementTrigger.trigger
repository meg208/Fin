trigger FNS_CommunityUserManagementTrigger on FNS_CommunityUserManagement__e (after insert) {
   
   Set<Id> userIdSet = new Set<Id>();
    for (FNS_CommunityUserManagement__e event : Trigger.New) {
       userIdSet.add(event.FNS_UserId__c);
    }
   
    FNS_CommunityUtil.copyAdminAccessTokenToUser(userIdSet);
}