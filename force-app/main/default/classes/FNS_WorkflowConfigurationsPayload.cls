/*********************************************************************************************
* @description This class is map JSON values to the Object
* @author Keerthi Kambhampati
* @date March 5th 2019
* @Support Email Keerthi@comitydesigns.com
*********************************************************************************************/
public with sharing class FNS_WorkflowConfigurationsPayload {
    public List<FNS_WorkflowConfig> workflowConfigurationsList;
    public class FNS_WorkflowConfig{
        public FNS_ObjectContainer.FNS_Activity activity {get;set;} 
    	public FNS_ObjectContainer.FNS_Activity nextDefaultactivity {get;set;}
    	public List<FNS_ObjectContainer.FNS_Activity> nextAvailableActivities {get;set;}
    	public Integer sequenceNumber {get;set;}
    }
	
}