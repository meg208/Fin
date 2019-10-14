({
    toggleExpansion: function( component, event, helper ) {
      var toShow = component.get( "v.isExpanded" );
      component.set( "v.isExpanded", !toShow );
    },
    removeMessage: function( component, event, helper ) {
      var message = event.getSource( ).get( "v.value" )
      var messages = component.get( "v.messages" )
      if ( message > -1 )
        messages.splice( message, 1 );
      component.set( "v.messages", messages );
    }
  })