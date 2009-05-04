<cfcomponent extends="eventHandler">
	
	<cffunction name="getAccountsService" access="package" returntype="Any">
		<cfset hp = getService("sessionContext").getContext().getHomePortals()>
		<cfreturn hp.getPluginManager().getPlugin("accounts").getAccountsService()>
	</cffunction>
	
	<cffunction name="reloadSite" access="private" returntype="void">
		<cfscript>
			var siteID = "";
			var oSiteDAO = 0;
			var qrySite = 0;
			var oHomePortals = 0;
			var oSiteBean = 0;
			oContext = getService("sessionContext").getContext();

			if(oContext.hasSiteInfo() and oContext.getSiteInfo().getID() neq "") {
				siteID = oContext.getSiteInfo().getID();
			
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
				oContext.clearSiteContext();
				oContext.setSiteInfo(oSiteBean);
				oContext.setHomePortals(oHomePortals);
			}
		</cfscript>	
	</cffunction>
	
</cfcomponent>