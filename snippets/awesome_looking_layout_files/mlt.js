//alert(getDomain(document.referrer));
if (!(getMLTCookie('hittail_ok')))
{
	if (getDomain(document.location.href) != getDomain(document.referrer) && (document.referrer != ''))
	{
		if(mlt_filter(document.referrer))
		{
			document.write('<img src=http://tracking.hittail.com/mlt.png?' + 
			escape(document.referrer) + ' width=1 height=1>');
		}
	}
	setMLTCookie ('hittail_ok', '1', '', '/', document.domain, '')
}

function mlt_filter(strToTest)
{
	 var mlt_acceptable = true;
	 var patternArray = new Array("http://private.", "http://internal.", "http://intranet.", "login=", "/login", "login.", "logon=", "/logon", "logon.", "/signin", "signin=", "signin.", "signon", "/admin/", "mail.", "/mail/", "/email/", "webmail", "mailbox", "https://", "cache:", "http://www.blogger.com", "http://localhost", "http://client.", "http://docs.", "http://timebase.", "http://www2.blogger.", "http://www.typepad.com/t/app/", "http://www.typepad.com/t/comments", "http://blockedReferrer");

	 for(i=0;i<patternArray.length;i++ )
	 {
		 if(strToTest.search(patternArray[i])>-1)
		 {
			mlt_acceptable = false;
		 }
	}
	var hittailPattern  = /http:\/\/(.+)\.hittail.com(.*)/;
	var mylongtailPattern  = /http:\/\/(.+)\.mylongtail.com(.*)/;
	if(strToTest.search(hittailPattern)>-1 || strToTest.search(mylongtailPattern)>-1)
	{
		mlt_acceptable = false;
	}
	return mlt_acceptable;
}

function setMLTCookie(name, value, expires, path, domain, secure) {
  var curCookie = name + "=" + escape(value) +
  //    ((expires) ? "; expires=" + expires.toGMTString() : "") +
      ((path) ? "; path=" + path : "") +
      ((domain) ? "; domain=" + domain : "") +
      ((secure) ? "; secure" : "");
  document.cookie = curCookie;
}

function getMLTCookie(name) {
  var dc = document.cookie;
  var prefix = name + "=";
  var begin = dc.indexOf("; " + prefix);
  if (begin == -1) {
    begin = dc.indexOf(prefix);
    if (begin != 0) return null;
  } else
    begin += 2;
  var end = document.cookie.indexOf(";", begin);
  if (end == -1)
    end = dc.length;
  return unescape(dc.substring(begin + prefix.length, end));
}

function getDomain(url) {
	var host, tld, sld, begin, end, remaining;
	begin = url.indexOf('//') + 2;
	if (url.indexOf('/',8)) 
	{
		end = url.indexOf('/',8);
	} else {
		end = url.length
	}
	return url.substring(begin, end);
}
