<cfcomponent extends="ColdBricks.components.services.dao.DAO">

	<cffunction name="initTableParams" access="package" returntype="void" hint="setup table specific settings">
		<cfset setTableName("help")>
		<cfset setPrimaryKey("helpID","cf_sql_varchar")>
		
		<cfset addColumn("name", "cf_sql_varchar")>
		<cfset addColumn("description", "cf_sql_varchar")>
	</cffunction>

</cfcomponent>