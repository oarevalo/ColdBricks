<cfcomponent extends="ColdBricks.handlers.ehColdBricks">

	<cffunction name="doLoadSite" access="public" returntype="void">
		<cfscript>
			var siteID = getValue("siteID");
			var firstTime = getValue("firstTime",false);	// this is to flag a site being opened for the first time after creation
			var nextEvent = getValue("nextEvent");
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

				if(nextEvent eq "") nextEvent = "sites.ehSite.dspMain";
				setNextEvent(nextEvent,"firstTime=#firstTime#");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("sites.ehSites.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oContext = 0;
			var aModules = arrayNew(1);
			
			try {
				oContext = getService("sessionContext").getContext();

				// create catalog object and instantiate for this page
				hp = oContext.getHomePortals();

				// if this is the hp engine, display a warning
				oSiteInfo = oContext.getSiteInfo();
				if(oSiteInfo.getSiteName() eq "homePortalsEngine") {
					setValue("isHomePortalsEngine",true);
				}
				
				// get available modules
				aModules = getService("UIManager").getSiteFeatures();

				// get widgets
				stWidgets = renderWidgets( getService("UIManager").getSiteWidgets() );

				setValue("aModules",aModules);
				setValue("stWidgets",stWidgets);
				setValue("cbPageTitle", "Site Dashboard :: <span style='color:red;'>#oSiteInfo.getsitename()#</span>");
				setView("vwSite");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doSaveNotes" access="public" returntype="void">
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
				setNextEvent("sites.ehSite.dspMain");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("sites.ehSite.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doLoadAccountPage" access="public" returntype="void">
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
				
				if(not hp.getPluginManager().hasPlugin("accounts")) {
					throw("Accounts plugin not found");
				}
				
				// if not account given, then get the default account
				if(account eq "") account = getAccountsService().getConfig().getDefaultAccount();
				
				// get account info
				qryAccount = getAccountsService().getAccountByName(account);
				
				// load account
				oContext.setAccountID(qryAccount.accountID);
				oContext.setAccountName(account);
				oSite = getAccountsService().getSite(account);
				oContext.setAccountSite( oSite );

				// if no page given, the load default page in account
				if(page eq "")	page = oSite.getDefaultPage();

				// load page
				oPage = oSite.getPage(page);
				oContext.setPage( oPage );
				oContext.setPageHREF( oSite.getPageHREF(page) );
			
				setNextEvent("page.ehPage.dspMain","account=#account#");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("sites.ehSite.dspMain");
			}	
		</cfscript>
	</cffunction>

	<cffunction name="doLoadHomePage" access="public" returntype="void">
		<cfscript>
			var pageHREF = "";
			var hp = 0;
			var qryAccount = 0;
			var account = "";
			var oContext = getService("sessionContext").getContext();
			var oPage = 0;
			var oSite = 0;
			var hasAccountsPlugin = false;
			var oAccService = 0;
			
			try {
				hp = oContext.getHomePortals();
				hasAccountsPlugin = hp.getPluginManager().hasPlugin("accounts");

				if(hp.getConfig().getDefaultPage() neq "") {
					pageHREF = hp.getConfig().getDefaultPage();
					try {
						oPage = hp.getPageProvider().load( pageHREF );
					
					} catch(pageProvider.pageNotFound e) {
					}
				}
				
				if(hasAccountsPlugin) {
					oAccService = getAccountsService();

					if(oAccService.getConfig().getDefaultAccount() neq "") {
					
						// get the default account
						account = oAccService.getConfig().getDefaultAccount();
						
						// get account info
						qryAccount = oAccService.getAccountByName(account);
						
						// load account
						oContext.setAccountID(qryAccount.accountID);
						oContext.setAccountName(account);
						oSite = oAccService.getSite(account);
						oContext.setAccountSite( oSite );
		
						// load default page in account
						page = oSite.getDefaultPage();
		
						// load page
						oPage = oSite.getPage(page);
						pageHREF = oSite.getPageHREF(page);
					}
				}

				if(pageHREF eq "")
					throw("No default page set. You can set a default homepage by editing the site settings","validation");
				
				oContext.setPage( oPage );
				oContext.setPageHREF( pageHREF );
			
				setNextEvent("page.ehPage.dspMain","account=#account#");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("sites.ehSite.dspMain");
			}	
		</cfscript>
	</cffunction>

	<cffunction name="doArchiveSite" access="public" returntype="void">
		<cfset var oContext = getService("sessionContext").getContext()>
		<cfset var siteID = oContext.getSiteInfo().getID()>
		<cflocation url="index.cfm?event=ehSites.doArchiveSite&siteID=#siteID#" addtoken="false">
	</cffunction>

</cfcomponent>