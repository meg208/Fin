public class FNS_AuthorizeFFDCConroller {
      public string sessionState{get;set;}
      public string code{get;set;}
     
    public pagereference getParam(){
		sessionState= ApexPages.currentPage().getParameters().get('session_state');//ApexPages.currentPage().getHeaders().get('session_state');
        code=ApexPages.currentPage().getParameters().get('code'); //ApexPages.currentPage().getHeaders().get('code');
        String lightningPage = System.Url.getOrgDomainUrl().toExternalForm()+'/lightning/n/FNS_FinastraSetup' ;
        System.debug('>>>domain:>>>>'+System.Url.getOrgDomainUrl().toExternalForm());
        System.debug('>>>currentpage:>>>>'+ApexPages.currentPage());        
        System.debug('>>>sesseionState:>>>>'+sessionState);
        System.debug('>>>>code:>>>>'+ code);
		FNS_SetupController.getFFDCValues(sessionState,code);
        pageReference pge = new PageReference(lightningPage);
        return pge;
        //return null;
    }

}