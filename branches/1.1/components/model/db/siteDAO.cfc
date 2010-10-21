<cfcomponent extends="ColdBricks.components.services.dao.DAO">

	<cffunction name="initTableParams" access="package" returntype="void" hint="setup table specific settings">
		<cfset setTableName("sites")>
		<cfset setPrimaryKey("siteID","cf_sql_varchar")>
		
		<cfset addColumn("siteName", "cf_sql_varchar")>
		<cfset addColumn("path", "cf_sql_varchar")>
		<cfset addColumn("ownerUserID", "cf_sql_varchar")>
		<cfset addColumn("createdDate", "cf_sql_timestamp")>
		<cfset addColumn("notes", "cf_sql_varchar")>
	</cffunction>

</cfcomponent>