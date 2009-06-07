function doFormEvent (e, targetID, frm) {
	var params = {};
	for(i=0;i<frm.length;i++) {
		if(!(frm[i].type=="radio" && !frm[i].checked))  {
			params[frm[i].name] = frm[i].value;
		}
	}
	doEvent(e, targetID, params);
}

function doEvent (e, targetID, params, onComplete) {
	var pars = "";
	
	if(onComplete==null || onComplete==undefined) onComplete = doEventComplete;
	
	for(p in params) pars = pars + p + "=" + escape(params[p]) + "&";
	pars = pars + "event=" + e;
	var myAjax = new Ajax.Updater(targetID,
									"index.cfm",
									{method:'get', parameters:pars, evalScripts:true, onFailure:h_callError, onComplete:onComplete});
	startLoadingTicker();
}

function h_callError(request) {
	alert('Sorry. An error ocurred while calling a server side component.');
}

function doEventComplete (obj) {stopLoadingTicker()}

function startLoadingTicker() {
	var i = $("loadingImage");
	if(i) i.style.display = 'inline';
}
function stopLoadingTicker() {
	var i = $("loadingImage");
	if(i) i.style.display = 'none';
}
 
 
 
var tab = "\t";

function checkTab(evt) {
	var t = evt.target;
	var ua = navigator.userAgent.toLowerCase(); 
	var isFirefox = (ua.indexOf('mozilla') != -1); 
	var isOpera = (ua.indexOf('opera') != -1); 
	var isIE  = (ua.indexOf('msie') != -1 && !isOpera && (ua.indexOf('webtv') == -1) ); 
	if(!isIE) {
		var ss = t.selectionStart;
		var se = t.selectionEnd;
		
		// Tab key - insert tab expansion
		if (evt.keyCode == 9) {
		    evt.preventDefault();
		    
		    // Special case of multi line selection
		    if (ss != se && t.value.slice(ss,se).indexOf("\n") != -1) {
		        // In case selection was not of entire lines (e.g. selection begins in the middle of a line)
		        // we ought to tab at the beginning as well as at the start of every following line.
		        var pre = t.value.slice(0,ss);
		        var sel = t.value.slice(ss,se).replace(/\n/g,"\n"+tab);
		        var post = t.value.slice(se,t.value.length);
		        t.value = pre.concat(tab).concat(sel).concat(post);
		        t.selectionStart = ss + tab.length;
		        t.selectionEnd = se + tab.length;
		    }
		    
		    // "Normal" case (no selection or selection on one line only)
		    else {
		        t.value = t.value.slice(0,ss).concat(tab).concat(t.value.slice(ss,t.value.length));
		        if (ss == se) {
		            t.selectionStart = t.selectionEnd = ss + tab.length;
		        }
		        else {
		            t.selectionStart = ss + tab.length;
		            t.selectionEnd = se + tab.length;
		        }
		    }
		}
		
		// Backspace key - delete preceding tab expansion, if exists
		else if (evt.keyCode==8 && t.value.slice(ss - tab.length,ss) == tab) {
		    evt.preventDefault();
		    t.value = t.value.slice(0,ss - tab.length).concat(t.value.slice(ss,t.value.length));
		    t.selectionStart = t.selectionEnd = ss - tab.length;
		}
		
		// Delete key - delete following tab expansion, if exists
		else if (evt.keyCode==46 && t.value.slice(se,se + tab.length) == tab) {
		    evt.preventDefault();
		    t.value = t.value.slice(0,ss).concat(t.value.slice(ss + tab.length,t.value.length));
		    t.selectionStart = t.selectionEnd = ss;
		}
		
		// Left/right arrow keys - move across the tab in one go
		else if (evt.keyCode == 37 && t.value.slice(ss - tab.length,ss) == tab) {
		    evt.preventDefault();
		    t.selectionStart = t.selectionEnd = ss - tab.length;
		}
		else if (evt.keyCode == 39 && t.value.slice(ss,ss + tab.length) == tab) {
		    evt.preventDefault();
		    t.selectionStart = t.selectionEnd = ss + tab.length;
		}
	}      
  }
  function checkTabIE() {
	var ua = navigator.userAgent.toLowerCase(); 
	var isFirefox = (ua.indexOf('mozilla') != -1); 
	var isOpera = (ua.indexOf('opera') != -1); 
	var isIE  = (ua.indexOf('msie') != -1 && !isOpera && (ua.indexOf('webtv') == -1) ); 

	if(isIE && event.srcElement.value) {
	   if (event.keyCode == 9) {  // tab character
	      if (document.selection != null) {
	         document.selection.createRange().text = '\t';
	         event.returnValue = false;
	      } else {
	         event.srcElement.value += '\t';
	         return false;
	      }
	   }
	 }
  }
  
  
  function hideMessageBox() {
  	var d = document.getElementById("app_messagebox");
  	d.style.display = "none";
  }	
  
 function overlay() {
	el = document.getElementById("overlay");
	el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
} 

function togglePanel(id) {
	var d = document.getElementById(id);
	if(d) {
		if(d.style.display=='block') 
			d.style.display='none';
		else	
			d.style.display='block';
	}
}

function loadSite(siteID,firstTime,nextEvent) {
	if(firstTime==null || firstTime==undefined) firstTime = false;
	if(nextEvent==null || nextEvent==undefined) nextEvent = "";
	overlay();
	document.location = 'index.cfm?event=site.ehSite.doLoadSite&siteID=' + siteID + '&firstTime='+firstTime + '&nextEvent='+nextEvent;
}
