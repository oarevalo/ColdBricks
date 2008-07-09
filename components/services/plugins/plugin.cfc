<cfcomponent>

	<cfset variables.instance = structNew()>
	<cfset variables.instance.id = "">
	<cfset variables.instance.name = "">
	<cfset variables.instance.moduleName = "">
	<cfset variables.instance.version = "">
	<cfset variables.instance.description = "">
	<cfset variables.instance.iconSrc = "">
	<cfset variables.instance.type = "">
	<cfset variables.instance.defaultEvent = "">
	<cfset variables.instance.path = "">
	<cfset variables.instance.stCustomSettings = structNew()>

	<!--- Constructor --->
	<cffunction name="init" access="public" returntype="plugin">
		<cfargument name="moduleName" type="string" required="true" hint="Name of the module containing the plugin">
		<cfargument name="modulePath" type="string" required="true" hint="Path to the directory containing the module">
		<cfset variables.instance.ModuleName = arguments.moduleName>
		<cfset variables.instance.path = arguments.modulePath>
		<cfreturn this>
	</cffunction>

	<!--- Read-only properties --->
	<cffunction name="getModuleName" access="public" returntype="string">
		<cfreturn variables.instance.ModuleName>
	</cffunction>

	<cffunction name="getPath" access="public" returntype="string">
		<cfreturn variables.instance.Path>
	</cffunction>


	<!--- Read/write properties --->	
	<cffunction name="getID" access="public" returntype="string">
		<cfreturn variables.instance.ID>
	</cffunction>

	<cffunction name="setID" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.ID = arguments.data>
	</cffunction>

	<cffunction name="getName" access="public" returntype="string">
		<cfreturn variables.instance.Name>
	</cffunction>

	<cffunction name="setName" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Name = arguments.data>
	</cffunction>

	<cffunction name="getVersion" access="public" returntype="string">
		<cfreturn variables.instance.Version>
	</cffunction>

	<cffunction name="setVersion" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Version = arguments.data>
	</cffunction>

	<cffunction name="getDescription" access="public" returntype="string">
		<cfreturn variables.instance.Description>
	</cffunction>

	<cffunction name="setDescription" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Description = arguments.data>
	</cffunction>

	<cffunction name="getIconSrc" access="public" returntype="string">
		<cfreturn variables.instance.IconSrc>
	</cffunction>

	<cffunction name="setIconSrc" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.IconSrc = arguments.data>
	</cffunction>

	<cffunction name="getType" access="public" returntype="string">
		<cfreturn variables.instance.Type>
	</cffunction>

	<cffunction name="setType" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Type = arguments.data>
	</cffunction>
	
	<cffunction name="getDefaultEvent" access="public" returntype="string">
		<cfreturn variables.instance.DefaultEvent>
	</cffunction>

	<cffunction name="setDefaultEvent" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.DefaultEvent = arguments.data>
	</cffunction>

	<cffunction name="getCustomSetting" access="public" returntype="string">
		<cfargument name="name" type="string" required="true">
		<cfif structKeyExists(variables.instance.stCustomSettings, arguments.name)>
			<cfreturn variables.instance.stCustomSettings[arguments.name]>
		<cfelse>
			<cfthrow type="pluginService.invalidCustomSetting" message="The requested custom setting does not exist">
		</cfif>
	</cffunction>

	<cffunction name="setCustomSetting" access="public" returntype="string">
		<cfargument name="name" type="string" required="true">
		<cfargument name="value" type="string" required="true">
		<cfset variables.instance.stCustomSettings[arguments.name] = arguments.value>
	</cffunction>

	<cffunction name="getCustomSettings" access="public" returntype="struct">
		<cfreturn duplicate(variables.instance.stCustomSettings)>
	</cffunction>
	

	<!--- utility methods --->
	<cffunction name="getMemento" access="public" returntype="struct">
		<cfreturn duplicate(variables.instance)>
	</cffunction>
		
</cfcomponent>