global class FNS_FetchRefreshTokenScheduler implements Schedulable {
       global void execute(SchedulableContext sc){
            String batchprocessid = Database.executeBatch(new FNS_FetchRefreshTokenBatch(), 1);
       }
}