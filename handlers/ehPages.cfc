<cfcomponent extends="eventHandler">
	
	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
						
			try {
				hp = oContext.getHomePortals();
				
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("contentRoot", hp.getConfig().getContentRoot() );
				setValue("cbPageTitle", "Pages");
				setValue("cbPageIcon", "images/documents_48x48.png");
				setValue("cbShowSiteMenu", true);
				setView("site/pages/vwMain");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");
			}				
		</cfscript>
	</cffunction>

	<cffunction name="dspFolder" access="public" returntype="void">
		<cfscript>
			var path = getValue("path");
			var hp = 0;
			var aPages = 0;
			var oContext = getService("sessionContext").getContext();

			try {
				hp = oContext.getHomePortals();

				aPages = hp.getPageProvider().list(path);

				setValue("contentRoot", hp.getConfig().getContentRoot() );
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("aPages",aPages);
				
				setView("site/pages/vwFolder");
				setLayout("Layout.None");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>
	</cffunction>

	<cffunction name="dspPageInfo" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var aPages = 0;
			var stPage = 0;
			var path = getValue("path");
			var pageHREF = "";
			var oContext = getService("sessionContext").getContext();
			
			try {
				setLayout("Layout.None");	

				hp = oContext.getHomePortals();

				setValue("pageExists", hp.getPageProvider().pageExists(path));
				setValue("stPage", hp.getPageProvider().query(path));
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("contentRoot", hp.getConfig().getContentRoot() );
				setView("site/pages/vwPageInfo");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>
	</cffunction>
	
</cfcomponent>