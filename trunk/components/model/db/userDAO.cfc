<cfcomponent extends="ColdBricks.components.services.dao.DAO">

	<cffunction name="initTableParams" access="package" returntype="void" hint="setup table specific settings">
		<cfset setTableName("users")>
		<cfset setPrimaryKey("userID","cf_sql_varchar")>
		
		<cfset addColumn("userName", "cf_sql_varchar")>
		<cfset addColumn("password", "cf_sql_varchar")>
		<cfset addColumn("firstName", "cf_sql_varchar")>
		<cfset addColumn("lastName", "cf_sql_varchar")>
		<cfset addColumn("email", "cf_sql_varchar")>
		<cfset addColumn("role", "cf_sql_varchar")>
	</cffunction>

</cfcomponent>