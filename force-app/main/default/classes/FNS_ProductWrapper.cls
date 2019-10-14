/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Create Product
    * @description Wrapper class to get Fields, Objects API Names 
  */
public with sharing class FNS_ProductWrapper {
    
	@AuraEnabled public Map<String, FNS_FieldSetFormController.FieldSetForm> objFieldsMap{get;set;}
	@AuraEnabled public Map<String, String> objNames{get;set;}
	@AuraEnabled public Map<String, String> fieldNames{get;set;}
	@AuraEnabled public Map<String, String> productLoan{get;set;}
	@AuraEnabled public Map<String, String> product{get;set;}
	@AuraEnabled public Map<String, String> fee{get;set;}
	@AuraEnabled public Map<String, String> pricing{get;set;}
	@AuraEnabled public Map<String, String> productRole{get;set;}
	@AuraEnabled public boolean opportunityReadOnly{get;set;}
	@AuraEnabled public String error{get;set;}
    
    public class productWizard{
        @AuraEnabled public productwrap product{get;set;}
        @AuraEnabled public loanwrap loan{get;set;}
    }
    public class productWrap{
        @AuraEnabled public Map<String, FNS_FieldSetFormController.FieldSetForm> objFieldsMap{get;set;}
		@AuraEnabled public Map<String, String> objNames{get;set;}
    }
     public class loanWrap{
        @AuraEnabled public Map<String, FNS_FieldSetFormController.FieldSetForm> objFieldsMap{get;set;}
		@AuraEnabled public Map<String, String> objNames{get;set;}
    }
}