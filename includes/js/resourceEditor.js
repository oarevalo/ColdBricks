tinyMCE.init({
	mode : "exact",
	elements : "body",
	theme : "advanced",
	plugins : "table",
	theme_advanced_toolbar_location : "top",
	theme_advanced_toolbar_align : "left",
	theme_advanced_path : "false",
	theme_advanced_buttons1 : "bold,italic,underline,separator,justifyleft,justifycenter,justifyright,separator,bullist,numlist,separator,outdent,indent,separator,link,unlink,separator,image,hr,separator,forecolor,backcolor,separator,help",
	theme_advanced_buttons2 : "fontselect,fontsizeselect,formatselect,tablecontrols",
	theme_advanced_buttons3 : "",
	//valid_elements : "*[*]"
	relative_urls : false
});

function selectResourceType(resType,id,pkg,resLibIndex) {
	if(id==null || id==undefined) id="";
	if(pkg==null || pkg==undefined) pkg="";
	if(resLibIndex==null || resLibIndex==undefined) resLibIndex="";
	doEvent("ehResources.dspResourceTypeList","nodePanel",{resourceType: resType,id: id,pkg: pkg,resLibIndex: resLibIndex});

	d = $$(".resTreeItem");
	for(var i=0;i < d.length;i++) {
		d[i].style.fontWeight="normal";
	}	
	
	// highlight selected account
	d = $("resTreeItem_"+resType);
	if(d) d.style.fontWeight="bold";
}

function selectResource(resType,id,pkg,resLibIndex) {
	if(id==null || id==undefined) id="";
	if(pkg==null || pkg==undefined) pkg="";
	if(resLibIndex==null || resLibIndex==undefined) resLibIndex="";
	doEvent("ehResources.dspResourceType","nodePanel",{resourceType: resType,id: id,pkg: pkg,resLibIndex: resLibIndex});

	d = $$(".resTreeItem");
	for(var i=0;i < d.length;i++) {
		d[i].style.fontWeight="normal";
	}	
	
	// highlight selected account
	d = $("resTreeItem_"+resType);
	if(d) d.style.fontWeight="bold";
}


function selectPanel(pnl, createEditorControl) {
	var id = "body";
	var pEditor = $("pnl_editor");
	var pInfo = $("pnl_info");
	
	if(pnl=='info') {
		if(pEditor) pEditor.style.display = "none";
		if(pInfo) pInfo.style.display = "block";
	
	} else if(pnl=='code') {
		if(pInfo) pInfo.style.display = "none";
		if(pEditor) pEditor.style.display = "block";
	
	} else if(pnl=='preview') {
		if(pInfo) pInfo.style.display = "none";
		if(pEditor) pEditor.style.display = "block";
		if(createEditorControl) {
			tinyMCE.idCounter=0;
			tinyMCE.execCommand('mceAddControl', false, id);
		}
	}

	d = $$(".panelSelector");
	for(var i=0;i < d.length;i++) {
		d[i].style.fontWeight="normal";
	}	
	
	// highlight selected account
	d = $("panelSelector_"+pnl);
	if(d) d.style.fontWeight="bold";

}

function setResourceTypeInfo(lbl,info) {
	var d = $("resInfo");
	if(d) d.innerHTML = "<h3 style='border-bottom:1px solid black;margin-bottom:3px;'>" + lbl + "</h3>" + info;	
}

function saveContent(frm) {
	var myMCE = tinyMCE.getInstanceById('body');
	tinyMCE.selectedInstance = myMCE;

	var ta = $('body');
	ta.value = tinyMCE.getContent();

	frm.submit();

}

function saveResource(frm) {
	var strErrors = "";
	if(frm.name.value=='') strErrors = strErrors + "\n - Resource name cannot be empty.";
	if(frm.pkg.value=='') strErrors = strErrors + "\n - Package name cannot be empty.";
	if(frm.resourceType.value == 'feed' && frm.href.value=='') strErrors = strErrors + "\n - Feed URL cannot be empty.";

	if(strErrors!="") {
		alert("Please correct the following:\n" + strErrors);
		return;		
	}
	
	if(frm.resourceType.value == 'content')
		saveContent(frm);
	else	
		frm.submit();
}

