public class FNS_DataTableController {
    /*
    Method Name : getAccRecords
    Purpose     : To get the wrapper of Columns and Headers
    */
    @AuraEnabled
    public static FNS_DataTableResponse getRecords(String recordIds, String objectName, String fieldSetName){     
        system.debug('recordId = '+recordIds);
       	Type idArrType = Type.forName('List<string>');
      	List<string> recordIdList = (List<string>) JSON.deserialize(recordIds, idArrType);
        system.debug('recordId = '+recordIdList); 
        system.debug('objectName = '+objectName);
        system.debug('fieldSetName = '+fieldSetName);
        //Get the fields from FieldSet
        Schema.SObjectType SObjectTypeObj = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();            
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        system.debug('SObjectTypeObj = '+SObjectTypeObj);
        system.debug('fieldSetObj = '+fieldSetObj);
        system.debug('DescribeSObjectResultObj = '+DescribeSObjectResultObj);
        //To hold the table hearders 
        List<FNS_DataTableColumns> dataTableColumns = new List<FNS_DataTableColumns>();
        
        //Field to be queried - fetched from fieldset
        List<String> fieldsToQuery = new List<String>();
        
        //The final wrapper response to return to component
        FNS_DataTableResponse response = new FNS_DataTableResponse();
        
        for( Schema.FieldSetMember eachFieldSetMember : fieldSetObj.getFields() ){
            String dataType = String.valueOf(eachFieldSetMember.getType()).toLowerCase();
            //This way we can set the type of a column
            //We do not get the exact type from schema object which matches to lightning:datatable component structure
            if(dataType == 'datetime'){
                dataType = 'date';
            }
            //Create a wrapper instance and store label, fieldname and type.
            FNS_DataTableColumns datacolumns = new FNS_DataTableColumns( String.valueOf(eachFieldSetMember.getLabel()) , 
                                                                String.valueOf(eachFieldSetMember.getFieldPath()), 
                                                                String.valueOf(eachFieldSetMember.getType()).toLowerCase());
            if(datacolumns.type == 'picklist'){
                fieldsToQuery.add('toLabel('+String.valueOf(datacolumns.fieldName)+') ');
            }else
            {
                fieldsToQuery.add(String.valueOf(eachFieldSetMember.getFieldPath()));
            }
            dataTableColumns.add(datacolumns);
            system.debug('datacolumns = '+datacolumns);
            
        }
        
        //Form an SOQL to fetch the data - Set the wrapper instance and return as response
        if(! dataTableColumns.isEmpty()){            
            response.dataTableColumns = dataTableColumns;
           /* String query = 'SELECT ' + String.join(fieldsToQuery, ',') + ' FROM '+objectName+' WHERE Id =\''+recordId+'\'';*/
            String query = 'SELECT ' + String.join(fieldsToQuery, ',') + ' FROM '+objectName+' WHERE Id IN: recordIdList';
            System.debug('dataTable Query >> '+query);
            response.dataTableData = Database.query(query);
        }
        
        return response;
    }
    
    //Wrapper class to hold Columns with headers
    public class FNS_DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        
        //Create and set three variables label, fieldname and type as required by the lightning:datatable
        public FNS_DataTableColumns(String label, String fieldName, String type){
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;            
        }
    }
    
    //Wrapper calss to hold response - This response is used in the lightning:datatable component
    public class FNS_DataTableResponse {
        @AuraEnabled
        public List<FNS_DataTableColumns> dataTableColumns {get;set;}
        @AuraEnabled
        public List<sObject> dataTableData {get;set;}                
        
        public FNS_DataTableResponse(){
            dataTableColumns = new List<FNS_DataTableColumns>();
            dataTableData = new List<sObject>();
        }
    }
}