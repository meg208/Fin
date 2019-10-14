/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Create Product
    * @description get the Fields from Field Set. 
  */
public with sharing class FNS_FieldSetFormController {
    
    @AuraEnabled
    public static FieldSetForm getForm(String fieldSetName, String objectName, String recordTypeId, String recordId) {
        FieldSetForm form = new FieldSetForm();        
        form.Fields = getFields(objectName, fieldSetName);
        
        return form;
    }
    /**
        * @description get the Fields from respective Object and Field Set. 
        * @param Map of Object Name and Field Set Name
        * @return a list of fields that are not accessible
        */   
    public static Map<String, FNS_FieldSetFormController.FieldSetForm> getObjFields(Map<String,String> objFields) {
        System.debug(LoggingLevel.ERROR,'objFields>>'+objFields);
        Map<String, FieldSetForm> objFieldsMap = new Map<String, FieldSetForm>();
        for (String objName : objFields.keySet()) {
            FieldSetForm form = new FieldSetForm();   
            form.Fields = getFields(objName, objFields.get(objName));
            objFieldsMap.put(objName, form);
        }
        return objFieldsMap;
    }    
    public static List<FNS_Field> getFields(String objectName, String fieldSetName) {
        Schema.SObjectType objectType = null;
        
        if (String.isNotBlank(objectName)) {
            objectType = Schema.getGlobalDescribe().get(objectName);
        }
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.fieldSets.getMap();
        Schema.FieldSet fieldSet = fieldSetMap.get(fieldSetName);
        List<Schema.FieldSetMember> fieldSetMembers = fieldSet.getFields();
        
        List<FNS_Field> fields = new List<FNS_Field>();
        for (Schema.FieldSetMember fsm : fieldSetMembers) {
            FNS_Field f = new FNS_Field(fsm);
            fields.add(f);
        }
        return fields;
    }
    
    public class FieldSetForm {
        @AuraEnabled
        public List<FNS_Field> Fields { get; set; }
        public FieldSetForm() {
            Fields = new List<FNS_Field>();
        }
    }
}