<cfcomponent extends="eventHandler">

	<cffunction name="dspMain">
		<cfscript>
			var hp = 0;
			var oAcc = 0;
			var loaded = getValue("loaded",false);
			var showAccount = getValue("showAccount", true );
						
			try {
				hp = session.context.hp;
				oAcc = hp.getAccountsService();
				
				if(showAccount and structKeyExists(session.context,"accountID") and session.context.accountID neq "") {
					setValue("showAccount", true );
					setValue("accountID", session.context.accountID );
				}
				
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("qryAccounts", oAcc.GetUsers() );
				setValue("accountsRoot", hp.getConfig().getAccountsRoot() );
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
	
	<cffunction name="dspAccount">
		<cfscript>
			var accountID = getValue("accountID");
			var accountName = getValue("accountName");
			var viewType = getValue("viewType");
			var hp = 0;
			var oAccountSite = 0;
			var aPages = 0;

			try {
				hp = session.context.hp;

				// if a siteID is given, then set it on the context struct
				if(accountID neq "") {
					session.context.accountID = accountID;
					session.context.accountName = accountName;
					session.context.accountSite = createObject("component","Home.Components.site").init(accountName, hp.getAccountsService() );
				} else {
					setValue("accountID", session.context.accountID);
					setValue("accountName", session.context.accountName);
				}
				
				// get default view type
				if(not structKeyExists(session.context,"accountViewType")) session.context.accountViewType = "details";
				if(viewType neq "") session.context.accountViewType = viewType;
				
				oAccountSite = session.context.accountSite;
				aPages = oAccountSite.getPages();

				setValue("accountsRoot", hp.getConfig().getAccountsRoot() );
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("aPages",aPages);
				setValue("siteTitle",oAccountSite.getSiteTitle());
				setValue("viewType",session.context.accountViewType);
				
				setView("site/accounts/vwAccount");
				setLayout("Layout.None");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>
	</cffunction>

	<cffunction name="dspAccountInfo">
		<cfscript>
			var hp = 0;
			var numPages = 0;
			var oAccountSite = 0;
			
			try {
				setLayout("Layout.None");

				hp = session.context.hp;
				oAccountSite = session.context.accountSite;
				
				numPages = arrayLen(oAccountSite.getPages());

				setValue("accountID", session.context.accountID);
				setValue("accountName", session.context.accountName);
				setValue("oAccountSite", oAccountSite);
				setValue("accountsRoot", hp.getConfig().getAccountsRoot() );
				setValue("numPages", numPages);
				setValue("appRoot", hp.getConfig().getAppRoot() );
	
				setView("site/accounts/vwAccountInfo");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>
	</cffunction>

	<cffunction name="dspPageInfo">
		<cfscript>
			var hp = 0;
			var oAccountSite = 0;
			var aPages = 0;
			var stPage = 0;
			var page = getValue("page");
			var pageHREF = "";
			
			try {
				setLayout("Layout.None");	

				hp = session.context.hp;
				oAccountSite = session.context.accountSite;
				aPages = oAccountSite.getPages();

				if(page neq "") {
					for(i=1;i lte arrayLen(aPages);i=i+1) {
						if(aPages[i].href eq page) {
							stPage = aPages[i];
							break;
						}
					}
				}

				pageHREF = hp.getConfig().getAccountsRoot() & "/" & session.context.accountName & "/layouts/" & page;
				
				setValue("pageExists", fileExists(expandPath(pageHREF)));
				setValue("stPage",stPage);
				setValue("accountName", session.context.accountName);
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setView("site/accounts/vwPageInfo");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>
	</cffunction>

	<cffunction name="dspAddPage">
		<cfscript>
			var oSite = 0;
			var oAccounts = 0;
			var userID = 0;
			var qryAccount = 0;
			var aCatalogPages = 0;
			var aPages = 0;

			try {
				hp = session.context.hp;
				
				// check if we have a site cfc loaded 
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account first.");
				
				// get site from session
				oSite = session.context.accountSite;

				// get info from site
				userID = oSite.getUserID();
				aPages = oSite.getPages();

				// get accounts info 
				oAccounts = oSite.getAccount();
				qryAccount = oAccounts.getAccountByUserID(userID);

				// get catalog
				oCatalog = hp.getCatalog();
				aCatalogPages = oCatalog.getResourcesByType("page");
				
				setValue("qryAccount", qryAccount);
				setValue("aPages", aPages);
				setValue("aCatalogPages", aCatalogPages);

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
			var pageHREF = getValue("pageHREF","");
			var numCopies = getValue("numCopies",1);

			try {
				hp = session.context.hp;
				
				// check if we have a site cfc loaded 
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account first.");
				
				// get site from session
				oSite = session.context.accountSite;

				// get user
				userID = oSite.getUserID();

				// get accounts info 
				oAccounts = oSite.getAccount();

				// search account
				qryAccount = oAccounts.getAccountByUserID(userID);

				// build full page address
				pageHREF = hp.getConfig().getAccountsRoot() & "/" & qryAccount.username & "/layouts/" & pageHREF;

				// create page object 
				opage = createObject("component","Home.Components.page").init( pageHREF );

				if(val(numCopies) lt 1) numCopies = 1;
					
				setValue("pageHREF",pageHREF);
				setValue("numCopies",numCopies);
				setValue("oPage", oPage );
				setValue("qryAccount", qryAccount );
				setView("site/accounts/vwTokenizePage");		

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehAccounts.dspAddPage");
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspEdit">
		<cfscript>
			var oAccounts = structNew();
			var	qryAccount = 0;
			var accountID = getValue("accountID",0);
			var hp = 0;
			
			try {
				hp = session.context.hp;
				
				// get accounts info 
				oAccounts = hp.getAccountsService();
				stAccountInfo = oAccounts.getConfig();
	
				if(accountID eq 0) throw("Please select an account first");
	
				// search account
				qryAccount = oAccounts.getAccountByUserID(accountID);
				
				setValue("stAccountInfo", stAccountInfo);
				setValue("qryAccount", qryAccount);
				setValue("accountsRoot", hp.getConfig().getAccountsRoot() );
				
				setView("site/accounts/vwEdit");
	
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehAccounts.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspCreate">
		<cfscript>
			setView("site/accounts/vwCreate");
		</cfscript>
	</cffunction>



	<cffunction name="doSave" access="public" returntype="void">
		<cfscript>
			var oAccounts = 0;
			var accountID = getValue("accountID","");
			var username = getValue("username");
			var firstName = getValue("firstName");
			var middleName = getValue("middleName");
			var lastname = getValue("lastname");
			var email = getValue("email");
			var password = getValue("password");
			var pwd_new = getValue("pwd_new");
			var pwd_new2 = getValue("pwd_new2");
			var changePwd = getValue("changePwd",0);
			var NewUserID = "";

			try {
				hp = session.context.hp;
				oAccounts = hp.getAccountsService();

				if(username eq "") throw("Username cannot be empty.","coldBricks.validation");
				if(accountID eq "" and password eq "") throw("Password cannot be empty.","coldBricks.validation");
				if(email eq "") throw("Email address cannot be empty.","coldBricks.validation");
				if(accountID neq "" and changePwd and pwd_new eq "")  throw("New password cannot be empty.","coldBricks.validation");
				if(accountID neq "" and changePwd and pwd_new neq pwd_new2)  throw("Passwords do not match.","coldBricks.validation");

				if(accountID neq "") {
					oAccounts.UpdateAccount(accountID, firstName, middleName, lastName, email);
					if(changePwd) oAccounts.changePassword(accountID, pwd_new);
					setMessage("info", "Account saved");
				} else {
					accountID = oAccounts.CreateAccount(username, password, email);
					oAccounts.UpdateAccount(accountID, firstName, middleName, lastName, email);
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

			try {
				if(accountID eq "") throw("Please indicate the user account to delete.","coldBricks.validation");
				
				hp = session.context.hp;
				oAccounts = hp.getAccountsService();
				oAccounts.delete(accountID);
				
				session.context.accountID = "";
				session.context.accountSite = 0;
				
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
			
			try {
				oSite = session.context.accountSite;
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
			try {
				oSite = session.context.accountSite;
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
			
			try {
				oSite = session.context.accountSite;
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
			
			try {
				// get site from session
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account first.");
				oSite = session.context.accountSite;
				
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
				session.context.accountID = "";
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
			
			try {
				// get site from session
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account first.");
				oSite = session.context.accountSite;
				
				if(val(numCopies) eq 0) throw("The number of copies to make must be a valid number greater or equal to 1","coldBricks.validation");
				if(tokenize eq 1) setNextEvent("ehAccounts.dspTokenizePage","pageHREF=#pageHREF#&numCopies=#numCopies#");
				
				for(i=1;i lte val(numCopies);i=i+1) {
					oSite.addPage("",pageHREF);
				}
				
				setMessage("info", "Page copied.");
				session.context.accountID = "";
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
			
			try {
				// get site from session
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account first.");
				oSite = session.context.accountSite;
				
				// get resource root
				hp = session.context.hp;
				resRoot = hp.getConfig().getResourceLibraryPath();
		
				// get pagetemplate resource
				oCatalog = hp.getCatalog();
				oResourceBean = oCatalog.getResourceNode("page", resourceID);
				
				// add page resource
				oSite.addPageResource(oResourceBean, resRoot);
				
				setMessage("info", "Page added to site.");
				session.context.accountID = "";
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
			
			try {
				// get site from session
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account first.","coldBricks.validation");
				oSite = session.context.accountSite;
				
				if(val(numCopies) eq 0) throw("Please enter a valid greater or equal to 1 for the number of copies to be made","coldBricks.validation");
				if(val(numTokens) eq 0) throw("Please enter a valid greater or equal to 1 for the number of tokens to use","coldBricks.validation");

				// create blank page instance
				oPage = createObject("component","Home.Components.page");

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
						
						// load new page
						oPage.init(newPageURL);		
						
						// write page file with updated tokens
						writeFile( expandPath( oPage.getHREF() ), newXMLContent);
					
						st = structNew();
						st.error = false;
						st.pageName = pageTitle;
						st.errorMessage = "";
						st.url = oPage.getHREF();
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
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account first.");
				
				// get site from session
				oSite = session.context.accountSite;

				// find account
				qryAccount = oSite.getAccount().getAccountByUserID( oSite.getUserID() );
				
				
				setValue("aStatus", aStatus);
				setValue("pageHREF", pageHREF);
				setValue("numCopies", numCopies);
				setValue("numTokens", numTokens);
				setValue("qryAccount", qryAccount);
				setValue("appRoot", session.context.hp.getConfig().getAppRoot() );
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