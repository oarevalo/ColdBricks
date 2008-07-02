<cfcomponent name="DAO" hint="this component provides a basic DAO implementation for accessing a backend data store">

	<cfscript>
		variables.oDataProvider = 0;
		variables.mapColumns = structNew();
		variables.mapTableInfo = structNew();
		variables.mapTableInfo.tableName = "";
		variables.mapTableInfo.PKName = "";
		variables.mapTableInfo.PKType = "cf_sql_numeric";
	</cfscript>
	
	<!--- Constructor --->
	<cffunction name="init" access="public" returntype="DAO">
		<cfargument name="dataProvider" type="dataProvider" required="true">
		
		<!--- init connection params --->
		<cfset variables.oDataProvider = arguments.dataProvider>
		
		<!--- init table specific settings --->
		<cfset initTableParams()>
		
		<cfreturn this>
	</cffunction>
	
	
	<!--- Data Access Methods --->
	<cffunction name="get" access="public" returntype="query">
		<cfargument name="id" type="any" required="true">
		<cfreturn variables.oDataProvider.get(arguments.id, variables.mapTableInfo, variables.mapColumns)>
	</cffunction>
	
	<cffunction name="getAll" access="public" returntype="query">
		<cfreturn variables.oDataProvider.getAll(variables.mapTableInfo, variables.mapColumns)>
	</cffunction>

	<cffunction name="delete" access="public" returntype="void">
		<cfargument name="id" type="any" required="true">
		<cfset variables.oDataProvider.delete(arguments.id, variables.mapTableInfo, variables.mapColumns)>
	</cffunction>
				
	<cffunction name="save" access="public" returntype="any">
		<cfargument name="id" type="any" required="false" default="0">
		<cfset var stArgs = arguments>
		<cfset stArgs._mapTableInfo = variables.mapTableInfo>
		<cfset stArgs._mapColumns = variables.mapColumns>
		<cfreturn variables.oDataProvider.save(argumentCollection = stArgs)>
	</cffunction>
	
	<cffunction name="search" returntype="query" access="public">
		<cfset var stArgs = arguments>
		<cfset stArgs._mapTableInfo = variables.mapTableInfo>
		<cfset stArgs._mapColumns = variables.mapColumns>
		<cfreturn variables.oDataProvider.search(argumentCollection = stArgs)>
	</cffunction>
	
	
			
	<!--- Setup Methods --->	
	<cffunction name="initTableParams" access="private" returntype="void" hint="setup table specific settings">
		<cfthrow message="The method initTableParams must be overriden">		
	</cffunction>
		
	<cffunction name="addColumn" access="private">
		<cfargument name="name" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfargument name="default" type="string" required="false" default="">
		<cfset variables.mapColumns[arguments.name] = structNew()>
		<cfset variables.mapColumns[arguments.name].cfsqltype = arguments.type>
		<cfset variables.mapColumns[arguments.name].value = "">
		<cfset variables.mapColumns[arguments.name].isNull = false>
		<cfset variables.mapColumns[arguments.name].default = "">
	</cffunction>			
				
	<cffunction name="setPrimaryKey" access="private">
		<cfargument name="name" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfset variables.mapTableInfo.PKName = arguments.name>
		<cfset variables.mapTableInfo.PKType = arguments.type>
	</cffunction>			

	<cffunction name="setTableName" access="private">
		<cfargument name="name" type="string" required="true">
		<cfset variables.mapTableInfo.tableName = arguments.name>
	</cffunction>			



	<!--- Other Private Methods --->	
	<cffunction name="getColumnStruct" access="private" returnType="struct">
		<cfset var st = duplicate(variables.mapColumns)>
		<cfset var key = "">
		<cfloop collection="#st#" item="key">
			<cfset st[key].value = st[key].default>
		</cfloop>
		<cfreturn st>
	</cffunction>			
			
</cfcomponent>