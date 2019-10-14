({
	doInit:function(component,event,helper){
        //component.set('v.finsPrimaryOwner', 'FinServ__PrimaryOwner__c');
		helper.createPricingCmp(component,event,helper);
    },
    createPricingCmp: function(component,event,helper) {
        var objFields = component.get("v.objFields");
        objFields=JSON.parse(JSON.stringify(objFields));
        for (let i= 0 ; i < objFields.length ; i++){
	        var field = objFields[i];
        	var apiName = field.APIName;
            $A.createComponent(
                
                "lightning:inputField",
                {
                    'aura:id': apiName,
                    'fieldName': apiName
                },
                function(newInputField, status, errorMessage){
                    //Add the new button to the body array
                    if (status === "SUCCESS") {
                        $A.createComponent(
                            "lightning:layoutItem",
                            {
                                size: 5,
                                body: newInputField
                            },
	                        function(layoutItem, status, errorMessage){
                                if (status === "SUCCESS") {
                                    var body = component.get("v.body");
                                    body.push(layoutItem);
                                    component.set("v.body", body);
                                }
                                else if (status === "INCOMPLETE") {
                                    console.log("No response from server or client is offline.")
                                    // Show offline error
                                }
                                else if (status === "ERROR") {
                                    console.log("Error: " + errorMessage);
                                    // Show error message
                                }
                            }
                        );   
                        //inputFieldsCmps.push(newInputField);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                        // Show offline error
                    }
                    else if (status === "ERROR") {
						console.log("Error: " + errorMessage);
                        // Show error message
                    }
                }
            );
        }
    },
})