/**
    * Copyright (c) 2019, Brillio
    * All rights reserved.
    * @author Brillio
    * @date 2019
    * @group Create Product
    * @description Helps in evaluating CRUD Access
  */
  
public with sharing class FNS_CreateProductController {
     static FNS_ErrorLog logger = new FNS_ErrorLog();
    /**
    * @description Get the Field Names, Object Names for Objects. 
    * @param opportunityId to get Record Type of Opportunity
    * @return a Wrapper class
    */ 
    @AuraEnabled
    public static FNS_ProductWrapper getComponentData(String opportunityId){
		System.debug(LoggingLevel.ERROR,'opportunityId>>'+opportunityId);
      	FNS_ProductWrapper wrapper = new  FNS_ProductWrapper(); 
        try{
            Map<String, FNS_FieldSetFormController.FieldSetForm> objFieldNameMap = FNS_ProductDomain.getObjFieldName();
            Map<String,String> fieldName = new Map<String,String>();
            Map<String,String> oppRecordTypeMap =new FNS_ApplicationSelector().getApplicationRecordType(new set<String>{opportunityId});
            String recordTypeName = oppRecordTypeMap.get(opportunityId);
            
            wrapper.objFieldsMap = objFieldNameMap;
            wrapper.objNames=FNS_ProductDomain.getObjectNames();
            wrapper.fieldNames = FNS_ProductDomain.getFieldAPINames();
            wrapper.productLoan =FNS_ProductDomain.getproductLoanFieldMap();
            wrapper.product =FNS_ProductDomain.getproductFieldMap();
            wrapper.fee =FNS_ProductDomain.getFeeFieldMap();
            wrapper.pricing =FNS_ProductDomain.getPricingFieldMap();
            wrapper.productRole =FNS_ProductDomain.getProductRoleFieldMap();
            wrapper.opportunityReadOnly = (recordTypeName==FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE)?false:true;
            System.debug(LoggingLevel.ERROR,'FNS_ProductWrapper wrapper>>'+wrapper);
        }catch (DMLException ex){
            logger.addLogRecord('FNS_CreateProductController', 'getComponentData', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        } catch (Exception ex){
            logger.addLogRecord('FNS_CreateProductController', 'getComponentData', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage(); 
        }
        return wrapper;
    }
	/**
        * @description Get application related Product data. 
        * @param applicationId to get related product, Loans
        * @return a Wrapper class
        */ 
    @AuraEnabled
    public static FNS_ShowProductCompController.FNS_ProductResponseWrapper getProductData(String applicationId){
        System.debug(LoggingLevel.ERROR,'applicationId>>'+applicationId);
        FNS_ShowProductCompController.FNS_ProductResponseWrapper wrapper = new FNS_ShowProductCompController.FNS_ProductResponseWrapper();
        try{
			Id appId = Id.valueOf(applicationId);
			//FNS_ApplicationRollup.getSummaryForLoanAndFees(new Set<Id>{appId});
			List<FNS_ShowProductCompController.FNS_ProductWrapper> productWrapperList = FNS_ShowProductCompController.getAllRelatedProductsForWrapper(applicationId);
            wrapper.productWrapperList = productWrapperList;
            
        }catch (DMLException ex){
            logger.addLogRecord('FNS_CreateProductController', 'getProductData', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
            
        } catch (Exception ex){
            logger.addLogRecord('FNS_CreateProductController', 'getProductData', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        }
        return wrapper;
    }
    /**
* @description Delete Product Role, Product Loan. 
* @param record Id
* @param object API name as String 
* @return a Wrapper class
*/ 
    @AuraEnabled
    public static FNS_ProductWrapper deleteRecords(String recordId,String objName){
        FNS_ProductWrapper wrapper = new  FNS_ProductWrapper();
        try{
            System.debug(LoggingLevel.ERROR,'recordId>>'+recordId+'>>>objName>>>'+objName);
            fflib_SObjectUnitOfWork uow = FNS_Util.getUOWForRecordDelete();
            FNS_Util.deleteRecords(uow, new List<String>{recordId},objName);
        }
        catch(DMLException ex){
            logger.addLogRecord('FNS_CreateProductController', 'deleteRecords', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        } catch (Exception ex){
            logger.addLogRecord('FNS_CreateProductController', 'deleteRecords', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage(); 
        }
        return wrapper;
    } 
    
}
