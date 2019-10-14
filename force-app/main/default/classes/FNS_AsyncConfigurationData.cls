public class FNS_AsyncConfigurationData implements Queueable {
    List<FNS_ObjectContainer.FNS_PICKLISTTYPE> configurationDataTotal;
   
    public FNS_AsyncConfigurationData(List<FNS_ObjectContainer.FNS_PICKLISTTYPE> configurationData){
        this.configurationDataTotal = configurationData;
 
    }
    public void execute(QueueableContext context) {
         FNS_ConfigurationDomain.upsertConfigurationData(configurationDataTotal);
    }
    
}