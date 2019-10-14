global with sharing class FNS_Constants {
   public static final String NEED_UREGENT_COLOR_CODE = 'RED';
   public static final String PAST_DUE_COLOR_CODE = 'YELLOW';
   public static final String ON_SCHEDULE_COLOR_CODE = 'GREEN';
   public static final String SANDBOX_LOGIN_URL = 'https://test.salesforce.com';
   public static final String PRODUCTION_LOGIN_URL = 'https://login.salesforce.com';
   public static final String TOKEN_URL = '/services/oauth2/token'; 
   public static final String AUTHORIZE_URL = '/services/oauth2/authorize';
   public static final String METHOD_GET = 'GET';
   public static final String METHOD_POST = 'POST'; 
   public static final String CONTENT_TYPE = 'content-type'; 
   public static final String CONTENT_TYPE_URLENCODED ='application/x-www-form-urlencoded';
   public static final String GRANT_TYPE_AUTH_CODE ='grant_type=authorization_code';
   public static final String GRANT_TYPE_CLIENT_CRED ='grant_type=client_credentials'; 
   public static final String CLIENT_ID = '&client_id=';
   public static final String CLIENT_SECRET = '&client_secret=';
   public static final String AUTHCODE = '&code='; 
   public static final String REDIRECT_URI = '&redirect_uri=';
   public static final String ENCODEUTF8 = 'UTF-8'; 
   public static final String RESPONSETYPE_CODE = '?response_type=code';
   public static final String STATE_MYSTATE ='&state=mystate';
   public static final String AUTHORIZATION = 'Authorization';
   public static final String BEARER = 'Bearer ';
   public static final String ACCEPT = 'accept';
   
   public static final String NUMBER_OF_LOAN = 'Number Of Loans';
   public static final String ACCOUNT_NAME = 'Account.Name';
   public static final String DATA_TYPE_STRING = 'STRING';
   public static final String DATA_TYPE_NUMBER = 'NUMBER';
   public static final String DATA_TYPE_CURRENCY = 'CURRENCY';
   public static final String DATA_TYPE_PERCENT = 'PERCENT';
   public static final String STR_SUCCESS = 'Success';
   public static final String STR_ACTIVE_DEALS = 'Active Deals';
   public static final String CLOSING_SOON_COLOR_CODE = '';
   public static final String STR_PROPOSAL_STAGE_VALUE = 'Proposal';
   public static final String STAGE_NAME = 'StageName';
   public static final String DEAL_NAME = 'Deal';
   public static final String USER_EXTERNALIDFORTESTCLASS = '100031';
   
   //Contact Phone Number Type.
   public static final String CONTACT_PHONE_TYPE_PRIMARY = 'PRIMARY';
   public static final String CONTACT_PHONE_TYPE_SECONDARY = 'SECONDARY';
   public static final String CONTACT_PHONE_TYPE_HOME = 'HOME';
   
   //Read only Record Type for Sobjects.
   public static final String OPPORTUNITY_READONLYRECORDTYPE =  'FNS_ApplicationReadOnly' ;
   public static final String PRODUCT_READONLYRECORDTYPE =  'FNS_FinancialAccountReadOnly' ;
   public static final String LOAN_READONLYRECORDTYPE =  'FNS_FinancialAccountTransactionReadOnly' ;
   public static final String PRICING_READONLYRECORDTYPE =  'FNS_PricingReadOnly' ;
   public static final String FEE_READONLYRECORDTYPE =  'FNS_FeeReadOnly' ;
   
    //Editable Record Type for Sobjects.
   public static final String OPPORTUNITY_EDITABLERECORDTYPE =  'FNS_Application' ;
   public static final String PRODUCT_EDITABLERECORDTYPE =  'FNS_FinancialAccount' ;
   public static final String PRODUCT_ROLE_EDITABLERECORDTYPE =  'FNS_FinancialAccountRole' ;
   public static final String LOAN_EDITABLERECORDTYPE =  'FNS_FinancialAccountTransaction' ;
   public static final String PRICING_EDITABLERECORDTYPE =  'FNS_Pricing' ;
   public static final String FEE_EDITABLERECORDTYPE =  'FNS_Fee' ;
   public static final String YEAR =  'Year' ;
   public static final String MONTH =  'Month' ;
   
   
   public static final String APP_STAGEREADONLY =  'Submitted to Underwriting' ;
   
   //officerRole
   public static final String PRIMARYOFFICER = 'Primary' ;
   public static final String PRIMARYOWNER = 'Primary Owner' ;
   public static final String SECONDARYOFFICER = 'Secondary' ;
   public static final String TERTIARYOFFICER = 'Tertiary' ;
   
   //Related Role
   public static final String BORROWER = 'Borrower' ;
   public static final String GUARANTOR = 'Guarantor' ;
   public static final String CO_BORROWER = 'Co_Borrower' ;

   public static final String METHOD_PUT ='PUT'; //Kavya - for put call
   public static final String NOCONFIGDATA = 'noConfigData';
   public static final String STR_FAILURE = 'Failure';
   public static final String CURRENT = 'Current';
   public static final String COMPLETED = 'Completed';
   public static final String PENDING = 'Pending';
   public static final String YOU = 'You'; 
   public static final String LEADS = 'Leads';
   public static final String USERID = 'UserId';
   public static final String APPLICATION_JSON = 'application/json';
   public static final String DOCUMENT_UPLOAD_CONTENT_TEXT = '/content';
   public static final String DOCUMENT_UPLOAD_CONTENT_TYPE = '[multipart/form-data]';
   public static final String DOCUMENT_RETRIEVE_FILENAME = 'Document';
   public static final String DOCUMENT_RETRIEVE_PATHONCLIENT = 'Application.txt';
   public static final String SYSTEMADMINISTRATOR = 'System Administrator'; 
   public static final String ADMIN = 'ADMIN'; 
   public static final String NOTADMIN = 'NOT ADMIN'; 
    
   public static final String CONFIG_DMLTYPE_INSERT = 'INSERT';
   public static final String CONFIG_DMLTYPE_UPDATE = 'UPDATE';
   public static final String DATAACCESSURL = 'DataAccessURL';
   
   public static final String CLASS_APPLICATION = 'Applications';
   public static final String CLASS_BANKS = 'Banks';
   public static final String CLASS_CONFIGURATION_DATA = 'ConfigurationData';
   public static final String CLASS_FEE_TYPES = 'FeeTypes';
   public static final String CLASS_PREDICTIVE_ANALITICS = 'PredictiveAnalytics';
   public static final String CLASS_PROCESS_CENTERS = 'ProcessCenters';
   public static final String CLASS_PROCESS_GROUPS = 'ProcessGroups';
   public static final String CLASS_PRODUCT_TYPES = 'ProductTypes';
   public static final String CLASS_QUEUE_ACTIVITIES = 'QueueActivities';
   public static final String CLASS_USER_PROFILES = 'UserProfiles';
   public static final String CLASS_WORKFLOW_CONFIGURATIONS = 'WorkflowConfigurations';
   public static final String CLASS_ORGANIZATIONS = 'Organizations';
   public static final String CLASS_TRACKING_ITEMS = 'TrackingItems';
   public static final String CLASS_DOCUMENT_UPLOAD = 'DocumentUpload'; 

   public static final String CONFIG_API_TYPE = 'configuration/';
   public static final String CREDIT_API_TYPE = 'credit-agreement/';
   public static final String CUST_API_TYPE = 'customer/';
   public static final String WORKFLOW_API_TYPE = 'workflow-process/';
   public static final String ORIGINATION_API_TYPE = 'analytics/';

   //API 1.0 changes
  // public static final String URL_ACTIVE_DEAL_API_EXTENSION = '/officer-application-summary';
   public static final String URL_ACTIVE_DEAL_API_EXTENSION = 'summary?officerId=';
   public static final String URL_APPLICATION = 'FNS_ApplicationAPI';
   public static final String URL_TRACKING_ITEMSAPI = 'FNS_TRACKINGITEMSAPI';
   public static final String URL_UPLOADDOCUMENTS = 'FNS_DocumentUploadAPI';
   public static final String URL_APPLICATION_URL = 'applications/';
   public static final String URL_BANKS = 'FNS_BanksAPI';
   public static final String URL_CONFIGURATION_DATA = 'FNS_ConfigurationDataAPI';
   public static final String URL_FEE_TYPES = 'FNS_FeeTypeAPI';
   public static final String URL_PREDICTIVE_ANALITICS = 'FNS_PredictiveAnalyticsAPI';
   public static final String URL_PROCESS_CENTERS = 'FNS_ProcessCenterAPI';
   public static final String URL_PROCESS_GROUPS = 'FNS_ProcessGroupAPI';
   public static final String URL_PRODUCT_TYPES = 'FNS_ProductTypeAPI';
   public static final String URL_QUEUE_ACTIVITIES = 'FNS_QueueActivitiesAPI';
   public static final String URL_USER_PROFILES = 'FNS_UserProfilesAPI';
   public static final String URL_WORKFLOW_CONFIGURATIONS = 'FNS_WorkflowConfigurationAPI';
   public static final String URL_QUEUE_ACTIVITIES_BY_APPLICATION = '/queue-activities';
   public static final String URL_QUEUE_ACTIVITIES_ROUTE = 'route';
   //public static final String URL_ORGANIZATIONS = 'customer/organizations';
   public static final String URL_ORGANIZATIONS = 'FNS_OrganizationAPI';
   public static final String URL_TRACKING_ITEMS = 'tracking-items/';
   public static final String URL_DOCUMENT_UPLOAD = 'documents';
   public static final String URL_CONFIGURATION_DATA_GLOBALPICKLIST = '/services/data/v41.0/tooling/sobjects/GlobalValueSet';
   public static final String URL_CONFIGURATION_DATA_FETCH_GLOBALPICKLISTID = '/services/data/v41.0/tooling/query/?q=select+id+from+globalvalueset+where+MasterLabel=';
   public static final String URL_HTTPPATCH = 'HttpMethod=PATCH';
   public static final String DISPOSITIONCONFIG = 'DISPOSITION';
   public static final String URL_DOCUMENTUPLOAD = 'workflow-process/documents/';
   public static final String CUSTOMER_PUSH_HEADER = 'x-userid';
   public static final String GLOBAL_FEETYPE_PICKLIST = 'FeeType';
   public static final String GLOBAL_PRODUCTTYPE_PICKLIST = 'ProductType';

   public static final String API_RESPONSE = 'ApiResponse';
   public static final String API_EMPTY = 'Empty';
   public static final String API_ERROR = 'Error';
   public static final String DISPOSITION = 'DISPOSITION';

   public static final String LOAN_NONFSCOBJECTNAME = 'FNS_FinancialAccountTransaction__c';
   public static final String LOAN_FSCOBJECTNAME = 'FinServ__FinancialAccountTransaction__c' ;
   
   //public static final String COMPLETED = 'Completed';
   public static final String REJECTED = 'Rejected';
   public static final String DEFAULT_CURRENCY = 'USD';

   public static final String VERSION_NUMBER = 'VERSION_NUMBER';
   public static final String MASTER_LABEL = 'Masterlabel';
   public static final String REFRESH_TOKEN = 'refresh_token';
   public static final String SYSTEM_ADMINISTRATOR = 'System Administrator';
}