tinyMCE.init({
	mode : "exact",
	elements : "body",
	theme : "advanced",
	plugins : "table",
	theme_advanced_toolbar_location : "top",
	theme_advanced_toolbar_align : "left",
	theme_advanced_path : "false",
//	theme_advanced_buttons1 : "bold,italic,underline,separator,justifyleft,justifycenter,justifyright,separator,bullist,numlist,separator,outdent,indent,separator,link,unlink,separator,image,hr,separator,forecolor,backcolor,separator,help",
//	theme_advanced_buttons2 : "fontselect,fontsizeselect,formatselect,tablecontrols",
//	theme_advanced_buttons3 : "",
	//valid_elements : "*[*]"
	relative_urls : false
});

var aTokens = new Array();
var currentEventHander = "";

function selectTemplate(templateType,templateName) {
	doEvent(currentEventHander+".dspTemplate","nodePanel",{templateType: templateType,templateName: templateName});

	d = $$(".resTreeItem");
	for(var i=0;i < d.length;i++) {
		d[i].style.fontWeight="normal";
	}	
	
	// highlight selected account
	d = $("resTreeItem_"+templateName);
	if(d) d.style.fontWeight="bold";
}

function insertAtCursor(myField, myValue) {

  //IE support
 if (document.selection) {
    myField.focus();
    sel = document.selection.createRange();
    sel.text = myValue;
  }

  //MOZILLA/NETSCAPE support
  else if (myField.selectionStart || myField.selectionStart == '0') {
    var startPos = myField.selectionStart;
    var endPos = myField.selectionEnd;
    myField.value = myField.value.substring(0, startPos)
                  + myValue
                  + myField.value.substring(endPos, myField.value.length);
  } else {
    myField.value += myValue;
  }
}

function insertToken(tokenIndex) {
	var f = $("body");
	if(tokenIndex > 0)
		insertAtCursor(f, aTokens[tokenIndex]);	
}

function saveTemplate(frm) {
	if(frm.templateName.value == '') {
		alert("Template name cannot be empty");
		return;
	}
	if(frm.templateHREF.value == '') {
		frm.templateHREF.value = prompt("Enter the path where to save this template", frm.defaultHREF.value+frm.templateName.value+".htm");
	}
	if(frm.templateHREF.value == '') {
		alert("Template path cannot be empty");
		return;
	}
	if(frm.templateView.value=="richtext") {
		var myMCE = tinyMCE.getInstanceById('body');
		tinyMCE.selectedInstance = myMCE;
	
		var ta = $('body');
		ta.value = tinyMCE.getContent();
	}
	frm.event.value = currentEventHander+".doSaveTemplate";
	frm.submit();
}

function deleteTemplate(frm) {
	if(confirm("Delete this template?")) {
		frm.event.value = currentEventHander+".doDeleteTemplate";
		frm.submit();
	}
}
