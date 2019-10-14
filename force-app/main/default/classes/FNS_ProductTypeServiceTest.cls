/*****************************************************************************************
* @description This class is used to test FNS_ProductTypeService class
* @author Kavya Papasani
* @date Apr 28 2019
* @Support Email kavya@comitydesigns.com
******************************************************************************************/
@isTest
public class FNS_ProductTypeServiceTest {
    
    public static FNS_ProductType__c productTypeRec;
    
    /* Test Method to test insertRecords method */
    @isTest static void testInsertRecords(){
        productTypeRec = new FNS_ProductType__c(Name= 'Term Loan', FNS_ProductTypeExternalId__c= 'ExtId'); 
        List<FNS_ProductType__c> records = new List<FNS_ProductType__c>();
        records.add(productTypeRec); 
        FNS_ProductTypeService service = new FNS_ProductTypeService(); 
        
        test.startTest(); 
        service.insertRecords(records);
        test.stopTest(); 
        
        List<FNS_ProductType__c> insertedRecords = [Select Id from FNS_ProductType__c]; 
        System.assertNotEquals(0, records.size());
    }
    
}