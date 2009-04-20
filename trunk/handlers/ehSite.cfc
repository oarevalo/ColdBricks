<cfcomponent extends="ehColdBricks">

	<cffunction name="doLoadSite" access="public" returntype="void">
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

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var oResourceLibrary = 0;
			var stResourceTypes = structNew();
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
			var hasAccountsPlugin = false;
			var oAccService = 0;
			var aModules = arrayNew(1);
			
			try {
				oContext = getService("sessionContext").getContext();
				
				// get site
				oSiteInfo = oContext.getSiteInfo();

				// create catalog object and instantiate for this page
				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();
				
				// get resource types
				stResourceTypes = hp.getResourceLibraryManager().getResourceTypesInfo();

				// get resources
				qryResources = oCatalog.getResources();

				// if this is the hp engine, display a warning
				if(oSiteInfo.getSiteName() eq "homePortalsEngine") {
					setValue("isHomePortalsEngine",true);
				}
				
				// get accounts (if enabled)
				if(hp.getPluginManager().hasPlugin("accounts")) {
					hasAccountsPlugin = true;
					oAccService = getAccountsService();
					qryAccounts = oAccService.search();
	
					// if there is an account selected, get the account pages
					if(qlAccount neq "") {
						oAccountSite = oAccService.getSite(qlAccount);		
						aPages = oAccountSite.getPages();		
	
						// sort pages
						for(i=1;i lte arrayLen(aPages);i=i+1) {
							arrayAppend(aPagesSorted, aPages[i].href);
						}
						arraySort(aPagesSorted,"textnocase","asc");
					}
					
					setValue("defaultAccount", oAccService.getConfig().getDefaultAccount() );
				}
				
				// get available modules
				aModules = getService("UIManager").getSiteModules();

				// get installed site plugins
				aPlugins = getService("plugins").getPluginsByType("site");
				oUserPluginDAO = getService("DAOFactory").getDAO("userPlugin");
				qryUserPlugins = oUserPluginDAO.search(userID = getValue("oUser").getID());
				showAllModules = (getValue("oUser").getRole() eq "admin" or getValue("oUser").getRole() eq "mngr");

				for(i=1;i lte arrayLen(aPlugins);i=i+1) {
					if(showAllModules or listFind( valueList(qryUserPlugins.pluginID), aPlugins[i].getID() )) {
						tmpImage = aPlugins[i].getPath() & "/" & aPlugins[i].getIconSrc();
						tmpDesc = aPlugins[i].getDescription();
			
						if(aPlugins[i].getIconSrc() eq "") tmpImage = "images/cb-blocks.png";
						if(tmpDesc eq "") tmpDesc = "<em>No description available</em>";
			
						st = {
							href = "index.cfm?event=" & aPlugins[i].getModuleName() & "." & aPlugins[i].getDefaultEvent(),
							help = tmpDesc,
							imgSrc = tmpImage,
							alt = "Plugin: " & aPlugins[i].getName(),
							label = aPlugins[i].getName()
						};
						
						arrayAppend(aModules, duplicate(st));
					}
				}				
				
				
				setValue("oSiteInfo", oSiteInfo);
				setValue("stResourceTypes", stResourceTypes);	
				setValue("qryResources", qryResources);	
				setValue("qryAccounts",  qryAccounts);
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("aPages", aPagesSorted );
				setValue("aModules",aModules);
				setValue("cbPageTitle", "Site Dashboard");
				setValue("hasAccountsPlugin", hasAccountsPlugin);
				setView("site/vwMain");
			
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
				setNextEvent("ehSite.dspMain");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");
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
			
				setNextEvent("ehPage.dspMain","account=#account#");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");
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
			
				setNextEvent("ehPage.dspMain","account=#account#");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");
			}	
		</cfscript>
	</cffunction>

	<cffunction name="doArchiveSite" access="public" returntype="void">
		<cfset var siteID = oContext.getSiteInfo().getID()>
		<cflocation url="index.cfm?event=ehSites.doArchiveSite&siteID=#siteID#" addtoken="false">
	</cffunction>

</cfcomponent>