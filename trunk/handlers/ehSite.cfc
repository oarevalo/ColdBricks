<cfcomponent extends="eventHandler">

	<cffunction name="doLoadSite">
		<cfscript>
			var siteID = getValue("siteID");
			var firstTime = getValue("firstTime",false);	// this is to flag a site being opened for the first time after creation
			var oSiteDAO = 0;
			var qrySite = 0;
			var oHomePortals = 0;
			var oSiteBean = 0;
			var oContext = 0;
			
			try {
				// if a siteID is given, then set it on the context struct
				if(siteID neq "") {

					// load site information
					oSiteDAO = getService("DAOFactory").getDAO("site");
					qrySite = oSiteDAO.get(siteID);

					// create site bean
					oSiteBean = createObject("component","ColdBricks.components.model.siteBean").init();
					oSiteBean.setID( siteID );
					oSiteBean.setSiteName( qrySite.siteName );
					oSiteBean.setPath( qrySite.path );
					oSiteBean.setOwnerUserID( qrySite.ownerUserID );
					oSiteBean.setCreatedDate( qrySite.createdDate );
					oSiteBean.setNotes( qrySite.notes );
				
					// instantiate HomePortals application
					oHomePortals = createObject("Component","homePortals.components.homePortals").init(oSiteBean.getPath());

					// load the full index of the resource library
					oHomePortals.getCatalog().index();

					// store site and app in session					
					oContext = getService("sessionContext").getContext();
					oContext.clearSiteContext();
					oContext.setSiteInfo(oSiteBean);
					oContext.setHomePortals(oHomePortals);
					
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
			var aPlugins = arrayNew(1);
			var oContext = 0;
			var oSiteInfo = 0;
			var stModAccess = structNew();
			var oUser = getValue("oUser");
			var oUserPluginDAO = 0;
			
			try {
				oContext = getService("sessionContext").getContext();
				
				// get site
				oSiteInfo = oContext.getSiteInfo();
				
				// get resource types
				oResourceLibrary = createObject("component","homePortals.components.resourceLibrary");
				aResourceTypes = oResourceLibrary.getResourceTypes();
							
				// create catalog object and instantiate for this page
				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();
				
				// get resources
				qryResources = oCatalog.getResources();
				
				// get accounts
				qryAccounts = hp.getAccountsService().getAccounts();
				
				// if this is the hp engine, display a warning
				if(oSiteInfo.getSiteName() eq "homePortalsEngine")
					setMessage("warning","This is the runtime engine for the HomePortals framework.");

				// if there is an account selected, get the account pages
				if(qlAccount neq "") {
					oAccountSite = createObject("component","homePortals.components.accounts.site").init(qlAccount, hp.getAccountsService() );		
					aPages = oAccountSite.getPages();		

					// sort pages
					for(i=1;i lte arrayLen(aPages);i=i+1) {
						arrayAppend(aPagesSorted, aPages[i].href);
					}
					arraySort(aPagesSorted,"textnocase","asc");

				}

				// get installed site plugins
				aPlugins = getService("plugins").getPluginsByType("site");
				oUserPluginDAO = getService("DAOFactory").getDAO("userPlugin");
				qryUserPlugins = oUserPluginDAO.search(userID = oUser.getID());
				
				setValue("oSiteInfo", oSiteInfo);
				setValue("aResourceTypes", aResourceTypes);	
				setValue("qryResources", qryResources);	
				setValue("qryAccounts",  qryAccounts);
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("defaultAccount", hp.getAccountsService().getConfig().getDefaultAccount() );
				setValue("aPages", aPagesSorted );
				setValue("aPlugins",aPlugins);
				setValue("qryUserPlugins",qryUserPlugins);
				setValue("cbPageTitle", "Site Dashboard");
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
			var oSiteDAO = 0;
			var notes = getValue("notes");
			var oContext = getService("sessionContext").getContext();
			var siteID = oContext.getSiteInfo().getID();
			var qry = 0;

			try {
				oSiteDAO = getService("DAOFactory").getDAO("site");
			
				// save note
				oSiteDAO.save(id=siteID, notes=notes);
				
				// update site info in memory
				oContext.getSiteInfo().setNotes( oSiteDAO.get(siteID).notes );
				
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
			var oContext = getService("sessionContext").getContext();
			var oPage = 0;
			var oSite = 0;
			
			try {
				hp = oContext.getHomePortals();
				
				// if not account given, then get the default account
				if(account eq "") account = hp.getAccountsService().getConfig().getDefaultAccount();
				
				// get account info
				qryAccount = hp.getAccountsService().getAccountByName(account);
				
				// load account
				oContext.setAccountID(qryAccount.accountID);
				oContext.setAccountName(account);
				oSite = createObject("component","homePortals.components.accounts.site").init(account, hp.getAccountsService() );
				oContext.setAccountSite( oSite );

				// if no page given, the load default page in account
				if(page eq "")	page = oSite.getDefaultPage();

				// load page
				oPage = oSite.getPage(page);
				oContext.setPage( oPage );
				oContext.setPageHREF( oSite.getPageHREF(page) );
			
				setNextEvent("ehPage.dspMain","account=#account#");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");
			}	
		</cfscript>
	</cffunction>

	<cffunction name="doLoadHomePage">
		<cfscript>
			var pageHREF = "";
			var hp = 0;
			var qryAccount = 0;
			var account = "";
			var oContext = getService("sessionContext").getContext();
			var oPage = 0;
			var oSite = 0;
			
			try {
				hp = oContext.getHomePortals();
				
				pageHREF = hp.getAppDefaultPage();
				
				if(pageHREF eq "")
					throw("No default page set. You can set a default homepage by either setting the defaultPage property or defaultAccount property on the site config","validation");
				
				if(hp.getConfig().getDefaultPage() neq "") {
					pageHREF = hp.getConfig().getDefaultPage();
					oPage = hp.getPageProvider().load( pageHREF );
				}
				
				if(hp.getAccountsService().getConfig().getDefaultAccount() neq "") {
				
					// get the default account
					account = hp.getAccountsService().getConfig().getDefaultAccount();
					
					// get account info
					qryAccount = hp.getAccountsService().getAccountByName(account);
					
					// load account
					oContext.setAccountID(qryAccount.accountID);
					oContext.setAccountName(account);
					oSite = createObject("component","homePortals.components.accounts.site").init(account, hp.getAccountsService() );
					oContext.setAccountSite( oSite );
	
					// load default page in account
					page = oSite.getDefaultPage();
	
					// load page
					oPage = oSite.getPage(page);
					pageHREF = oSite.getPageHREF(page);
				}
				
				oContext.setPage( oPage );
				oContext.setPageHREF( pageHREF );
			
				setNextEvent("ehPage.dspMain","account=#account#");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");
			}	
		</cfscript>
	</cffunction>

</cfcomponent>