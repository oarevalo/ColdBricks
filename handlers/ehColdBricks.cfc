<cfcomponent extends="eventHandler">
	
	<cffunction name="getAccountsService" access="package" returntype="Any">
		<cfset hp = getService("sessionContext").getContext().getHomePortals()>
		<cfreturn hp.getPluginManager().getPlugin("accounts").getAccountsService()>
	</cffunction>
	
</cfcomponent>