<cfcomponent extends="ColdBricks.components.model.db.DAO">

	<cffunction name="initTableParams" access="package" returntype="void" hint="setup table specific settings">
		<cfset setTableName("userSite")>
		<cfset setPrimaryKey("userSiteID","cf_sql_varchar")>
		
		<cfset addColumn("userID", "cf_sql_varchar")>
		<cfset addColumn("siteID", "cf_sql_varchar")>
	</cffunction>

</cfcomponent>