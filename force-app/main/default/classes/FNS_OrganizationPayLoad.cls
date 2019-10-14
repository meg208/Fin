/*****************************************************************************************
* @description This class is used to pull data for Organization.
* @author Nidhi Chouksey
* @date 22/03/2019
* @Support Email Nidhi@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_OrganizationPayLoad {
    public List<FNS_Addresses> addresses;
    public List<FNS_AlternateIdentifiers> alternateIdentifiers;
    //public Decimal annualRevenue;
    public AnnualRevenue annualRevenue; //API 1.0
    public List<FNS_ContactList> contactList;
    public List<FNS_CreditInformation> creditInformation;
    public String customerId;
    public List<FNS_CustomerProfiles> customerProfiles;
    public List<FNS_AlternateIdentifiers> externalSystemIdentifiers;
    public String fullName;
    public List<FNS_HostSystemInternalIdentifiers> hostSystemInternalIdentifiers;
    public String immediateParent;
    public String legalName;
    public String naicsCode;
    public Boolean official;
    public String officialType;
    public String organizationId;
    public FNS_PrimaryIdentifier primaryIdentifier;
    public String revenueCurrency;
    public String sicCode;
    public String sicCodeCountry;
    public String structure;
    public List<FNS_TaxDetails> taxDetails;
    public String customerDescription;
   
    public with sharing class FNS_Addresses {
        public String addressType;
        public String city;
        public String country;
        public String houseNumber;
        public String postalCode;
        public String postalCodeExtension;
        public String province;
        public String state;
        public String street1;
        public String street2;
        public String street3;
    }

    public with sharing class FNS_PrimaryIdentifier {
        public String identityNumber;
        public String identityType;
    }

    public with sharing class FNS_TaxDetails {
        public Integer objectId;
        //public String taxCountry;
        public String taxExemptCode;
        public String taxNumber;
        public String taxPayerId;
        public String taxRegion;
        public String taxType;
        public String taxDetailsId;
        public String  country;
    }

    

    public with sharing class FNS_CustomerProfiles {
        public String creditComment;
        public DateTime creditReviewDate;
        public String nextReviewDate;
        public String profileId;
        public String customerProfileId;
        public String profileType;
        public String watchfulAccountIndicator;
    }

    public with sharing class FNS_PhoneList {
        public String phoneNumber;
        public String phoneType;
        public String primaryBusinessEmail;
    }

    public with sharing class FNS_AlternateIdentifiers {
        public String identityNumber;
        public String identityType;
    }

    public with sharing class FNS_CreditInformation {
        public String informationStatement;
        public String informationType;
    }

    public with sharing class FNS_HostSystemInternalIdentifiers {
    	public String bankId;
        //public String hostSystemInternalIdentifierCode;//API 1.0
        public String name;//API 1.0
        public String code; //API 1.0
    }

    public with sharing class FNS_ContactList {
        public String contactType;
        public String department;
        public String fullName;
        public List<FNS_PhoneList> phoneList;
        public String primaryBusinessEmail;
        public String title;
        public String contactId;        
    }
	
	public with sharing class FNS_Response {
        public String organizationId;
    }
     public with sharing class AnnualRevenue{
        public decimal amount;
        public string currencyCode;
        
        
    }
}