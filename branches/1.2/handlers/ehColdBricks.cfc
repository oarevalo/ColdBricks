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

	<cffunction name="renderWidgets" access="private" returntype="struct" output="true">
		<cfargument name="__awidgets" type="array" required="true">
		<cfargument name="__defaultLocation" type="string" required="false" default="default">
		<cfset var __content = structNew()>
		<cfset var __tmpContent = "">
		<cfset var __pos = "default">
		<cfset var __i = 0>
		<cfset var __st = 0>

		<cfloop from="1" to="#arrayLen(__aWidgets)#" index="__i">
			<cfset __st = structNew()>
			<cfset __st.title = "">
			<cfset __st.body = "">
			<cftry>
				<cfsavecontent variable="__tmpContent">
					<cfinclude template="#__aWidgets[__i].href#">
				</cfsavecontent>
				<cfcatch type="any">
					<cfset getService("bugTracker").notifyService(cfcatch.message, cfcatch)>
					<cfset __tmpContent = "<b>Error:</b>" & cfcatch.Message>
				</cfcatch>
			</cftry>
				
			<cfif __aWidgets[__i].position eq "">
				<cfset __pos = arguments.__defaultLocation >
			<cfelse>
				<cfset __pos = __aWidgets[__i].position>
			</cfif>
			
			<cfif not structKeyExists(__content,__pos)>
				<cfset __content[__pos] = arrayNew(1)>
			</cfif>
			
			<cfset __st = structNew()>
			<cfset __st.title = __aWidgets[__i].title>
			<cfset __st.body = __tmpContent>
			
			<cfif trim(__tmpContent) neq "">
				<cfset arrayAppend(__content[__pos], __st)>
			</cfif>
		</cfloop>		

		<cfreturn __content>
	</cffunction>
		
</cfcomponent>