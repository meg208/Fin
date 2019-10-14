/**
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Create Product
* @description Helps in evaluating CRUD Access
*/
public class FNS_ProductWizardController {
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    /**
* @description Get the Field Names, Object Names for Objects. 
* @param opportunityId to get Record Type of Opportunity
* @return a Wrapper class
*/ 
    @AuraEnabled
    public static FNS_ProductWizardWrapper.productWizard getComponentData(String applicationId){
        FNS_ProductWizardWrapper.productWizard wrapper = new FNS_ProductWizardWrapper.productWizard();
        FNS_ProductWizardWrapper.productWrap productwrap = new FNS_ProductWizardWrapper.productWrap();
        productwrap.fields = FNS_ProductDomain.getProductFields();
        productwrap.moreFields=FNS_ProductDomain.getProductMoreFields();
        productwrap.ObjectName = FNS_ProductDomain.getProductObjectName();
        productwrap.requiredFields= FNS_ProductDomain.getProductRequiredFields();
        if (productwrap.requiredFields!=null && !productwrap.requiredFields.isEmpty()){
            List<Opportunity> opp = new FNS_ApplicationSelector().selectApplicationById(new Set<Id>{applicationId});
            System.debug('opp>>'+opp);
            if (opp!=null && !opp.isEmpty()){
                for (FNS_Field f : productwrap.requiredFields){
                    if (f.APIName.contains('FNS_Application__c')){
                        f.Value = (Object)applicationId;
                    }
                    if (f.APIName.contains('PrimaryOwner__c')){
                        f.Value = (Object)opp[0].AccountId;
                    }
                }
            }
        }
        productwrap.ObjectLabel='PRODUCT';
        
        FNS_ProductWizardWrapper.loanWrap loanWrap = new FNS_ProductWizardWrapper.loanWrap();
        loanWrap.fields = FNS_ProductDomain.getLoanFields();
        loanWrap.moreFields=FNS_ProductDomain.getLoanMoreFields();
        loanWrap.ObjectName = FNS_ProductDomain.getLoanObjectName();
        loanWrap.requiredFields = FNS_ProductDomain.getLoanRequiredFields();
        if (loanWrap.requiredFields!=null && !loanWrap.requiredFields.isEmpty()){
            for (FNS_Field f : loanWrap.requiredFields){
                if (f.APIName.contains('TransactionDate__c')){
                    f.Value = (Object)System.now();
                }
            }
        }
        loanWrap.ObjectLabel='LOAN';
        system.debug('wrapper>>>>'+loanWrap.requiredFields);
        FNS_ProductWizardWrapper.pricingWrap pricingWrap = new FNS_ProductWizardWrapper.pricingWrap();
        pricingWrap.fields = FNS_ProductDomain.getPricingFields();
        pricingWrap.moreFields = FNS_ProductDomain.getPricingMoreFields();
        pricingWrap.ObjectName = FNS_ProductDomain.getPricingObjectName();
        pricingWrap.requiredFields = FNS_ProductDomain.getPricingRequiredFields();
        pricingWrap.ObjectLabel='PRICING';
        
        Map<String,String> oppRecordTypeMap =new FNS_ApplicationSelector().getApplicationRecordType(new set<String>{applicationId});
        String recordTypeName = oppRecordTypeMap.get(applicationId);
        wrapper.opportunityReadOnly = (recordTypeName==FNS_Constants.OPPORTUNITY_READONLYRECORDTYPE)?false:true;
        wrapper.product = productwrap;   
        wrapper.loan = loanWrap;
        wrapper.pricing = pricingWrap;
        system.debug('wrapper>>>>'+wrapper);
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
            logger.addLogRecord('FNS_ProductWizardController', 'getProductData', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
            
        } catch (Exception ex){
            logger.addLogRecord('FNS_ProductWizardController', 'getProductData', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        }
        return wrapper;
    }
    @AuraEnabled
    public static FNS_ShowProductCompController.FNS_ProductResponseWrapper updateAmountonApplication(String applicationId){
        FNS_ShowProductCompController.FNS_ProductResponseWrapper wrapper = new FNS_ShowProductCompController.FNS_ProductResponseWrapper();
         try{
        	Id appId = Id.valueOf(applicationId);
             FNS_ApplicationRollup.setProductRollUpAmountOnProduct(new Set<Id>{appId});
              }catch (DMLException ex){
            logger.addLogRecord('FNS_ProductWizardController', 'updateAmountonApplication', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
            
        } catch (Exception ex){
            logger.addLogRecord('FNS_ProductWizardController', 'updateAmountonApplication', ex.getMessage() + ex.getStackTraceString());
            wrapper.error=ex.getMessage();
        }
         return wrapper;

    }
    
	/**
    * @description Delete related pricing record. 
    * @param recordId, objName
    * @return a Wrapper class
    */
    @AuraEnabled
    public static FNS_ProductWizardWrapper deletePricingRecords(String recordId, String objName){
        FNS_ProductWizardWrapper wrapper = new FNS_ProductWizardWrapper();
        try{
            System.debug(LoggingLevel.ERROR,'recordId>>'+recordId+'>>>objName>>>'+objName);
            fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] {FNS_Pricing__c.SObjectType});
            FNS_Util.deleteRecords(uow, new List<String>{recordId},objName);
        }
        catch(DMLException ex){
            logger.addLogRecord('FNS_ProductWizardController', 'deletePricingRecords', ex.getMessage() + ex.getStackTraceString());
            wrapper.error = ex.getMessage();
        } catch (Exception ex){
            logger.addLogRecord('FNS_ProductWizardController', 'deletePricingRecords', ex.getMessage() + ex.getStackTraceString());
            wrapper.error = ex.getMessage(); 
        }
        return wrapper;
    }
	
