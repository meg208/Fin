/*****************************************************************************************
 * Copyright (c) 2019, Brillio
 * All rights reserved.
 * @author Brillio
 * @date 2019
 * @group View Product Read Only
 * @description This class is used to pull data for Application.

******************************************************************************************/
  
public with sharing class FNS_ViewProductController {
   static FNS_ErrorLog logger = new FNS_ErrorLog();
   /*************************************************************************************
   * @description  Constructs the domain class for Opportunity.
   * @Params       recordId 
   * @Returns      returns instance of FNS_ViewRecordWrapper
   **************************************************************************************/ 
    @AuraEnabled
    public static FNS_ViewRecordWrapper getObjectDetails(String recordId){
		String objName;
        String recordTypeValue;
        Id recordIdValue = Id.valueOf(recordId);
        FNS_ViewRecordWrapper recordWrapper = new FNS_ViewRecordWrapper();
      	try{
           	System.debug(recordIdValue.getSObjectType());
            objName = recordIdValue.getSObjectType().getDescribe().getName();
            System.debug(objName);
            for (Schema.RecordTypeInfo rtInfo : recordIdValue.getSObjectType().getDescribe().getRecordTypeInfos()) {
                if (rtInfo.isDefaultRecordTypeMapping()) {
                    recordTypeValue = rtInfo.getRecordTypeId();
                }
            }
            
            recordWrapper.objName = objName;
            recordWrapper.recordTypeId = recordTypeValue;
       
        }catch (DMLException ex){
            logger.addLogRecord('FNS_ViewProductController', 'getObjectDetails', ex.getMessage() + ex.getStackTraceString());
            recordWrapper.error=ex.getMessage();
        } catch (Exception ex){
            logger.addLogRecord('FNS_ViewProductController', 'getObjectDetails', ex.getMessage() + ex.getStackTraceString());
            recordWrapper.error=ex.getMessage();
        }
        return recordWrapper;
    }
	/***********************************************************************
	* @description Wrapper class used for objectname and associated recordtype
	* @param none
	* @return none 
	************************************************************************/
	public with sharing class FNS_ViewRecordWrapper {
		@AuraEnabled public String objName {get; set;}
		@AuraEnabled public String recordTypeId {get; set;}
        @AuraEnabled public String error{get;set;}
	}    
}