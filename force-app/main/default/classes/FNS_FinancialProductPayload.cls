/*****************************************************************************************
* @description This class is used to perform DML using json for an Application.
* @author Sameer Chaudhari
* @date 13/03/2019
* @Support Email Sameer@comitydesigns.com
******************************************************************************************/
public with sharing class FNS_FinancialProductPayload {
    //API 1.0 changes 
    // public double amount;
    public FNS_Money amount;
    public FNS_ObjectContainer.FNS_CustomerIds customerIds ;
    public String opportunityID;
    public String accountID;
    public String currencyCode;  
    public String lineOfCreditId;   
    public List<FNS_ObjectContainer.FNS_Customers> customers;
    public List<FNS_ObjectContainer.FNS_FinAccountRole> productRoles;
    public String effectiveDate;
    public String expiryDate;
    public String maturityDate;
    public List<FNS_ObjectContainer.FNS_Fee> fees;
    public String hostLoanNumber;
    public String financialProductId;
    public List<FNS_ObjectContainer.FNS_Loan> loans;
    public List<FNS_ObjectContainer.FNS_pricing> pricings;
    public string rateType;
    public String purposeTypeId;
    public String purpose;
    public String productType;
    public Double previousAmount;
    public String paymentType;
    public String paymentFrequencyId;
    public String originationTypeIndicator;
    public String termUnit;
    public String term;
    public String locCurrency;
    
    //API 1.0 changes
    public with sharing class FNS_Money{
    	public decimal amount;
    	public string currencyCode;
		public Decimal fxRate;       
    }
}