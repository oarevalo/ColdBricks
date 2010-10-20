<cfcomponent>
	
	<cfset variables.instance = structNew()>
	<cfset variables.instance.ID = "">
	<cfset variables.instance.siteName = "">
	<cfset variables.instance.path = "">
	<cfset variables.instance.ownerUserID = "">
	<cfset variables.instance.createdDate = "">
	<cfset variables.instance.notes = "">
	
	<cffunction name="init" access="public" returntype="siteBean">
		<cfreturn this>
	</cffunction>

	<cffunction name="getID" access="public" returntype="string">
		<cfreturn variables.instance.ID>
	</cffunction>

	<cffunction name="setID" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.ID = arguments.data>
	</cffunction>

	<cffunction name="getSiteName" access="public" returntype="string">
		<cfreturn variables.instance.SiteName>
	</cffunction>

	<cffunction name="setSiteName" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.SiteName = arguments.data>
	</cffunction>

	<cffunction name="getPath" access="public" returntype="string">
		<cfreturn variables.instance.Path>
	</cffunction>

	<cffunction name="setPath" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Path = arguments.data>
	</cffunction>

	<cffunction name="getOwnerUserID" access="public" returntype="string">
		<cfreturn variables.instance.OwnerUserID>
	</cffunction>

	<cffunction name="setOwnerUserID" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.OwnerUserID = arguments.data>
	</cffunction>

	<cffunction name="getCreatedDate" access="public" returntype="date">
		<cfreturn variables.instance.CreatedDate>
	</cffunction>

	<cffunction name="setCreatedDate" access="public" returntype="void">
		<cfargument name="data" type="date" required="true">
		<cfset variables.instance.CreatedDate = arguments.data>
	</cffunction>

	<cffunction name="getNotes" access="public" returntype="string">
		<cfreturn variables.instance.Notes>
	</cffunction>

	<cffunction name="setNotes" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Notes = arguments.data>
	</cffunction>

</cfcomponent>