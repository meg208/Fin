/***************************************************************************************
* @description Class This class is to fetch referral data for Relationship Manager
* @author Keerthi Kambhampati
* @date 02/21/2019
* @Support Email Keerthi@comitydesigns.com
****************************************************************************************/
public with sharing class FNS_ReferralsService {
    
    public static FNS_ErrorLog logger = new FNS_ErrorLog();
    
    
    /***********************************************************************************
* @description  Method to identify the list view on given object.
* @Params    null
* @Returns   List<ListView> on a given object.
* @author    Keerthi@comitydesigns.com
* @throws    null
**************************************************************************************/ 
    @AuraEnabled
    public static List<ListView> getListViews() {
        List<ListView> listviews; 
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        Map<Id, String> maplistview = new Map<Id, String>(); 
        
        String fieldSetName = '';
        
        fieldSetName = namespace + 'AllOpenLeads';
        try {
            listviews = new FNS_ListViewsSelector().selectByName('Lead', new Set<String>{fieldSetName});
        } catch(Exception ex){
            logger.addLogRecord('FNS_ReferralsService', 'getListViews', ex.getMessage() + ex.getStackTraceString());
        }   
        
        return listviews;
    }
    
    /***********************************************************************************
* @description Wrapper class used to display Lead and related contact records 
* @Params    null
* @Returns   null
* @author    Keerthi@comitydesigns.com
* @throws    null
**************************************************************************************/ 
    public with sharing class LeadWrapper{
        String LeadId;
        String LeadName;
        String LeadCompany;
        String LeadPhone;
        String LeadStatus;
        String LeadEmail;
        DateTime LeadCreatedDate;
        String ContactId;
        String ContactName;        
        String ContactPhone;
        String ContactEmail;
        String ContactTitle;
    }
    
    /***********************************************************************************
* @description Wrapper class used to display Lead with Contacts and other parameters
* @Params    null
* @Returns   null
* @author    Keerthi@comitydesigns.com
* @throws    null
**************************************************************************************/
    
    public with sharing class LeadDetailsWrapper {
        Integer leadListLength = 0;
        Boolean displayViewDetails = false;
        String referralsDynamicTitle = '';
        List<LeadWrapper> leadWrapperList = new List<LeadWrapper>();
    }
    
    /******************************************************************************************
* @description  Method to display Lead details with Internal / External referral contacts
* @Params    null
* @Returns   List of wrapper class of Lead and associated contacts
* @author    Keerthi@comitydesigns.com
* @throws    null
********************************************************************************************/ 
    @AuraEnabled
    public static Object getReferralsForRelationshipManager(String filterCondition){
        Map<String, Object> objValue = new Map<String, Object> {
            FNS_Constants.API_RESPONSE => FNS_Constants.API_EMPTY,
            FNS_Constants.API_ERROR => FNS_Constants.API_EMPTY
            };
                    
        LeadDetailsWrapper leadDetailsWrapper = new LeadDetailsWrapper();
        List<LeadWrapper> leadWrapperFinalList = new List<LeadWrapper>();
        
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        string extNamespace= FNS_Util.getExtensionPackageNamespace();
        string namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
        
        try {
            FNS_ReferralsSelector fnsReferrals = new FNS_ReferralsSelector();            
            List<Lead> leadsList = fnsReferrals.getReferralsForRM(filterCondition);             
            List<LeadWrapper> leadWrapperList = new List<LeadWrapper>();
            for(Lead leadRecord : leadsList){ 
                LeadWrapper leadWrapper = new LeadWrapper();
                leadWrapper.LeadId = String.valueOf(leadRecord.Id);
                leadWrapper.LeadName = leadRecord.Name;
                leadWrapper.LeadCompany = leadRecord.Company;
                leadWrapper.LeadStatus = leadRecord.Status;
                leadWrapper.LeadPhone = leadRecord.Phone;
                leadWrapper.LeadEmail = leadRecord.Email;
                leadWrapper.LeadCreatedDate = (DateTime)leadRecord.CreatedDate;
                if(FNS_Util.isFSCInstalled){
                    if((String)leadRecord.get('FinServ__ReferredByUser__c') != null){
                        leadWrapper.ContactId =  (String)leadRecord.getSobject('FinServ__ReferredByUser__r').get('Id'); 
                        leadWrapper.ContactEmail = (String)leadRecord.getSobject('FinServ__ReferredByUser__r').get('Email');
                        leadWrapper.ContactPhone = (String)leadRecord.getSobject('FinServ__ReferredByUser__r').get('Phone');
                        leadWrapper.ContactName = (String)leadRecord.getSobject('FinServ__ReferredByUser__r').get('Name');
                        leadWrapper.ContactTitle = (String)leadRecord.getSobject('FinServ__ReferredByUser__r').get('Title');
                    } else if((String)leadRecord.get('FinServ__ReferredByContact__c') != null){                         
                        leadWrapper.ContactId =  (String)leadRecord.getSobject('FinServ__ReferredByContact__r').get('Id'); 
                        leadWrapper.ContactEmail = (String)leadRecord.getSobject('FinServ__ReferredByContact__r').get('Email');
                        leadWrapper.ContactPhone = (String)leadRecord.getSobject('FinServ__ReferredByContact__r').get('Phone');
                        leadWrapper.ContactName = (String)leadRecord.getSobject('FinServ__ReferredByContact__r').get('Name');
                        leadWrapper.ContactTitle = (String)leadRecord.getSobject('FinServ__ReferredByContact__r').get('Title');
                    } else {                        
                        leadWrapper.ContactName='You';
                    }
                } else {
                    if((String)leadRecord.get(namespace +'FNS_InternalReferrer__c') != null){
                        leadWrapper.ContactId =  (String)leadRecord.get(namespace +'FNS_InternalReferrer__c');
                        leadWrapper.ContactEmail = (String)leadRecord.getSobject(namespace +'FNS_InternalReferrer__r').get('Email');
                        leadWrapper.ContactPhone = (String)leadRecord.getSobject(namespace +'FNS_InternalReferrer__r').get('Phone');
                        leadWrapper.ContactName = (String)leadRecord.getSobject(namespace +'FNS_InternalReferrer__r').get('Name');
                        leadWrapper.ContactTitle = (String)leadRecord.getSobject(namespace +'FNS_InternalReferrer__r').get('Title');
                    }
                    else if((String)leadRecord.get(namespace +'FNS_ExternalReferrer__c') != null){
                        leadWrapper.ContactId =  (String)leadRecord.get(namespace +'FNS_ExternalReferrer__c'); 
                        leadWrapper.ContactEmail = (String)leadRecord.getSobject(namespace +'FNS_ExternalReferrer__r').get('Email');
                        leadWrapper.ContactPhone = (String)leadRecord.getSobject(namespace +'FNS_ExternalReferrer__r').get('Phone');
                        leadWrapper.ContactName = (String)leadRecord.getSobject(namespace +'FNS_ExternalReferrer__r').get('Name');
                        leadWrapper.ContactTitle = (String)leadRecord.getSobject(namespace +'FNS_ExternalReferrer__r').get('Title');
                    } else {
                        leadWrapper.ContactName='You';
                    }
                }
                
                if(leadWrapper.ContactName != null){
                    leadWrapperList.add(leadWrapper);
                }
                
                leadDetailsWrapper.leadListLength = leadWrapperList.size();
                
                if(leadWrapperList.size() > 5){
                    for(Integer i = 0; i < 5; i++){
                        leadWrapperFinalList.add(leadWrapperList[i]);
                    }
                    leadDetailsWrapper.leadWrapperList = leadWrapperFinalList;
                    leadDetailsWrapper.displayViewDetails = true;
                } else {
                    leadDetailsWrapper.leadWrapperList = leadWrapperList;
                }                               
            }
            
            if(!leadWrapperList.isEmpty() && leadWrapperList.size() > 0 ){
                leadDetailsWrapper.referralsDynamicTitle = 'Leads ('+leadWrapperList.size()+')';
            }
            objValue.put(FNS_Constants.API_RESPONSE,JSON.serialize(leadDetailsWrapper,true));
        } catch(Exception ex){
            //Class name, method name, error message
            logger.addLogRecord(namespace +'FNS_ReferralsService', 'getReferralsForRelationshipManager', ex.getMessage() + ex.getStackTraceString());
            objValue.put(FNS_Constants.API_ERROR,ex.getMessage());
        }
        return objValue;
    }
}