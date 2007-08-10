var ppp_root = "http://payperpost.com";
document.write('<script type="text/javascript" language="javascript1.7" src="http://payperpost.com/javascripts/Objects/Url.js"></script>');

var ppp_inCall 				= false;
var ppp_mouse_pos_x 		= 0;
var ppp_mouse_pos_y 		= 0;
var ppp_mp;
var id 						= 0;
var ppp_img_id 				= 0;
var ppp_has_been_restyled 	= false;
var ppp_domain 				= "";
var ppp_popup 				= "";
var blog_is_typepad			= false;

var ppp_loading = "";
	ppp_loading += "<table width='100%' height='100%'>";
	ppp_loading += "	<tr>";
	ppp_loading += "		<td valign='middle' align='center'>";
	ppp_loading += "			<img style='vertical-align:middle;' src='"+ppp_root+"/images/dialogLoading.gif'><BR>";
	ppp_loading += "			Loading...";
	ppp_loading += "		</td>";
	ppp_loading += "	</tr>";
	ppp_loading += "</table>";

// ---------------------------------------------------------------
// BROWSER DETECTION
// ---------------------------------------------------------------

var BrowserDetect = {
	init: function () {
	this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
	this.version = this.searchVersion(navigator.userAgent)
		|| this.searchVersion(navigator.appVersion)
		|| "an unknown version";
	this.OS = this.searchString(this.dataOS) || "an unknown OS";
	},
	searchString: function (data) {
	for (var i=0;i<data.length;i++)	{
		var dataString = data[i].string;
		var dataProp = data[i].prop;
		this.versionSearchString = data[i].versionSearch || data[i].identity;
		if (dataString) {
			if (dataString.indexOf(data[i].subString) != -1)
				return data[i].identity;
		}
		else if (dataProp)
			return data[i].identity;
	}
},
searchVersion: function (dataString) {
		var index = dataString.indexOf(this.versionSearchString);
		if (index == -1) return;
		return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
	},
	dataBrowser: [
		{ string: navigator.userAgent, subString: "OmniWeb", versionSearch: "OmniWeb/", identity: "OmniWeb"},
		{ string: navigator.vendor, subString: "Apple", identity: "Safari"},
		{ prop: window.opera, identity: "Opera"},
		{ string: navigator.vendor, subString: "iCab", identity: "iCab"},
		{ string: navigator.vendor, subString: "KDE", identity: "Konqueror"},
		{ string: navigator.userAgent, subString: "Firefox", identity: "Firefox"},
		{ string: navigator.vendor, subString: "Camino", identity: "Camino"},
		{ string: navigator.userAgent, subString: "Netscape", identity: "Netscape"}, // for newer Netscapes (6+)
		{ string: navigator.userAgent, subString: "MSIE", identity: "Explorer", versionSearch: "MSIE"},
		{ string: navigator.userAgent, subString: "Gecko", identity: "Mozilla", versionSearch: "rv"},
		{ string: navigator.userAgent, subString: "Mozilla", identity: "Netscape", versionSearch: "Mozilla"} // for older Netscapes (4-)
	],
	dataOS : [
		{ string: navigator.platform, subString: "Win", identity: "Windows"},
		{ string: navigator.platform, subString: "Mac", identity: "Mac"},
		{ string: navigator.platform, subString: "Linux", identity: "Linux"}
	]
};
BrowserDetect.init();

// ---------------------------------------------------------------
// DISCLOSURE BADGE
// ---------------------------------------------------------------