    @AuraEnabled
    public static FNS_ShowProductCompController.FNS_ProductResponseWrapper insertLoanRecords(String productId, String applicationId, String loanListToUpdate){ 
		system.debug('>>>productId'+productId);  
        system.debug('>>>loanListToUpdate'+loanListToUpdate);
        FNS_ShowProductCompController.FNS_ProductResponseWrapper wrapper = new FNS_ShowProductCompController.FNS_ProductResponseWrapper();
		/* // This comment should be uncommented. Commented just to avoid deployment errors.
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork( 
                                            new Schema.SObjectType[] {                                                                                              
                                                FinServ__FinancialAccountTransaction__c.SObjectType                                             
                                             }
                                         );
        List<FinServ__FinancialAccountTransaction__c> loanList ;
        try 
        {
            if(String.isNotBlank(productId) && String.isNotBlank(applicationId) && String.isNotBlank(loanListToUpdate))
            {
                
                loanList = (List<FinServ__FinancialAccountTransaction__c>)JSON.deserialize(loanListToUpdate, List<FinServ__FinancialAccountTransaction__c>.class);
                System.debug('>>>>loanList>>' +loanList);
                if(loanList != null && !loanList.isEmpty())
                {
                    for(FinServ__FinancialAccountTransaction__c loan: loanList)
                    {
                        System.debug('>>>> loan before insert' + loan );
                        loan.FNS_Application__c = applicationId;
                        loan.FinServ__FinancialAccount__c = productId ;
                        loan.FinServ__TransactionDate__c = System.now();
                        System.debug('>>>> loan before insert' + loan.Id );
                        if(loan.Id !=null){
                            uow.registerDirty(loan) ;
                        }else
                             uow.registerNew(loan) ; 
                        
                       
                        
                    }
                
                 } 
                uow.commitWork();
            }
        }
        catch (Exception ex )
        {
            wrapper.error=ex.getMessage();
            throw new FNS_CustomException(ex.getMessage());
            
        }
        
       */
       return wrapper; 
    }
    /*    Code tp be made dynamic next week 
     	* String baseNamespace  = FNS_Util.getBasePackageNamepace(); 
          String finFinancialAccountTransactionObjName  ;
          Schema.SObjectType finFinancialAccountTransactionObject;       
        
		 if(FNS_Util.isFSCInstalled)
        	{
            	finFinancialAccountTransactionObjName  = 'FinServ__FinancialAccount__c' ;            
        	}
        else
        	{
            	finFinancialAccountTransactionObjName = baseNamespace+'FNS_FinancialAccountTransaction__c' ;
        	}
       		finFinancialAccountTransactionObject = Schema.getGlobalDescribe().get(finFinancialAccountTransactionObjName);
        	sObject loanRecord = finFinancialAccountTransactionObject.newSObject();
        	List<sObject> loanList = new List<sObject>();
        	if(String.isNotBlank(productId) && String.isNotBlank(applicationId) && String.isNotBlank(loanListToUpdate))
        	{
            
            	loanList = ((List<SObject>)Type.forName(finFinancialAccountTransactionObject))JSON.deserialize(loanListToUpdate, List<finFinancialAccountTransactionObject>.class);
            
        	}
    	 * 
    	 * 
    	 * 
    	 * */
    	 
    public static SObject parseSOjects(String sObjectApiName, String jSONSObject){
        Map<String, Object> fieldMap = (Map<String, Object>)JSON.deserializeUntyped(jSONSObject);
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectApiName);
        SObject newSobject = targetType.newSObject();
        Map<String, Schema.sObjectField> targetFields = targetType.getDescribe().fields.getMap();
            System.debug(JSON.serialize( targetFields.keySet()));
        for (String key : fieldMap.keySet())
        {
            Object value = fieldMap.get(key);
            System.debug(key + ' 1 = ' + value);
            System.debug(' 2= ' + targetFields.get(key));
            if(!targetFields.containsKey(key.toLowerCase())){
                System.debug(key + ' Field is not defibed in object: ' + sObjectApiName);
            }else{
                Schema.DisplayType valueType = targetFields.get(key.toLowerCase()).getDescribe().getType();
                if (value != null && value instanceof String && valueType != Schema.DisplayType.String)
                {
                    String svalue = (String)value;
                    if (valueType == Schema.DisplayType.Date)
                        newSobject.put(key, Date.valueOf(svalue));
                    else if(valueType == Schema.DisplayType.DateTime){
                     	System.debug('@@ svalue :: '+ svalue);                        
                        if(svalue.length() > 19){
                            svalue = svalue.replace('T',' ');
                            svalue = svalue.left(19);
                        	System.debug('@@ svalue :: '+ svalue);
                        }
                        newSobject.put(key, DateTime.valueOfGmt(svalue));
                }else if (valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency)
                        newSobject.put(key, svalue == '' ? null : Decimal.valueOf(svalue));
                    else if (valueType == Schema.DisplayType.Double)
                        newSobject.put(key, svalue == '' ? null : Double.valueOf(svalue));
                    else if (valueType == Schema.DisplayType.Integer)
                        newSobject.put(key, Integer.valueOf(svalue));
                    else if (valueType == Schema.DisplayType.Base64)
                        newSobject.put(key, Blob.valueOf(svalue));
                    else
                        newSobject.put(key, svalue);
                }
                else
                    newSobject.put(key, value);
            }
        }
        return newSobject;
    }
     
}