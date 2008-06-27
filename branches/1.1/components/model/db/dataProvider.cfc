<cfcomponent>

	<cfset variables.oConfigBean = 0>
	
	<cffunction name="init" returntype="dataProvider" access="public">
		<cfargument name="configBean" type="dataProviderConfigBean" required="true">
		<cfset variables.oConfigBean = arguments.configBean>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" returntype="query">
		<cfargument name="id" type="any" required="true">
		<cfargument name="_mapTableInfo" type="struct" required="true">
		<cfargument name="_mapColumns" type="struct" required="true">
		<cfthrow message="method not defined">
	</cffunction>
	
	<cffunction name="getAll" access="public" returntype="query">
		<cfargument name="_mapTableInfo" type="struct" required="true">
		<cfargument name="_mapColumns" type="struct" required="true">
		<cfthrow message="method not defined">
	</cffunction>

	<cffunction name="delete" access="public" returntype="void">
		<cfargument name="id" type="any" required="true">
		<cfargument name="_mapTableInfo" type="struct" required="true">
		<cfargument name="_mapColumns" type="struct" required="true">
		<cfthrow message="method not defined">
	</cffunction>
				
	<cffunction name="save" access="public" returntype="any">
		<cfargument name="id" type="any" required="false" default="0">
		<cfargument name="_mapTableInfo" type="struct" required="true">
		<cfargument name="_mapColumns" type="struct" required="true">
		<cfthrow message="method not defined">
	</cffunction>
	
	<cffunction name="search" returntype="query" access="public">
		<cfargument name="_mapTableInfo" type="struct" required="true">
		<cfargument name="_mapColumns" type="struct" required="true">
		<cfthrow message="method not defined">
	</cffunction>
	
	
</cfcomponent>