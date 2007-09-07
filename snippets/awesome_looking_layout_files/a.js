
					function set_103Cookie(cookie_val)
					{
						var date = new Date();
						date.setTime(date.getTime() + (30 * 60 * 1000));
						document.cookie = "103bees=" + cookie_val + "; expires=" + date.toGMTString() + "; path=/";
					}
					
					function get_103Cookie()
					{
						var nameEQ = "103bees=";
						var ca = document.cookie.split(';');
						for(var i=0;i < ca.length;i++)
						{
							var c = ca[i];
							while (c.charAt(0) == ' ') 
								c = c.substring(1,c.length);
								
							if (c.indexOf(nameEQ) == 0)
								return c.substring(nameEQ.length,c.length);
						}
						return null;
					}
																
					if(get_103Cookie() == null)
					{
						url = 'http://103bees.com/beehive/collector.php?bee=770&amp;fid=6354&amp;ref=' + encodeURIComponent(document.referrer) + '&amp;req=' + encodeURIComponent(document.URL);
						document.write('<img src="' + url + '" width="0" height="0" alt="" />');
						set_103Cookie(encodeURIComponent(document.referrer));
					}
				