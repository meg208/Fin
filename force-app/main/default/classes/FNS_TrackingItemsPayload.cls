/*****************************************************************************************
* @description This class is used to hold the Payload Information for Tracking Items.
* @author Praneeth
* @date Mar 22 2019
* @Support Email praneeth.aitharaju@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_TrackingItemsPayload {
    
	public class TrackStatus {
		public PrintStatus docType {get;set;} 
		public String dstatusDesc {get;set;} 
		public Integer dstatusId {get;set;} 

	}
	
	public class PrintStatus {
		public Integer configurationDataId {get;set;} 
		public String description {get;set;} 
		public String type {get;set;} // in json: type
		public String value {get;set;} 
	}
	
    public Integer Id {get;set;}
	public String applicationId {get;set;} 
	public List<String> collateralIds {get;set;} 
	public String comments {get;set;} 
	public String creationDate {get;set;} 
	public List<String> customerIds {get;set;} 
	public String description {get;set;} 
	public String dueDate {get;set;} 
	public Boolean isActive {get;set;} 
	public Boolean isCSA {get;set;} 
	public Boolean isChecklist {get;set;} 
	public Boolean isStandard {get;set;} 
	public Boolean isVerified {get;set;} 
	public Boolean keepOnRefresh {get;set;} 
	public List<String> loanIds {get;set;} 
	public String notes {get;set;} 
	public Integer pkgId {get;set;} 
	public String primaryRelationship {get;set;} 
	public String printStatusId {get;set;} 
	public String priorityId {get;set;} 
	public Boolean refresh {get;set;} 
	public Integer sequence {get;set;} 
	public String slaIndicator {get;set;} 
	public String slaPercentage {get;set;} 
	public String trackStatusId {get;set;} 
	public Integer trackingItemId {get;set;} 
    public String trackingItemType{get;set;}
	public List<String> userIds {get;set;} 
}