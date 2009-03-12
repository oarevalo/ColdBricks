


function loadAccount(accountID,username) {
	var tmpAccountID = accountID;

	if(accountID != "" && username == "") {
		accountID = "";
	}

	doEvent("ehAccounts.dspAccount","accountMainPanel",{accountID: accountID, accountName: username}, loadAccountCallback);
	
	d = $$(".accountTreeItem");
	for(var i=0;i < d.length;i++) {
		d[i].style.fontWeight="normal";
	}	
	
	// highlight selected account
	d = $("accountTreeItem_"+tmpAccountID);
	if(d) d.style.fontWeight="bold";
}

function loadAccountCallback() {
	doEventComplete()
	loadPageInfo("");
	doEvent("ehAccounts.dspAccountInfo","accountInfoPanel",{}, doEventComplete);
}

function loadPageInfo(page,index) {
	doEvent("ehAccounts.dspPageInfo","pageInfoPanel",{page: page}, doEventComplete);

	d = $$(".pagesViewItem");
	for(var i=0;i < d.length;i++) {
		d[i].style.fontWeight="normal";
	}	
	
	// highlight selected account
	d = $("pagesViewItem_"+index);
	if(d) d.style.fontWeight="bold";
}

function openPage(account,page) {
	document.location = 'index.cfm?event=ehPage.dspMain&page='+escape(page)+'&account='+escape(account);
}

function deletePage(page) {
	if(confirm('Delete page?')) {
		document.location = '?event=ehAccounts.doDeletePage&page='+escape(page);
	}
}

function deleteAccount(accountID) {
	if(confirm('Are you sure you wish to delete this account and all related files?'))
		document.location = '?event=ehAccounts.doDelete&accountID=' + accountID;	
}


