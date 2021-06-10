
Shiny.addCustomMessageHandler(
  type = 'load-notice', function(message) {
    new jBox('Notice', {
      id: 'loading',      
      content: message,
      closeButton:true,
      autoClose:3000,
      color: 'red',
      stack: false,
      responsiveHeight:true,
      animation: 'slide'
    });
});