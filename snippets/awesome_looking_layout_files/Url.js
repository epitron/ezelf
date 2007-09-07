/*****************************************************************************
* Url
******************************************************************************
* Version: 1.0
* Date: 05.24.2007
* Description: This library is used as the main javaScript loader. It also 
* provides a factory method which returns an object from it's string name.
*
*****************************************************************************/

function Url() {
	var _NAME = "UrlObject";
	var _VERSION = "1.0";
	var _CLASSIFICATION = "Utility";
	var _STRINGDESCRIPTION = "This is a utility for various url manipulation.";
	var _ENABLETESTS = false;
	try {
		_ENABLETESTS = true;
		this.jsUnitTestInternalSuite = jsUnitTestInternalSuite;
	} catch (e) {
	}
	
	//Read Only Public Methods
    this.NAME = function() { return _NAME; }
    this.VERSION = function() { return _VERSION; }
    this.CLASSIFICATION = function() { return _CLASSIFICATION; }
    this.STRINGDESCRIPTION = function() { return _STRINGDESCRIPTION; }
	
	//Public Methods
	this.CompareUrls = compareUrls;
	
	//Private Methods
    function compareUrls(url, locationUrl) {
	    url = stripElements(url);
	    locationUrl = stripElements(locationUrl);

	    if (locationUrl.indexOf(url) > -1) {
		    return true;
	    } else {
		    if (domainMashUp(url, locationUrl) == true) {
			    return true;
		    } 
	    }
	    return false;
    }
    
    function stripElements(tmpString) {
	    tmpString = tmpString.replace("http://", "");
    	tmpString = tmpString.replace("www.", "");
	    tmpString = tmpString.replace("~", "");
	    tmpString = tmpString.toLowerCase();
	    return tmpString;
    }

    function domainMashUp(url, locationUrl) {
	    if (checkSubDomains(url, locationUrl) == true) {
		    return true;
	    } 
	
	    if (checkReverseSubDomains(url, locationUrl) == true) {
		    return true;
	    } 
	
	    if (checkMySpace(url, locationUrl) == true) {
		    return true;
	    }
	    
	    if (check360Yahoo(url, locationUrl) == true) {
		    return true;
	    }
	
	    return false;
    }

    function checkSubDomains(url, locationUrl) {
	    //Lets first grab the sub-domain
	    subDomainNameIndex = url.indexOf(".");
	    subDomainName = url.substr(0, subDomainNameIndex);
	    newUrl = url.substr(subDomainNameIndex + 1);
	
	    //lets strip from the first /
	    slashIndex = newUrl.indexOf("/");
	    if (slashIndex > -1) {
		    newUrl = newUrl.substr(0, slashIndex);
	    } else {
		    //No work to do
	    }
	
	    //Lets create the subdomain folder
	    newUrl = newUrl + "/" + subDomainName;
	
	    //Now we check for match
	    if (locationUrl.indexOf(newUrl) > -1) {
		    return true;
	    } 
	    return false;
    }

    function checkReverseSubDomains(url, locationUrl) {
	    firstSlashIndex = url.indexOf("/");
        subDomainName = url.substr(firstSlashIndex + 1);
        newUrl = url.substr(0, firstSlashIndex);

        //Check for any following slashes and remove them
        firstSlashIndex = subDomainName.indexOf("/");
        if (firstSlashIndex > -1) {
	        subDomainName = subDomainName.substr(0, firstSlashIndex);
        } else {
	        //No work needed
        }
	
	 
	    newUrl = subDomainName + "." + newUrl;
	    if (locationUrl.indexOf(newUrl) > -1) {
		    return true;
	    }
	    return false;
    }

    function checkMySpace(url, locationUrl) {
	    //if the location isn't myspace why even go through the trouble.
	    if (locationUrl.indexOf("blog.myspace.com") < 0) {
		    return false;
	    }
	    
	    if (url.indexOf("friendID") > 0) {
		    urlIDindex = url.indexOf("friendID");
		    urlID = url.substr(urlIDindex + 9);
		    urlIDindex = urlID.indexOf("&");
		    urlID = urlID.substr(0, urlIDindex);
	    } else {
		    urlIDindex = url.indexOf("/");
		    urlID = url.substr(urlIDindex + 1);
        }
	    
	    if (locationUrl.indexOf(urlID) > -1) {
		    return true;
	    }
	
	    return false;
	
    }

    function check360Yahoo(url, locationUrl) {
	    //if the location isn't 360.yahoo.com why even go through the trouble.
	    if (locationUrl.indexOf("360.yahoo.com") < 0) {
		    return false;
	    }
	    
	    if (url.indexOf("blog-") > 0) {
		    urlIDindex = url.indexOf("blog-");
		    urlID = url.substr(urlIDindex + 9);
		    urlIDindex = urlID.indexOf("?");
		    if (urlIDindex > 0) {
		        urlID = urlID.substr(0, urlIDindex);
		    }
	    } 
	    
	    if (locationUrl.indexOf(urlID) > -1) {
		    return true;
	    }
	
	    return false;
	
    }

    function jsUnitTestInternalSuite() {
        var _TESTERROR = false;
	    if (_ENABLETESTS == true) {
		    info("Entering Internal Test Suite");
            testConstructor();
            testStripElements();
			testCheckSubDomainsFalse();
            testCheckSubDomainsFolderFalse();
            testCheckSubDomainsTrue();
            testCheckSubDomainsTrueWTilde();
            testCheckSubDomainsTrueWOtherLevels();
            testCheckReverseSubDomainsFalse();
            testCheckReverseSubDomainsFolderFalse();
            testCheckReverseSubDomainsTrue();
            testCheckReverseSubDomainsTrueWTilde();
            testCheckReverseSubDomainsTrueWOtherLevels();
            testNonMySpaceBlogEntry();
            testMySpaceBlogShortUrlTrue();
            testMySpaceBlogLongUrlTrue();
			testMySpaceBlogShortUrlFalse();
            testMySpaceBlogLongUrlFalse();
            testMySpaceReversedBlogShortUrlTrue();
            testMySpaceReversedBlogLongUrlTrue();
			testMySpaceReversedBlogShortUrlFalse();
            testMySpaceReversedBlogLongUrlFalse();
            test360YahooTrue();
			test360YahooFalse();
            if(_TESTERROR) fail();
        }
		
       	function testConstructor() {
            var Base = new Url();
            try {
                assertEquals("UrlObject", Base.NAME());
                info("testConstructor has Passed");
            } catch(e) {
                warn("testConstructor has Failed. Expected [UrlObject] - Was: [" + Base.NAME() + "]");
                _TESTERROR = true;
            }
        }

        function testStripElements() {
	        url = "http://www.Test.com/~user";
            try {
                assertEquals("test.com/user", stripElements(url));
                info("testStripElements has Passed");
            } catch(e) {
                warn("testStripElements has Failed. Expected [test.com/user] - Was: [" + stripElements(url) + "]");
                _TESTERROR = true;
            }
        }

        function testCheckSubDomainsFalse() {
            url = "something.test.com";
            urlLocation = "something.test2.com";
            try {
                assertFalse(checkSubDomains(url, urlLocation));
                info("testCheckSubDomainsFalse has Passed");
            } catch(e) {
                warn("testCheckSubDomainsFalse has Failed. Expected [false] - Was: [" + checkSubDomains(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function testCheckSubDomainsFolderFalse() {
            url = "something.test.com";
            urlLocation = "test2.com/something";
            try {
                assertFalse(checkSubDomains(url, urlLocation));
                info("testCheckSubDomainsFolderFalse has Passed");
            } catch(e) {
                warn("testCheckSubDomainsFolderFalse has Failed. Expected [false] - Was: [" + checkSubDomains(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

		function testCheckSubDomainsTrue() {
            url = "something.test.com";
            urlLocation = "test.com/something";
            try {
                assertTrue(checkSubDomains(url, urlLocation));
                info("testCheckSubDomainsTrue has Passed");
            } catch(e) {
                warn("testCheckSubDomainsTrue has Failed. Expected [true] - Was: [" + checkSubDomains(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

		function testCheckSubDomainsTrueWTilde() {
            url = "something.test.com";
            urlLocation = stripElements("test.com/~something");
            try {
                assertTrue(checkSubDomains(url, urlLocation));
                info("testCheckSubDomainsTrueWTilde has Passed");
            } catch(e) {
                warn("testCheckSubDomainsTrueWTilde has Failed. Expected [true] - Was: [" + checkSubDomains(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function testCheckSubDomainsTrueWOtherLevels() {
            url = "something.test.com/index.php";
            urlLocation = "test.com/something/index.php";
            try {
                assertTrue(checkSubDomains(url, urlLocation));
                info("testCheckSubDomainsTrueWOtherLevels has Passed");
            } catch(e) {
                warn("testCheckSubDomainsTrueWOtherLevels has Failed. Expected [true] - Was: [" + checkSubDomains(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }
		function testCheckReverseSubDomainsFalse() {
            url = "test2.com/something";
            urlLocation = "something.test.com";
            try {
                assertFalse(checkReverseSubDomains(url, urlLocation));
                info("testCheckReverseSubDomainsFalse has Passed");
            } catch(e) {
                warn("testCheckReverseSubDomainsFalse has Failed. Expected [false] - Was: [" + checkReverseSubDomains(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function testCheckReverseSubDomainsFolderFalse() {
            url = "test.com/something";
            urlLocation = "something.test2.com";
            try {
                assertFalse(checkReverseSubDomains(url, urlLocation));
                info("testCheckReverseSubDomainsFolderFalse has Passed");
            } catch(e) {
                warn("testCheckReverseSubDomainsFolderFalse has Failed. Expected [false] - Was: [" + checkReverseSubDomains(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

		function testCheckReverseSubDomainsTrue() {
            url = "test.com/something";
            urlLocation = "something.test.com/";
            try {
                assertTrue(checkReverseSubDomains(url, urlLocation));
                info("testCheckReverseSubDomainsTrue has Passed");
            } catch(e) {
                warn("testCheckReverseSubDomainsTrue has Failed. Expected [true] - Was: [" + checkReverseSubDomains(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

		function testCheckReverseSubDomainsTrueWTilde() {
            url = stripElements("test.com/~something");
            urlLocation = "something.test.com/";
            try {
                assertTrue(checkReverseSubDomains(url, urlLocation));
                info("testCheckReverseSubDomainsTrueWTilde has Passed");
            } catch(e) {
                warn("testCheckReverseSubDomainsTrueWTilde has Failed. Expected [true] - Was: [" + checkReverseSubDomains(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function testCheckReverseSubDomainsTrueWOtherLevels() {
            url = "test.com/something/index.php";
            urlLocation = "something.test.com/index.php";
            try {
                assertTrue(checkReverseSubDomains(url, urlLocation));
                info("testCheckReverseSubDomainsTrueWOtherLevels has Passed");
            } catch(e) {
                warn("testCheckReverseSubDomainsTrueWOtherLevels has Failed. Expected [true] - Was: [" + checkReverseSubDomains(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

		function testNonMySpaceBlogEntry() {
            url = "test.com/something/index.php";
            urlLocation = "something.test.com";
            try {
                assertFalse(checkMySpace(url, urlLocation));
                info("testNonMySpaceBlogEntry has Passed");
            } catch(e) {
                warn("testNonMySpaceBlogEntry has Failed. Expected [false] - Was: [" + checkMySpace(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }
        
		function testMySpaceBlogShortUrlTrue() {
            url = "blog.myspace.com/22784172";
            urlLocation = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=22784172&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            try {
                assertTrue(checkMySpace(url, urlLocation));
                info("testMySpaceBlogShortUrlTrue has Passed");
            } catch(e) {
                warn("testMySpaceBlogShortUrlTrue has Failed. Expected [true] - Was: [" + checkMySpace(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function testMySpaceBlogLongUrlTrue() {
            url = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=22784172&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            urlLocation = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=22784172&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            try {
                assertTrue(checkMySpace(url, urlLocation));
                info("testMySpaceBlogLongUrlTrue has Passed");
            } catch(e) {
                warn("testMySpaceBlogLongUrlTrue has Failed. Expected [true] - Was: [" + checkMySpace(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function testMySpaceBlogShortUrlFalse() {
            url = "blog.myspace.com/22784173";
            urlLocation = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=22784172&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            try {
                assertFalse(checkMySpace(url, urlLocation));
                info("testMySpaceBlogShortUrlFalse has Passed");
            } catch(e) {
                warn("testMySpaceBlogShortUrlFalse has Failed. Expected [true] - Was: [" + checkMySpace(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function testMySpaceBlogLongUrlFalse() {
            url = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=22784173&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            urlLocation = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=22784172&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            try {
                assertFalse(checkMySpace(url, urlLocation));
                info("testMySpaceBlogLongUrlFalse has Passed");
            } catch(e) {
                warn("testMySpaceBlogLongUrlFalse has Failed. Expected [false] - Was: [" + checkMySpace(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function testMySpaceReversedBlogShortUrlTrue() {
            urlLocation = "blog.myspace.com/22784172";
            url = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=22784172&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            try {
                assertTrue(checkMySpace(url, urlLocation));
                info("testMySpaceReversedBlogShortUrlTrue has Passed");
            } catch(e) {
                warn("testMySpaceBlogReversedShortUrlTrue has Failed. Expected [true] - Was: [" + checkMySpace(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function testMySpaceReversedBlogLongUrlTrue() {
            urlLocation = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=22784172&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            url = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=22784172&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            try {
                assertTrue(checkMySpace(url, urlLocation));
                info("testMySpaceReversedBlogLongUrlTrue has Passed");
            } catch(e) {
                warn("testMySpaceReversedBlogLongUrlTrue has Failed. Expected [true] - Was: [" + checkMySpace(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function testMySpaceReversedBlogShortUrlFalse() {
            urlLocation = "blog.myspace.com/227a4173";
            url = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=227a4172&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            try {
                assertFalse(checkMySpace(url, urlLocation));
                info("testMySpaceReversedBlogShortUrlFalse has Passed");
            } catch(e) {
                warn("testMySpaceReversedBlogShortUrlFalse has Failed. Expected [false] - Was: [" + checkMySpace(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function testMySpaceReversedBlogLongUrlFalse() {
            urlLocation = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=227a4173&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            url = "blog.myspace.com/index.cfm?fuseaction=blog.ListAll&friendID=227a4172&MyToken=204ea6bc-5dea-4953-b140-394147955d93ML";
            try {
                assertFalse(checkMySpace(url, urlLocation));
                info("testMySpaceReversedBlogLongUrlFalse has Passed");
            } catch(e) {
                warn("testMySpaceReversedBlogLongUrlFalse has Failed. Expected [false] - Was: [" + checkMySpace(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }
        
		function test360YahooTrue() {
            url = "http://blog.360.yahoo.com/blog-$ylrNbQic6eY3qDmtvBk0LmMSApL";
            urlLocation = "http://ca.blog.360.yahoo.com/blog-$ylrNbQic6eY3qDmtvBk0LmMSApL?l=246&u=250&mx=250&lmt=5";
            try {
                assertTrue(check360Yahoo(url, urlLocation));
                info("test360YahooTrue has Passed");
            } catch(e) {
                warn("test360YahooTrue has Failed. Expected [true] - Was: [" + check360Yahoo(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }

        function test360YahooFalse() {
            url = "http://blog.360.yahoo.com/blog-$ylrNbQic6eY3qDmtvBk0LmMSApx";
            urlLocation = "http://ca.blog.360.yahoo.com/blog-$ylrNbQic6eY3qDmtvBk0LmMSApL?l=246&u=250&mx=250&lmt=5";
            try {
                assertFalse(check360Yahoo(url, urlLocation));
                info("test360YahooFalse has Passed");
            } catch(e) {
                warn("test360YahooFalse has Failed. Expected [false] - Was: [" + check360Yahoo(url, urlLocation) + "]");
                _TESTERROR = true;
            }
        }
	}
}

try {
   assertEquals(1,1);
   var UrlObj = new Url();
} catch(e) {	   
}