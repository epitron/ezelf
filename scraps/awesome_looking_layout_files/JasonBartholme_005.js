document.write('<p class="feedburnerFlareBlock">');
document.write('<a href="http://feeds.feedburner.com/JasonBartholme" class="first">Subscribe to this feed</a>');
document.write('<span> &#8226; </span><a href="http://digg.com/submit?phase=2&partner=fb&url=http%3A%2F%2Fwww.jasonbartholme.com%2F2007%2F07%2F10%2Fhow-much-is-your-time-worth-as-a-blogger%2F&title=How+much+is+your+time+worth+as+a+blogger%3F">Digg This!</a>');
document.write('<span> &#8226; </span><a href="http://del.icio.us/post?v=4&partner=fb&url=http%3A%2F%2Fwww.jasonbartholme.com%2F2007%2F07%2F10%2Fhow-much-is-your-time-worth-as-a-blogger%2F&title=How+much+is+your+time+worth+as+a+blogger%3F">Save to del.icio.us</a>');
document.write('</p>');
var fStartPost=1;if(window.feedburner_currPost!=null){window.feedburner_currPost++}else{window.feedburner_currPost=1}if(document.body.getAttribute("fStartPost")){fs=parseInt(document.body.getAttribute("fStartPost"));if(!isNaN(fs))fStartPost=fs}if(window.feedburner_startPostOverride!=null){fs=parseInt(window.feedburner_startPostOverride);if(!isNaN(fs))fStartPost=window.feedburner_startPostOverride}else{window.feedburner_startPostOverride=fStartPost}if(window.feedburner_currPost==fStartPost){feedSrc='http://feeds.feedburner.com/~s/JasonBartholme?i='+escape("http://www.jasonbartholme.com/2007/07/10/how-much-is-your-time-worth-as-a-blogger/")+'&showad=true';document.write('<script src=\"'+feedSrc+'\" type=\"text/javascript\"></script>')}
                
if( typeof(FBSiteTrackerUri) == "undefined" || typeof(FBSiteTrackerURI) == "unknown" ) {
 var FBSiteTrackerUri = "JasonBartholme";
 document.write('<script type="text/javascript" charset="utf-8" src="http://feeds.feedburner.com/~d/static/site-tracker.js"></script>');
}
    	