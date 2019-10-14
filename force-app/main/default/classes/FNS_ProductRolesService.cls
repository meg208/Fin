public class FNS_ProductRolesService {
	public static string baseNamespace = FNS_Util.getBasePackageNamepace();

    public void upsertRecords(List<sObject > productRolesList){
        String objName = baseNamespace+'FNS_FinancialAccountRole__c';
        if(FNS_Util.isFSCInstalled){
          objName= 'FinServ__FinancialAccountRole__c';
        }
        SObjectType sObjType = ((SObject) Type.forName(objName).newInstance()).getSObjectType();
        
        fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                sObjType
		});
        uow.registerUpsert(productRolesList);
        FNS_ObjectAccessContainer.checkApplicationRolesAccess(FNS_AccessController.DML_OPERATION_UPSERT);
        uow.commitWork();
    }
}