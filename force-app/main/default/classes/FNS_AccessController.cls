/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Access Handler
    * @description Helps in evaluating CRUD Access
  */
   
   public with sharing class FNS_AccessController {
    //FLS check constants 
   public static final String DML_OPERATION_UPSERT = 'Upsert';
   public static final String DML_OPERATION_INSERT = 'Insert'; 
   public static final String DML_OPERATION_UPDATE = 'Update';
   public static final String DML_OPERATION_DELETE = 'Delete';
   public static final String DML_OPERATION_READ = 'Read';
    
   /**
    * @description Exception thrown when error occurs
    */
    public with sharing class AccessControlDmlException extends Exception {}
    
    /**
    *@description map of object name as key and field map as value
    */
    public static Map<String,  Map<String, Schema.SObjectField>> objectFieldInfoMap;
    
    /**
    *@description private static variable referencing the class
    */
    private static FNS_AccessController instance = null;
    
    /**
    *@description map of object name as key and object describe as value
    */
    private static Map<String, Schema.DescribeSObjectResult> describeObjectMap;

    /**
    *@description private static variable referencing the class
    */
    private static Map<String, Schema.SObjectType> objectNameMap;
    
    
    /**
    *@description The constructor is private and initializes the maps
    */
    static{
        objectFieldInfoMap = new Map<String,  Map<String, Schema.SObjectField>>();
        describeObjectMap = new  Map<String, Schema.DescribeSObjectResult>();
    }
    
    
    /**
        * @description Performs a CRUD/FLS check for the given objent name, CRUD operation and field name list
        * @param the object name to perform CRUD/FLS check on
        * @param the CRUD operation type
        * @param the list of field names to perform CRU check
        * @return a list of fields that are not accessible
        */      
    public static void checkCRUD_FLS(String objName, String operationType, Set<String> fieldNames)
    {
        Type objTypeName;
        if (String.isNotBlank(objName))
        {
             objTypeName = Type.forName(objName);
        }
        String fldName;
        if (objTypeName != null)
         {
            SObject sObj = (SObject)objTypeName.newInstance();             
            Schema.sObjectType objType = sObj.getSObjectType();
            Map<String, Schema.SObjectField> fieldInfoMap = null;
            Schema.DescribeSObjectResult objResult = null;
            if (objectFieldInfoMap.containsKey(objName))
            {
                fieldInfoMap = objectFieldInfoMap.get(objName);
                objResult = describeObjectMap.get(objName);
            } else 
            {    
                objResult =  objType.getDescribe();         
                fieldInfoMap = objResult.fields.getMap();
                objectFieldInfoMap.put(objName, fieldInfoMap); 
                describeObjectMap.put(objName, objResult);               
            }
            if((operationType == DML_OPERATION_READ && objResult.isAccessible())
                    || (operationType == DML_OPERATION_INSERT && objResult.isCreateable())
                    || (operationType == DML_OPERATION_UPDATE && objResult.isUpdateable())
                    || (operationType == DML_OPERATION_UPSERT && objResult.isCreateable() && objResult.isUpdateable()))
            { 
                 String orignalFieldName = ''; 
                 for(String fieldName :fieldNames)
                 {
                    if(String.isBlank(fieldName))
                    {
                        continue;
                    }
                    orignalFieldName = fieldName;
                   
                    Schema.SObjectField tmpfield = fieldInfoMap.get(fieldName);
                    if( tmpfield != null )
                   {
                        DescribeFieldResult fieldDefinition = tmpfield.getDescribe();
                        if(operationType == DML_OPERATION_READ && !(fieldDefinition.isAccessible()))
                        {    
                             throw new AccessControlDmlException(Label.FNS_FIELD_NOT_READABLE); 
                                                  
                        }else if(operationType != DML_OPERATION_READ && !fieldDefinition.isUpdateable() && !fieldName.equalsIgnoreCase('Id'))
                        { 
                             throw new AccessControlDmlException(Label.FNS_FIELD_NOT_UPDATEABLE); 
                        }
                   }
                   else
                   {
                        throw new AccessControlDmlException(Label.FNS_FIELD_INVALIDNAME); 
                   }   
                 }  
                
            }
            else if(operationType == DML_OPERATION_DELETE)
            {
               if (!objResult.isDeletable())
               {
                  throw new AccessControlDmlException(objName + ' ' + Label.FNS_OBJECT_NOT_DELETABLE);
               }
          }else
           {
               throw new AccessControlDmlException(String.format(Label.FNS_OBJECT_ERROR, new String[]{operationType, objName}));
           }
            
         }
        
    }
    
}