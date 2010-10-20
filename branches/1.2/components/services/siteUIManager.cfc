<cfcomponent>

	<cfset variables.instance = {
									UIManager = 0
								}>

	<cffunction name="init" access="public" returntype="siteUIManager">
		<cfargument name="UIManager" type="any" required="true">
		<cfset variables.instance.UIManager = arguments.UIManager>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getFeatures" access="public" returntype="array">
		<cfargument name="context" type="any" required="true">
		<cfargument name="userAccessMap" type="any" required="true">
		<cfscript>
			var aModules = arrayNew(1);
			var hp = arguments.context.getHomePortals();
			var aAllModules = variables.instance.UIManager.getSiteFeatures();
			var isAllowed = false;
			var i = 0;

			for(i=1;i lte arrayLen(aAllModules);i++) {
				isAllowed = structKeyExists(arguments.userAccessMap, aAllModules[i].accessMapKey)
									and arguments.userAccessMap[aAllModules[i].accessMapKey]
									and
									(
										aAllModules[i].bindToPlugin eq ""
										or
										(
											aAllModules[i].bindToPlugin neq ""
											and
											hp.getPluginManager().hasPlugin( aAllModules[i].bindToPlugin )
										)	
									);
				if(isAllowed) arrayAppend(aModules, aAllModules[i]);
			}
			
			return aModules;	
		</cfscript>
	</cffunction>

	<cffunction name="getWidgets" access="public" returntype="array">
		<cfargument name="context" type="any" required="true">
		<cfargument name="userAccessMap" type="any" required="true">
		<cfreturn variables.instance.UIManager.getSiteWidgets()>
	</cffunction>
	
</cfcomponent>