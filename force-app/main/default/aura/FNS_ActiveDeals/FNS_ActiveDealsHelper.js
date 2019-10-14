({
    fetchOppWrapper : function(component, event, helper) {
        let getAction = component.get("c.getPendingDealsWithTask");
        getAction.setCallback(this, function(response) {
            let state = response.getState();
            console.log("callback state: " + state);
            if (component.isValid() && state === "SUCCESS") {
                let result = response.getReturnValue() ;
                console.log('wrapper',JSON.parse(result));
                let oppWrapper = { };
                let oppDetailsOnePage = [];
                oppWrapper = JSON.parse(result);
                //console.log("oppWrapper : " + JSON.stringify(oppWrapper));
                
                if(!$A.util.isEmpty(oppWrapper.error)){
                    component.set("v.responseError", oppWrapper.error);
                }
                else{
                    if(!(oppWrapper.oppDetails.length==0 || oppWrapper.oppDetails.length==null)){
                        component.set("v.opportunityShow", true);
                        component.set("v.isFilterIcon", false);
                        component.set('v.isViewAll',true);
                        component.set('v.oppWrapper',oppWrapper);
                    }
                    else{
                        component.set("v.opportunityShow", false);
                        component.set('v.isViewAll',false);
                        component.set("v.isFilterIcon", true);
                    }
                }
            }
            else{
                component.set("v.opportunityShow", false);
                component.set('v.isViewAll',false);
                component.set("v.isFilterIcon", true);
            }
            component.set("v.isLoaded", true);
            component.set("v.isLoan", true);
            component.set("v.selectedResource", component.get("v.selectedResourceDefault"));
            component.set("v.selectedOperator",component.get("v.selectedOperatorDefault"));
            component.set("v.selectedValue",component.get("v.selectedValueDefault"));
        });
        $A.enqueueAction(getAction);
    },
    
    handleTrackingItems : function(component, event, helper){
        let idx = event.target.getAttribute('data-index');
        let opportunityId = component.get("v.oppWrapper.oppDetails")[idx].oppId;
        window.open('/'+opportunityId, '_blank'); 
        event.stopPropagation();
    },
    
    showHover : function(component, event, helper){
        let opportunityDetails = component.get("v.oppWrapper.oppDetails");
        let idx = event.currentTarget.getAttribute('data-index');
        //let clickedOpportunity = component.get("v.oppWrapper.oppDetails")[idx];
        for(let i=0; i<opportunityDetails.length; i++){
            if(i==idx){
                if(opportunityDetails[i].Clicked){
                    window.setTimeout($A.getCallback(function() {
                        if(!$A.util.isUndefinedOrNull( component.find('popover') )){
                            component.find('popover').getElement().focus();
                        }
                    }), 10);
                    opportunityDetails[i].Clicked = false;
                }else{
                    opportunityDetails[i].Clicked = true;
                }
            }
            else{
                opportunityDetails[i].Clicked = false;
            }
        }
        component.set("v.oppWrapper.oppDetails", opportunityDetails);
        
    },
    handleComponentEvent : function(component, event, helper) {
        let context = event.getParam("context");
        let oppDetailsOnePage = [];
		let oppDetails = component.get("v.oppWrapper.oppDetails");
        let opportunityDetailsRed = component.get("v.oppWrapper.opportunityDetailsRed");
        let opportunityDetailsYellow = component.get("v.oppWrapper.opportunityDetailsYellow");
        let opportunityDetailsGreen = component.get("v.oppWrapper.opportunityDetailsGreen");
        let opportunityDetailsGrey = component.get("v.oppWrapper.opportunityDetailsGrey");
        let opportunityDetailsProposal = component.get("v.oppWrapper.opportunityDetailsProposal");
		if(!$A.util.isUndefinedOrNull(oppDetails)){
        component.set("v.isRestoreDefault", true);
        if(context == 'RED'){
            component.set("v.oppWrapper.oppDetails", component.get("v.oppWrapper.opportunityDetailsRed"));   
        }
        else if(context == 'YELLOW'){
            component.set("v.oppWrapper.oppDetails", component.get("v.oppWrapper.opportunityDetailsYellow"));
            component.set("v.oppWrapper.oppList", component.get("v.oppWrapper.oppList"));
        }
            else if(context == 'GREEN'){
                component.set("v.oppWrapper.oppDetails",  component.get("v.oppWrapper.opportunityDetailsGreen"));
            }
                else if(context == 'GREY'){
                    console.log('grey list = '+component.get("v.oppWrapper.opportunityDetailsGrey"));
                    component.set("v.oppWrapper.oppDetails", component.get("v.oppWrapper.opportunityDetailsGrey"));
                }
                    else if(context == 'PROPOSAL'){
                        console.log('proposal list = '+component.get("v.oppWrapper.opportunityDetailsProposal"));
                        console.log('proposal listlength = '+component.get("v.oppWrapper.opportunityDetailsProposal").length);
                        component.set("v.oppWrapper.oppDetails", component.get("v.oppWrapper.opportunityDetailsProposal"));
                    } 
		}				
        $A.util.isEmpty(component.get("v.oppWrapper.oppDetails")) ? component.set("v.opportunityShow", false) : component.set("v.opportunityShow", true);
    },
    viewAll : function(component, event, helper){
        let action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                let listview = response.getReturnValue();
                if(listview != undefined){
                    console.log('List View =>'+JSON.stringify(listview));
                    let navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "listViewId": listview[0].Id,
                        "listViewName": null,
                        "scope": "Opportunity"
                    });
                    navEvent.fire();
                }
                component.set("v.opportunityShow", true);
            }
        });
        $A.enqueueAction(action);
    },
    filter : function(component, event, helper){
        component.set("v.hideFilter", true);
        if(component.get("v.isFilterOpen")){
            component.set("v.isFilterOpen", false);
            component.set("v.isEmptyFilter", false);
        }
        else{
            component.set("v.isFilterOpen", true);
            component.set("v.isEmptyFilter", false);
            window.setTimeout($A.getCallback(function() {
                if(!$A.util.isUndefinedOrNull( component.find('hideFilter') )){
                    component.find('hideFilter').getElement().focus();
                }
            }), 10);
        }
    },
    filterSelected: function(component, event, helper, selectecResoruce){
        let filterSelectedValuePrevious = component.get("v.filterSelectedValuePrevious");
        let filterSelectedResourcePrevious = component.get("v.filterSelectedResourcePrevious");
        let filterSelectedOperatorPrevious = component.get("v.filterSelectedOperatorPrevious");
        if(selectecResoruce=='Customer'){
            component.set("v.isCustomer",true);
            component.set("v.isDisposition",false);
            component.set("v.isLoan",false);
            if(!$A.util.isUndefinedOrNull(filterSelectedValuePrevious)){
                component.set("v.selectedLookUpRecord", component.get("v.selectedLookUpRecord"));
                if(selectecResoruce==filterSelectedResourcePrevious){
                    component.find("filterSelectedAmountOperator").set("v.value", filterSelectedOperatorPrevious);
                }
                else{
                    component.find("filterSelectedAmountOperator").set("v.value", '');
                    component.set("v.selectedLookUpRecord", '');
                    component.find("filterSelectedAmountOperator").set("v.value", '');
                }
            }
            else{
                component.set("v.selectedLookUpRecord", '');
                component.find("filterSelectedAmountOperator").set("v.value", '');
            }
        }
        else if(selectecResoruce=='Disposition'){
            component.set("v.isDisposition",true);
            component.set("v.isCustomer",false);
            component.set("v.isLoan",false);
            if(!$A.util.isUndefinedOrNull(filterSelectedValuePrevious)){
                component.set("v.stageName",filterSelectedValuePrevious);
                if(selectecResoruce==filterSelectedResourcePrevious){
                    component.find("filterSelectedAmountOperator").set("v.value", filterSelectedOperatorPrevious);
                }
                else{
                    component.find("filterSelectedAmountOperator").set("v.value", '');
                    //component.find("filterSelectedDisposition").set("v.value", '');
                    //component.find("filterSelectedAmountOperator").set("v.value", '');
                }
            }
            else{
                //component.find("filterSelectedDisposition").set("v.value", '');
                component.find("filterSelectedAmountOperator").set("v.value", '');
            }
        }
            else if(selectecResoruce=='Number Of Loans'){
                component.set("v.isLoan",true);
                component.set("v.isDisposition",false);
                component.set("v.isCustomer",false);
                if(!$A.util.isUndefinedOrNull(filterSelectedValuePrevious) && !isNaN(filterSelectedValuePrevious)){
                    component.set("v.filterSelectedValue", filterSelectedValuePrevious);
                    if(selectecResoruce==filterSelectedResourcePrevious){
                        component.find("filterSelectedAmountOperator").set("v.value", filterSelectedOperatorPrevious);
                    }
                    else{
                        component.find("filterSelectedAmountOperator").set("v.value", '');
                        component.set("v.filterSelectedValue", '');
                        component.find("filterSelectedAmountOperator").set("v.value", '');
                    }
                }
                else{
                    component.set("v.filterSelectedValue", '');
                    component.find("filterSelectedAmountOperator").set("v.value", '');
                }
            }
                else{
                    component.set("v.isLoan",true);
                    component.set("v.isDisposition",false);
                    component.set("v.isCustomer",false);
                    component.set("v.filterSelectedValue", '');
                    component.find("filterSelectedAmountOperator").set("v.value", '');
                }
    },
    cancel : function(component, event, helper){
        let selectedResource = component.get("v.selectedResource");
        let selectedOperator = component.get("v.selectedOperator");
        let selectedValue = component.get("v.selectedValue");
        let selectedResourceDefault = component.get("v.selectedResourceDefault");
        let selectedOperatorDefault = component.get("v.selectedOperatorDefault");
        let selectedValueDefault = component.get("v.selectedValueDefault");
        let filterSelectedResourcePrevious = component.get("v.filterSelectedResourcePrevious");
        helper.filterSelected(component, event, helper, filterSelectedResourcePrevious);
        if(selectedValue != selectedValueDefault)
        {
         	 component.set("v.stageName",selectedValue);    
        }
        component.find("filterSelectedResource").set("v.value", filterSelectedResourcePrevious);
        component.set("v.isEmptyFilter", false);
        component.set("v.isFilterOpen", false);
    },
    applyFilter:function(component, event, helper){
        component.set("v.responseError", '');
        component.set("v.isFilterApply", true);
        //component.get("v.selectedLookUpRecord").Id;
        component.set("v.isEmptyFilter", false);
        let selectecResoruce =component.find("filterSelectedResource").get("v.value");
        let oppWrap = component.get("v.oppWrapper");
        console.log('oppWrap>>>>>',oppWrap);
        let fieldType;
        let fieldName;
        let fieldApi;
        let filterSelectedAmountOperatorForFilter;
        let value;
        console.log('selectecResoruce>>>>>',selectecResoruce);
        for(let i=0; i<oppWrap.filterAttList.length; i++){
            if(oppWrap.filterAttList[i].fieldName ==selectecResoruce)
            {
                fieldType=oppWrap.filterAttList[i].fieldType;
                fieldName=oppWrap.filterAttList[i].fieldName;
                fieldApi=oppWrap.filterAttList[i].fieldApi;
                if(fieldApi=="Account.Name"){
                    fieldApi = "Account.Id";
                }
            }
        }
        let filterSelectedAmountOperator =component.find("filterSelectedAmountOperator").get("v.value");
        if(filterSelectedAmountOperator == $A.get("$Label.c.FNS_PENDING_DEALS_LESS_THAN")){
            filterSelectedAmountOperatorForFilter = "<";
        }
        else if(filterSelectedAmountOperator == $A.get("$Label.c.FNS_PENDING_DEALS_LESS_THAN_EQUAL_TO")){
            filterSelectedAmountOperatorForFilter = "<=";
        }else if(filterSelectedAmountOperator == $A.get("$Label.c.FNS_PENDING_DEALS_EQUALS")){
            filterSelectedAmountOperatorForFilter = "=";
        } else if(filterSelectedAmountOperator == $A.get("$Label.c.FNS_PENDING_DEALS_NOT_EQUALS")){
            filterSelectedAmountOperatorForFilter = "!=";
        }else if(filterSelectedAmountOperator == $A.get("$Label.c.FNS_PENDING_DEALS_GREATER_THAN")){
            filterSelectedAmountOperatorForFilter = ">";
        }else if(filterSelectedAmountOperator == $A.get("$Label.c.FNS_PENDING_DEALS_GREATER_THAN_EQUAL_TO")){
            filterSelectedAmountOperatorForFilter = ">=";
        }
        let isCustomer = component.get("v.isCustomer");
        if(component.get("v.isCustomer")){
            if(!$A.util.isEmpty(component.get("v.selectedLookUpRecord"))){
                value =component.get("v.selectedLookUpRecord").Id;
            }
        }else if(component.get("v.isLoan")){
            value =component.find("filterSelectedAmountValue").get("v.value");
        }else if(component.get("v.isDisposition")){
         	  value =component.find("stage").get("v.value");
        }
        if($A.util.isEmpty(selectecResoruce) || $A.util.isEmpty(value) || $A.util.isEmpty(filterSelectedAmountOperatorForFilter)){
            component.set("v.isEmptyFilter", true);
            component.set("v.isFilterApply", false);
            return;
        }
        
        let action = component.get("c.getFilterRecords");
        let setCondition ={};
        setCondition.savedUserFilter = {'value' : value,
                                        'operator' : filterSelectedAmountOperatorForFilter,
                                        'fieldType' : fieldType,
                                        'fieldName' : fieldName,
                                        'fieldApi' : fieldApi,
                                        'currencyIsoCode' : ""};
        action.setParams({
            "inputFilter" : JSON.stringify(setCondition)
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state == "SUCCESS"){
				let result = response.getReturnValue();
                let jsonResult = JSON.parse(result);
                console.log('my json',JSON.parse(result));
                if(!$A.util.isEmpty(jsonResult.error)){
                    component.set("v.responseError", jsonResult.error);
                    helper.clearFilters(component, event, helper);
                }
				else{
		            component.set("v.selectedResource",selectecResoruce);
		            component.set("v.selectedOperator",filterSelectedAmountOperator)
		            if(component.get("v.isCustomer")){
		                component.set("v.selectedValue",component.get("v.selectedLookUpRecord").Name);	
		            }else{
		                component.set("v.selectedValue",value);
		            }
		            
		            let jsonData  = JSON.parse(response.getReturnValue());
		            let oppListOnePage = [];
		            console.log('old oppWrapper', JSON.parse(JSON.stringify(component.get("v.oppWrapper"))));
		            component.set("v.buttonOrder", 0);
		            component.set("v.oppWrapper.oppDetails", jsonData.oppList);
		            component.set("v.filterSelectedResource",selectecResoruce);
		            component.set("v.filterSelectedOperator",filterSelectedAmountOperator);
		            component.set("v.filterSelectedValue",value);
		            component.set("v.filterSelectedOperatorPrevious",filterSelectedAmountOperator);
		            component.set("v.filterSelectedResourcePrevious",selectecResoruce);
		            component.set("v.filterSelectedValuePrevious", value);
		            component.set("v.isFilterOpen",false);
		            component.set("v.isRestoreDefault",true);
		            component.set("v.isFilterApply", false);
                    component.set("v.stageName",component.find("stage").get("v.value"));
                    (!$A.util.isEmpty(jsonData.oppList) )? component.set("v.opportunityShow", true) :component.set("v.opportunityShow", false);
					}
				}else{
                console.log('failed'); 
                component.set("v.isFilterApply", false);
                component.set("v.opportunityShow", false);
            }
        });
        $A.enqueueAction(action);
    },
    clearFilters : function(component, event, helper){
        component.set("v.buttonOrder", 0);
        component.set("v.isFilterApply", true);
        helper.resetValue(component, event, helper);
        component.set("v.filterSelectedOperatorPrevious",'');
        component.set("v.filterSelectedResourcePrevious",'');
        component.set("v.filterSelectedValuePrevious", '');
        component.set("v.stageName","");
        helper.fetchOppWrapper(component, event, helper);
        component.set("v.isRestoreDefault",false);
        component.set("v.isFilterOpen",false);
        component.set("v.isFilterApply", false);
    },
    resetValue:function(component, event, helper){
        let isCustomer = component.get("v.isCustomer");
        let isDisposition = component.get("v.isDisposition");
        if(isCustomer){
            component.set("v.selectedLookUpRecord", '');
        }
        else if(isDisposition){
           component.set("v.stageName","");
        }
        component.find("filterSelectedResource").set("v.value", '');
        component.find("filterSelectedAmountOperator").set("v.value", '');
        component.set("v.filterSelectedValue", '');
        component.set("v.isDisposition", false);
        component.set("v.isCustomer", false);
        component.set("v.selectedResource", component.get("v.selectedResourceDefault"));
        component.set("v.selectedOperator",component.get("v.selectedOperatorDefault"));
        component.set("v.selectedValue",component.get("v.selectedValueDefault"));
    },
    accountView : function(component, event, helper){
        let idx = event.target.getAttribute('data-index');
        let accountId = component.get("v.oppWrapper.oppDetails")[idx].accountId;
        window.open('/'+accountId, '_blank');
    },
    opportunityView : function(component, event, helper){
        let idx = event.target.getAttribute('data-index');
        let opportunityId = component.get("v.oppWrapper.oppDetails")[idx].oppId;
		let opportunityExtId = component.get("v.oppWrapper.oppDetails")[idx].oppExtId;
		window.open('/'+opportunityId, '_blank');
		/*component.set("v.isSpinner", true);
        let action = component.get("c.updateDataFromFFDC");
        action.setParams({
            "appExtId" : opportunityExtId
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            console.log('state = '+state); 
            if(state == "SUCCESS"){
                helper.showToast(component,event, helper,"Success","Success", $A.get("$Label.c.FNS_RECORD_DELETE_SUCCESS"));
            }else{
                console.log('failed');
                helper.showToast(component,event, helper,"Error","Error",$A.get("$Label.c.FNS_RECORD_NOT_FOUND"));
            }
            component.set("v.isSpinner", false);
            window.open('/'+opportunityId, '_blank');
        });
        $A.enqueueAction(action);*/
    },
	showToast : function(component, event, helper,title,type,msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": msg
        });
        toastEvent.fire();
    },
    hidePopover : function(component, event, helper) {
        let opportunityDetails = component.get("v.oppWrapper.oppDetails");
        let idx = event.currentTarget.getAttribute('data-index');
        let clickedOpportunity = component.get("v.oppWrapper.oppDetails")[idx];
        for(let i=0; i<opportunityDetails.length; i++){
            if(i==idx){
                if(opportunityDetails[i].Clicked){
                    opportunityDetails[i].Clicked = false;
                }
                else{
                    opportunityDetails[i].Clicked = false;
                }
            }
            else{
                opportunityDetails[i].Clicked = false;
            }
        }
        component.set("v.oppWrapper.oppDetails", opportunityDetails);
        event.stopPropagation();
    }
})