<cfcomponent extends="ColdBricks.components.model.db.DAO">

	<cffunction name="initTableParams" access="package" returntype="void" hint="setup table specific settings">
		<cfset setTableName("users")>
		<cfset setPrimaryKey("userID","cf_sql_varchar")>
		
		<cfset addColumn("userName", "cf_sql_varchar")>
		<cfset addColumn("password", "cf_sql_varchar")>
		<cfset addColumn("firstName", "cf_sql_varchar")>
		<cfset addColumn("lastName", "cf_sql_varchar")>
		<cfset addColumn("email", "cf_sql_varchar")>
		<cfset addColumn("administrator", "cf_sql_numeric")>
	</cffunction>

</cfcomponent>