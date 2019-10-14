({
    fetchPicklistValues : function(component, fieldName, elementId) {
        let action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        let opts = [];  
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                let allValues = response.getReturnValue();
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (let i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                if(fieldName === 'FNS_NAICSCode__c'){
                    component.set("v.options", opts);
                }
                else if(fieldName === 'FNS_NAICSCodeSet1__c'){
                    component.set("v.optionsSet1", opts); 
                }
                    else if(fieldName === 'FNS_NAICSCodeSet2__c'){
                        component.set("v.optionsSet2", opts);
                    }
                        else if(fieldName === 'FNS_NAICSCodeSet3__c'){
                            component.set("v.optionsSet3", opts);
                        }
                            else if(fieldName === 'FNS_SICCode__c'){
                                component.set("v.optionsSic", opts); 
                            }
                                else if(fieldName === 'FNS_SICCodeSet1__c'){
                                    component.set("v.optionsSicSet1", opts); 
                                }
                                    else if(fieldName === 'FNS_SICCodeSet2__c'){
                                        component.set("v.optionsSicSet2", opts); 
                                    }
            }
        });
        $A.enqueueAction(action);
    },
    
    initHelper :function(component, event, helper){
        let action = component.get("c.getNaicsSicCodes");
        let recordId = component.get("v.recordId"); 
        action.setParams({
            accountRecordId: recordId
        });
        let opts = [];  
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                component.set('v.accountDetails', JSON.parse(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    onPicklistSelectHelper : function(component, event, helper){
        let code = component.find("naicsCode").get("v.value"); 
        component.set('v.code', component.find("naicsCode").get("v.value"));
        if(code != null){
            let codeValue = code.substring(0,2); 
            let options = component.get("v.optionsSet1");
            let finalList =[]; 
            if(codeValue != null){
                if(codeValue === "11" || codeValue === '21' || codeValue === '23' || codeValue=== '31'){
                    options= component.get("v.optionsSet1"); 
                    for(let i =0 ; i<options.length; i++){
                        if(codeValue === '31'){
                            if(options[i].value.substring(0,1) === '3'){
                                finalList.push(options[i].value)
                            }
                        }
                        else if(options[i].value.substring(0,2) === codeValue){
                            finalList.push(options[i].value); 
                        }
                    }
                }
                
                else if(codeValue === '42' || codeValue === '44' || codeValue === '48' ||   codeValue === '51' || 
                        codeValue === '52' || codeValue === '53' || codeValue === '54' || codeValue === '55' || 
                        codeValue === '56' || codeValue === '61' || codeValue === '62'){
                    options= component.get("v.optionsSet2");
                    for(let i =0 ; i<options.length; i++){
                        if(codeValue === '44'){
                            if(options[i].value.substring(0,2) === '44' || options[i].value.substring(0,2) === '45'){
                                finalList.push(options[i].value); 
                            }
                        }
                        else if(codeValue === '48'){
                            if(options[i].value.substring(0,2) === '48' || options[i].value.substring(0,2) === '49'){
                                finalList.push(options[i].value); 
                            }
                        }
                            else if(options[i].value.substring(0,2) === codeValue){
                                finalList.push(options[i].value); 
                            }
                    }
                    
                }
                    else {
                        options= component.get("v.optionsSet3");
                        for(let i =0 ; i<options.length; i++){
                            if(options[i].value.substring(0,2) === codeValue){
                                finalList.push(options[i].value); 
                            }
                        }
                    }
                
            }
            if(finalList.length > 0 && finalList != null){
                component.set("v.subCodeOptions", finalList);
                component.set("v.showSet1", true); 
            }
        }
    }, 
    
    onSicPicklistSelectHelper : function(component, event, helper){
        let code = component.find("sicCode").get("v.value"); 
        
        component.set('v.siccode', component.find("sicCode").get("v.value"));
        if(code != null){
            let codeValue = code.substring(0,2); 
            let options = component.get("v.optionsSicSet2");
            let finalList =[]; 
            if(codeValue != null){
                if(codeValue === "73" || codeValue === '75' || codeValue === '76' || codeValue=== '78' || codeValue === '79' || codeValue === '80'
                   || codeValue === '81' || codeValue === '82' || codeValue === '83' || codeValue === '84' || codeValue === '86' || codeValue === '87'
                   || codeValue === '88' || codeValue === '89' || codeValue === '91' || codeValue === '92' || codeValue === '93' || codeValue === '94' 
                   || codeValue === '95' || codeValue === '96' || codeValue === '97' || codeValue === '99'){
                    options= component.get("v.optionsSicSet2"); 
                    for(let i =0 ; i<options.length; i++){
                        if(options[i].value.substring(0,2) === codeValue){
                            finalList.push(options[i].value); 
                        }
                    }
                }
                
                else {
                    options= component.get("v.optionsSicSet1");
                    for(let i =0 ; i<options.length; i++){
                        if(options[i].value.substring(0,2) === codeValue){
                            finalList.push(options[i].value); 
                        }
                    }
                }
                
            }
            if(finalList.length > 0 && finalList != null){
                component.set("v.subSicCodeOptions", finalList);
                component.set("v.showSicSet1", true); 
            }
        }
    }, 
    
    handleSaveHelper :function(component, event,  helper){
        component.set("v.loaded", true); 
        let SubCode = component.get("v.subCode");
        let sicSubCode = component.get("v.subSicCode");
        let naicsCode = component.get("v.code"); 
        let sicCode = component.get("v.sicCodeValue")
        let recordId = component.get("v.recordId"); 
        let action = component.get("c.saveNAICSandSICCode"); 
        action.setParams({
            naicsCode : naicsCode, 
            sicCode : sicCode,
            subNaicsCode : SubCode, 
            subSicCode : sicSubCode,
            accountRecordId : recordId
        }); 
        action.setCallback(this, function(response){
            if (response.getState() == "SUCCESS") {
                helper.initHelper(component, event, helper);
                component.set("v.loaded", false); 
                component.set("v.editClicked", false); 
            }
            else{
                component.set("v.loaded", false);
            }
            
        }); 
        $A.enqueueAction(action);
    }
    
})