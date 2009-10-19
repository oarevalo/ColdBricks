<cfcomponent extends="ehTemplates">
	
	<cfset variables.eventHandler = "templates.ehSiteTemplates">

	<cffunction name="setupMainView" access="private" returntype="void">
		<cfscript>
			setValue("currentEventHander", variables.eventHandler);
			setValue("cbPageTitle", "Templates");
			setValue("cbPageIcon", "images/templates_48x48.png");
			setValue("cbShowSiteMenu", true);
		</cfscript>
	</cffunction>

	<cffunction name="getDefaultTemplatePath" access="private" returntype="string">
		<cfset var oContext = getService("sessionContext").getContext()>
		<cfset var appRoot = oContext.getHomePortals().getConfig().getAppRoot()>
		<cfset var rtn = "/#appRoot#/templates/">
		<cfreturn reReplace(rtn,"//*","/","all")>
	</cffunction>

	<cffunction name="getHomePortalsConfigBean" access="private" returntype="homePortals.components.homePortalsConfigBean">
		<cfset var oContext = getService("sessionContext").getContext()>
		<cfreturn getService("configManager").getAppHomePortalsConfigBean( oContext )>
	</cffunction>

	<cffunction name="saveHomePortalsConfigBean" access="private" returntype="void">
		<cfargument name="configBean" type="homePortals.components.homePortalsConfigBean" required="true">
		<cfargument name="includeGeneralSettings" type="boolean" required="false" default="no">
		<cfset var oContext = getService("sessionContext").getContext()>
		<cfset getService("configManager").saveAppHomePortalsConfigDoc(oContext, arguments.configBean, argumengs.includeGeneralSettings)>
	</cffunction>		
	
</cfcomponent>