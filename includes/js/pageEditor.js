
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
				items[j].onclick = getModuleProperties;	
				items[j].ondblclick = editModuleProperties;
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
	document.location = "?event=ehPage.doUpdateModuleOrder&layout=" + newLayout;	
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
	if(confirm("Add " + resType + " " + resID + "?")) {
		document.location="?event=ehPage.doAddResource&resourceID="+resID+"&resType=" + resType;
	}
}

function viewResourceInfo(resID,resType) {
	doEvent("ehPage.dspResourceInfo","moduleProperties",{resourceID: resID, resType: resType});
}

function getModuleProperties(event) {
	e = fixEvent(event);
	var modID = this.id;
	
	doEvent("ehPage.dspModuleProperties","moduleProperties",{moduleID: modID});
	
	var items = document.getElementsByClassName("layoutListItem");
	for(var i=0;i<items.length;i++) {
		items[i].style.backgroundColor = "#eee";
	}
	$(modID).style.backgroundColor = "#fefcd8";
	
	
	function fixEvent(event) {
		if (typeof event == 'undefined') event = window.event;
		return event;
	}	
}

function editModuleProperties(event) {
	e = fixEvent(event);
	var modID = this.id;
	
	document.location = "?event=ehPage.dspEditModuleProperties&moduleID=" + modID;
	
	var items = document.getElementsByClassName("layoutListItem");
	for(var i=0;i<items.length;i++) {
		items[i].style.backgroundColor = "#eee";
	}
	$(modID).style.backgroundColor = "#fefcd8";
	
	
	function fixEvent(event) {
		if (typeof event == 'undefined') event = window.event;
		return event;
	}	
}

function doDeleteModule(moduleID) {
	if(confirm('Remove module from page?'))
		document.location = '?event=ehPage.doDeleteModule&ModuleID=' + moduleID;	
}


function deleteEventHandler(index) {
	if(confirm('Delete event handler?')) {
		document.location = '?event=ehPage.doDeleteEventHandler&index='+index;
	}
}

function doRenamePage() {
	var oldName = $("selCurrentPage").value;
	var newName = prompt("Enter the new name for this page:",oldName);

	if(newName && newName!=oldName) {
		tmpURL =  '?event=ehPage.doRenamePage&pageName=' + escape(newName);	
		document.location = tmpURL
	}
}

