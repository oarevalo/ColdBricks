<cfcomponent extends="eventHandler">

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oAcc = 0;
			var loaded = getValue("loaded",false);
			var showAccount = getValue("showAccount", true );
			var oContext = getService("sessionContext").getContext();
						
			try {
				hp = oContext.getHomePortals();
				oAcc = hp.getAccountsService();
				
				if(showAccount and oContext.getAccountID() neq "" and oContext.getAccountID() neq 0) {
					setValue("showAccount", true );
					setValue("accountID", oContext.getAccountID() );
				}
				
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("qryAccounts", oAcc.getAccounts() );
				setValue("accountsRoot", hp.getAccountsService().getConfig().getAccountsRoot() );
				setValue("cbPageTitle", "Accounts");
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				setView("site/accounts/vwMain");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				if(loaded)
					setNextEvent("ehGeneral.dspMain");		// this is to avoid circular redirects when first opening the site
				else
					setNextEvent("ehSite.dspMain");
			}				
		</cfscript>
	</cffunction>
	
	<cffunction name="dspAccount" access="public" returntype="void">
		<cfscript>
			var accountID = getValue("accountID");
			var accountName = getValue("accountName");
			var viewType = getValue("viewType");
			var hp = 0;
			var oAccountSite = 0;
			var aPages = 0;
			var oContext = getService("sessionContext").getContext();

			try {
				hp = oContext.getHomePortals();

				// if a siteID is given, then set it on the context struct
				if(accountID neq "") {
					oContext.setAccountID(accountID);
					oContext.setAccountName(accountName);
					oContext.setAccountSite(createObject("component","Home.Components.accounts.site").init(accountName, hp.getAccountsService() ));
				} else {
					setValue("accountID", oContext.getAccountID());
					setValue("accountName", oContext.getAccountName());
				}
				
				// get default view type
				if(oContext.getAccountViewType() eq "") oContext.setAccountViewType("details");
				if(viewType neq "") oContext.setAccountViewType(viewType);
				
				oAccountSite = oContext.getAccountSite();
				aPages = oAccountSite.getPages();

				setValue("accountsRoot", hp.getAccountsService().getConfig().getAccountsRoot() );
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("aPages",aPages);
				setValue("siteTitle",oAccountSite.getSiteTitle());
				setValue("viewType",oContext.getAccountViewType());
				
				setView("site/accounts/vwAccount");
				setLayout("Layout.None");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>
	</cffunction>

	<cffunction name="dspAccountInfo" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var numPages = 0;
			var oAccountSite = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
				oAccountSite = oContext.getAccountSite();
				
				numPages = arrayLen(oAccountSite.getPages());

				setValue("accountID", oContext.getAccountID());
				setValue("accountName", oContext.getAccountName());
				setValue("oAccountSite", oAccountSite);
				setValue("accountsRoot", hp.getAccountsService().getConfig().getAccountsRoot() );
				setValue("numPages", numPages);
				setValue("appRoot", hp.getConfig().getAppRoot() );
	
				setView("site/accounts/vwAccountInfo");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>
	</cffunction>

	<cffunction name="dspPageInfo" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oAccountSite = 0;
			var aPages = 0;
			var stPage = 0;
			var page = getValue("page");
			var pageHREF = "";
			var oContext = getService("sessionContext").getContext();
			
			try {
				setLayout("Layout.None");	

				hp = oContext.getHomePortals();
				oAccountSite = oContext.getAccountSite();
				aPages = oAccountSite.getPages();

				if(page neq "") {
					for(i=1;i lte arrayLen(aPages);i=i+1) {
						if(aPages[i].href eq page) {
							stPage = aPages[i];
							break;
						}
					}
				}

				pageHREF = oAccountSite.getPageHREF(page);
				
				setValue("pageExists", hp.getPageProvider().pageExists(pageHREF));
				setValue("stPage",stPage);
				setValue("accountName", oContext.getAccountName());
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setView("site/accounts/vwPageInfo");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>
	</cffunction>

	<cffunction name="dspAddPage" access="public" returntype="void">
		<cfscript>
			var oSite = 0;
			var oAccounts = 0;
			var accountID = 0;
			var qryAccount = 0;
			var aCatalogPages = 0;
			var aPages = 0;
			var oContext = getService("sessionContext").getContext();

			try {
				hp = oContext.getHomePortals();
				
				// check if we have a site cfc loaded 
				if(Not oContext.hasAccountSite()) throw("Please select an account first.");
				
				// get site from session
				oSite = oContext.getAccountSite();

				// get info from site
				aPages = oSite.getPages();

				// get accounts info 
				accountID = oContext.getAccountID();
				qryAccount = hp.getAccountsService().getAccountByID(accountID);

				// get catalog
				oCatalog = hp.getCatalog();
				aCatalogPages = oCatalog.getResourcesByType("page");
				
				setValue("qryAccount", qryAccount);
				setValue("aPages", aPages);
				setValue("aCatalogPages", aCatalogPages);

				setValue("cbPageTitle", "Accounts > #qryAccount.accountname# > Add Page");
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);

				setView("site/accounts/vwAddPage");		

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehAccounts.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspTokenizePage" access="public" returntype="void">
		<cfscript>
			var oSite = 0;
			var pageName = getValue("pageHREF","");
			var numCopies = getValue("numCopies",1);
			var oContext = getService("sessionContext").getContext();
			var accountName = "";

			try {
				hp = oContext.getHomePortals();
				
				// check if we have a site cfc loaded 
				if(Not oContext.hasAccountSite()) throw("Please select an account first.");
				
				// get site from session
				oSite = oContext.getAccountSite();

				// search account
				qryAccount = hp.getAccountsService().getAccountByName( oSite.getOwner() );

				// get source page
				oPage = oSite.getPage(pageName);

				// get full page address
				pageHREF = oSite.getPageHREF(pageName);

				if(val(numCopies) lt 1) numCopies = 1;
					
				setValue("pageHREF",pageHREF);
				setValue("numCopies",numCopies);
				setValue("oPage", oPage );
				setValue("qryAccount", qryAccount );
				setValue("cbPageTitle", "Accounts > #qryAccount.accountname# > Tokenize Page");
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);

				setView("site/accounts/vwTokenizePage");		

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehAccounts.dspAddPage");
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspEdit" access="public" returntype="void">
		<cfscript>
			var oAccounts = structNew();
			var	qryAccount = 0;
			var accountID = getValue("accountID",0);
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				
				// get accounts info 
				oAccounts = hp.getAccountsService();
				stAccountInfo = oAccounts.getConfig();
	
				if(accountID eq 0) throw("Please select an account first");
	
				// search account
				qryAccount = oAccounts.getAccountByID(accountID);
				
				setValue("stAccountInfo", stAccountInfo);
				setValue("qryAccount", qryAccount);
				setValue("accountsRoot", hp.getAccountsService().getConfig().getAccountsRoot() );

				setValue("cbPageTitle", "Accounts > #qryAccount.accountname# > Account Profile");
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				
				setView("site/accounts/vwEdit");
	
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehAccounts.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspCreate" access="public" returntype="void">
		<cfscript>
			setValue("cbPageTitle", "Accounts > Create New Account");
			setValue("cbPageIcon", "images/users_48x48.png");
			setValue("cbShowSiteMenu", true);
			setView("site/accounts/vwCreate");
		</cfscript>
	</cffunction>



	<cffunction name="doSave" access="public" returntype="void">
		<cfscript>
			var oAccounts = 0;
			var accountID = getValue("accountID","");
			var accountname = getValue("accountname");
			var firstName = getValue("firstName");
			var lastname = getValue("lastname");
			var email = getValue("email");
			var password = getValue("password");
			var pwd_new = getValue("pwd_new");
			var pwd_new2 = getValue("pwd_new2");
			var changePwd = getValue("changePwd",0);
			var NewUserID = "";
			var oContext = getService("sessionContext").getContext();

			try {
				hp = oContext.getHomePortals();
				oAccounts = hp.getAccountsService();

				if(accountname eq "") throw("Account name cannot be empty.","coldBricks.validation");
				if(accountID eq "" and password eq "") throw("Password cannot be empty.","coldBricks.validation");
				if(accountID neq "" and changePwd and pwd_new eq "")  throw("New password cannot be empty.","coldBricks.validation");
				if(accountID neq "" and changePwd and pwd_new neq pwd_new2)  throw("Passwords do not match.","coldBricks.validation");

				if(accountID neq "") {
					oAccounts.UpdateAccount(accountID, firstName, lastName, email);
					if(changePwd) oAccounts.changePassword(accountID, pwd_new);
					setMessage("info", "Account saved");
				} else {
					accountID = oAccounts.CreateAccount(accountname, password, firstName, lastName, email);
					setMessage("info", "Account created");
				}

				setNextEvent("ehAccounts.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				if(accountID neq "") 
					setNextEvent("ehAccounts.dspEdit","accountID=#accountID#");
				else
					setNextEvent("ehAccounts.dspCreate");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				if(accountID neq "") 
					setNextEvent("ehAccounts.dspEdit","accountID=#accountID#");
				else
					setNextEvent("ehAccounts.dspCreate");
			}
		</cfscript>	
	</cffunction>

	<cffunction name="doDelete" access="public" returntype="void">
		<cfscript>
			var oAccounts = 0;
			var accountID = getValue("accountID","");
			var oContext = getService("sessionContext").getContext();

			try {
				if(accountID eq "") throw("Please indicate the name of the account to delete.","coldBricks.validation");
				
				hp = oContext.getHomePortals();
				oAccounts = hp.getAccountsService();
				oAccounts.deleteAccount(accountID);
				
				oContext.setAccountID("");
				oContext.clearAccountSite();
				
				setMessage("info", "Account has been deleted.");
				setNextEvent("ehAccounts.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehAccounts.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehAccounts.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doSetSiteTitle" access="public" returntype="void">
		<cfscript>
			var title = getValue("title","");
			var oSite = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				oSite = oContext.getAccountSite();
				oSite.setSiteTitle(title);
				setMessage("info", "Site title changed.");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
			setNextEvent("ehAccounts.dspMain");
		</cfscript>
	</cffunction>

	<cffunction name="doSetDefaultPage" access="public" returntype="void">
		<cfscript>
			var page = getValue("page","");
			var oSite = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				oSite = oContext.getAccountSite();
				oSite.setDefaultPage(page);
				setMessage("info", "Default page set.");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
			setNextEvent("ehAccounts.dspMain");
		</cfscript>
	</cffunction>

	<cffunction name="doDeletePage" access="public" returntype="void">
		<cfscript>
			var page = getValue("page","");
			var oSite = 0;
			var userID = "";
			var oContext = getService("sessionContext").getContext();
			
			try {
				oSite = oContext.getAccountSite();
				for(i=1;i lte listLen(page);i=i+1) {
					oSite.deletePage(listGetAt(page,i));
				}
				setMessage("info", "Page deleted");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
			setNextEvent("ehAccounts.dspMain");
		</cfscript>
	</cffunction>

	<cffunction name="doAddPage" access="public" returntype="void">
		<cfscript>
			var pageName = getValue("pageName","");
			var oSite = 0;
			var tmpFirstPart = "";
			var oContext = getService("sessionContext").getContext();
			
			try {
				// get site from session
				if(Not oContext.hasAccountSite()) throw("Please select an account first.");
				oSite = oContext.getAccountSite();
				
				if(pageName eq "") throw("The page name cannot be blank.","coldBricks.validation");
				
				// if the pageName contains any spaces, then replace them with _
				pageName = replace(pageName," ","_","ALL");

				if(right(pageName,4) eq ".xml") 
					tmpFirstPart = left(pageName,len(pageName)-4);
				else
					tmpFirstPart = pageName;
					
				// check that the page name only contains simple characters
				if(reFind("[^A-Za-z0-9_]",tmpFirstPart)) 
					throw("Page names can only contain characters from the alphabet, digits and the underscore symbol","coldbricks.validation");
				
				// add page
				oSite.addPage(pageName);

				setMessage("info", "New page created.");
				oContext.setAccountID("");
				setNextEvent("ehAccounts.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehAccounts.dspAddPage");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehAccounts.dspAddPage");
			}			
		</cfscript>
	</cffunction>	
	
	<cffunction name="doCopyPage" access="public" returntype="void">
		<cfscript>
			var pageHREF = getValue("pageHREF","");
			var numCopies = getValue("numCopies",1);
			var tokenize = getValue("tokenize",0);
			var oSite = 0;
			var userID = "";
			var oContext = getService("sessionContext").getContext();
			
			try {
				// get site from session
				if(Not oContext.hasAccountSite()) throw("Please select an account first.");
				oSite = oContext.getAccountSite();
				
				if(val(numCopies) eq 0) throw("The number of copies to make must be a valid number greater or equal to 1","coldBricks.validation");
				if(tokenize eq 1) setNextEvent("ehAccounts.dspTokenizePage","pageHREF=#pageHREF#&numCopies=#numCopies#");
				
				for(i=1;i lte val(numCopies);i=i+1) {
					oSite.addPage("#getFileFromPath(pageHREF)##i#",pageHREF);
				}
				
				setMessage("info", "Page copied.");
				oContext.setAccountID("");
				setNextEvent("ehAccounts.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehAccounts.dspAddPage");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehAccounts.dspAddPage");
			}			
		</cfscript>
	</cffunction>		
	
	<cffunction name="doAddPageResource" access="public" returntype="void">
		<cfscript>
			var resourceID = getValue("resourceID");
			var oSite = 0;
			var hp = 0; var resRoot = "";
			var oCatalog = 0; var oResourceBean = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// get site from session
				if(Not oContext.hasAccountSite()) throw("Please select an account first.");
				oSite = oContext.getAccountSite();
				
				// get resource root
				hp = oContext.getHomePortals();
				resRoot = hp.getConfig().getResourceLibraryPath();
		
				// get pagetemplate resource
				oCatalog = hp.getCatalog();
				oResourceBean = oCatalog.getResourceNode("page", resourceID);
				
				// add page resource
				oSite.addPageResource(oResourceBean, resRoot);
				
				setMessage("info", "Page added to site.");
				oContext.setAccountID("");
				setNextEvent("ehAccounts.dspMain");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehAccounts.dspAddPage");
			}			
		</cfscript>
	</cffunction>			
	
	<cffunction name="doCopyTokenizedPage" access="public" returntype="void">
		<cfscript>
			var pageHREF = getValue("pageHREF","");
			var numCopies = getValue("numCopies",1);
			var numTokens = getValue("numTokens",1);
			var xmlContent = getValue("xmlContent","");
			var oSite = 0;
			var userID = "";
			var oPage = 0;
			var i = 0;
			var j = 0;
			var newPageURL = "";
			var pageTitle = "";
			var aStatus = arrayNew(1);
			var st = structNew();
			var oContext = getService("sessionContext").getContext();
			var xmlDoc = 0;
			
			try {
				// get site from session
				if(Not oContext.hasAccountSite()) throw("Please select an account first.","coldBricks.validation");
				oSite = oContext.getAccountSite();
				
				if(val(numCopies) eq 0) throw("Please enter a valid greater or equal to 1 for the number of copies to be made","coldBricks.validation");
				if(val(numTokens) eq 0) throw("Please enter a valid greater or equal to 1 for the number of tokens to use","coldBricks.validation");

				// process all copies
				for(i=1;i lte val(numCopies);i=i+1) {
					
					try {
						// get page title, make sure is not blank or that it doesnt have any invalid characters
						pageTitle = getValue("name_#i#");
						if(pageTitle eq "" or reFind("[^A-Za-z0-9_ .]",pageTitle) ) pageTitle = "Copy #i# of " & pageHREF;
						
						// remove the .xml from the pageTitle (this is to allow the site object to detect duplicates)
						pageTitle = replaceNoCase(pageTitle,".xml","");

						// build actual XML for new page by replacing tokens
						newXMLContent = xmlContent;
						for(j=1;j lte val(numTokens);j=j+1) {
							newXMLContent = replace(newXMLContent,"%#j#",getValue("token_#i#_#j#",""),"ALL");
						}			

						// check that new page is a valid XML document
						if(not isXml(newXMLContent)) {
							throw("The given content is not a valid XML document");
						}						

						// add blank page to site
						newPageURL = oSite.addPage(pageTitle);
						
						// load new page with updated tokens
						oPage = createObject("component","Home.Components.pageBean").init( newXMLContent );		
						
						// save page
						oSite.savePage( getFileFromPath(newPageURL), oPage );
					
						st = structNew();
						st.error = false;
						st.pageName = pageTitle;
						st.errorMessage = "";
						st.url = newPageURL;
						arrayAppend(aStatus, st);

					} catch(any e) {
						st = structNew();
						st.error = true;
						st.pageName = pageTitle;
						st.errorMessage = e.message;
						st.url = "";
						arrayAppend(aStatus, st);
					}
				}
				
				
				// check if we have a site cfc loaded 
				if(Not oContext.hasAccountSite()) throw("Please select an account first.");
				
				// get site from session
				oSite = oContext.getAccountSite();

				// find account
				qryAccount = oContext.getHomePortals().getAccountsService().getAccountByName( oSite.getOwner() );
				
				
				setValue("aStatus", aStatus);
				setValue("pageHREF", pageHREF);
				setValue("numCopies", numCopies);
				setValue("numTokens", numTokens);
				setValue("qryAccount", qryAccount);
				setValue("appRoot", oContext.getHomePortals().getConfig().getAppRoot() );
				
				setValue("cbPageTitle", "Accounts > #qryAccount.accountname# > Tokenize Page Results");
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				
				setView("site/accounts/vwTokenizationStatus");
				
			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehAccounts.dspTokenizePage");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehAccounts.dspTokenizePage");
			}			
		</cfscript>	
	</cffunction>

	<cffunction name="writeFile" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cfargument name="content" type="string" required="true">
		<cffile action="write" file="#arguments.path#" output="#arguments.content#">
	</cffunction>

</cfcomponent>