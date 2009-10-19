<cfcomponent extends="ehTemplates">
	
	<cfset variables.homePortalsConfigPath = "/config/homePortals-config.xml.cfm">
	<cfset variables.eventHandler = "templates.ehSiteTemplates">

	<cffunction name="setupMainView" access="private" returntype="void">
		<cfscript>
			setValue("currentEventHander", variables.eventHandler);
			setValue("cbPageTitle", "Templates");
			setValue("cbPageIcon", "images/templates_48x48.png");
			setValue("cbShowSiteMenu", true);
		</cfscript>
	</cffunction>

	<cffunction name="getHomePortalsConfigBean" access="private" returntype="homePortals.components.homePortalsConfigBean">
		<cfscript>
			var oContext = getService("sessionContext").getContext();
			var appRoot = oContext.getHomePortals().getConfig().getAppRoot();
			var oConfigBean = createObject("component","homePortals.components.homePortalsConfigBean").init( expandPath(appRoot & variables.homePortalsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="getDefaultTemplatePath" access="private" returntype="string">
		<cfset var oContext = getService("sessionContext").getContext()>
		<cfset var appRoot = oContext.getHomePortals().getConfig().getAppRoot()>
		<cfset var rtn = "/#appRoot#/templates/">
		<cfreturn reReplace(rtn,"//*","/","all")>
	</cffunction>

	<cffunction name="saveHomePortalsConfigBean" access="private" returntype="void">
		<cfargument name="configBean" type="homePortals.components.homePortalsConfigBean" required="true">
		<cfargument name="includeGeneralSettings" type="boolean" required="false" default="no">
		<cfscript>
			var oContext = getService("sessionContext").getContext();
			var appRoot = oContext.getHomePortals().getConfig().getAppRoot();
			saveHomePortalsConfigDoc(appRoot, arguments.configBean.toXML(), arguments.includeGeneralSettings);
		</cfscript>
	</cffunction>		

	<cffunction name="saveHomePortalsConfigDoc" access="private" returntype="void">
		<cfargument name="appRoot" type="string" required="true">
		<cfargument name="xmlDoc" type="XML" required="true">
		<cfargument name="includeGeneralSettings" type="boolean" required="false" default="no">
		
		<cfscript>
			var filePath = arguments.appRoot & variables.homePortalsConfigPath;
			var oFormatter = createObject("component","ColdBricks.components.xmlStringFormatter").init();
			
			structDelete(arguments.xmlDoc.xmlRoot.xmlAttributes, "version");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"baseResourceTypes") and arguments.xmlDoc.xmlRoot.baseResourceTypes.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "baseResourceTypes");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"initialEvent") and arguments.xmlDoc.xmlRoot.initialEvent.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "initialEvent");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"homePortalsPath") and arguments.xmlDoc.xmlRoot.homePortalsPath.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "homePortalsPath");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"appRoot") and arguments.xmlDoc.xmlRoot.appRoot.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "appRoot");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"bodyOnLoad") and arguments.xmlDoc.xmlRoot.bodyOnLoad.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "bodyOnLoad");
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
			
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"baseResources") and arrayLen(arguments.xmlDoc.xmlRoot.baseResources.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "baseResources");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"contentRenderers") and arrayLen(arguments.xmlDoc.xmlRoot.contentRenderers.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "contentRenderers");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"plugins") and arrayLen(arguments.xmlDoc.xmlRoot.plugins.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "plugins");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"resourceTypes") and arrayLen(arguments.xmlDoc.xmlRoot.resourceTypes.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "resourceTypes");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"resourceLibraryPaths") and arrayLen(arguments.xmlDoc.xmlRoot.resourceLibraryPaths.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "resourceLibraryPaths");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"renderTemplates") and arrayLen(arguments.xmlDoc.xmlRoot.renderTemplates.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "renderTemplates");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"pageProperties") and arrayLen(arguments.xmlDoc.xmlRoot.pageProperties.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "pageProperties");
			if(structKeyExists(arguments.xmlDoc.xmlRoot,"resourceLibraryTypes") and arrayLen(arguments.xmlDoc.xmlRoot.resourceLibraryTypes.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "resourceLibraryTypes");
	
			fileWrite(expandPath(filePath), oFormatter.makePretty(arguments.xmlDoc.xmlRoot), "utf-8");
		</cfscript>
	</cffunction>	
	
</cfcomponent>