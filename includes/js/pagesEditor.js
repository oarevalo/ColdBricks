function loadFolder(path) {
	doEvent("ehPages.dspFolder","folderMainPanel",{path: path}, loadFolderCallback);
	
	d = $$(".folderTreeItem");
	for(var i=0;i < d.length;i++) {
		d[i].style.fontWeight="normal";
	}	
	
	// highlight selected account
	d = $("folderTreeItem_"+path);
	if(d) d.style.fontWeight="bold";
}

function loadFolderCallback() {
	doEventComplete()
	loadPageInfo("");
}

function loadPageInfo(path,index) {
	doEvent("ehPages.dspPageInfo","pageInfoPanel",{path: path}, doEventComplete);

	d = $$(".pagesViewItem");
	for(var i=0;i < d.length;i++) {
		d[i].style.fontWeight="normal";
	}	
	
	// highlight selected account
	d = $("pagesViewItem_"+index);
	if(d) d.style.fontWeight="bold";
}

function openPage(page) {
	document.location = 'index.cfm?event=ehPage.dspMain&page='+escape(page);
}

function deletePage(page) {
	if(confirm('Delete page?')) {
		document.location = '?event=ehPages.doDeletePage&page='+escape(page);
	}
}

function deleteFolder(path) {
	if(confirm('Are you sure you wish to delete this folder and all of its pages?'))
		document.location = '?event=ehPages.doDeleteFolder&path=' + path;	
}


