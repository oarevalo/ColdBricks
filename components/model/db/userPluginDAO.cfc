<cfcomponent extends="ColdBricks.components.services.dao.DAO">

	<cffunction name="initTableParams" access="package" returntype="void" hint="setup table specific settings">
		<cfset setTableName("userPlugin")>
		<cfset setPrimaryKey("userPluginID","cf_sql_varchar")>
		
		<cfset addColumn("userID", "cf_sql_varchar")>
		<cfset addColumn("PluginID", "cf_sql_varchar")>
	</cffunction>

</cfcomponent>