/*****************************************************************************************
* @description This class is used to perform DML using json for an Application.
* @author Sameer Chaudhari
* @date 13/03/2019
* @Support Email Sameer@comitydesigns.com
******************************************************************************************/

public with sharing class FNS_ObjectContainer {
    public list<FNS_QueueActivityRoute> queueActivitiesList;
    public list<FNS_ApplicationSummary> applicationSummariesList;
    public list<FNS_Bank> banksList;
    public list<FNS_FeeType> feeTypesList;
    public list<FNS_ProcessCenter> processCentersList;
    public list<FNS_ProductType> productTypesList;
    public list<FNS_ProcessGroup> processGroupsList;
    public list<FNS_PICKLISTTYPE> configurationDataList;
    public list<FNS_TrackingItem> trackingItemsList;
    public list<FNS_UserProfile> userProfilesList;
    public list<FNS_Trackingdocs> documentsList ; // API 1.0 changes

    //Keerthi - GlobalPicklist records
    public with sharing class FNS_GLOBALPICKLIST{
        public Integer size;
        public Integer totalSize;
        public Boolean done;
        public Object queryLocator;
        public String entityTypeName;
        public List<Records> records;
    }
    
    public with sharing class Records {
        public Attributes attributes;
        public String Id;
    }
    
    public with sharing class Attributes {
        public String type_Z {get;set;} // in json: type
        public String url {get;set;} 
    }
    
    //Keerthi - Bank Details
    public with sharing class FNS_Bank{        
        public String bankId; // FNS_Bank__c -> FNS_BankExternalId__c
        public String bankName; // FNS_Bank__c -> FNS_BankName__c
        public String value; // FNS_Bank__c -> FNS_BankValue__c
        public String bankNumber; // FNS_Bank__c -> FNS_BankNumber__c
        public String governingState; // FNS_Bank__c -> FNS_GoverningState__c
        public String regionNumber; // FNS_Bank__c -> FNS_RegionNumber__c
        public String branch; // FNS_Bank__c -> FNS_Branch__c
        public String rcNumber; // FNS_Bank__c -> FNS_RCNumber__c
        public List<FNS_Regions> regions; //TODO
    }
    //Keerthi - Bank Details - TODO
    public with sharing class FNS_Regions {
        public List<FNS_Branch> branches;
        public String regionDescription;
        public String regionId;
    }
    //Keerthi - Bank Details - TODO
    public with sharing class FNS_Branch {
        public String branchCountry;
        public String branchDescription;
        public Integer branchId;
        public String branchNumber;
    }
    //Keerthi - FeeType Details
    public with sharing class FNS_FeeType{
        //public currencyType; //TODO
        //public FNS_defaultAmount defaultAmount; //TODO
        public String description; // FNS_FeeType__c -> FNS_Description__c
        public String feeTypeId; // FNS_FeeType__c -> FNS_FeeTypeExternalId__c
    }
    //Keerthi - ProcessCenterDetails
    public with sharing class FNS_ProcessCenter{
        public String state; // FNS_ProcessCenter__c -> FNS_State__c
        public String processCenterName; // FNS_ProcessCenter__c -> FNS_ProcessCenterExtId__c
        public String processCenterNumber; // FNS_ProcessCenter__c -> FNS_ProcessCenterNumber__c
        public String streetNumber; // FNS_ProcessCenter__c -> FNS_StreetNumber__c
        public String streetName; // FNS_ProcessCenter__c -> FNS_StreetName__c
        public String addressLine1; // FNS_ProcessCenter__c -> FNS_AddressLine__c
        public String city; // FNS_ProcessCenter__c -> FNS_City__c
        public String county; // FNS_ProcessCenter__c -> FNS_County__c
        public String zip; // FNS_ProcessCenter__c -> FNS_Zip__c
        public String processCenterId; // FNS_ProcessCenter__c -> FNS_ProcessCenterExtId__c
    }
    //Keerthi - ProcessGroupDetails
    public with sharing class FNS_ProcessGroup{
        public String description; // FNS_ProcessGroup__c -> FNS_Description__c
        public String nextDefaultProcessGroupId; // FNS_ProcessGroup__c -> FNS_NextDefaultProcessGroupId__c
        public String inactiveIndicator; // FNS_ProcessGroup__c -> FNS_InactiveIndicator__c
        public String processGroupId; //  FNS_ProcessGroup__c ->FNS_ProcessGroupExtId__c
    }
    //Keerthi - ProcessGroupDetails
    public with sharing class FNS_ProductType{
        public String description;// FNS_ProductType__c -> FNS_Description__c
        public String hierarchyIndicator;// FNS_ProductType__c -> FNS_HierarchyIndicator__c
        public String productTypeId;//FNS_ProductType__c -> FNS_ProductTypeExternalId__c
    }
    
    //Keerthi - User Profile details
    public with sharing class FNS_UserProfile{
        public String defaultActivity;
        public String email; //required
        public String firstName;
        public String initials;
        public String bankId; //required
        public String lastName;
        public String middleInitial;
        public String phone;
        public Boolean systemUserIndicator;
        public String officerNumber;
        public Boolean officerIndicator; //required
        public String systemType; //required
        public String userProfileId; //required
        public List<String> alternateProcessCentersId;
        public String processGroupId; //required     
        public List<String> branchIds;
    }
    
    //Keerthi - START - Configuration Wrapper
    public with sharing class FNS_Configuration{
        public List<FNS_PICKLISTTYPE> STRUCTURE {get;set;}
        public List<FNS_PICKLISTTYPE> CONFIG_CURRENCY {get;set;}
        public List<FNS_PICKLISTTYPE> TRACKING_ITEM_STATUS {get;set;}
        public List<FNS_PICKLISTTYPE> STATE {get;set;} 
        public List<FNS_PICKLISTTYPE> SUBMISSION_REQUIREMENT_STATUS {get;set;} //
        public List<FNS_PICKLISTTYPE> OFFICIAL_TYPE {get;set;}
        public List<FNS_PICKLISTTYPE> DISPOSITION {get;set;}
        public List<FNS_PICKLISTTYPE> ROLE {get;set;} 
        public List<FNS_PICKLISTTYPE> DOCUMENT_PRIORITY {get;set;} //
        public List<FNS_PICKLISTTYPE> POLICY_EXCEPTION_STATUSES {get;set;} //
        public List<FNS_PICKLISTTYPE> DOCUMENT_STATUS {get;set;}
        public List<FNS_PICKLISTTYPE> PRICING_TYPE {get;set;}
        public List<FNS_PICKLISTTYPE> FREQUENCY {get;set;}
        public List<FNS_PICKLISTTYPE> PURPOSE {get;set;}
        public List<FNS_ObjectContainer.FNS_PICKLISTTYPE> ENTITY_RELATION {get;set;}
        public List<FNS_ObjectContainer.FNS_PICKLISTTYPE> REPAY_TYPE {get;set;}
    }
    
    public with sharing class FNS_PICKLISTTYPE{
        public String configurationDataId;
        public String configurationDataType;
        public String description;
        public String value;
        public String systemId;
        public String systemOrder;
    }
    //Keerthi - END - Configuration Wrapper
    
        
    //Kavya -for predictive analytics 
    public with sharing class FNS_PredictiveAnalytics {
        public Integer recommendationId {get;set;}  //FNS_PredictiveAnalytics__c -> FNS_RecommendationId__c
        public String borrowerId {get;set;} //FNS_PredictiveAnalytics__c -> FNS_Customer__c
        public String borrowerName {get;set;}  //FNS_PredictiveAnalytics__c -> FNS_CustomerName__c
        public String facilityId {get;set;}  //FNS_PredictiveAnalytics__c -> FNS_FinancialAccount__c
        public String facilityName {get;set;}  //FNS_PredictiveAnalytics__c -> FNS_FinancialAccountName__c
        public String loanId {get;set;} //FNS_PredictiveAnalytics__c -> FNS_FinancialAccountTransaction__c
        public String loanName {get;set;} //FNS_PredictiveAnalytics__c -> FNS_FinancialAccountTransactionName__c
        public String recommendationDescription {get;set;} //FNS_PredictiveAnalytics__c -> FNS_RecommendationDescription__c
        public String recommendation {get;set;} //FNS_PredictiveAnalytics__c -> FNS_Recommendation__c
        public String priorityOrder {get;set;} //FNS_PredictiveAnalytics__c -> FNS_PriorityOrder__c
    }
    //Kavya- to retrieve and route queue activities for an application

    public with sharing class FNS_QueueActivityRoute{
        public String queueActivityId {get;set;} 
        public String applicationId {get;set;} 
        public String activityId {get;set;} 
        public String processCenterId {get;set;} 
        public String processJobId {get;set;} 
        public String processGroupId {get;set;} 
        public String completionDate {get;set;} 
        public String completedByUserId {get;set;} 
        public String userId {get;set;} 
        public String createdByUserId {get;set;} 
        public String completionTime {get;set;} 
        public String dueDate {get;set;} 
        public String dueTime {get;set;} 
        public String note {get;set;} 
        public Integer sequenceNumber {get;set;} 
        public String startDate {get;set;} 
        public String startTime {get;set;} 
        public String jobDueDate {get;set;} 
        public String groupDueDate {get;set;} 
        public Boolean stopClockIndicator {get;set;} 
        public Decimal numHours {get;set;} 
        public String hostSystemInternalIdentifier {get;set;} 
        public String legalBookNumber {get;set;} 
        public String creationDate {get;set;} 
        public String slaPercentage {get;set;} 
        public String slaIndicator {get;set;} 
        public Boolean current {get;set;} 
    }
    public with sharing class FNS_Pricing {
        public Decimal allInRate;
        public String baseRate;
        public String rateBasis;
        public String calcType;
        public String rateType;
        public Decimal spread;
        public String frequency;
        public String pricingType;

        //API 1.0 changes
        public String lineOfCreditId;
        public String pricingId;
    }
    
    
    public with sharing class FNS_Loan{
        public String accountID;
        public String LoanId;
     // API 1.0 changes
     // public Decimal amount;
     // public String currencyCode;
        public FNS_Money amount;
        public FNS_CustomerIds customerIds ;

        public Decimal previousAmount;
                
        public String effectiveDate;
        public String expiryDate;
        public String maturityDate;
        public List<FNS_Fee> fees;
        public String hostLoanNumber;
        public List<FNS_pricing> pricing;
        public String purposeTypeId;
        public String originationTypeIndicator; 
        public String paymentType;
        public String paymentFrequencyId; 
        public String productType; 
        public String loanPurpose;
        public String term;
        public String termUnit ;
        public decimal requestedRate;
    }
    
    public with sharing class FNS_Customers{
        public String customerId;
        public String fullName;
        public List<FNS_Address> addresses;
        public List<FNS_Contact> contacts;
        public List<FNS_ExternalSystemIdentifier> externalSystemIdentifiers;
        public List<FNS_TaxDetails> taxDetails ;
        public String taxPayerId;
        public String type_Z;
        public String title;
        public String customerDescription;
        public List<FNS_CreditInformation> creditInformations; //Application Flow
        public FNS_GovernmentIdentifier governmentIdentityNumber; //Application Flow
        public FNS_ProfileDetails beneficiaryProfile; //Application Flow
        public FNS_ProfileDetails borrowerProfile; //Application Flow
        public FNS_ProfileDetails guarantorProfile; //Application Flow
        public List<FNS_Details> obligorNumbers; //Application Flow
    }
    
    public with sharing class FNS_Contact{
        public String department;
        public String fullName;
        public String title;
        public List<FNS_Phone> primaryBusinessPhone ;
        public List<FNS_Phone> phoneList; //Application Flow
        public FNS_GovernmentIdentifier governmentIdentityNumber;
        public String primaryBusinessEmail;//Application Flow
        public String contactType;
    }
    
    public with sharing class FNS_ExternalSystemIdentifier {
        public String identityNumer;
        public String identityType;
    }
    
    public with sharing class FNS_GovernmentIdentifier {
        public String identityNumer;
        public String identityType;
    }
    
    public with sharing class FNS_TaxDetails {
        public String objectId;
        public String description;
        public String taxCountry;
        public String taxExemptCode;
        public String taxNumber;
        public String taxPayerId;
        public String taxRegion;
        public String taxType;
    }
    
    public with sharing class FNS_Phone {
        public String phoneNumber;
        public String phoneType;
    }
    
    public with sharing class FNS_Activity{
        public String activityId;
        public String description;
    }
    
    public with sharing class FNS_ConfigurationData{
        public String configurationDataId;
        public String description;
        public String type_Z;
    }
    
    public with sharing class FNS_DefaultAmount {
        public Double amount;
        public String currencyCode;
    }
    
    public with sharing class FNS_Fee {
        public double  accrualRate;
      //API 1.0 changes        
      //public double amount;
      //public String feeCurrency;

        public FNS_Money feeAmount;
        public String feeCurrency;
        public String uiFeeType;
        public String feeTypeId;
        public FNS_FeeType feeType;
    }
    
    public with sharing class FNS_Address {
        public String addressType;
        public String city;
        public String country;
        public String postalCode;
        public String postalCodeExtension;
        public String province;
        public String state;
        public String street1;
        public String street2;
        public String street3;
        public String houseNumber;
    }
    
    //Praneeth for Authentication -- FFDC
    public with sharing class FNS_Authentication {
        public String access_token;
        public String refresh_token;
        public Integer expires_in; 
        public Integer refresh_expires_in; 
        public String scope;
        
    }
    
    // Praneeth for Tracking Items 
    public with sharing class FNS_TrackingItem {
        public String trackingItemId;//Activity -  - FNS_TrackingItemExtId__c
        public String applicationId;//Activity - FNS_ApplicationId__c
        public String slaIndicator;//Activity- FNS_SLAIndicator__c
        public String comments;//Activity - FNS_Comments__c
        public String  dueDate;//Activity - FNS_DueDate__c
        public String description;//Activity - description
        public String trackStatusId;//Activity -FNS_TrackStatusId__c
        public String sequence;//Activity - FNS_Sequence__c
        public String notes;//Activity - FNS_Notes__c
        public List<String> collateralIds;// TODO
        public String  creationDate;//Activity - FNS_CreationDate__c
        public List<String> userIds;// Activity - FNS_UserExtId__c
        public List<String> customerIds;
        public boolean isActive;//Activity - FNS_IsActive__c
        public boolean isCSA;//Activity - FNS_IsCSA__c
        public boolean isChecklist;//Activity - FNS_IsCheckList__c
        public boolean isStandard;//Activity - FNS_IsStandard__c
        public boolean isVerified;//Activity - FNS_IsVerified__c
        public boolean keepOnRefresh;//Activity - FNS_KeepOnRefresh__c
        public List<String> linesOfCreditId; ////Activity - FNS_FinancialProductId__c
        public List<String> loanIds;// TODO
        public String pkgId; //Activity - FNS_PkgId__c
        public String primaryRelationship; // Activity - FNS_PrimaryRelationship__c
        public Integer printStatusId;//Activity - FNS_PrintStatusId__c
        public Integer priorityId;//Activity - FNS_PriorityId__c
        public boolean refresh;//Activity - FNS_Refresh__c
        public String slaPercentage;//Activity - FNS_SLAPercentage__c
        public String priority;// Not being used
    }
    
    // Praneeth for Tracking Docs 
    public with sharing class FNS_Trackingdocs {//Praneeth - TODO
        public String applicationId;
        public Integer collateralId;
        public String contentAddedDate;
        public String contentDirectory;
        public String covenantTrackingId;
        public String crwId;
        public Boolean csa;
        public String customerId;
        public String description;
        public String documentId;
        public String documentType;
        public String externalDocumentId;
        public Integer loanId;
        public Integer printOrderId;
        public Integer statusId;
        public Boolean systemAdded;
        public String trackingItemId;
        public Integer userId;
        public Boolean visible;
    }
    
    public with sharing class FNS_FinAccountRole {
        public String guaranteeDollar;
        public String guaranteePercent;
        public String loanId;
        public String FinacialAccount;
        public String productRelationshipRole;
        public String typeOfProductRole;
        public String relatedAccount;
        public String relatedContact;
        public String role;
        public String sourceSystemId;
        public String startDate;
        public String endDate;
    }
    
    //Application Flow
    public with sharing class FNS_CreditInformation {
        public String informationStatement;
        public String informationType;
    }
    
    public with sharing class FNS_ProfileDetails{
        public String creditComment;
        public String creditReviewDate;
        public String profileType;
    }
    
    public with sharing class FNS_Details{
        public String code;
        public String name;        
    }
    
    public with sharing class FNS_Officer{
        public String officerDescription;
        public String officerId;
    }
    
    public with sharing class FNS_CustomerIds{
        public List<String> BORROWER;
        public List<String> CO_BORROWER;
        public List<String> GUARANTOR;
    }
    
    public with sharing class FNS_QueueActivity {
        public FNS_Activity activity;
        public Integer activityId;
        public Integer applicationId;
        public FNS_ApplicationSummary applicationSummary;
        public Integer completedByUserId;
        public String completionDate;
        public String completionTime;
        public FNS_UserProfile completionUser;
        public Integer createdByUserId;
        public String creationDate;
        public FNS_UserProfile creationUser;
        public String dueDate;
        public String dueTime;
        public String groupDueDate;
        public String jobDueDate;
        public String legalBookumber;
        public String note;
        public Integer numHours;
        public String obligorNumber;  
        public FNS_ProcessCenter processCenter;
        public Integer processCenterId;
        public FNS_ProcessGroup processGroup;
        public Integer processGroupId;
        public FNS_ProcessJob processJob;
        public Integer processJobId;
        public Integer queueId;
        public Integer sequenceNumber;
        public String slaIndicator;
        public Double slaPercentage;
        public String startDate;
        public String startTime;
        public Boolean stockClockIndicator;
        public FNS_UserProfile user;
        public Integer userId;
        
    }
    
    public with sharing class FNS_ApplicationSummary{
        public String applicationId;
        public String bankId;
        public String startDate;
        public String dispositionId;
       // API 1.0 changes
        public FNS_Money applicationAmount;
     // public Double applicationAmount;
    //  public String applicationCurrencyCode;
        public String applicationBankName;
        public String borrowerId;
        public String borrowerName;
        public String closingDate;
        public String activitySLA;
        
    }

     //API 1.0 changes
    public with sharing class FNS_Money{
        public decimal amount;
        public string currencyCode;
        public Decimal fxRate;       
    }
    
    public with sharing class FNS_ProcessJob {
        public String type_Z;
        public String description;
        public Object value {get;set;} 
        public Integer configurationDataId;
    }
    
    public with sharing class FNS_Disposition {
        public String configurationDataType {get;set;} // in json: type
        public String description {get;set;} 
        public Object value {get;set;} 
        public Integer configurationDataId {get;set;} 
    }    
    
    public with sharing class FNS_Priority {
        public String type {get;set;} 
        public String description {get;set;} 
    }
    
    
    public with sharing class FNS_Application {
        public FNS_Activity activity;
        public Integer activityId;
        public Integer applicationId;
        public FNS_ApplicationSummary applicationSummary;
        public Integer completedByUserId;
        public String completionDate;
        public String completionTime;
        public FNS_UserProfile completionUser;
        public Integer createdByUserId;
        public String creationDate;
        public FNS_UserProfile creationUser;
        public String dueDate;
        public String dueTime;
        public String groupDueDate;
        public String jobDueDate;
        public String legalBookumber;
        public String note;
        public Integer numHours;
        public String obligorNumber;
        public FNS_ProcessCenter processCenter;
        public Integer processCenterId;
        public FNS_ProcessGroup processGroup;
        public Integer processGroupId;
        public FNS_ProcessJob processJob;
        public Integer processJobId;
        public Integer queueId;
        public Integer sequenceNumber;
        public String slaIndicator;
        public Double slaPercentage;
        public String startDate;
        public String startTime;
        public Boolean stockClockIndicator;
        public FNS_UserProfile user;
        public Integer userId;
        
    }
    
    public with sharing class FNS_CustomerIdsDecimal{
        public List<Decimal> BORROWER;
        public List<Decimal> CO_BORROWER;
        public List<Decimal> GUARANTOR;
    }
    
    
}