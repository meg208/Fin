/**
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group Domain Class
 * @description This class act as a domain class for Pricing object.
 */  
public with sharing class FNS_PricingDomain {

	/*************************************************************************************
	 * @description  Method to convert JSON Response into Pricing object.
	 * @Params       Namespace as string
	 * @Params       Financial Account as sObject
	 * @Params       Pricing wrapper class object
	 * @Returns      Pricing object.
	 *************************************************************************************/
	public static FNS_Pricing__c assignJSONToPricing(String namespace ,SObject finAccount ,FNS_ObjectContainer.FNS_Pricing pricingRec){
		FNS_Pricing__c pricing = new FNS_Pricing__c();
		FNS_ErrorLog logger = new FNS_ErrorLog();
		try{
			pricing.FNS_AllInRate__c = pricingRec.allInRate;//UI pricing type
			if(pricingRec.baseRate != null ){
				pricing.FNS_BaseRate__c = Decimal.valueof(pricingRec.baseRate);
			}
			pricing.FNS_CalcType__c = pricingRec.calcType;
			pricing.FNS_Frequencies__c = pricingRec.frequency;
			pricing.FNS_PricingType__c = pricingRec.pricingType;
			pricing.FNS_RateBasis__c = pricingRec.rateBasis;        
			pricing.FNS_RateType__c = pricingRec.rateType;
			pricing.FNS_Spread__c = pricingRec.spread;
		}catch(Exception ex){
            logger.addLogRecord('FNS_PricingDomain', 'assignJSONToPricing', ex.getMessage() + ex.getStackTraceString());
        }
		return pricing;
	} 
}