function show_disclosure_ad(id){
	if(document.getElementById('pppDiv') != null){
	// the DIV already exists....
	}else{
		ppp_generatePopup(id);
		ppp_showMousePos;
		var pppDiv = document.createElement("div");
		if(BrowserDetect.browser == "Explorer"){
			pppDiv.id = "pppDiv"
			pppDiv.onmouseover = function() { close_disclosure_ad=false; }
			pppDiv.onmouseout = function() { close_disclosure_ad=true;hide_disclosure_ad(); }
		}else{
			pppDiv.setAttribute('id','pppDiv');
			pppDiv.setAttribute('onmouseover', 'close_disclosure_ad=false;');
			pppDiv.setAttribute('onmouseout', 'close_disclosure_ad=true;hide_disclosure_ad();');
		}
		pppDiv.style.visibility = "visible";
		pppDiv.style.width = "447"; //447
		pppDiv.style.height = "308"; //308
		pppDiv.style.position = "absolute";
		pppDiv.style.top = (ppp_mouse_pos_y - 320) + "px";
		pppDiv.style.left = (ppp_mouse_pos_x - 30) + "px";
		document.body.appendChild(pppDiv);
		document.getElementById("pppDiv").innerHTML = ppp_popup;
		if(BrowserDetect.browser == "Explorer"){
			ppp_reStyleImages();
		}		
	}
};
function hide_disclosure_ad(){
	setTimeout("ppp_do_hide()", 500);
};
function ppp_do_hide(){
	if(close_disclosure_ad){
		var ppp_div_to_close = document.getElementById('pppDiv');
		if(ppp_div_to_close){
			document.body.removeChild(ppp_div_to_close);
			ppp_img_id = 0;
		}
	}
};
function ppp_generatePopup(id){
	if(BrowserDetect.browser == "Explorer"){ // This is IE
		objectStyle = " style='margin:0px;padding:0px;border:0px;overflow:hidden;'";
		ul_w = 13; ul_h = 12; bt_w = 454; bt_h = 12; ur_w = 13; ur_h = 12; bl_w = 13; bl_h = 264; ll_w = 13; ll_h = 14; bb_w = 378; bb_h = 14; lr_w = 13; lr_h = 14; obj_w = 454; obj_h = 264;
	}else{
		objectStyle = "";
		ul_w = 13; ul_h = 12; bt_w = 454; bt_h = 12; ur_w = 13; ur_h = 12; bl_w = 13; bl_h = 264; ll_w = 13; ll_h = 14; bb_w = 378; bb_h = 14; lr_w = 13; lr_h = 14; obj_w = 454; obj_h = 264;
	}
	ppp_popup = "";
	ppp_popup += "<table cellpadding='0' cellspacing='0' border='0'>";
	ppp_popup += "	<tr>";
	ppp_popup += "		<td>" + createPNG(ppp_root+'/images/buglet_border/border_ul.png', ul_w, ul_h, 'ul') + "</td>";
	ppp_popup += "		<td colspan='2' align='left'>" + createPNG(ppp_root+'/images/buglet_border/border_top.png', bt_w, bt_h, 'bt') + "</td>";
	ppp_popup += "		<td>" + createPNG(ppp_root+'/images/buglet_border/border_ur.png', ur_w, ur_h, 'ur') + "</td>";
	ppp_popup += "	</tr>";
	ppp_popup += "	<tr>";
	ppp_popup += "		<td valign='top'>" + createPNG(ppp_root+'/images/buglet_border/border_left.png', bl_w, bl_h, 'bl') + "</td>";
	ppp_popup += "		<td colspan='2' bgcolor='#ffffff' valign='top'>";
	ppp_popup += "			<iframe width='" + obj_w + "' height='" + obj_h + "' frameborder='0' id='pppObject' src='" + ppp_root + "/buglet/ad/" + id + "'>Your browser doesn't support iFrames.</iframe>";
	ppp_popup += "		</td>";
	ppp_popup += "		<td valign='top'>" + createPNG(ppp_root+'/images/buglet_border/border_right.png', bl_w, bl_h, 'bh') + "</td>";
	ppp_popup += "	</tr>";
	ppp_popup += "	<tr>";
	ppp_popup += "		<td valign='top'>" + createPNG(ppp_root+'/images/buglet_border/border_ll.png', ll_w, ll_h, 'll') + "</td>";
	ppp_popup += "		<td valign='top' align='left'>" + createPNG(ppp_root+'/images/buglet_border/border_pointer.png', 76, 50, 'pointer') + "</td>";
	ppp_popup += "		<td valign='top' align='left'>" + createPNG(ppp_root+'/images/buglet_border/border_bottom.png', bb_w, bb_h, 'bb') + "</td>";
	ppp_popup += "		<td valign='top'>" + createPNG(ppp_root+'/images/buglet_border/border_lr.png', lr_w, lr_h, 'lr') + "</td>";
	ppp_popup += "	</tr>";
	ppp_popup += "</table>";
}

// ---------------------------------------------------------------
// PPP DIRECT
// ---------------------------------------------------------------

