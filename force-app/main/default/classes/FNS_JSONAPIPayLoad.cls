/**
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group API Service
 * @description Act as a wrapper class for API service class.
 */  
public with sharing class FNS_JSONAPIPayLoad {
	public String body {get; set;}
	public String status {get; set;}
	public String action {get;set;}
	public String links {get;set;}
}