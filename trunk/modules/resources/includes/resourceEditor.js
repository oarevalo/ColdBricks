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
	doEvent("resources.ehResources.dspResourceTypeList","nodePanel",{resourceType: resType,id: id,pkg: pkg,resLibIndex: resLibIndex});

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
	doEvent("resources.ehResources.dspResource","nodePanel",{resourceType: resType,id: id,pkg: pkg,resLibIndex: resLibIndex});

	d = $$(".resTreeItem");
	for(var i=0;i < d.length;i++) {
		d[i].style.fontWeight="normal";
	}	
	
	// highlight selected account
	d = $("resTreeItem_"+resType);
	if(d) d.style.fontWeight="bold";
}

function setResourceTypeInfo(lbl,info) {
	var d = $("resInfo");
	if(d) d.innerHTML = "<h3 style='border-bottom:1px solid black;margin-bottom:3px;'>" + lbl + "</h3>" + info;	
}

function saveResource(frm) {
	var strErrors = "";

	if(frm.id.value=='') strErrors = strErrors + "\n - Resource ID cannot be empty.";
	if(frm.package.value=='' && frm.package_new.value=='') strErrors = strErrors + "\n - Package name cannot be empty.";

	if(strErrors!="") {
		alert("Please correct the following:\n" + strErrors);
		return;		
	}

	frm.submit();
}

function togglePackage(selVal) {
	if(selVal=='') 
		document.getElementById('newPkgDiv').style.display='block' 
	else 
		document.getElementById('newPkgDiv').style.display='none'
}

function showUploadFile() {
	document.getElementById('uploadDiv').style.display='block' 
}
function hideUploadFile() {
	document.getElementById('uploadDiv').style.display='none' 
}

function uploadFile(frm) {
	frm.event.value = "resources.ehResources.doUploadFile";
	frm.submit();
}

function confirmDeleteFile(id) {
	if(confirm("Delete target for resource '" + id + "' ?")) {
		document.location='index.cfm?event=resources.ehResources.doDeleteResourceFile&id='+id
	}
}

function loadResourceEditor(id,type) {
	doEvent("resources.ehResources.dspResourceEditor","nodePanel",{id: id,type: type});
}

function saveResourceFile(frm) {
	// check that there is a file name
	if(frm.fileName.value == '') {
		var ext = (frm.type.value=="richtext") ? "htm" : "txt";
		frm.fileName.value = prompt("Enter a name for this file",frm.id.value + "." + ext)
	}
	if(frm.fileName.value == '') {
		alert("Filename cannot be empty");
		return;
	}
	if(frm.type.value=="richtext") {
		var myMCE = tinyMCE.getInstanceById('body');
		tinyMCE.selectedInstance = myMCE;
	
		var ta = $('body');
		ta.value = tinyMCE.getContent();
	}
	frm.submit();
}

function uploadResource(resType,pkg,resLibIndex) {
	if(pkg==null || pkg==undefined) pkg="";
	if(resLibIndex==null || resLibIndex==undefined) resLibIndex="";

	var href = "index.cfm"
				+ "?event=resources.ehResources.dspUploadResource" 
				+ "&resourceType=" + resType
				+ "&pkg=" + pkg
				+ "&resLibIndex=" + resLibIndex

	fb.loadAnchor(href,"width:440 height:300 loadPageOnClose:self");
}

function createResource(resType,pkg,resLibIndex) {
	if(pkg==null || pkg==undefined) pkg="";
	if(resLibIndex==null || resLibIndex==undefined) resLibIndex="";

	var href = "index.cfm"
				+ "?event=resources.ehResources.dspCreateResource" 
				+ "&resourceType=" + resType
				+ "&pkg=" + pkg
				+ "&resLibIndex=" + resLibIndex

	fb.loadAnchor(href,"width:440 height:300 loadPageOnClose:self");
}