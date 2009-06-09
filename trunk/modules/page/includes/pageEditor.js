
currentModuleLayout = "";
function initLayoutPreview() {
	try {
		var lists = document.getElementsByClassName("layoutPreviewList");

		// clear all containers
		DragDrop.firstContainer = null;
		DragDrop.lastContainer = null;
		DragDrop.parent_id = null;
		DragDrop.parent_group = null;

		for(i=0;i<lists.length;i++) {
			// declare list as sortable
			list = document.getElementById(lists[i].id);
			DragDrop.makeListContainer( list , "g1");
			list.onDragOver = function() { this.style["background"] = "#EEF"; };
			list.onDragOut = function() {this.style["background"] = "none"; };
			list.onDragDrop = function() {enableUpdateModuleOrder(); };
			
			// add onclick event to list items
			items = list.getElementsByTagName( "li" );
			for (var j = 0; j < items.length; j++) {	
				items[j].onclick = getModulePropertiesHandler;	
				items[j].ondblclick = editModulePropertiesHandler;
			}
		}

		currentModuleLayout = DragDrop.serData('g1');
	} catch(e) {
		alert(e);
	}
}


function enableUpdateModuleOrder() {
	var newLayout = DragDrop.serData('g1');
	if(currentModuleLayout != newLayout) {
		$("moduleOrderButtons").style.display = "block";
	}
}

function updateModuleOrder() {
	var newLayout = DragDrop.serData('g1');
	document.location = "?event=page.ehPage.doUpdateModuleOrder&newlayout=" + newLayout;	
}

function showLayoutSectionTitles(display) {
	var divs = document.getElementsByClassName("layoutSectionLabel");
	for(i=0;i<divs.length;i++) {
		d = $(divs[i].id);
		if(display) 
			d.style.display = "block";
		else
			d.style.display = "none";
	}	
}

function addResource(resID,resType) {
	var href = "index.cfm"
				+ "?event=page.ehPage.dspAddResource" 
				+ "&resourceID=" + resID + "&resType=" + resType;
	fb.loadAnchor(href,"width:480 height:300 loadPageOnClose:self");
}

function viewResourceInfo(resID,resType) {
	doEvent("page.ehPage.dspResourceInfo","moduleProperties",{resourceID: resID, resType: resType});
}

function addContentTag(tag) {
	var href = "index.cfm"
				+ "?event=page.ehPage.dspAddContentTag" 
				+ "&tag=" + tag

	fb.loadAnchor(href,"width:480 height:300 loadPageOnClose:self");
}

function viewContentTagInfo(tag) {
	doEvent("page.ehPage.dspContentRenderersInfo","moduleProperties",{tag: tag});
}

function getModulePropertiesHandler(event) {
	e = fixEvent(event);

	getModuleProperties(this.id);

	function fixEvent(event) {
		if (typeof event == 'undefined') event = window.event;
		return event;
	}	
}

function getModuleProperties(modID) {

	doEvent("page.ehPage.dspModuleProperties","moduleProperties",{moduleID: modID});
	
	var items = document.getElementsByClassName("layoutListItem");
	for(var i=0;i<items.length;i++) {
		items[i].style.backgroundColor = "#eee";
	}
	if($(modID)) $(modID).style.backgroundColor = "#fefcd8";
}

function editModulePropertiesHandler(event) {
	e = fixEvent(event);
	
	editModuleProperties(this.id);
	
	function fixEvent(event) {
		if (typeof event == 'undefined') event = window.event;
		return event;
	}	
}

function editModuleProperties(modID) {
	
	document.location = "?event=page.ehPage.dspEditModuleProperties&moduleID=" + modID;
	
	var items = document.getElementsByClassName("layoutListItem");
	for(var i=0;i<items.length;i++) {
		items[i].style.backgroundColor = "#eee";
	}
	if($(modID)) $(modID).style.backgroundColor = "#fefcd8";
}

function doDeleteModule(moduleID) {
	if(confirm('Remove module from page?'))
		document.location = '?event=page.ehPage.doDeleteModule&ModuleID=' + moduleID;	
}


function deleteEventHandler(index) {
	if(confirm('Delete event handler?')) {
		document.location = '?event=page.ehPage.doDeleteEventHandler&index='+index;
	}
}

function doRenamePage() {
	var oldName = $("page").value;
	var newName = prompt("Enter the new name for this page:",oldName);

	if(newName && newName!=oldName) {
		tmpURL =  '?event=page.ehPage.doRenamePage&pageName=' + escape(newName);	
		document.location = tmpURL
	}
}

function changePage(pg) {
	if(pg!='--NEW--')
		document.location='?event=page.ehPage.dspMain&page='+pg;
	else 
		document.location='?event=ehAccounts.dspAddPage';	
}

function changeSkin(skinID) {
	if(skinID=="_NEW")
		document.location='?event=resources.ehResources.dspMain&resourceType=skin&id=NEW&pkg=__ALL__';
	else if(skinID=="_IMPORT")
		document.location='?event=resources.ehResources.dspImport';
	else if(skinID!=0) 
		document.location='?event=page.ehPage.doApplySkin&skinID=' + skinID;
}

function changePageTemplate(pageTemplateName) {
	if(pageTemplateName!="0") {
		document.location='?event=page.ehPage.doSetPageTemplate&templateName=' + pageTemplateName;
	}
}

function applyPageTemplate(resID) {
	if(resID=="_NEW")
		document.location='?event=resources.ehResources.dspMain&resType=pagetemplate&id=NEW';
	else if(resID=="_IMPORT")
		document.location='?event=resources.ehResources.dspImport';
	else if(resID!="")
		document.location='?event=page.ehPage.doApplyPageTemplate&resourceID='+resID
}

function doSetModuleLocation(modID,locName) {
	document.location='?event=page.ehPage.doSetModuleLocation&moduleID='+modID+'&location='+locName;
}

function doMoveModule(dir,modID) {
	document.location='?event=page.ehPage.doMoveModule&moduleID='+modID+'&direction='+dir;
}

function loadInFB(href) {
	fb.loadAnchor(href,"width:480 height:300");
}