function show_direct_form(id,url,badge){
	if(document.getElementById('pppDirect') != null){
		// the DIV already exists....
	}else{
		ppp_generateDirectPopup(id,url,badge);
		ppp_showMousePos;
		var pppDirect = document.createElement("div");
		if(BrowserDetect.browser == "Explorer"){
			pppDirect.id = "pppDirect"
		}else{
			pppDirect.setAttribute('id','pppDirect');
		}
		pppDirect.style.visibility = "visible";
		pppDirect.style.zIndex = get_highest_zindex() + 1;
		pppDirect.style.width = "588";
		pppDirect.style.height = "488";
		pppDirect.style.position = "absolute";
		var pppWidth = ppp_getBrowserWidth();
		var pppHeight = ppp_getBrowserHeight();
		if(BrowserDetect.browser == "Explorer"){
			ppp_offset_y = (document.documentElement && document.documentElement.scrollTop) ? document.documentElement.scrollTop : document.body.scrollTop;
			ppp_offset_x = (document.documentElement && document.documentElement.scrollLeft) ? document.documentElement.scrollLeft : document.body.scrollLeft;
		}else{
			ppp_offset_y = window.pageYOffset;
			ppp_offset_x = window.pageXOffset;
		}
		pppDirect.style.top = ((pppHeight-488)/2) + ppp_offset_y + "px";
		pppDirect.style.left = ((pppWidth-588)/2) + ppp_offset_x + "px";
		document.body.appendChild(pppDirect);
		document.getElementById("pppDirect").innerHTML = ppp_popup;
		if(BrowserDetect.browser == "Explorer"){
			ppp_reStyleImages();
		}
	}
};
function ppp_direct_form_hide(){
	var ppp_div_to_close = document.getElementById('pppDirect');
	if(ppp_div_to_close){
		document.body.removeChild(ppp_div_to_close);
		ppp_img_id = 0;
	}
};
function ppp_generateDirectPopup(id,url,badge){
	if(BrowserDetect.browser == "Explorer"){ // This is IE
		objectStyle = " style='margin:0px;padding:0px;border:0px;overflow:hidden;'";
	}else{
		objectStyle = "";
	}
	ppp_popup = "";
	ppp_popup += "<table cellpadding='0' cellspacing='0' border='0'>";
	ppp_popup += "	<tr>";
	ppp_popup += "		<td style='padding:0px;border:0px;margin:0px;height:80px;'><div style='padding:0px;margin:0px;height:80px;'>" + createPNG(ppp_root+'/images/ppp_direct/border/ul.png', 30, 80, 'ul') + "</div></td>";
	ppp_popup += "		<td valign='top' style='height:80px;width:529px;padding:0px;border:0px;margin:0px;'>";
	ppp_popup += "			<div style='position:relative;height:80px;width:529px;border:0px;margin:0px;padding:0px;'>";
	top_image = "top.png"
	url_width = 338
	url_left = 135
	if(blog_is_typepad){
		top_image = "top_for_typepad.png";
		url_width = 208
		url_left = 265
	}
	ppp_popup += "				<div style='position:absolute;top:0px;left:0px;height:80px;width:529px;border:0px;margin:0px;padding:0px;'>" + createPNG(ppp_root+'/images/ppp_direct/border/'+top_image, 529, 80, 'bt') + "</div>";
	ppp_popup += "				<div style='position:absolute;top:36px;left:"+url_left+"px;height:20px;width:"+url_width+"px;border:0px;margin:0px;padding:0px;overflow:hidden;text-align:right;font-weight:bold;font-size:12px;color:white;font-family:verdana;'>"+url+"</div>";
	ppp_popup += "				<div style='position:absolute;top:36px;left:483px;height:16px;width:47px;border:0px;margin:0px;padding:0px;cursor:pointer;' onclick='ppp_direct_form_hide()'>" + createPNG(ppp_root+'/images/ppp_direct/close.png', 47, 16, 'close') + "</div>";
	ppp_popup += "			</div>";
	ppp_popup += "		</td>";
	ppp_popup += "		<td style='padding:0px;border:0px;margin:0px;height:80px;'><div style='padding:0px;margin:0px;height:80px;'>" + createPNG(ppp_root+'/images/ppp_direct/border/ur.png', 29, 80, 'ur') + "</div></td>";
	ppp_popup += "	</tr>";
	ppp_popup += "	<tr>";
	ppp_popup += "		<td style='padding:0px;border:0px;margin:0px;height:378px;' valign='top'><div style='padding:0px;margin:0px;height:378px;'>" + createPNG(ppp_root+'/images/ppp_direct/border/left.png', 30, 378, 'bl') + "</div></td>";
	ppp_popup += "		<td style='padding:0px;border:0px;margin:0px;height:378px;' bgcolor='#ffffff' valign='top' width='529' height='378'>";
	urlValidator = new Url();
	this_loc = window.location + "";
	if(urlValidator.CompareUrls(url, this_loc) == true || (this_loc == ppp_root + "/ppp_direct/blogger_directory.html")){
		url_src = ppp_root+"/direct/offer_information/"+id+"?badge="+badge
	}else{
		url_src = ppp_root+"/direct/wrong_location/"
	}
	ppp_popup += "			<div style='padding:0px;margin:0px;height:378px;'><iframe width='529' height='378' frameborder='0' id='pppObject' src='"+url_src+"'>Your browser doesn't support iFrames.</iframe></div>";
	ppp_popup += "		</td>";
	ppp_popup += "		<td style='padding:0px;border:0px;margin:0px;height:378px;' valign='top'><div style='padding:0px;margin:0px;height:378px;'>" + createPNG(ppp_root+'/images/ppp_direct/border/right.png', 29, 378, 'bh') + "</div></td>";
	ppp_popup += "	</tr>";
	ppp_popup += "	<tr>";
	ppp_popup += "		<td style='padding:0px;border:0px;margin:0px;height:30px;' valign='top'><div style='padding:0px;margin:0px;height:30px;'>" + createPNG(ppp_root+'/images/ppp_direct/border/ll.png', 30, 30, 'll') + "</div></td>";
	ppp_popup += "		<td style='padding:0px;border:0px;margin:0px;height:30px;' valign='top' align='left'><div style='padding:0px;margin:0px;height:30px;'>" + createPNG(ppp_root+'/images/ppp_direct/border/bottom.png', 529, 30, 'bb') + "</div></td>";
	ppp_popup += "		<td style='padding:0px;border:0px;margin:0px;height:30px;' valign='top'><div style='padding:0px;margin:0px;height:30px;'>" + createPNG(ppp_root+'/images/ppp_direct/border/lr.png', 29, 30, 'lr') + "</div></td>";
	ppp_popup += "	</tr>";
	ppp_popup += "</table>";
}
function ppp_checkLocation(){
	
}
// ---------------------------------------------------------------
// GLOBAL FUNCTIONS
// ---------------------------------------------------------------

