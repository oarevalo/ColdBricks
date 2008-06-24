<cfcomponent extends="eventHandler">

	<cffunction name="doLoadSite">
		<cfscript>
			var siteID = getValue("siteID");
			var firstTime = getValue("firstTime",false);	// this is to flag a site being opened for the first time after creation
			var oDataProvider = 0;
			var oSiteDAO = 0;
			var qrySite = 0;
			var loadSite = false;
			var oHomePortals = 0;
			
			try {
				// if a siteID is given, then set it on the context struct
				if(siteID neq "") {
					session.context = structNew();
					session.context.siteID = siteID;
					loadSite = true;
				} else {
					setValue("siteID", session.context.siteID);
					siteID = session.context.siteID;
				}

				oDataProvider = application.oDataProvider;
				oSiteDAO = createObject("component","ColdBricks.components.model.siteDAO").init(oDataProvider);

				// get site information
				qrySite = oSiteDAO.get(siteID);

				if(loadSite) {
					oHomePortals = createObject("Component","Home.Components.homePortals").init(qrySite.path);

					// prepare context and keep it in session
					session.context.hp = oHomePortals;
					session.context.siteInfo = qrySite;
				}

				setNextEvent("ehSite.dspMain","firstTime=#firstTime#");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSites.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspMain">
		<cfscript>
			var oResourceLibrary = 0;
			var aResourceTypes = arrayNew(1);
			var hp = 0;
			var oCatalog = 0;
			var qryResources = 0;
			var qryAccounts = 0;
			var qlAccount = getValue("qlAccount","");
			var oAccountSite = 0;
			var aPages = arrayNew(1);
			var aPagesSorted = arrayNew(1);
			
			try {
				// get resource types
				oResourceLibrary = createObject("component","Home.Components.resourceLibrary");
				aResourceTypes = oResourceLibrary.getResourceTypes();
							
				// create catalog object and instantiate for this page
				hp = session.context.hp;
				oCatalog = hp.getCatalog();
				
				// get resources
				qryResources = oCatalog.getResources();
				
				// get accounts
				qryAccounts = hp.getAccountsService().GetUsers();
				
				// if this is the hp engine, display a warning
				if(session.context.siteInfo.siteName eq "homePortalsEngine")
					setMessage("warning","This is the runtime engine for the HomePortals framework.");

				// if there is an account selected, get the account pages
				if(qlAccount neq "") {
					oAccountSite = createObject("component","Home.Components.site").init(qlAccount, hp.getAccountsService() );		
					aPages = oAccountSite.getPages();		

					// sort pages
					for(i=1;i lte arrayLen(aPages);i=i+1) {
						arrayAppend(aPagesSorted, aPages[i].href);
					}
					arraySort(aPagesSorted,"textnocase","asc");

				}
				
				setValue("qrySite", session.context.siteInfo);
				setValue("aResourceTypes", aResourceTypes);	
				setValue("qryResources", qryResources);	
				setValue("qryAccounts",  qryAccounts);
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("defaultAccount", hp.getConfig().getDefaultAccount() );
				setValue("aPages", aPagesSorted );
				
				setView("site/vwMain");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doSaveNotes">
		<cfscript>
			var oDataProvider = 0;
			var oSiteDAO = 0;
			var notes = getValue("notes");
			var siteID = session.context.siteID;

			try {
				oDataProvider = application.oDataProvider;
				oSiteDAO = createObject("component","ColdBricks.components.model.siteDAO").init(oDataProvider);
			
				// save note
				oSiteDAO.save(id=siteID, notes=notes);
				
				// update site info in memory
				session.context.siteInfo = oSiteDAO.get(siteID);
				
				setMessage("info", "Notes saved");	
				setNextEvent("ehSite.dspMain");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doLoadAccountPage">
		<cfscript>
			var account = getValue("account");
			var page = getValue("page");
			var pageHREF = "";
			var hp = 0;
			var qryAccount = 0;
			
			try {
				hp = session.context.hp;
				
				// if not account given, then get the default account
				if(account eq "") account = hp.getConfig().getDefaultAccount();
				
				// get account info
				qryAccount = hp.getAccountsService().getAccountByUsername(account);
				
				// load account
				session.context.accountID = qryAccount.userID;
				session.context.accountName = account;
				session.context.accountSite = createObject("component","Home.Components.site").init(account, hp.getAccountsService() );

				// if no page given, the load default page in account
				if(page eq "")	
					pageHREF = hp.getAccountsService().getAccountDefaultPage(account);
				else
					pageHREF = hp.getConfig().getAccountsRoot() & "/" & account & "/layouts/" & page;

				// load page
				session.context.page = createObject("component","Home.Components.page").init( pageHREF );
			
				setNextEvent("ehPage.dspMain");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");
			}	
		</cfscript>
	</cffunction>

</cfcomponent>