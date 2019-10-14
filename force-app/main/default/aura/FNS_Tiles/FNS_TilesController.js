({
    boxClicked: function(component, event, helper) {
       let ctarget = event.currentTarget;
       let clickedBoxColor = ctarget.dataset.value;
       console.log('clickedBoxColor = '+clickedBoxColor);
       helper.boxClickedHelper(component, event,clickedBoxColor );
    },
    
})