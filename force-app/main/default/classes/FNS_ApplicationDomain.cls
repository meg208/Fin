/*****************************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Access Handler
* @description This class is used to pull data for Application.

******************************************************************************************/
public with sharing class FNS_ApplicationDomain extends fflib_SObjectDomain {
    static FNS_ErrorLog logger = new FNS_ErrorLog();
    static String bankExtId;
    static Map<String, String> customerIdToExtIdMap = new Map<String, String>();
    /*************************************************************************************
* @description  Constructs the domain class for Opportunity.
* @Params       none
* @Returns      none
**************************************************************************************/
    public FNS_ApplicationDomain(List<Opportunity> sObjectList) {
        super(sObjectList);
    }
    
    /*************************************************************************************
* @description  Interface used by the triggerHandler in constructing instances of Domain class.
* @Params       none
* @Returns      none
**************************************************************************************/
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new FNS_ApplicationDomain(sObjectList);
        }
    }
    
    public override void onValidate() {
        
    }
    
    /*************************************************************************************
* @description  Method used to get Application data from FFDC, invoked from trigger
* @Params       Application External ID
* @Returns      none
**************************************************************************************/
    @future(callout = true)
    public static void pullApplicationDataFromFFDC(Id applicationExtId){
        //To do Query application 
        //getApplicationDataFromFFDC(application); 
    }
    
    /*************************************************************************************
* @description  Method used to get Application data from FFDC
* @Params       Application External ID
* @Returns      none
**************************************************************************************/
    public static void getApplicationDataFromFFDC(Opportunity application){
    try{
        String applicationExternalID = application.FNS_ApplicationExtId__c; 
        //Activities GET API call 
        HTTPResponse queueActivitiesRes= FNS_ApplicationWithQueueActivityDomain.getActivitiesForApplication(applicationExternalID);
        
        //Application Summary API call to get updated disposition
        User loggedInUser = new FNS_UserSelector().selectById(UserInfo.getUserId());           
        HTTPResponse activeDealsSummaryRes= FNS_QueueActivityDomain.getActiveDealsSummaryForRM(loggedInUser.FNS_UserExternalId__c);
        
        //Application Get call
        String responseState = FNS_Constants.STR_FAILURE; 
        if(String.isNotEmpty(applicationExternalID)) {
            FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
            param.objectName = FNS_Constants.CLASS_APPLICATION;
            param.endPoint = FNS_Constants.URL_APPLICATION;
            param.extendedAPIUrl = applicationExternalID;
            param.methodName = FNS_Constants.METHOD_GET;
            FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
            HttpResponse jsonResponse = router.getPostRequest(param);
            System.debug('>>> jsonResponse for Application API>>'  + jsonResponse.getbody());
            if(jsonResponse.getStatusCode() == 200){
                if (!String.isEmpty(jsonResponse.getBody())){
                    responseState = FNS_Constants.STR_SUCCESS; 
                    FNS_ApplicationPayload applicationResp = (FNS_ApplicationPayload )JSON.deserialize(jsonResponse.getBody(), FNS_ApplicationPayload.class);
                    handleResponse(applicationResp);
                }  
            }
            if(queueActivitiesRes.getStatusCode() == 200){
                FNS_ApplicationWithQueueActivityDomain.handleQueueActivityResponse(queueActivitiesRes); 
                
            }
            // Get Product Amount At application level
            FNS_ApplicationRollup.setProductRollUpAmountOnProduct(new set<ID>{application.id});
            system.debug('activeDealsSummaryRes response'+activeDealsSummaryRes);
           
           // Handle Application summary response
            if(activeDealsSummaryRes.getStatusCode() == 200){
                if (!String.isEmpty(activeDealsSummaryRes.getBody())){
                    // Changes for APi 1.0
                    // List<FNS_ObjectContainer.FNS_ApplicationSummary> applicationSummary = (List<FNS_ObjectContainer.FNS_ApplicationSummary>)JSON.deserialize(jsonResponse.getBody(), List<FNS_ObjectContainer.FNS_ApplicationSummary>.class);
                    List<FNS_ObjectContainer.FNS_ApplicationSummary> applicationSummary ;
                    FNS_ObjectContainer listApplicationSummary = (FNS_ObjectContainer)JSON.deserialize(activeDealsSummaryRes.getBody(), FNS_ObjectContainer.class);
                    if(listApplicationSummary != null && listApplicationSummary.applicationSummariesList!= null )
                    {
                        applicationSummary =  listApplicationSummary.applicationSummariesList;
                        FNS_QueueActivityDomain.handleResponse(applicationSummary);
                    }
                }
            }
        }
        } catch (Exception ex){  
        	System.debug('>>>>Exception>>' +ex.getMessage() + 'Line Number' + ex.getLineNumber()  + 'getStackTraceString'  +ex.getStackTraceString());
        	throw new FNS_CustomException(ex.getmessage());
        	//logger.addLogRecord('FNS_ApplicationDomain', 'getApplicationDataFromFFDC', ex.getMessage() + ex.getStackTraceString()); 
        }
        
    }
    
    /*************************************************************************************
* @description  Method used to handle response from FFDC to get the Application detail.
* @Params       FNS_ApplicationPayload object
* @Returns      none
**************************************************************************************/
    public static void handleResponse(FNS_ApplicationPayload applicationResp) {
        Opportunity application; 
        FNS_Bank__c bank;
        List<Account> customerListForProductRole;
        Set<String> customerExtIDSet ;
        Set<ID> oppIdSet = new Set<ID>();
        if(applicationResp != null && applicationResp.linesOfCredit != null){
            if(String.isnotEmpty(applicationResp.bankId)){
                bank = getBankFromAppResp(String.valueof(applicationResp.bankId));
            }
            if(String.isnotEmpty(applicationResp.applicationId)) {
                application = FNS_Util.getOpportunityFromAppResp(String.valueOf(applicationResp.applicationId));
                if(application != null){
                    oppIdSet.add(application.ID);
                }
            }
            customerExtIDSet = upsertCustomerFirstForApplicationGet(applicationResp.linesOfCredit);
        }
        
        if(application != null && applicationResp.customerIds != null  ) {
            Set<String> allCustomers = new Set<String>();
            Set<String> roleCustId = getCustomerIdForRelatedRole(applicationResp.customerIds);
            allCustomers.addAll(roleCustId);
            allCustomers.addAll(customerExtIDSet);
            //Get Customers API call out
            FNS_OrganizationDomain.fetchCustomersFromCME(allCustomers);
            
            //Pull the customers upserted before Application is updated.
            customerListForProductRole = new FNS_AccountSelector().selectByExternalId(customerExtIDSet);
        }
        if(application != null && applicationResp != null && applicationResp.linesOfCredit != null) {
            FNS_FinancialProductDomain.upsertfinancialProductList(application.FNS_ApplicationExtId__c ,applicationResp.linesOfCredit ,customerListForProductRole);
        }
        
        fflib_SObjectUnitOfWork   uow =  getunitOfWork();
        if(application != null && applicationResp.customerIds != null ) {
            updateRelatedRoles(application.FNS_ApplicationExtId__c,applicationResp.customerIds,uow);
        }
        if(application != null){
            if(applicationResp.startDate != null){
                application.FNS_StartDateTime__c = FNS_Util.convertStringToDate(applicationResp.startDate);
            }
            if(bank != null){
                application.FNS_Bank__c = bank.ID;
            }
            if(applicationResp.dispositionId != null){
                application.StageName = FNS_Util.dispostionIdToValue.get(applicationResp.dispositionId);
            }
            application.FNS_BypassValidation__c = !application.FNS_BypassValidation__c;           
            uow.registerDirty(application);
        }
        
        if (application != null && applicationResp.officerIds != null && !applicationResp.officerIds.isEmpty()) {
            Set<String>  officerIDSet = new Set<String>();
            officerIDSet.addAll(applicationResp.officerIds);  
            List<FNS_Officer__c> existingofficerList = fetchOfficers (officerIDSet);
            Map<String,FNS_Officer__c> officerMap =  getMapOfOfficer(existingofficerList);
            List<FNS_ApplicationWithOfficer__c> existingAppWithOfficerList =  new FNS_ApplicationOfficersSelector().getApplicationOfficersByAppId(oppIdSet);
            updateApplicationOfficers(uow ,application.FNS_ApplicationExtId__c,applicationResp.officerIds ,officerMap);
            if(existingAppWithOfficerList != null  && !existingAppWithOfficerList.isEmpty()){
                uow.registerDeleted(existingAppWithOfficerList);
            }
        }
        FNS_ObjectAccessContainer.checkOpportunityAccess(FNS_AccessController.DML_OPERATION_UPDATE);
        FNS_ObjectAccessContainer.checkRelatedRoleAccess(FNS_AccessController.DML_OPERATION_INSERT);
        FNS_ObjectAccessContainer.checkRelatedRoleAccess(FNS_AccessController.DML_OPERATION_DELETE);
        FNS_ObjectAccessContainer.checkApplicationWithOfficerAccess(FNS_AccessController.DML_OPERATION_INSERT); 
        FNS_ObjectAccessContainer.checkApplicationWithOfficerAccess(FNS_AccessController.DML_OPERATION_DELETE) ;
        try
        {
            uow.commitwork();
        }
        catch (DMLException ex)
        {
            //logger.addLogRecord('FNS_ApplicationDomain', 'handleResponse', ex.getMessage() + ex.getStackTraceString());
            System.debug('>>>>Exception>>' +ex.getMessage() + 'Line Number' + ex.getLineNumber()  + 'getStackTraceString'  +ex.getStackTraceString());
        	throw new FNS_CustomException(ex.getmessage());
        }
        
        
        
    }  
    
    /*************************************************************************************
* @description  Method used to get customers id for related roles.
* @Params       Wrapper class
* @Returns      none
**************************************************************************************/  
    public static Set<String> getCustomerIdForRelatedRole(FNS_ObjectContainer.FNS_CustomerIds customerIds){
        Set<String> customerSet = new Set<String>();
        Set<String> borrowerSet = new Set<String>();
        Set<String> guarantorSet = new Set<String>();
        Set<String> co_borrowerSet = new Set<String>();
        Set<ID> oppIDSet = new Set<ID>();
        
        if (customerIds.BORROWER != null && !customerIds.BORROWER.isEmpty()) {
            List<String> borrowerIds = customerIds.BORROWER ;
            borrowerSet.addall(borrowerIds);
            customerSet.addall(borrowerIds);
        }
        if (customerIds.GUARANTOR != null && !customerIds.GUARANTOR.isEmpty()) {
            List<String> guarantorIDs = customerIds.GUARANTOR ;
            guarantorSet.addall(guarantorIDs);
            customerSet.addall(guarantorIDs);
            
        }
        if (customerIds.CO_BORROWER != null && !customerIds.CO_BORROWER.isEmpty()) {
            List<String> co_borrowerIds = customerIds.CO_BORROWER ;
            co_borrowerSet.addAll(co_borrowerIds);
            customerSet.addall(co_borrowerIds);
        }
        return customerSet;
    }
    
    /*************************************************************************************
* @description  Method used to updated customers id related roles.
* @Params       Application Id
* @Params       Wrapper class - FNS_CustomerIds
* @Params       Unit of work object
* @Returns      none
**************************************************************************************/  
    public static void updateRelatedRoles( String applicationID ,FNS_ObjectContainer.FNS_CustomerIds customerIds ,fflib_SObjectUnitOfWork uow ) {
        
        Opportunity application;
        if(!String.isEmpty(applicationID)){
            application = FNS_Util.getOpportunityFromAppResp(applicationID);
        }
        Set<String> customerSet = new Set<String>();
        Set<String> borrowerSet = new Set<String>();
        Set<String> guarantorSet = new Set<String>();
        Set<String> co_borrowerSet = new Set<String>();
        Set<ID> oppIDSet = new Set<ID>();
        oppIDSet.add(application.ID);
        
        if (customerIds.BORROWER != null && !customerIds.BORROWER.isEmpty()) {
            List<String> borrowerIds = customerIds.BORROWER ;
            borrowerSet.addall(borrowerIds);
            customerSet.addall(borrowerIds);
        }
        if (customerIds.GUARANTOR != null && !customerIds.GUARANTOR.isEmpty()) {
            List<String> guarantorIDs = customerIds.GUARANTOR ;
            guarantorSet.addall(guarantorIDs);
            customerSet.addall(guarantorIDs);
            
        }
        if (customerIds.CO_BORROWER != null && !customerIds.CO_BORROWER.isEmpty()) {
            List<String> co_borrowerIds = customerIds.CO_BORROWER ;
            co_borrowerSet.addAll(co_borrowerIds);
            customerSet.addall(co_borrowerIds);
        }
        
        List<Account> customerList = new List<Account>();
        Map<String,Account> customerMap =  new Map<String,Account>();
        Account entity ;
        FNS_RelatedRoles__c relatedRole ;
        List<FNS_RelatedRoles__c> existingRoles = new FNS_RelatedRolesSelector().selectRoleByOppId(oppIDSet);
        if(! customerSet.isEmpty()){
            customerList = new FNS_AccountSelector().selectByExternalId(customerSet);
            if(! customerList.isEmpty()){
                for(Account acc : customerList){
                    customerMap.put(String.valueof(acc.FNS_CustomerExtId__c ), acc);
                }
            }
        }
        
        if(! customerMap.isEmpty()){
            for(String custID : customerMap.keySet()) {
                entity = customerMap.get(custID);
                relatedRole = new FNS_RelatedRoles__c();
                relatedRole.FNS_AccountName__c= entity.ID;
                relatedRole.FNS_Application__c = application.ID;
                if(borrowerSet.contains(custID)) {
                    relatedRole.FNS_RoleOfEntity__c = FNS_Constants.BORROWER ;//'BORROWER';
                }else if(guarantorSet.contains(custID)) {
                    relatedRole.FNS_RoleOfEntity__c = FNS_Constants.GUARANTOR ; //'GUARANTOR';
                }else if(co_borrowerSet.contains(custID)) {
                    relatedRole.FNS_RoleOfEntity__c = FNS_Constants.CO_BORROWER ; //'CO_BORROWER';
                }
                if(relatedRole.FNS_RoleOfEntity__c != null){
                    //relatedRole.Name = relatedRole.FNS_RoleOfEntity__c;
                }
                uow.registerNew(relatedRole);
            }
        }
        if(existingRoles != null && ! existingRoles.isEmpty()){
            uow.registerDeleted(existingRoles);
        }
    }   
    
    /*************************************************************************************
* @description  Method used to get the bank details from Application response.
* @Params       Bank Id
* @Returns      none
**************************************************************************************/  
    public static  FNS_Bank__c  getBankFromAppResp(String bankID) {
        Set<String> bankIDSet = new Set<String>();
        List<FNS_Bank__c> bankList = new List<FNS_Bank__c>();
        if(bankID != null) {
            bankIDSet.add(bankID);
            bankList = new FNS_BanksSelector().selectByBankId (bankIDSet);
        }
        FNS_Bank__c bank  ;
        if(!bankList.isEmpty()) {
            bank = bankList.get(0);
        }
        return bank;
    } 
    
    public static fflib_SObjectUnitOfWork getunitOfWork() { 
        return new fflib_SObjectUnitOfWork( 
            new Schema.SObjectType[] {
                Account.SObjectType,
                    Opportunity.SObjectType,
                    FNS_ApplicationWithOfficer__c.SObjectType,
                    FNS_RelatedRoles__c.SObjectType
                    });
    } 
    
    /*************************************************************************************
* @description  Method used to convert officerIds list from list of Integer to list of string.
* @Params       List of officer Ids
* @Returns      none
**************************************************************************************/  
    public static List<String> getOfficerIDList(List<Integer> offcierIDList){
        List<String> officerIDs = new List<String>();
        for(Integer officerID : offcierIDList ) {
            if(officerID  != null){
                officerIDs.add(String.valueof(officerID));
            }
        }
        return officerIDs;
    }
    
    /*************************************************************************************
* @description  Method used to fetch officer details.
* @Params       Set of officer Ids
* @Returns      none
**************************************************************************************/  
    public static List<FNS_Officer__c> fetchOfficers(Set<String> officerIDs) {       
        List<FNS_Officer__c> officerList = new FNS_OfficersSelector().selectByExternalId(officerIDs)  ;
        return officerList;
    }
    
    /*************************************************************************************
* @description  Method used to create officer map from the provide officer list.
* @Params       List of officers
* @Returns      none
**************************************************************************************/  
    public static Map<String,FNS_Officer__c> getMapOfOfficer( List<FNS_Officer__c>  officerList) {
        Map<String,FNS_Officer__c> officerMap = new Map<String,FNS_Officer__c>();
        if(officerList != null){
            for(FNS_Officer__c officer : officerList ) {
                officerMap.put(String.valueof(officer.FNS_OfficerId__c) ,officer);
            }
        }
        return  officerMap;         
    }
    
    /*************************************************************************************
* @description  Method used to insert records in Application Officer junction object with the application Id.
* @Params       Unit of work object
* @Params       Application Id
* @Params       List of officers
* @Params       Map of officers
* @Returns      none
**************************************************************************************/ 
    public static void  updateApplicationOfficers(fflib_SObjectUnitOfWork uow ,
                                                  String applicationID,                                                   
                                                  List<String> officerIdList,
                                                  Map<String,FNS_Officer__c> officerMap){
                                                      Opportunity application;
                                                      FNS_ApplicationWithOfficer__c appWithOfficer;
                                                      if(!String.isEmpty(applicationID)){
                                                          application = FNS_Util.getOpportunityFromAppResp(applicationID);
                                                      }
                                                      if(uow != null && application != null && officerIdList != null && officerMap != null  ){
                                                          for(Integer i= 0 ; i < officerIdList.size() ; i++ ) {                            
                                                              appWithOfficer = new FNS_ApplicationWithOfficer__c();
                                                              if( officerMap.containsKey(officerIdList[i])) {
                                                                  appWithOfficer.FNS_Officer__c = officerMap.get(officerIdList[i]).ID;
                                                                  appWithOfficer.FNS_Application__c = application.ID;
                                                                  /*if( i == 0) {
appWithOfficer.FNS_OfficerRole__c = FNS_Constants.PRIMARYOFFICER; //'Primary';
}
if( i == 1) {
appWithOfficer.FNS_OfficerRole__c = FNS_Constants.SECONDARYOFFICER; //'Secondary';
}
if( i == 2) {
appWithOfficer.FNS_OfficerRole__c = FNS_Constants.TERTIARYOFFICER; //'Tertiary';
}*/
                                                                  uow.registernew(appWithOfficer);    
                                                              }
                                                          }
                                                      }
                                                      
                                                  }
    
    /*************************************************************************************
* @description  Method used to upsert customers before Application get request.
* @Params       Unit of work object
* @Params       Application Id
* @Params       List of officers
* @Params       Map of officers
* @Returns      none
**************************************************************************************/ 
    public static  Set<String> upsertCustomerFirstForApplicationGet(List<FNS_FinancialProductPayload> financialProductArray){
        Set<String> customerIdSet = new Set<String>();
        Map<String,Set<String>> customerSetMap = new Map<String,Set<String>>();
        
        if(financialProductArray != null && !financialProductArray.isEmpty()){
            for( FNS_FinancialProductPayload financialProduct: financialProductArray){
                if(financialProduct.customerIds != null){
                    Set<String> custIDSet = FNS_FinancialAccountRolesDomain.getCustomerExtIDs(financialProduct.customerIds );
                    customerIdSet.addAll(custIDSet);
                }
            }   
        }
        return customerIdSet;
    }
    
    /*************************************************************************************
* @description  Method to get All Customer Ids related to Application.
* @Params       apexClass, methodName, errorMsg
* @Returns      none
* @author       Swanand@comitydesigns.com
*************************************************************************************/
    public static Set<String> getApplicationRelatedCustomers(String applicationId){
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        Set<String> relatedCusomerIds = new Set<String>();
        Set<Id> relatedProductIds = new Set<Id>();
        String productObjName = '';
        String productRoleAccField = '';
        
        if(FNS_Util.isFSCInstalled){
            productObjName = namespace + 'FinancialAccountApplicationsFSC__r';
            productRoleAccField = 'FinServ__RelatedAccount__c';
        }else {
            productObjName = namespace + 'FinancialAccountApplications__r'; 
            productRoleAccField = namespace + 'FNS_RelatedAccount__c';
        }
        
        if(applicationId != null) {
            Id oppId = Id.valueOf(applicationId);
            List<Opportunity> oppList = new FNS_ApplicationSelector().selectById(new Set<Id>{oppId});
            Id appOrgId = oppList[0].AccountId;
            relatedCusomerIds.add((String)appOrgId);
            
            List<SObject> relatedRoleList = new FNS_RelatedRolesSelector().selectRoleByOppId(new Set<Id>{oppId});
            if(! relatedRoleList.isEmpty()){
                for(SObject obj : relatedRoleList){
                    if(obj.get(baseNamespace+'FNS_AccountName__c') != null){
                        relatedCusomerIds.add((String)obj.get(baseNamespace+'FNS_AccountName__c'));
                    }
                }
            }
            
            List<Opportunity> oppToProductList = new FNS_ApplicationSelector().selectApplicationWithProducts(new Set<Id>{oppId});
            if(! oppToProductList.isEmpty()){
                Opportunity oppRecord = oppToProductList[0];
                List<SObject> productList = oppRecord.getSObjects(productObjName);
                if(productList != null && ! productList.isEmpty()){
                    for(SObject prodObj : productList){
                        relatedProductIds.add((Id)prodObj.get('Id'));
                    }
                }
            }
            
            List<SObject> relatedProductRoleList = new FNS_ProductRolesSelector().getProductRoles(relatedProductIds);
            if(! relatedProductRoleList.isEmpty()){
                for(SObject obj : relatedProductRoleList){
                    if(obj.get(productRoleAccField) != null){
                        relatedCusomerIds.add((String)obj.get(productRoleAccField));
                    }
                }
            }
            system.debug('relatedCusomerIds = '+relatedCusomerIds);
        }
        return  relatedCusomerIds;
    }
    
    
    /*************** Application POST Response *****************/
    
    
    /*************************************************************************************
* @description  Method to create Application Wrapper for POST Request
* @Params       apexClass, methodName, errorMsg
* @Returns      none
*************************************************************************************/
    public static String createApplicatonWrapper(Set<ID> oppIdSet){
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        List<Opportunity> oppList = new FNS_ApplicationSelector().selectApplicationWithProducts(oppIdSet);
        List<FNS_ApplicationPayload> applicationWrapper = new List<FNS_ApplicationPayload>();
        List<FNS_RelatedRoles__c> relatedRoleList = new FNS_RelatedRolesSelector().selectRoleByOppId(oppIdSet);
        Set<Id> productIdSet;
        Set<ID> bankIdSet;
        Set<ID> feeSetId;
        Map<ID,Set<ID>> applicationProductMap = new Map<ID,Set<ID>>();
        String productRelationShip;
        Map<ID,Set<ID>> productFeesMap = new Map<ID,Set<ID>>();
        User loggedInUser = new FNS_UserSelector().selectById(UserInfo.getUserId());
        
        Map<ID,List<FNS_RelatedRoles__c>> oppIdRelatedRolesListMap = new Map<ID,List<FNS_RelatedRoles__c>>();
        if(relatedRoleList != null){
            for(FNS_RelatedRoles__c rrObj : relatedRoleList){
                if(rrObj.FNS_Application__c != null){
                    List<FNS_RelatedRoles__c> relatedRoles = oppIdRelatedRolesListMap.get(rrObj.FNS_Application__c);
                    if (relatedRoles == null) {
                        relatedRoles = new List<FNS_RelatedRoles__c>();
                        oppIdRelatedRolesListMap.put(rrObj.FNS_Application__c, relatedRoles);
                    }
                    relatedRoles.add(rrObj);
                }
            }
        }
        List<SObject> oppProductList;
        //For Values
        for(Opportunity oppObj : oppList){
            productIdSet = new Set<ID>();
            oppProductList = new List<SObject>();
            //Bank Details
            bankIdSet = new Set<ID>();
            bankIdSet.add((ID)oppObj.FNS_Bank__c);
            
            //Product
            productRelationShip = FNS_Util.isFSCInstalled ? 'FinancialAccountApplicationsFSC__r':'FinancialAccountApplications__r';
            oppProductList = oppObj.getSobjects(namespace + productRelationShip);
            if(oppProductList != null && !oppProductList.isEmpty()){
                for(SObject prodObj : oppProductList){
                    productIdSet.add((Id)prodObj.get('Id'));
                }
            }
            
            applicationProductMap.put(oppObj.id, productIdSet);
        }
        Map<String,FNS_Bank__c> bankByIDMap = new Map<String,FNS_Bank__c>(new FNS_BanksSelector().selectById(bankIdSet));
        Map<ID,sObject> productMap = new Map<ID,sObject>(new FNS_ProductsSelector().selectProductsWithChilds(productIdSet));
        
        List<sObject> productRoleList = new FNS_ProductRolesSelector().getProductRolesWithParentsInfo(productIdSet);
        Map<ID,List<sObject>> productRoleMap = new Map<ID,List<sObject>>();
        String relatedObjName = '';
        if(FNS_Util.isFSCInstalled){
            relatedObjName = 'FinServ__FinancialAccount__c';
        }else {
            relatedObjName = namespace+'FNS_FinancialAccount__c';
        }
        
        
        for(sObject sObj : productRoleList){
            if (sObj.get(relatedObjName) != null){
                List<sObject> relatedRoles = productRoleMap.get((Id) sObj.get(relatedObjName));
                if (relatedRoles == null) {
                    relatedRoles = new List<sObject>();
                    productRoleMap.put((Id) sObj.get(relatedObjName) , relatedRoles);
                }
                relatedRoles.add(sObj);
            }
        } 
        
        for(Opportunity opp : oppList){
            FNS_ApplicationPayload appWrapper = new FNS_ApplicationPayload();
            if(FNS_Util.dispostionValueToId.containsKey(opp.StageName)){
                appWrapper.dispositionId = FNS_Util.dispostionValueToId.get(opp.StageName);
            }
            if(opp.FNS_Bank__c != null){
                appWrapper.bankId = String.valueOf((bankByIDMap.get(opp.FNS_Bank__c)).FNS_BankExternalId__c);
                bankExtId = String.valueOf((bankByIDMap.get(opp.FNS_Bank__c)).FNS_BankExternalId__c);
            }
            appWrapper.description = opp.Description;
            appWrapper.startDate = FNS_Util.convertDateTimeToString(opp.FNS_StartDateTime__c);
            appWrapper.customerIds = createCustomerIdsWrapper(oppIdRelatedRolesListMap.get(opp.id));
            
            Set<ID> productIdSets = applicationProductMap.get(opp.id);
            List<sObject> productList = new List<sObject>();
            if(productIdSets != null){
                for(ID idValue :productIdSets){
                    productList.add(productMap.get(idValue));
                }
            }
            appWrapper.linesOfCredit = createLOCWrapper(productList, productRoleMap);
            if(string.isNotBlank(loggedInUser.FNS_UserExternalId__c)){
                appWrapper.officerIds = new List<String> {loggedInUser.FNS_UserExternalId__c};
                    }
            system.debug('@@@@@ appWrapper ' + JSON.Serialize(appWrapper));
            return JSON.Serialize(appWrapper);
        }
        return null;
    }
    
    /*************************************************************************************
* @description  Method to create CustomerIds Wrapper for Application POST Request.
* @Params       List of related Roles.
* @Returns      List of wrapper class object
*************************************************************************************/
    public static FNS_ObjectContainer.FNS_CustomerIds createCustomerIdsWrapper(List<FNS_RelatedRoles__c> relatedRolesList ){
        FNS_ObjectContainer.FNS_CustomerIds customerWrapper = new FNS_ObjectContainer.FNS_CustomerIds();
        String baseNamespace = FNS_Util.getBasePackageNamepace();
        sObject sObj;
        
        customerWrapper.BORROWER = new List<String>();
        customerWrapper.CO_BORROWER = new List<String>();
        customerWrapper.GUARANTOR = new List<String>();
        if(relatedRolesList != null){
            for(FNS_RelatedRoles__c relatedObj : relatedRolesList){
                if(relatedObj.FNS_AccountName__c != null){
                    sObj = relatedObj.getSobject(baseNamespace+'FNS_AccountName__r');
                    if(relatedObj.FNS_RoleOfEntity__c == FNS_Constants.BORROWER){
                        if(String.isNotBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')))){
                            customerWrapper.BORROWER.add(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')));
                        }else if(String.isBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c'))) && customerIdToExtIdMap.containsKey(String.valueOF(sObj.get('Id')))){
                            customerWrapper.BORROWER.add(customerIdToExtIdMap.get(String.valueOF(sObj.get('Id'))));
                        }
                    } else if(relatedObj.FNS_RoleOfEntity__c == FNS_Constants.CO_BORROWER ){
                        if(String.isNotBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')))){
                            customerWrapper.CO_BORROWER.add(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')));
                        }else if(String.isBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c'))) && customerIdToExtIdMap.containsKey(String.valueOF(sObj.get('Id')))){
                            customerWrapper.CO_BORROWER.add(customerIdToExtIdMap.get(String.valueOF(sObj.get('Id'))));
                        }
                    }else if(relatedObj.FNS_RoleOfEntity__c == FNS_Constants.GUARANTOR ){
                        if(String.isNotBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')))){
                            customerWrapper.GUARANTOR.add(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')));
                        }else if(String.isBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c'))) && customerIdToExtIdMap.containsKey(String.valueOF(sObj.get('Id')))){
                            customerWrapper.GUARANTOR.add(customerIdToExtIdMap.get(String.valueOF(sObj.get('Id'))));
                        }
                    }
                }
            }
        }
        return customerWrapper;
    }
    
    /*************************************************************************************
* @description  Method to create LOC Wrapper for Application POST Request.
* @Params       List of Product
* @Params       Product-Role map
* @Returns      List of wrapper class object
*************************************************************************************/
    public static List<FNS_FinancialProductPayload> createLOCWrapper(List<sObject> productList, Map<ID,List<sObject>> productRoleMap){
        List<FNS_FinancialProductPayload> locPayLoadList = new List<FNS_FinancialProductPayload>();
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        for(sObject obj : productList){
            FNS_FinancialProductPayload locPayLoadObj = new FNS_FinancialProductPayload();
            //API 1.0 changes starts >>
            //locPayLoadObj.amount = (Decimal) obj.get(namespace +'FNS_Amount__c');
            locPayLoadObj.amount = new FNS_FinancialProductPayload.FNS_Money();
            locPayLoadObj.amount.amount = (Decimal) obj.get(namespace +'FNS_Amount__c');
            locPayLoadObj.amount.currencyCode ='USD' ;// (String) obj.get(namespace +'FNS_SuppCurrencies__c');//API 1.0 Hardecoded
            //API 1.0 changes Ends  <<
            locPayLoadObj.productType = (String)(obj.get(namespace +'FNS_ProductType__c'));
            
            locPayLoadObj.effectiveDate = FNS_Util.convertDateTimeToString((DateTime) obj.get(namespace +'FNS_EffectiveDate__c'));
            locPayLoadObj.expiryDate = FNS_Util.convertDateTimeToString((DateTime) obj.get(namespace +'FNS_ExpiryDate__c'));
            locPayLoadObj.maturityDate = FNS_Util.convertDateTimeToString((DateTime) obj.get(namespace +'FNS_MaturityDate__c'));
            locPayLoadObj.currencyCode = (String) obj.get(namespace +'FNS_CurrencyCode__c');
            locPayLoadObj.opportunityID = (String) obj.get(namespace +'FNS_Application__c');
            locPayLoadObj.lineOfCreditId = (String) (obj.get(namespace +'FNS_FinancialProductExtId__c'));
            locPayLoadObj.purposeTypeId = (String)(obj.get(namespace +'FNS_Purpose__c'));
            locPayLoadObj.originationTypeIndicator = 'N';
            if((String)(obj.get(namespace +'FNS_TermUnit__c')) == FNS_Constants.YEAR){
                locPayLoadObj.termUnit = FNS_Constants.MONTH;
                Integer termValue = Integer.valueOf((Decimal.valueof((String)obj.get(namespace +'FNS_Term__c'))));
                locPayLoadObj.term = String.valueOf(termValue*12);
            }else {
                locPayLoadObj.termUnit = FNS_Constants.MONTH;
                locPayLoadObj.term = (String)(obj.get(namespace +'FNS_Term__c'));
            }
            
            
            List<sObject> relatedList = FNS_Util.isFSCInstalled?obj.getSobjects(namespace + 'ProductFeesFSC__r') :obj.getSobjects(namespace +'FinancialProductFees__r');
            if(relatedList != null){
                locPayLoadObj.fees = createFeeWrapper(relatedList);
            }
            
            relatedList =  FNS_Util.isFSCInstalled?obj.getSobjects(namespace +'Finserv__FinancialAccountTranslations__r'):obj.getSobjects(namespace +'FinancialAccountLoans__r');
            if(relatedList != null){
                locPayLoadObj.loans = setLoanWrapper(relatedList);
            }
            relatedList = FNS_Util.isFSCInstalled?obj.getSobjects(namespace + 'ApplicationPricings__r'):obj.getSobjects(namespace +'FinancialProductPricings__r');
            if(relatedList != null){
                locPayLoadObj.pricings = createPricingWrapper(relatedList);
            }
            
            relatedList = productRoleMap.get(obj.id);
            if(relatedList != null){
                locPayLoadObj.customerIds = createPrductCustomerIds(relatedList);
            }
            locPayLoadList.add(locPayLoadObj);
        }
        system.debug('@@@ locPayLoadList :: ' + locPayLoadList);
        return locPayLoadList;
    }
    
    /*************************************************************************************
* @description  Method to create LOAN Wrapper for Application POST Request.
* @Params       List of Loan.
* @Returns      List of wrapper class object
*************************************************************************************/
    public Static List<FNS_ObjectContainer.FNS_Loan> setLoanWrapper(List<sObject> loanList){
        List<FNS_ObjectContainer.FNS_Loan> loanWrapperList = new List<FNS_ObjectContainer.FNS_Loan>();
        String baseNamespace = FNS_Util.getBasePackageNamepace();
        String extNamespace = FNS_Util.getExtensionPackageNamespace();
        String namespace = FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        FNS_ObjectContainer.FNS_Loan loanObj;
        String amountField = '';
        if(FNS_Util.isFSCInstalled){
            amountField = 'FinServ__Amount__c';
        }else {
            amountField = namespace +'FNS_Amount__c';
        }
        if(loanList != null){
            system.debug('@@ loanList size :: ' + loanList.size());
            for(sObject obj : loanList){
                loanObj = new FNS_ObjectContainer.FNS_Loan();
                loanObj.customerIds = new FNS_ObjectContainer.FNS_CustomerIds();
                
                
                //loanObj.hostLoanNumber = (String) obj.get(namespace +'FNS_HostLoanNumber__c');
                loanObj.loanId = (String) obj.get(namespace +'FNS_FinancialAccountTransactionExtId__c');
                loanObj.effectiveDate = FNS_Util.convertDateTimeToString((DateTime) obj.get(namespace +'FNS_EffectiveDate__c'));
                loanObj.expiryDate = FNS_Util.convertDateTimeToString((DateTime) obj.get(namespace +'FNS_ExpiryDate__c'));
                loanObj.maturityDate = FNS_Util.convertDateTimeToString((DateTime) obj.get(namespace +'FNS_MaturityDate__c'));
                loanObj.productType = (String) obj.get(namespace +'FNS_LoanProductType__c');
                //API 1.0 chnages strats >>
                //loanObj.amount = (Decimal) obj.get(amountField);
                loanObj.requestedRate = 10.01;//Need Dynamic API 1.0 
                loanObj.amount = new FNS_ObjectContainer.FNS_Money();
                loanObj.amount.amount = (Decimal) obj.get(amountField);
                loanObj.amount.currencyCode = 'USD';//Need Dynamic API 1.0  //(Decimal) obj.get(amountField);//Temporary Hardcoded 
                if (UserInfo.isMultiCurrencyOrganization())
                {
                    //loanObj.amount.currencyCode = (String) obj.get(namespace +'CurrencyIsoCode' );  
                }                
                loanObj.purposeTypeId = (String)(obj.get(namespace +'FNS_LoanPurpose__c'));
                loanObj.originationTypeIndicator = 'N';
                if((String)(obj.get(namespace +'FNS_TermUnit__c')) == FNS_Constants.YEAR){
                    loanObj.termUnit = FNS_Constants.MONTH;
                    Integer termValue = Integer.valueOf((Decimal.valueof((String)obj.get(namespace +'FNS_Term__c'))));
                    loanObj.term = String.valueOf(termValue*12);
                }else {
                    loanObj.termUnit = FNS_Constants.MONTH;
                    loanObj.term = (String)(obj.get(namespace +'FNS_Term__c'));
                }
                loanWrapperList.add(loanObj);
            }
        }
        system.debug('@@ loanWrapper Obj ::' + loanWrapperList);
        return loanWrapperList;
    }
    
    /*************************************************************************************
* @description  Method to create FEE Wrapper for Application POST Request.
* @Params       List of Fee
* @Returns      List of wrapper class object
*************************************************************************************/
    public static List<FNS_ObjectContainer.FNS_Fee> createFeeWrapper(List<sObject> feeList){
        List<FNS_ObjectContainer.FNS_Fee> feeWrapperList = new List<FNS_ObjectContainer.FNS_Fee>();
        String baseNamespace = FNS_Util.getBasePackageNamepace();
        FNS_ObjectContainer.FNS_Fee feeObj;
        //FNS_ObjectContainer.FNS_FeeType feeTypeObj;
        if(feeList != null && !feeList.isEmpty()){
            for(sObject obj : feeList){
                feeObj = new FNS_ObjectContainer.FNS_Fee();
                //feeTypeObj = new FNS_ObjectContainer.FNS_FeeType();
                feeObj.feeTypeId = (String) obj.get(baseNamespace+'FNS_FeeType__c');
                //API 1.0 changes
                //feeObj.amount = (Decimal) obj.get(baseNamespace+'FNS_Amount__c');
                //feeObj.feeCurrency = (String) obj.get(baseNamespace+'FNS_CurrencyCode__c')    ;
                feeObj.accrualRate =  (Decimal) obj.get(baseNamespace+'FNS_FeeRate__c');
                //feeObj.feeType = feeTypeObj;
                feeWrapperList.add(feeObj);
            }
        }
        system.debug('########### feeWrapperList  '+feeWrapperList );
        return feeWrapperList;
    }
    
    /*************************************************************************************
* @description  Method to create Pricing Wrapper for Application POST Request.
* @Params       List of price
* @Returns      List of wrapper class object
*************************************************************************************/
    public static List<FNS_ObjectContainer.FNS_Pricing> createPricingWrapper(List<sObject> priceList){
        List<FNS_ObjectContainer.FNS_pricing> pricingList = new List<FNS_ObjectContainer.FNS_pricing>();
        FNS_ObjectContainer.FNS_pricing pricingObj;
        String baseNamespace = FNS_Util.getBasePackageNamepace();
        if(priceList != null && !priceList.isEmpty()){
            for(sObject sObj : priceList){
                pricingObj = new FNS_ObjectContainer.FNS_pricing();
                pricingObj.allInRate = (Decimal) sObj.get(baseNamespace+'FNS_AllInRate__c');
                pricingObj.baseRate = String.valueOf(sObj.get(baseNamespace+'FNS_BaseRate__c'));
                pricingObj.rateBasis = String.valueOf(sObj.get(baseNamespace+'FNS_RateBasis__c'));
                pricingObj.calcType = (String) sObj.get(baseNamespace+'FNS_CalcType__c');
                pricingObj.rateType = (String) sObj.get(baseNamespace+'FNS_RateType__c');
                pricingObj.spread = (Decimal) sObj.get(baseNamespace+'FNS_Spread__c');
                pricingObj.frequency = (String) sObj.get(baseNamespace+'FNS_Frequencies__c');
                pricingObj.pricingType = (String) sObj.get(baseNamespace+'FNS_PricingType__c');
                pricingList.add(pricingObj);
            }
        }
        system.debug('@@@ pricingWrapper  ::' + pricingList);
        return pricingList;
    }
    
    /*************************************************************************************
* @description  Method to create CustomerIds Wrapper for Application POST Request.
* @Params       List of relatedroles
* @Returns      List of wrapper class object
*************************************************************************************/
    public static FNS_ObjectContainer.FNS_CustomerIds createPrductCustomerIds(List<sObject> relatedRolesList ){
        FNS_ObjectContainer.FNS_CustomerIds customerWrapper = new FNS_ObjectContainer.FNS_CustomerIds();
        String baseNamespace = FNS_Util.getBasePackageNamepace();
        sObject sObj;
        
        String relatedAccField = '';
        String relatedRelAccField = '';
        String productRoleObjName = '';
        if(FNS_Util.isFSCInstalled){
            relatedAccField = 'FinServ__RelatedAccount__c';
            relatedRelAccField = 'FinServ__RelatedAccount__r';
            productRoleObjName = 'FinServ__FinancialAccountRole__c';
        }else {
            relatedAccField = baseNamespace +'FNS_RelatedAccount__c';
            relatedRelAccField  = baseNamespace +'FNS_RelatedAccount__r';
            productRoleObjName = baseNamespace +'FNS_FinancialAccountRole__c';
        }
        customerWrapper.BORROWER = new List<String>();
        customerWrapper.CO_BORROWER = new List<String>();
        customerWrapper.GUARANTOR = new List<String>();
        Map<String, String> pklstFldMap = FNS_Util.getPicklistFieldValueMap(productRoleObjName,baseNamespace+'FNS_ProductRelRole__c');
        if(relatedRolesList != null){
            for(sObject relatedObj : relatedRolesList){
                if(relatedObj.get(relatedAccField) != null){
                    sObj = relatedObj.getSobject(relatedRelAccField);
                    if(pklstFldMap.containsKey((String)relatedObj.get(baseNamespace+'FNS_ProductRelRole__c'))){
                        String pklstFldLbl = pklstFldMap.get((String)relatedObj.get(baseNamespace+'FNS_ProductRelRole__c'));
                        if(pklstFldLbl == FNS_Constants.BORROWER){
                            if(String.isNotBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')))){
                                customerWrapper.BORROWER.add(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')));
                            }else if(String.isBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c'))) && customerIdToExtIdMap.containsKey(String.valueOF(sObj.get('Id')))){
                                customerWrapper.BORROWER.add(customerIdToExtIdMap.get(String.valueOF(sObj.get('Id'))));
                            }
                        } else if(pklstFldLbl == FNS_Constants.CO_BORROWER){
                            if(String.isNotBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')))){
                                customerWrapper.CO_BORROWER.add(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')));
                            }else if(String.isBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c'))) && customerIdToExtIdMap.containsKey(String.valueOF(sObj.get('Id')))){
                                customerWrapper.CO_BORROWER.add(customerIdToExtIdMap.get(String.valueOF(sObj.get('Id'))));
                            }
                        }else if(pklstFldLbl == FNS_Constants.GUARANTOR){
                            if(String.isNotBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')))){
                                customerWrapper.GUARANTOR.add(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c')));
                            }else if(String.isBlank(String.valueOF(sObj.get(baseNamespace+'FNS_CustomerExtId__c'))) && customerIdToExtIdMap.containsKey(String.valueOF(sObj.get('Id')))){
                                customerWrapper.GUARANTOR.add(customerIdToExtIdMap.get(String.valueOF(sObj.get('Id'))));
                            }
                        }
                    }
                }
            }
        }
        system.debug('$$$$$$ customerWrapper ' + customerWrapper);
        return customerWrapper;
    }
    
    /*************************************************************************************
* @description  Method to push the Application record into FFDC and update external id on application.
* @Params       Application Id
* @Returns      none
*************************************************************************************/
    public static void pushApplicationToFFDC(String applicationId){
        try{
            system.debug('>>>pushApplicationToFFDC>>');
            fflib_ISObjectUnitOfWork uow;
            uow = new fflib_SObjectUnitOfWork(new List<Schema.SObjectType>{Account.SObjectType, Opportunity.sObjectType});
            
            if(applicationId != null) {
                Set<String> relatedOrgIds = getApplicationRelatedCustomers(applicationId);
                if(! relatedOrgIds.isEmpty() && relatedOrgIds != null){
                    customerIdToExtIdMap = FNS_OrganizationDomain.pushCustomerAndRelatedRecords(relatedOrgIds, bankExtId, uow);
                }
                String appJson = createApplicatonWrapper(new Set<ID>{(ID)(applicationId)});
                system.debug('Application Request>>>'+appJson);
                if(appJson != null){
                    FNS_IntegrationUtil.FNS_RequestParam param = new FNS_IntegrationUtil.FNS_RequestParam();
                    param.objectName = FNS_Constants.CLASS_APPLICATION;
                    param.endPoint = FNS_Constants.URL_APPLICATION;
                    param.methodName = FNS_Constants.METHOD_POST;
                    param.body = appJson;
                    
                    Map<String, String> headerMap = new Map<String, String>();
                    headerMap.put(FNS_Constants.CONTENT_TYPE, 'application/json');
                    param.headerMap = headerMap;
                    
                    FNS_JSONAPIRouter router = new FNS_JSONAPIRouter();
                    HttpResponse jsonResponse = router.getPostRequest(param);
                    system.debug('>>>Application Push Response>>>>'+jsonResponse);
                    if(jsonResponse.getStatusCode() == 200){
                        if (!String.isEmpty(jsonResponse.getBody())){
                            FNS_ApplicationPayload applicationResp = (FNS_ApplicationPayload )JSON.deserialize(jsonResponse.getBody(), FNS_ApplicationPayload.class);
                            system.debug('>>>applicationResp>>'+applicationResp.applicationId);
                            if(applicationResp != null){
                                List<Opportunity> applicationList; 
                                applicationList = new FNS_ApplicationSelector().selectById(new Set<Id>{applicationId});
                                if(applicationList != null){
                                    applicationList[0].FNS_ApplicationExtId__c = applicationResp.applicationId;
                                    applicationList[0].StageName = 'Initial Input'; // Temp hard coded
                                    uow.registerUpsert(applicationList);
                                    
                                }
                            }  
                        } 
                    }
                    FNS_ObjectAccessContainer.checkOpportunityAccess(FNS_AccessController.DML_OPERATION_UPDATE);
                    FNS_ObjectAccessContainer.checkAccountAccess(FNS_AccessController.DML_OPERATION_UPDATE);
                    
                    uow.commitwork();
                }
            }
        }
        catch (Exception ex)
        {
            logger.addLogRecord('FNS_ApplicationDomain', 'pushApplicationToFFDC', ex.getMessage() + ex.getStackTraceString());
        }        
    }
    
}