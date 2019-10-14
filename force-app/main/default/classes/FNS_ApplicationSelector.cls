/****************************************************************************************
* @description Class This class is used to handle all the DML operations for Opportunity.
* @author Swanand Mulay
* @date 15/02/2019
* @Support Email swanandm@comitydesigns.com
****************************************************************************************/
public with sharing class FNS_ApplicationSelector extends fflib_SObjectSelector {
    
    //
    /*************************************************************************************
    * @description  Constructor to set boolean values to TRUE of Super class.We are setting 
                    includeFieldsetFields, enforceCRUD, enforceFLS in param constructor to 
                    TRUE
    * @Params       none
    * @Returns      none
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/
    public FNS_ApplicationSelector() {
        super(true, true, true);
    }
    
    public FNS_ApplicationSelector(Boolean enforceFLS) {
        super(true, true, false);
    }
    
    /*************************************************************************************
    * @description  Method to return Schema.FieldSet defined in Opportunity object
    * @Params       none
    * @Returns      Fields from Fieldset
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/ 
    public List<Schema.FieldSet> getSObjectFieldSet() {
       
        return new List<Schema.FieldSet> { 
            SObjectType.Opportunity.FieldSets.FNS_ActiveDeals 
        };
    }
    
    /*************************************************************************************
    * @description  Method to return Schema.SObjectField list of Opportunity object
    * @Params       none
    * @Returns      List of Schema.SObjectField of Opportunity object
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/ 
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Opportunity.Id,
            Opportunity.Name,
            Opportunity.Amount,
            Opportunity.StageName,
            Opportunity.CloseDate,
            Opportunity.FNS_SLAStatus__c,            
            Opportunity.AccountID,
            Opportunity.FNS_ApplicationExtId__c,
            Opportunity.Description,
            Opportunity.FNS_LoanAmount__c, 
            Opportunity.FNS_Fees__c,
            Opportunity.FNS_Quip__c,
            Opportunity.FNS_QuipFinalized__c,
            Opportunity.FNS_StartDateTime__c,
            Opportunity.FNS_BypassValidation__c
        };
    }
    
    /*************************************************************************************
    * @description  Method to return SObject type of Opportunity object
    * @Params       none
    * @Returns      Returns SObjecttype of Opportunity object
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/ 
    public Schema.SObjectType getSObjectType() {
        return Opportunity.sObjectType;
    }
    
    /*************************************************************************************
    * @description  Method to return Opportunity records based on oppIds.
    * @Params       Set of Opportunity ids
    * @Returns      Returns List of Opportunity object
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/
    public List<Opportunity> selectById(Set<Id> oppIds) {
        return (List<Opportunity>) selectSObjectsById(oppIds);
    }
  
  /*************************************************************************************
    * @description  Method to return Opportunity records based on oppIds.
    * @Params       Set of Opportunity ids
    * @Returns      Returns List of Opportunity object
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/
    public List<Opportunity> selectApplicationById(Set<Id> oppIds) {
      String baseNamespace= FNS_Util.getBasePackageNamepace();
      String extNamespace= FNS_Util.getExtensionPackageNamespace();
      String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
      
      fflib_QueryFactory query = newQueryFactory();
    
        if(oppIds != null && !oppIds.isEmpty()){
            query.setCondition('Id IN :oppIds');
        }
         
        fflib_SObjectSelector banksSelector = new FNS_BanksSelector();
        banksSelector.configureQueryFactoryFields(query, namespace + 'FNS_Bank__r');
        return (List<Opportunity>) Database.query( query.toSOQL() );
        
    }
    
    /*****************************************************************************************************
    * @description  Method to return Opportunity records along with its associated task records.
                    This method returns record based on opportunity ids, pending Deals and Opportunity Owner.
    * @Params       set of oppIds, isPendingDeals(if false this will get all opportuniy records), ownership
    * @Returns      Returns List of Opportunity object and its associated Task records.
    * @author       swanandm@comitydesigns.com
    ******************************************************************************************************/
   public List<Opportunity> selectPendingDealsWithTasks(Set<Id> oppIds, Boolean isPendingDeals, Id ownership, Boolean isExcludeOpp) {
        
        Set<String> skippedStageSet = getRestrictedDispositionValues();
        Set<String> taskStatusSet = new Set<String>{FNS_Constants.COMPLETED};
        Set<String> taskRejectedSet = new Set<String>{FNS_Constants.REJECTED};
        Id ownershipId = ownership;
        
        fflib_QueryFactory oppsQueryFactory = newQueryFactory(true, true, true);
        oppsQueryFactory.assertIsAccessible();
        oppsQueryFactory.setEnforceFLS(true);
        oppsQueryFactory.selectFieldSet(SObjectType.Opportunity.FieldSets.FNS_ActiveDeals);
        oppsQueryFactory.selectField('Account.Name');
        
         if(FNS_Util.checkMCEnabled()){
                 oppsQueryFactory.selectField('CurrencyIsoCode');

         }
       // oppsQueryFactory.addOrdering('FNS_SLAStatus__c', fflib_QueryFactory.SortOrder.ASCENDING);
        
        List<String> oppQueryConditions = new List<String>();
        if(oppIds != null && !oppIds.isEmpty()){
          if(isExcludeOpp){
            oppQueryConditions.add('Id NOT IN :oppIds');
          } else {
              oppQueryConditions.add('Id IN :oppIds');
          }
        }
        
        if(isPendingDeals){
           oppQueryConditions.add('StageName NOT IN :skippedStageSet');
        } 
        if(ownershipId != null){
            oppQueryConditions.add('OwnerId =: ownershipId');
        }
        
        if(! oppQueryConditions.isEmpty()){
            oppsQueryFactory.setCondition(String.join(oppQueryConditions, ' AND '));
        }
        
        //oppsQueryFactory.setLimit(9);
        List<String> taskQueryConditions = new List<String>();
        
        fflib_QueryFactory tasksSubQueryFactory = new FNS_TasksSelector().addQueryFactorySubselect(oppsQueryFactory, 'Tasks');    
        
        taskQueryConditions.add('Status NOT IN : taskStatusSet');
        taskQueryConditions.add('(ActivityDate < TODAY OR Status IN : taskRejectedSet)');
        
        tasksSubQueryFactory.setCondition(String.join(taskQueryConditions, ' AND '));
        tasksSubQueryFactory.addOrdering('ActivityDate', fflib_QueryFactory.SortOrder.ASCENDING);
        //tasksSubQueryFactory.setLimit(5);
        
        
        return (List<Opportunity>) Database.query(oppsQueryFactory.toSOQL());
    }
    
    /*****************************************************************************************************
    * @description  Method to return Opportunity records along with its associated task records.
                    This method returns record based on filterCondition, pending Deals and Opportunity Owner.
    * @Params       filterCondition, isPendingDeals(if false this will get all opportuniy records), ownership
    * @Returns      Returns List of Opportunity object and its associated Task records.
    * @author       swanandm@comitydesigns.com
    ******************************************************************************************************/
    public List<Opportunity> pendingDealsWithTasksByFilter(String filterCondition, Boolean isPendingDeals, Id ownership) {
        
        Set<String> skippedStageSet = getRestrictedDispositionValues();
        Set<String> taskStatusSet = new Set<String>{FNS_Constants.COMPLETED};
        Set<String> taskRejectedSet = new Set<String>{FNS_Constants.REJECTED};
        Id ownershipId = ownership;
        
        fflib_QueryFactory oppsQueryFactory = newQueryFactory(true, true, true);
        oppsQueryFactory.assertIsAccessible();
        oppsQueryFactory.setEnforceFLS(true);
        oppsQueryFactory.selectFieldSet(SObjectType.Opportunity.FieldSets.FNS_ActiveDeals);
        oppsQueryFactory.selectField('Account.Name');
        
        if(FNS_Util.checkMCEnabled()){
            oppsQueryFactory.selectField('CurrencyIsoCode');
        }
        
        List<String> oppQueryConditions = new List<String>();
        if(filterCondition != null){
            oppQueryConditions.add(filterCondition);
        }
        if(isPendingDeals){
           // oppQueryConditions.add('StageName NOT IN :skippedStageSet');
        }
        if(ownershipId != null){
            oppQueryConditions.add('OwnerId =: ownershipId');
        }
        
        if(! oppQueryConditions.isEmpty()){
            oppsQueryFactory.setCondition(String.join(oppQueryConditions, ' AND '));
        }
        
        List<String> taskQueryConditions = new List<String>();
        
        fflib_QueryFactory tasksSubQueryFactory = new FNS_TasksSelector().addQueryFactorySubselect(oppsQueryFactory, 'Tasks');    
        
        taskQueryConditions.add('Status NOT IN : taskStatusSet');
        taskQueryConditions.add('(ActivityDate < TODAY OR Status IN : taskRejectedSet)');
        
        tasksSubQueryFactory.setCondition(String.join(taskQueryConditions, ' AND '));
        tasksSubQueryFactory.addOrdering('ActivityDate', fflib_QueryFactory.SortOrder.ASCENDING);
        system.debug('# test 11111:: '+ oppsQueryFactory.toSOQL());

        return (List<Opportunity>) Database.query(oppsQueryFactory.toSOQL());
    }
    /*****************************************************************************************************
    * @description  Method to return Opportunity records along with its associated Product records.
                    This method returns record based on opportunity ids.
    * @Params       set of oppIds
    * @Returns      Returns List of Opportunity object and its associated Product records.
    * @author       swanandm@comitydesigns.com
    ******************************************************************************************************/
    public List<Opportunity> selectApplicationWithProducts(Set<Id> oppIds) {
        
        String productObjName = '';
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
      
        fflib_QueryFactory oppsQueryFactory = newQueryFactory(true, true, true);
        oppsQueryFactory.assertIsAccessible();
        oppsQueryFactory.setEnforceFLS(true);
        oppsQueryFactory.selectFieldSet(SObjectType.Opportunity.FieldSets.FNS_ActiveDeals);
        oppsQueryFactory.selectField('Account.Name');
        oppsQueryFactory.selectField('RecordTypeId');
        
        //This will query opportunity object along with bank object
        fflib_SObjectSelector banksSelector = new FNS_BanksSelector();
        banksSelector.configureQueryFactoryFields(oppsQueryFactory, namespace + 'FNS_Bank__r');
        
        if(FNS_Util.checkMCEnabled()){
            oppsQueryFactory.selectField('CurrencyIsoCode');
        }
       
        List<String> oppQueryConditions = new List<String>();
        if(oppIds != null && !oppIds.isEmpty()){
            oppQueryConditions.add('Id IN :oppIds');
        }
        
        if(! oppQueryConditions.isEmpty()){
            oppsQueryFactory.setCondition(String.join(oppQueryConditions, ' AND '));
        }
        
        if(FNS_Util.isFSCInstalled){
            //This needs to relationshipname to fetch the child records
            productObjName = extNamespace+'FinancialAccountApplicationsFSC__r';
        }else {
            productObjName = baseNamespace+'FinancialAccountApplications__r';
        }
        
        fflib_QueryFactory productsSubQueryFactory = new FNS_ProductsSelector().addQueryFactorySubselect(oppsQueryFactory, productObjName);
        
        List<String> productQueryConditions = new List<String>();
        productQueryConditions.add(namespace + 'FNS_Application__c IN : oppIds');        
        productsSubQueryFactory.setCondition(String.join(productQueryConditions, ' AND '));
        
        
        system.debug('oppsQueryFactory = '+oppsQueryFactory.toSOQL());
        system.debug('productsSubQueryFactory = '+productsSubQueryFactory.toSOQL());
        
        return (List<Opportunity>) Database.query(oppsQueryFactory.toSOQL());
    }
     
  
   public Set<String> getRestrictedDispositionValues(){
        List<String> stageList = new List<String>();
        FNS_AdminConfiguration__c adminConfig = FNS_AdminConfiguration__c.getOrgDefaults();
        if(adminConfig != null){
            String stages = adminConfig.FNS_RestrictedDispositionValues__c;
            if(!String.isBlank(Stages)){
                stages.split(';');
                stageList.addAll(stages.split(';'));
            }
        }
        Set<String> valueSet = new  Set<String>();
        valueSet.addAll(stageList) ;       
        return valueSet;
    }
  
  /*************************************************************************************
    * @description  Method to return List of Opportunity object records based on stagename.
    * @Params       Stagename field
    * @Returns      Returns List of Opportunity object based on stagename
    * @author       swanandm@comitydesigns.com
    **************************************************************************************/
    public List<Opportunity> selectByApplicationtage(String Applicationtage , Id ownershipId) {
        fflib_QueryFactory query = newQueryFactory();
        query.selectFieldSet(SObjectType.Opportunity.FieldSets.FNS_ActiveDeals);
        query.selectField('Account.Name');
        List<String> oppQueryConditions = new List<String>();
        if(Applicationtage != null){
            oppQueryConditions.add('StageName = :Applicationtage');
        }
        
      
        if(ownershipId != null){
            oppQueryConditions.add('OwnerId =: ownershipId');
        }
        
        if(! oppQueryConditions.isEmpty()){
            query.setCondition(String.join(oppQueryConditions, ' AND '));
        }
        
        system.debug('query = '+query.toSOQL());
        return (List<Opportunity>) Database.query( query.toSOQL() );
  }
  
   public List<Opportunity> selectByExternalId(Set<String> appExternalIdSet) {
        fflib_QueryFactory query = newQueryFactory();
        query.selectField('RecordTypeId');
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;

         if(appExternalIdSet != null && !appExternalIdSet.isEmpty()){
               query.setCondition(baseNamespace+'FNS_ApplicationExtId__c IN :appExternalIdSet');
           }
           system.debug('query = '+query.toSOQL());
        return (List<Opportunity>) Database.query( query.toSOQL() );
    }

   /*****************************************************************************************************
    * @description  Method to return Opportunity records along with its associated task records.
                    
    * @Returns      Returns External Id from Opportunity object associated to record 
    * @author       kavya@comitydesigns.com
    ******************************************************************************************************/
    public List<SObject> getApplicationId(String appId) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        String extNamespace= FNS_Util.getExtensionPackageNamespace();
        String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;

        fflib_QueryFactory oppsQueryFactory = newQueryFactory(true, true, true);
        oppsQueryFactory.assertIsAccessible();
        oppsQueryFactory.setEnforceFLS(true);
        oppsQueryFactory.selectField('RecordTypeId');
        oppsQueryFactory.selectField('Id');
        oppsQueryFactory.selectField(baseNamespace+'FNS_ApplicationExtId__c');

        String oppQueryCondition; 
        if(appId != null){
            oppQueryCondition= 'Id=:appId';
             oppsQueryFactory.setCondition(oppQueryCondition);
        }
    
            
        return (List<SObject>) Database.query(oppsQueryFactory.toSOQL());
    }
    /*****************************************************************************************************
   * @description  Method to return Opportunity record's record type name.
                   
   * @Returns      Returns map of opportunity record and its record type name
   * @author       swanandm@comitydesigns.com
   ******************************************************************************************************/
   public Map<String, String> getApplicationRecordType(Set<String> applicationIds) {
       
       fflib_QueryFactory oppsQueryFactory = newQueryFactory(true, true, true);
       oppsQueryFactory.assertIsAccessible();
       oppsQueryFactory.setEnforceFLS(true);
       Map<String, String> oppIdToRecordTypeNameMap = new Map<String, String>();
       oppsQueryFactory.selectField('RecordTypeId');
       oppsQueryFactory.selectField('RecordType.DeveloperName');

       if(applicationIds != null && applicationIds != null){
           oppsQueryFactory.setCondition('Id IN :applicationIds');
       }
       
       List<Opportunity> oppList = (List<Opportunity>) Database.query(oppsQueryFactory.toSOQL());
       if(oppList != null && !oppList.isEmpty()){
           for(Opportunity opp : oppList){
               oppIdToRecordTypeNameMap.put(opp.Id, opp.RecordType.DeveloperName);
           }
       }
       
       return oppIdToRecordTypeNameMap;
   }
    public List<Opportunity> getApplicationbyContact(String contactID) {
       String baseNamespace= FNS_Util.getBasePackageNamepace();
       fflib_QueryFactory oppsQueryFactory = newQueryFactory(true, true, true);
       oppsQueryFactory.assertIsAccessible();
       oppsQueryFactory.setEnforceFLS(true);
      
       oppsQueryFactory.selectField('Description');
       oppsQueryFactory.selectField('CloseDate');
       oppsQueryFactory.selectField(baseNamespace+'FNS_Quip__c'); 
       if(contactID != null && contactID != null){
           oppsQueryFactory.setCondition(baseNamespace+'FNS_Contact__c = :contactID');
       }
       System.debug('>>>'+oppsQueryFactory.toSOQL());
       List<Opportunity> oppList= (List<Opportunity>) Database.query(oppsQueryFactory.toSOQL());
       return oppList;
   }
   /*****************************************************************************************************
    * @description  Method to return Opportunity records based on Application External Id
                    
    * @Returns      Returns Opportunity object  
    * @author       kavya@comitydesigns.com
    ******************************************************************************************************/
    public List<SObject> getApplicationRecord(String applicationExternalId) {
        String baseNamespace= FNS_Util.getBasePackageNamepace();
        fflib_QueryFactory oppsQueryFactory = newQueryFactory(true, true, true);
        oppsQueryFactory.assertIsAccessible();
        oppsQueryFactory.setEnforceFLS(true);
        
        oppsQueryFactory.selectField('Id');
        oppsQueryFactory.selectField(baseNamespace+'FNS_ApplicationExtId__c');
        oppsQueryFactory.selectField('StageName'); 

        String oppQueryCondition; 
        if(applicationExternalId != null){
            oppQueryCondition= baseNamespace+ 'FNS_ApplicationExtId__c =:applicationExternalId';
            oppsQueryFactory.setCondition(oppQueryCondition);
        }
        
        oppsQueryFactory.setLimit(1);
        return (List<SObject>) Database.query(oppsQueryFactory.toSOQL());
    } 
    public List<Opportunity> getApplicationFromContact(String contactID){
        FNS_ApplicationSelector.FNS_CommunityApplication selector = new FNS_ApplicationSelector.FNS_CommunityApplication();
        return selector.getApplicationFromContact(contactID);
    }
    public List<Opportunity> getApplication(String appId){
        FNS_ApplicationSelector.FNS_CommunityApplication selector = new FNS_ApplicationSelector.FNS_CommunityApplication();
        return selector.getApplication(appId);
    }
    private without sharing class FNS_CommunityApplication extends fflib_SObjectSelector{
        public Schema.SObjectType getSObjectType() {
            return Opportunity.sObjectType;
        }
        public List<Schema.SObjectField> getSObjectFieldList() {
            return new List<Schema.SObjectField> {
                    Opportunity.Id,
                    Opportunity.Name,
                    Opportunity.Amount,
                    Opportunity.StageName,
                    Opportunity.CloseDate,
                    Opportunity.FNS_SLAStatus__c,            
                    Opportunity.AccountID,
                    Opportunity.FNS_ApplicationExtId__c,
                    Opportunity.Description,
                    Opportunity.FNS_LoanAmount__c, 
                    Opportunity.FNS_Fees__c,
                    Opportunity.FNS_Quip__c,
                    Opportunity.FNS_QuipFinalized__c,
                    Opportunity.FNS_StartDateTime__c
                    };
                        }
        private List<Opportunity> getApplicationFromContact(String contactID){
            fflib_QueryFactory oppsQueryFactory = newQueryFactory(false, false, true);
            oppsQueryFactory.setEnforceFLS(false);
            if(contactID != null && contactID != null){
                oppsQueryFactory.setCondition('FNS_Contact__c = :contactID');
            }
            System.debug('>>>'+oppsQueryFactory.toSOQL());
            List<Opportunity> oppList= (List<Opportunity>) Database.query(oppsQueryFactory.toSOQL());
            return oppList;
        }
        public List<Opportunity> getApplication(String appId) { 
            String baseNamespace= FNS_Util.getBasePackageNamepace();
            String extNamespace= FNS_Util.getExtensionPackageNamespace();
            String namespace= FNS_Util.isFSCInstalled?extNamespace:baseNamespace;
    
            fflib_QueryFactory oppsQueryFactory = newQueryFactory(false, false, true);
            oppsQueryFactory.selectField('Id');
            oppsQueryFactory.selectField(baseNamespace+'FNS_ApplicationExtId__c');
    
            String oppQueryCondition; 
            if(appId != null){
                oppQueryCondition= 'Id=:appId';
                 oppsQueryFactory.setCondition(oppQueryCondition);
            }
        return (List<Opportunity>) Database.query(oppsQueryFactory.toSOQL());
      }        
    }
    
    /***************************************************************************************
     * @description  Method to get Dispositin values from configtype object and also exclude dispositin values 
                     from exclude disposition value provided in Admin Config custom settings.
     * @Params       null
     * @Returns      List<String> disposition values.
     **************************************************************************************/ 
    public static List<String> getDispositionValues(){
        List<FNS_ConfigurationType__c> configTypleList = new FNS_ConfigurationTypeSelector().getConfigTypeRecordsByType('Disposition');
        List<String> dispositionList = new List<String>();
        Set<String> restrictedDispositionSet  = new FNS_ApplicationSelector().getRestrictedDispositionValues();
        for(FNS_ConfigurationType__c config : configTypleList){
            if(config.FNS_Description__c != null && !restrictedDispositionSet.contains(config.FNS_Description__c)){
                dispositionList.add(config.FNS_Description__c);
            }
        }
        return dispositionList;
    }
}