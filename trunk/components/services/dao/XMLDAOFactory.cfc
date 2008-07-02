<cfcomponent>
	
	<cfset variables.instance = structNew()>
	<cfset variables.instance.dataRoot = "">
	<cfset variables.instance.modelsPath = "">
	<cfset variables.instance.DataProvider = "">
	
	<cffunction name="init" access="public" returntype="XMLDAOFactory">
		<cfargument name="dataRoot" type="string" required="true">
		<cfargument name="modelsPath" type="string" required="true">
		<cfscript>
			var oConfigBean = 0;
			var oDataProvider = 0;
			
			setDataRoot(arguments.dataRoot);
			setModelsPath(arguments.modelsPath);

			// setup dataProvider config
			oConfigBean = createObject("component","dataProviderConfigBean").init();
			oConfigBean.setDataRoot(arguments.dataRoot);
			
			// initialize dataProvider and copy to application scope
			oDataProvider = createObject("component","xmlDataProvider").init(oConfigBean);		
			setDataProvider(oDataProvider);
			
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getDAO" access="public" returntype="DAO" hint="returns a properly configured instance of a DAO">
		<cfargument name="entity" type="string" required="true">
		<cfset var oDAO = createObject("component",variables.instance.modelsPath & arguments.entity & "DAO")>
		<cfset oDAO.init(getDataProvider())>
		<cfreturn oDAO>
	</cffunction>

	<cffunction name="getDataRoot" access="public" returntype="string">
		<cfreturn variables.instance.DataRoot>
	</cffunction>

	<cffunction name="setDataRoot" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.DataRoot = arguments.data>
	</cffunction>

	<cffunction name="getModelsPath" access="public" returntype="string">
		<cfreturn variables.instance.ModelsPath>
	</cffunction>

	<cffunction name="setModelsPath" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.ModelsPath = arguments.data>
	</cffunction>

	<cffunction name="getDataProvider" access="public" returntype="dataProvider">
		<cfreturn variables.instance.DataProvider>
	</cffunction>

	<cffunction name="setDataProvider" access="public" returntype="void">
		<cfargument name="data" type="dataProvider" required="true">
		<cfset variables.instance.DataProvider = arguments.data>
	</cffunction>

</cfcomponent>