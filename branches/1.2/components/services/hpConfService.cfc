<cfcomponent>
	<cfset variables.homePortalsRoot = "/homePortals">
	<cfset variables.homePortalsConfigPath = "">
	
	<cffunction name="init" access="public" returntype="hpConfService" hint="constructor">
		<cfargument name="homePortalsConfigPath" type="string" required="true">
		<cfset variables.homePortalsConfigPath = arguments.homePortalsConfigPath>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getHomePortalsConfigBean" access="public" returntype="homePortals.components.homePortalsConfigBean" hint="returns the homeportals config object for the given app path. If no path is given then returns the main config object">
		<cfargument name="appRoot" type="string" required="false" default="#variables.homePortalsRoot#">
		<cfargument name="configFilePath" type="string" required="false" default="#variables.homePortalsConfigPath#">
		<cfscript>
			var oConfigBean = createObject("component","homePortals.components.homePortalsConfigBean").init( expandPath(arguments.appRoot & arguments.configFilePath) );
			return oConfigBean;
		</cfscript>
	</cffunction>
		
	<cffunction name="saveHomePortalsConfigBean" access="public" returntype="void" hint="saves the given homeportals config object. This is only used for the global config">
		<cfargument name="configBean" type="homePortals.components.homePortalsConfigBean" required="true">
		<cfargument name="appRoot" type="string" required="false" default="#variables.homePortalsRoot#">
		<cfargument name="configFilePath" type="string" required="false" default="#variables.homePortalsConfigPath#">
		<cfset var oFormatter = createObject("component","ColdBricks.components.xmlStringFormatter").init()>
		<cfset fileWrite( expandPath(arguments.appRoot & arguments.configFilePath), oFormatter.makePretty( arguments.configBean.toXML().xmlRoot ), "utf-8" )>
	</cffunction>	

	<cffunction name="getAppHomePortalsConfigBean" access="public" returntype="homePortals.components.homePortalsConfigBean" hint="returns the homeportals config object from the current context">
		<cfargument name="context" type="ColdBricks.components.model.contextBean" required="true">
		<cfscript>
			var appRoot = arguments.context.getHomePortals().getConfig().getAppRoot();
			var configPath = arguments.context.getHomePortals().getConfigFilePath();
			return getHomePortalsConfigBean(appRoot, configPath);
		</cfscript>
	</cffunction>
	
	<cffunction name="saveAppHomePortalsConfigBean" access="public" returntype="void" hint="saves the homeportals config object for the current context">
		<cfargument name="context" type="ColdBricks.components.model.contextBean" required="true">
		<cfargument name="configBean" type="homePortals.components.homePortalsConfigBean" required="true">
		<cfargument name="includeGeneralSettings" type="boolean" required="false" default="no">
		<cfscript>
			var appRoot = arguments.context.getHomePortals().getConfig().getAppRoot();
			var configPath = arguments.context.getHomePortals().getConfigFilePath();
			saveHomePortalsConfigDoc(appRoot, arguments.configBean.toXML(), arguments.includeGeneralSettings, configPath);
		</cfscript>
	</cffunction>	
	
	<cffunction name="saveAppHomePortalsConfigDoc" access="public" returntype="void" hint="saves the homeportals config XML object for the current context">
		<cfargument name="context" type="ColdBricks.components.model.contextBean" required="true">
		<cfargument name="xmlDoc" type="XML" required="true">
		<cfargument name="includeGeneralSettings" type="boolean" required="false" default="no">
		<cfscript>
			var appRoot = arguments.context.getHomePortals().getConfig().getAppRoot();
			var configPath = arguments.context.getHomePortals().getConfigFilePath();
			saveHomePortalsConfigDoc(appRoot, arguments.xmlDoc, arguments.includeGeneralSettings, configPath);
		</cfscript>
	</cffunction>	

	<cffunction name="saveHomePortalsConfigDoc" access="public" returntype="void" hint="saves the given homeportals config XML object">
		<cfargument name="appRoot" type="string" required="true">
		<cfargument name="xmlDoc" type="XML" required="true">
		<cfargument name="includeGeneralSettings" type="boolean" required="false" default="no">
		<cfargument name="configFilePath" type="string" required="false" default="#variables.homePortalsConfigPath#">
		<cfscript>
			var filePath = arguments.appRoot & variables.homePortalsConfigPath;
			var oFormatter = createObject("component","ColdBricks.components.xmlStringFormatter").init();

			structDelete(arguments.xmlDoc.xmlRoot.xmlAttributes, "version");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"baseResourceTypes") and arguments.xmlDoc.xmlRoot.baseResourceTypes.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "baseResourceTypes");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"initialEvent") and arguments.xmlDoc.xmlRoot.initialEvent.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "initialEvent");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"homePortalsPath") and arguments.xmlDoc.xmlRoot.homePortalsPath.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "homePortalsPath");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"appRoot") and arguments.xmlDoc.xmlRoot.appRoot.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "appRoot");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"pageProviderClass") and arguments.xmlDoc.xmlRoot.pageProviderClass.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "pageProviderClass");
			
			// remove nodes that we are not editing
			if(not arguments.includeGeneralSettings) {
				if(structKeyExists(arguments.xmlDoc.xmlRoot,"defaultPage") and arguments.xmlDoc.xmlRoot.defaultPage.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "defaultPage");
				if(structKeyExists(arguments.xmlDoc.xmlRoot,"contentRoot") and arguments.xmlDoc.xmlRoot.contentRoot.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "contentRoot");
				if(structKeyExists(arguments.xmlDoc.xmlRoot,"pageCacheSize") and arguments.xmlDoc.xmlRoot.pageCacheSize.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "pageCacheSize");
				if(structKeyExists(arguments.xmlDoc.xmlRoot,"pageCacheTTL") and arguments.xmlDoc.xmlRoot.pageCacheTTL.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "pageCacheTTL");
				if(structKeyExists(arguments.xmlDoc.xmlRoot,"catalogCacheSize") and arguments.xmlDoc.xmlRoot.catalogCacheSize.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "catalogCacheSize");
				if(structKeyExists(arguments.xmlDoc.xmlRoot,"catalogCacheTTL") and arguments.xmlDoc.xmlRoot.catalogCacheTTL.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "catalogCacheTTL");
			}
			
			fileWrite(expandPath(filePath), oFormatter.makePretty(arguments.xmlDoc.xmlRoot), "utf-8"); 
		</cfscript>
	</cffunction>		
	
</cfcomponent>