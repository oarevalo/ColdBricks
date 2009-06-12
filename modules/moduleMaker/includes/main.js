function selectModuleType(itemName) {
	doEvent("moduleMaker.ehModuleMaker.dspModule","nodePanel",{moduleType: itemName});

	d = $$(".resTreeItem");
	for(var i=0;i < d.length;i++) {
		d[i].style.fontWeight="normal";
	}	
	
	// highlight selected account
	d = $("resTreeItem_"+itemName);
	if(d) d.style.fontWeight="bold";
}

function selectPanel(id) {
	d1 = $("head");
	d2 = $("body");
	d3 = $("config");
	
	d1.style.display = "none"
	d2.style.display = "none"
	d3.style.display = "none"
	
	if(id=="head") {d1.style.display="block"}
	if(id=="body") {d2.style.display="block"}
	if(id=="config") {d3.style.display="block"}
	
}
