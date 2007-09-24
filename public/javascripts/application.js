function set_ajax_throbber(element) {
  Ajax.Responders.register({ 
   onCreate: function() { 
     if (Ajax.activeRequestCount > 0) 
       Element.show(element); 
   }, 
   onComplete: function() { 
     if (Ajax.activeRequestCount == 0) 
       Element.hide(element); 
   } 
   });
}

function do_ajax_request( uri ) {
  new Ajax.Request(
    uri, 
    {
      asynchronous: true, 
      evalScripts: true
    }
    /*
      onComplete: function(request){Element.hide('loading');},
      onLoading: function(request){Element.show('loading');}
      */
  );
  
  return false;
}

function play_album(album_id) {
  location = "/stream/album/" + album_id;
}

function loading(div_id) {
    $(div_id).innerHTML = '<div class="loading"><img src="/images/throbber1.gif"><br />Loading...</div>';
}

function expand_artist(artist_id) {
  var expander_name = 'artists_'+artist_id+'_albums';
  var expander = $(expander_name);
  if (expander.loaded) {
    expander.toggle();
  }
  else {
    do_ajax_request("/browse/expand_artist/" + artist_id);
  }
}