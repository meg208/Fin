({
     doInit:function(component,event,helper){
        helper.doInit(component,event,helper);
    },
    removeCmp : function(component, event, helper) {
       let cmpEvent = component.getEvent("deletedProductLoan");
       cmpEvent.setParams({ "rowNo" : component.get("v.productLoanRow")});
       cmpEvent.setParams({ "productLoanId" : component.get("v.productLoanId")});
       cmpEvent.fire();
       component.destroy();
    },
     
    saveProductLoan: function(component, event, helper) {
        let negative = /-(?=[0-9])/g;
        let positive = /[0-9]/g; 
        let params = event.getParam('arguments');
        component.find('finAccountLkp').set('v.value', params.finAccount);
        component.find('loanOpportunityLkp').set('v.value', params.OpportunityId);
        let amount = component.find("amount").get("v.value");
        let fieldValue = component.find("term").get("v.value"); 
         console.log(amount, fieldValue);
        if (((!$A.util.isEmpty(amount) && amount>=0) && (fieldValue.match(positive)!=null && fieldValue.match(negative)==null)) || ($A.util.isEmpty(amount) && $A.util.isEmpty(fieldValue))){
            component.set("v.errorMessage", "");
        }
        else{
            component.set("v.errorMessage", $A.get("$Label.c.FNS_ERROR"));
            let cmpEvent = component.getEvent("handleError");
            cmpEvent.fire();
            return;
        } 
             
        /*if(!$A.util.isEmpty(amount) && amount<=0){
            component.set("v.errorMessage", $A.get("$Label.c.FNS_ERROR"));
            let cmpEvent = component.getEvent("handleError");
            cmpEvent.fire();
            return;
        }
        else{
            component.set("v.errorMessage", "");
        }*/
        component.find("productLoanEditForm").submit();
    },
    
    handleSuccess : function(component, event, helper) {
        let payload = event.getParams().response;
        //console.log('product Loan Payload',JSON.stringify(payload));
        console.log('Payload',payload.id);
        component.set("v.productLoanId",payload.id);
        let cmpEvent = component.getEvent("showStatus");
        let msg =  new Object();
        msg.object="Product Loan";
        msg.error="";
        msg.status="success";
        msg.recordID=payload.id;
        cmpEvent.setParams({"message" : msg});
        cmpEvent.fire();
   },
   onError : function(component, event, helper) {
                                
        let cmpEvent = component.getEvent("showStatus");
        let msg =  new Object();
        msg.object="Product Loan";
        msg.error="Record Failed to Create/update";
        msg.status="Error";
        cmpEvent.setParams({ "message" : msg});
        cmpEvent.fire();
   },
})