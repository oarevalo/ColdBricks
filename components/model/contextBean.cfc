<cfcomponent>
	
	<cfset variables.instance = structNew()>

	<cfset variables.instance.user = 0>
	<cfset variables.instance.siteInfo = 0>

	<cfset variables.instance.HomePortals = 0>

	<cfset variables.instance.accountID = "">
	<cfset variables.instance.accountName = "">
	<cfset variables.instance.accountSite = 0>
	<cfset variables.instance.accountViewType = "">

	<cfset variables.instance.page = 0>
	<cfset variables.instance.pageHREF = "">
	<cfset variables.instance.pageResourceTypeView = "">
	
	<cfset variables.instance.resourceType = "">
	<cfset variables.instance.package = "">
	<cfset variables.instance.resLibIndex = 0>
	<cfset variables.instance.resourceViewMode = "">
	<cfset variables.instance.pageViewMode = "">
	
	<cffunction name="init" access="public" returntype="contextBean">
		<cfreturn this>
	</cffunction>


	<!--- User Bean --->

	<cffunction name="getUser" access="public" returntype="userBean">
		<cfreturn variables.instance.User>
	</cffunction>

	<cffunction name="setUser" access="public" returntype="void">
		<cfargument name="data" type="userBean" required="true">
		<cfset variables.instance.User = arguments.data>
	</cffunction>
	
	<cffunction name="hasUser" access="public" returntype="boolean">
		<cfreturn not isSimpleValue(variables.instance.User)>
	</cffunction>
	
	
	<!--- Site Bean --->

	<cffunction name="getSiteInfo" access="public" returntype="siteBean">
		<cfreturn variables.instance.SiteInfo>
	</cffunction>

	<cffunction name="setSiteInfo" access="public" returntype="void">
		<cfargument name="data" type="siteBean" required="true">
		<cfset variables.instance.SiteInfo = arguments.data>
	</cffunction>

	<cffunction name="hasSiteInfo" access="public" returntype="boolean">
		<cfreturn not isSimpleValue(variables.instance.SiteInfo)>
	</cffunction>

	<cffunction name="clearSiteContext" access="public" returntype="void">
		<cfset variables.instance.siteInfo = 0>
		<cfset variables.instance.HomePortals = 0>
		<cfset variables.instance.accountID = "">
		<cfset variables.instance.accountName = "">
		<cfset variables.instance.accountSite = 0>
		<cfset variables.instance.accountViewType = "">
		<cfset variables.instance.page = 0>
		<cfset variables.instance.pageResourceTypeView = "">
		<cfset variables.instance.resourceType = "">
		<cfset variables.instance.package = "">
		<cfset variables.instance.resLibIndex = 0>
		<cfset variables.instance.resourceViewMode = "">
		<cfset variables.instance.pageViewMode = "">
	</cffunction>


	<!--- HomePortals --->

	<cffunction name="getHomePortals" access="public" returntype="homePortals.components.homePortals">
		<cfreturn variables.instance.HomePortals>
	</cffunction>

	<cffunction name="setHomePortals" access="public" returntype="void">
		<cfargument name="data" type="homePortals.components.homePortals" required="true">
		<cfset variables.instance.HomePortals = arguments.data>
	</cffunction>

	<cffunction name="hasHomePortals" access="public" returntype="boolean">
		<cfreturn not isSimpleValue(variables.instance.HomePortals)>
	</cffunction>


	<!--- Account --->
	
	<cffunction name="getAccountID" access="public" returntype="string">
		<cfreturn variables.instance.AccountID>
	</cffunction>

	<cffunction name="setAccountID" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.AccountID = arguments.data>
	</cffunction>
	
	<cffunction name="getAccountName" access="public" returntype="string">
		<cfreturn variables.instance.AccountName>
	</cffunction>

	<cffunction name="setAccountName" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.AccountName = arguments.data>
	</cffunction>

	<cffunction name="getAccountSite" access="public" returntype="homePortals.plugins.accounts.components.site">
		<cfreturn variables.instance.AccountSite>
	</cffunction>

	<cffunction name="setAccountSite" access="public" returntype="void">
		<cfargument name="data" type="homePortals.plugins.accounts.components.site" required="true">
		<cfset variables.instance.AccountSite = arguments.data>
	</cffunction>

	<cffunction name="hasAccountSite" access="public" returntype="boolean">
		<cfreturn not isSimpleValue(variables.instance.AccountSite)>
	</cffunction>

	<cffunction name="clearAccountSite" access="public" returntype="void">
		<cfset variables.instance.AccountSite = 0>
	</cffunction>


	<cffunction name="getaccountViewType" access="public" returntype="string">
		<cfreturn variables.instance.accountViewType>
	</cffunction>

	<cffunction name="setaccountViewType" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.accountViewType = arguments.data>
	</cffunction>



	<!--- Page --->

	<cffunction name="getPage" access="public" returntype="homePortals.components.pageBean">
		<cfreturn variables.instance.Page>
	</cffunction>

	<cffunction name="getPageHREF" access="public" returntype="string">
		<cfreturn variables.instance.PageHREF>
	</cffunction>

	<cffunction name="setPage" access="public" returntype="void">
		<cfargument name="data" type="homePortals.components.pageBean" required="true">
		<cfset variables.instance.Page = arguments.data>
	</cffunction>

	<cffunction name="setPageHREF" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.PageHREF = reReplace(arguments.data,"//*","/","all")>
	</cffunction>

	<cffunction name="hasPage" access="public" returntype="boolean">
		<cfreturn not isSimpleValue(variables.instance.Page)>
	</cffunction>

	<cffunction name="getpageResourceTypeView" access="public" returntype="string">
		<cfreturn variables.instance.pageResourceTypeView>
	</cffunction>

	<cffunction name="setpageResourceTypeView" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.pageResourceTypeView = arguments.data>
	</cffunction>


	<!--- Resources --->
	<cffunction name="getResourceType" access="public" returntype="string">
		<cfreturn variables.instance.ResourceType>
	</cffunction>

	<cffunction name="setResourceType" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.ResourceType = arguments.data>
	</cffunction>
 
	<cffunction name="getPackage" access="public" returntype="string">
		<cfreturn variables.instance.Package>
	</cffunction>

	<cffunction name="setPackage" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Package = arguments.data>
	</cffunction>

	<cffunction name="getResLibIndex" access="public" returntype="numeric">
		<cfreturn variables.instance.ResLibIndex>
	</cffunction>

	<cffunction name="setResLibIndex" access="public" returntype="void">
		<cfargument name="data" type="numeric" required="true">
		<cfset variables.instance.ResLibIndex = arguments.data>
	</cffunction>

	<cffunction name="getResourceViewMode" access="public" returntype="string">
		<cfreturn variables.instance.ResourceViewMode>
	</cffunction>

	<cffunction name="setResourceViewMode" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.ResourceViewMode = arguments.data>
	</cffunction>

	<cffunction name="getPageViewMode" access="public" returntype="string">
		<cfreturn variables.instance.PageViewMode>
	</cffunction>

	<cffunction name="setPageViewMode" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.PageViewMode = arguments.data>
	</cffunction>

</cfcomponent>