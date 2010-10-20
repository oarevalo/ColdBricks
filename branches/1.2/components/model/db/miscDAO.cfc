<cfcomponent extends="ColdBricks.components.services.dao.DAO">

	<cffunction name="initTableParams" access="package" returntype="void" hint="setup table specific settings">
		<cfset setTableName("misc")>
		<cfset setPrimaryKey("miscID","cf_sql_varchar")>
		
		<cfset addColumn("name", "cf_sql_varchar")>
		<cfset addColumn("value", "cf_sql_varchar")>
	</cffunction>

</cfcomponent>