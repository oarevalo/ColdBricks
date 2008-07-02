<cfcomponent>
	
	<cfproperty name="DSN" type="string" required="false" default="">
	<cfproperty name="username" type="string" required="false" default="">
	<cfproperty name="password" type="string" required="false" default="">
	<cfproperty name="dbtype" type="string" required="false" default="">
	<cfproperty name="dataRoot" type="string" required="false" default="">
	
	<cffunction name="init" access="public" returntype="dataProviderConfigBean">
		<cfscript>
			variables.instance = structNew();
			variables.instance.DSN = "";
			variables.instance.username = "";
			variables.instance.password = "";
			variables.instance.dbtype = "";
			variables.instance.dataRoot = "";
		</cfscript>
		<cfreturn this>
	</cffunction>

	<cffunction name="getDSN" returntype="string" access="public">
		<cfreturn variables.instance.DSN>
	</cffunction>

	<cffunction name="getUsername" returntype="string" access="public">
		<cfreturn variables.instance.username>
	</cffunction>

	<cffunction name="getPassword" returntype="string" access="public">
		<cfreturn variables.instance.password>
	</cffunction>

	<cffunction name="getDBType" returntype="string" access="public">
		<cfreturn variables.instance.dbtype>
	</cffunction>

	<cffunction name="getDataRoot" returntype="string" access="public">
		<cfreturn variables.instance.dataRoot>
	</cffunction>


	<cffunction name="setDSN" returntype="void" access="public">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.DSN = arguments.data>
	</cffunction>

	<cffunction name="setUsername" returntype="void" access="public">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.username = arguments.data>
	</cffunction>

	<cffunction name="setPassword" returntype="void" access="public">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.password = arguments.data>
	</cffunction>

	<cffunction name="setDBType" returntype="void" access="public">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.dbtype = arguments.data>
	</cffunction>

	<cffunction name="setDataRoot" returntype="void" access="public">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.dataRoot = arguments.data>
	</cffunction>

</cfcomponent>