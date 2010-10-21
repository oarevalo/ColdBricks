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
	if(resLibIndex==null || resLibIndex==undefined || resLibIndex==-1) resLibIndex=0;

	d = $$(".resTreeItem");
	for(var i=0;i < d.length;i++) {
		d[i].style.fontWeight="normal";
	}	
	
	// highlight selected account
	d = $("resTreeItem_"+resType);
	if(d) d.style.fontWeight="bold";
	
	resourceEditor.open(id,resType,pkg,resLibIndex);
}

function setResourceTypeInfo(lbl,info) {
	var d = $("resInfo");
	if(d) d.innerHTML = "<h3 style='border-bottom:1px solid black;margin-bottom:3px;'>" + lbl + "</h3>" + info;	
}

function togglePackage(selVal) {
	if(selVal=='') 
		document.getElementById('newPkgDiv').style.display='block' 
	else 
		document.getElementById('newPkgDiv').style.display='none'
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
	if(resLibIndex==null || resLibIndex==undefined || resLibIndex==-1) resLibIndex=0;
	resourceEditor.open('NEW',resType,pkg,resLibIndex);
}
