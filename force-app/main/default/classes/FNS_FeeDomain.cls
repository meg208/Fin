/**************************************************************************
* Copyright (c) 2019, Brillio
* All rights reserved.
* @author Brillio
* @date 2019
* @group Domain Class
* @description This class acts as domain class for Fee object 
****************************************************************************/
public with sharing class FNS_FeeDomain {
    /***********************************************************************
    * @description This methods converts json response to Fee object
    * @param Instance of FNS_ObjectContainer.FNS_Fee class
    * @return instance of Fee object
    ************************************************************************/
    
    public static FNS_Fee__c assignJSONToFee(FNS_ObjectContainer.FNS_Fee feeRec){
        FNS_Fee__c fee = new FNS_Fee__c();
        if(feeRec.accrualRate != null){
        	fee.FNS_FeeRate__c = feeRec.accrualRate;
        }
        //  API 1.0 changes 
        //fee.FNS_Amount__c =  feeRec.amount;
         if( feeRec.feeAmount != null)
        {
            fee.FNS_Amount__c =  feeRec.feeAmount.amount;
            //fee.FNS_CurrencyCode__c = feeRec.feeAmount.currencyCode;
        } 
        else
        {
           fee.FNS_Amount__c  = 0.0 ;
        } 
        fee.FNS_CurrencyCode__c = FNS_Constants.DEFAULT_CURRENCY; // Temp Hard coding
        fee.FNS_FeeType__c = feeRec.feeTypeId;
        
        return fee;
    } 
}