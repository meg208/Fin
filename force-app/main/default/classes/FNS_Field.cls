/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Create Product
    * @description get the field data Field Set
  */
public with sharing class FNS_Field {
    
    public FNS_Field(Schema.FieldSetMember f) {
        this.DBRequired = f.DBRequired;
        this.APIName = f.fieldPath;
        this.Label = f.label;
        this.Value = null;
        this.Required = f.required;
        this.Type = String.valueOf(f.getType());
    }
    
    public FNS_Field(Boolean DBRequired) {
        this.DBRequired = DBRequired;
    }
    
    @AuraEnabled
    public Boolean DBRequired { get;set; }
    
    @AuraEnabled
    public String APIName { get;set; }
    
    @AuraEnabled
    public String Label { get;set; }
    
    @AuraEnabled
    public Boolean Required { get;set; }
    
    @AuraEnabled
    public String Type { get; set; }

    @AuraEnabled
    public Object Value { get; set; }
    
}