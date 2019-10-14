({
    boxClickedHelper : function(component, event, clickedBoxColor) {
        let cmpEvent = component.getEvent("cmpEvent");        
        if(clickedBoxColor == 'RED'){
            component.set("v.buttonOrder", 1);
        }
        else if(clickedBoxColor == 'YELLOW'){
            component.set("v.buttonOrder", 2);
        }
            else if(clickedBoxColor == 'GREEN'){
                component.set("v.buttonOrder", 3);
            }
                else if(clickedBoxColor == 'GREY'){
                    component.set("v.buttonOrder", 4);
                }
                    else if(clickedBoxColor == 'PROPOSAL'){
                        component.set("v.buttonOrder", 5);
                    }
        cmpEvent.setParams({
            "context" : clickedBoxColor
        });
        cmpEvent.fire();
    },
    
})