public class FNS_ApplicationDetailController {
    static FNS_ErrorLog logger = new FNS_ErrorLog();
	@Auraenabled
    public static ApplicationDetailWrapper getApplication(string applicationId){
        ApplicationDetailWrapper wrapper = new ApplicationDetailWrapper();
        try{
         String oppReadOnlyRecordType = FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE ;
         ID oppReadOnlyID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(oppReadOnlyRecordType).RecordTypeId ;
         List<Sobject> opp =  new FNS_ApplicationSelector().getApplicationId(applicationId);
         system.debug('opp>>>'+opp[0].get('RecordTypeId'));
         if(opp !=null){
            wrapper.isReadOnly = (opp[0].get('RecordTypeId') == oppReadOnlyID) ? true:false;
         } 
         
        }catch (DMLException ex){
            logger.addLogRecord('FNS_ApplicationDetailController', 'getApplication', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        } catch (Exception ex){
            logger.addLogRecord('FNS_ApplicationDetailController', 'getApplication', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        }
        
        return wrapper;
    }
    
    public class ApplicationDetailWrapper{
        @AuraEnabled Public boolean isReadOnly{get;set;} 
        @AuraEnabled Public string error{get;set;}
    }
}