function ppp_getBrowserHeight(){
	var myHeight = 0;
	if( typeof( window.innerWidth ) == 'number' ) {
    	//Non-IE
    	myHeight = window.innerHeight;
  	} else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
    	//IE 6+ in 'standards compliant mode'
    	myHeight = document.documentElement.clientHeight;
  	} else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
    	//IE 4 compatible
    	myHeight = document.body.clientHeight;
  	}
  	return myHeight;
}
function ppp_getBrowserWidth(){
	var myWidth = 0;
	if( typeof( window.innerWidth ) == 'number' ) {
    	//Non-IE
    	myWidth = window.innerWidth;
  	} else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
    	//IE 6+ in 'standards compliant mode'
    	myWidth = document.documentElement.clientWidth;
  	} else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
    	//IE 4 compatible
    	myWidth = document.body.clientWidth;
  	}
  	return myWidth;
}
function ppp_getMousePosition(e){
	if (!e) var e = event;
	return e.pageX ? {'x':e.pageX, 'y':e.pageY} : {'x':e.clientX + (document.documentElement ? document.documentElement.scrollLeft : document.body.scrollLeft), 'y':e.clientY + (document.documentElement ? document.documentElement.scrollTop : document.body.scrollTop)};
};
function ppp_showMousePos(e){
	if (!e) var e = event;
	ppp_mp = ppp_getMousePosition(e);
	ppp_mouse_pos_x = ppp_mp.x;
	ppp_mouse_pos_y = ppp_mp.y;
};
function ppp_init(){
	document.onmousemove = ppp_showMousePos;
	ppp_location = document.location + ""
	if(ppp_location.indexOf("typepad.com") != -1){
		blog_is_typepad = true;	
	}
};
function createPNG(img,width,height,name){
	ppp_img_id++;
	return '<img name="'+name+'" id="ppp_border_image_'+ppp_img_id+'" SRC="'+img+'" ALT="Disclosure Badge Border" height='+height+' width='+width+' style="padding:0px;border:0px;margin:0px;filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='+img+', sizingMethod=scale);" >';
}
function fixPadding (){
	pppObject.body.style.margin = '0';
	pppObject.body.style.padding = '0';
}
function ppp_reStyleImages(){
	for(i=1;i<ppp_img_id+1;i++){
		if(document.getElementById("ppp_border_image_"+i).src && document.getElementById("ppp_border_image_"+i).src != ppp_root + "/images/spacer.gif"){
			eval("ppp_border_image_"+i+".src = '"+ppp_root+"/images/spacer.gif'");
		}
	}
	ppp_has_been_restyled = true;
}
function get_highest_zindex(){
	var allElems = document.getElementsByTagName? document.getElementsByTagName("*") : document.all; // or test for that too
	var maxZIndex = 0;
	for(var i=0;i<allElems.length;i++) {
		var elem = allElems[i];
		var cStyle = null;
		if (elem.currentStyle) {
			cStyle = elem.currentStyle;
		}else if (document.defaultView && document.defaultView.getComputedStyle) {
			cStyle = document.defaultView.getComputedStyle(elem,"");
		}
		var sNum;
		if (cStyle) {
			sNum = Number(cStyle.zIndex);
		} else {
			sNum = Number(elem.style.zIndex);
		}
		if (!isNaN(sNum)) {
			maxZIndex = Math.max(maxZIndex,sNum);
		}
	}
	return maxZIndex;
}
// ---------------------------------------------------------------
// INITIALIZATIONS
// ---------------------------------------------------------------

window.onload = ppp_init;