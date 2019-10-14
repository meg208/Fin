public class FNS_ProductWizardWrapper {
	@AuraEnabled public String error{get;set;}
    public class productWizard{
        @AuraEnabled public productwrap product{get;set;}
        @AuraEnabled public loanWrap loan{get;set;}
        @AuraEnabled public pricingWrap pricing{get;set;}
        @AuraEnabled public boolean opportunityReadOnly{get;set;}
    }
    public class productWrap{
        @AuraEnabled public List<FNS_Field> fields{get;set;}
        @AuraEnabled public List<FNS_Field> moreFields{get;set;}
        @AuraEnabled public String ObjectName{get;set;}
        @AuraEnabled public List<FNS_Field> requiredFields{get;set;}
        @AuraEnabled public String ObjectLabel{get;set;}
    }
    public class loanWrap{
        @AuraEnabled public List<FNS_Field> fields{get;set;}
        @AuraEnabled public List<FNS_Field> moreFields{get;set;}
        @AuraEnabled public String ObjectName{get;set;}
        @AuraEnabled public String ObjectLabel{get;set;}
        @AuraEnabled public List<FNS_Field> requiredFields{get;set;}
    }
    public class pricingWrap{
        @AuraEnabled public List<FNS_Field> fields{get;set;}
        @AuraEnabled public List<FNS_Field> moreFields{get;set;}
        @AuraEnabled public String ObjectName{get;set;}
        @AuraEnabled public String ObjectLabel{get;set;}
        @AuraEnabled public List<FNS_Field> requiredFields{get;set;}
    }

}