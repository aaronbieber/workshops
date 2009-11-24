// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Event.observe(window, 'load', function() {
   $$('input[type=text]').each(function(e) {
       Event.observe(e, 'focus', fieldUp);
       Event.observe(e, 'blur', fieldDown);
   });
   $$('input[type=submit]').each(function(e) {
      e.className = 'button'; 
   });
});

function fieldUp() {
    var e = arguments[0] || window.event;
    // new Effect.Highlight(Event.element(e), { duration: 0.5, startcolor: '#ffffff', endcolor: '#ffff88', restorecolor: '#ffff88' } );
    Event.element(e).setStyle( { backgroundColor: '#ffff99' } );
}

function fieldDown() {
    var e = arguments[0] || window.event;
    // new Effect.Highlight(Event.element(e), { duration: 0.5, startcolor: '#ffff88', endcolor: '#ffffff', restorecolor: '#ffffff' } );
    Event.element(e).setStyle( { backgroundColor: '#ffffff' } );
}