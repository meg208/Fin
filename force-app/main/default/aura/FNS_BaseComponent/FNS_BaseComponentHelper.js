({
    fireAppEvent: function(component, helper, action, payload) {
      var canFire = _.find(component.get('v.canFireAppActions'), function(a) {
        return a === action;
      });
      if ($A.util.isEmpty(action) || $A.util.isEmpty(canFire)) return;
      var appEvent = $A.get('e.c:appEvent');
      appEvent.setParams({
        action: action,
        payload: payload || null
      });
      appEvent.fire();
    },
  
    fireCompEvent: function(component, helper, action, payload) {
      /*var canFire = _.find(component.get('v.canFireCompActions'), function(a) {
        return a === action;
      });
      if ($A.util.isEmpty(action) || $A.util.isEmpty(canFire)) return;*/
      
      var compEvent = component.getEvent('baseCompEvent');
      compEvent.setParams({
        action: action,
        payload: payload || null
      });
      compEvent.fire();
    },
  
   showToastMessages: function(messages) {
      if (
        $A.util.isEmpty(messages) ||
        ($A.util.isArray(messages) && messages.length === 0)
      )
        return;
  
      _.forEach(messages, function(msg) {
        if ($A.util.isEmpty(msg.type) && $A.util.isEmpty(msg.message)) return;
        if ($A.util.isEmpty(msg.type) && !$A.util.isEmpty(msg.message))
          msg.type = 'error';
  
        var mode = msg.type.toLowerCase() === 'error' ? 'sticky' : 'dismissible';
        var toastEvent = $A.get('e.force:showToast');
        var msgType = msg.type.toLowerCase();
          
        if(msgType === 'success'){
            msgType = $A.get("$Label.c.FNS_SUCCESS");
        }else if(msgType === 'warning'){
            msgType = $A.get("$Label.c.FNS_WARNING");
        }else if(msgType === 'error'){
            msgType = $A.get("$Label.c.FNS_ERROR_HEADER");      
        }else if(msgType === 'info'){
          msgType = $A.get("$Label.c.FNS_INFO");     
        }
        else{
              msgType = msg.type; 
        }
          
        toastEvent.setParams({
          title: msgType + '!',
          type: msg.type.toLowerCase(),
          message: msg.message,
          mode: mode
        });
        toastEvent.fire();
      });
    }
  });