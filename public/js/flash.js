function isIE()
{
	return navigator.appName.indexOf("Microsoft") != -1 ||
		navigator.appName.indexOf("Opera") != -1;
}

function getFlashMovie() 
{
	var flashid = "loader";
	return isIE() ? window[flashid] : document[flashid];
}

function getInnerWidth()
{
	//return isIE() ? document.documentElement.clientWidth : window.innerWidth;
	// mozilla
	if (!isIE()) return window.innerWidth;
	//IE 6
	if (typeof document.documentElement != 'undefined' 
		&& typeof document.documentElement.clientWidth != 'undefined'
		&& document.documentElement.clientWidth != 0) return document.documentElement.clientWidth;
	// IE 7
	return document.getElementsByTagName('body')[0].clientWidth;
}

function getInnerHeight()
{
	//return isIE() ? document.documentElement.clientHeight : window.innerHeight;
	// mozilla
	if (!isIE()) return window.innerHeight;
	//IE 6
	if (typeof document.documentElement != 'undefined' 
		&& typeof document.documentElement.clientHeight != 'undefined'
		&& document.documentElement.clientHeight != 0) return document.documentElement.clientHeight;
	// IE 7
	return document.getElementsByTagName('body')[0].clientHeight;
}

function getOuterWidth()
{
	return isIE() ? document.documentElement.clientWidth : window.outerWidth;
}

function getOuterHeight()
{
	return isIE() ? document.documentElement.clientHeight : window.outerHeight;
}

function onFlashResize(width,height)
{
	// don't resize down on maximized
	if (getOuterWidth()>=screen.availWidth &&
		getOuterHeight()>=screen.availHeight) return;
	if (userResize)
	{
		if (width<minWidth) width = minWidth;
		else minWidth = 0;
		if (height<minHeight) height = minHeight;
		else minHeight = 0;
		if (minWidth==0 && minHeight==0) userResize = false;
	}
	// resize delta
	var fWidth = width-getInnerWidth()+5;
	var fHeight = height-getInnerHeight()+7;
	
	// adjustments
	if (fWidth>0 && fWidth+getOuterWidth()>screen.availWidth) fWidth = screen.availWidth-getOuterWidth();
	if (fHeight>0 && fHeight+getOuterHeight()>screen.availHeight) fHeight = screen.availHeight-getOuterHeight();
	
	flashResize = true;
	window.resizeBy(fWidth,fHeight);	
}

function refreshWindow() {
    flashResize = true;
    window.resizeBy(1, 1);
}

function getPageSize(size)
{
	var size = new Object();
	size.width = getInnerWidth();
	size.height = getInnerHeight();
	return size;
}

var minWidth = 0;
var minHeight = 0;
var userResize = false;
var flashResize = false;
window.onresize = function(event)
{
	if (userResize)
	{
		minWidth = getInnerWidth();
		minHeight = getInnerHeight();
	}
	else if (!flashResize) userResize = true;
	flashResize = false;
}