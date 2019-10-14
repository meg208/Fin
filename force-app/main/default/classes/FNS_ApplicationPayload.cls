/*****************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Wrapper Class
 * @description This class is used to perform DML using json for an Application.
 ******************************************************************************************/
public with sharing class FNS_ApplicationPayload {

	public FNS_ObjectContainer.FNS_Bank bank {get;set;} 
	public String bankId {get;set;} 
	public List<FNS_ObjectContainer.FNS_Officer> customers {get;set;} 
	public String dispositionId {get;set;} 
	public String description ;
	public List<FNS_FinancialProductPayload> linesOfCredit {get;set;} 
	public List<String> officerIds {get;set;} 
	public List<FNS_ObjectContainer.FNS_Officer> officers {get;set;} 
	public String startDate {get;set;} 
	public String applicationId {get;set;}     
	public FNS_ObjectContainer.FNS_CustomerIds customerIds{get;set;}

}