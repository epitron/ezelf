// position of the tooltip relative to the mouse in pixel //
var offsetx = 12;
var offsety =  8;

function newelement(newid)
{ 
    if(document.createElement)
    { 
        var el = document.createElement('div'); 
        el.id = newid;     
        with(el.style)
        { 
            display = 'none';
            position = 'absolute';
        } 
        el.innerHTML = '&nbsp;'; 
        document.body.appendChild(el); 
    } 
} 
var ie5 = (document.getElementById && document.all); 
var ns6 = (document.getElementById && !document.all); 
var ua = navigator.userAgent.toLowerCase();
var isapple = (ua.indexOf('applewebkit') != -1 ? 1 : 0);
function getmouseposition(e)
{
    if(document.getElementById)
    {
        var iebody=(document.compatMode && 
        	document.compatMode != 'BackCompat') ? 
        		document.documentElement : document.body;
        pagex = (isapple == 1 ? 0:(ie5)?iebody.scrollLeft:window.pageXOffset);
        pagey = (isapple == 1 ? 0:(ie5)?iebody.scrollTop:window.pageYOffset);
        mousex = (ie5)?event.x:(ns6)?clientX = e.clientX:false;
        mousey = (ie5)?event.y:(ns6)?clientY = e.clientY:false;

        var lixlpixel_tooltip = document.getElementById('tooltip');
        lixlpixel_tooltip.style.left = (mousex+pagex+offsetx) + 'px';
        lixlpixel_tooltip.style.top = (mousey+pagey+offsety) + 'px';
    }
}
function tooltip(tip)
{
    if(!document.getElementById('tooltip')) newelement('tooltip');
    var lixlpixel_tooltip = document.getElementById('tooltip');
    lixlpixel_tooltip.innerHTML = tip;
    lixlpixel_tooltip.style.display = 'block';
    document.onmousemove = getmouseposition;
}
function exit()
{
    document.getElementById('tooltip').style.display = 'none';
}

