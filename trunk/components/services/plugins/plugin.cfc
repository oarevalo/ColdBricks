<cfcomponent>

	<cfset variables.instance = structNew()>
	<cfset variables.instance.id = "">
	<cfset variables.instance.name = "">
	<cfset variables.instance.moduleName = "">
	<cfset variables.instance.version = "">
	<cfset variables.instance.description = "">
	<cfset variables.instance.iconSrc = "">
	<cfset variables.instance.type = "">
	<cfset variables.instance.minHostVersion = "">
	<cfset variables.instance.author = "">
	<cfset variables.instance.authorURL = "">
	<cfset variables.instance.docURL = "">
	<cfset variables.instance.defaultEvent = "">
	<cfset variables.instance.path = "">

	<cffunction name="init" access="public" returntype="plugin">
		<cfreturn this>
	</cffunction>

	<cffunction name="getID" access="public" returntype="string">
		<cfreturn variables.instance.ID>
	</cffunction>

	<cffunction name="setID" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.ID = arguments.data>
	</cffunction>

	<cffunction name="getModuleName" access="public" returntype="string">
		<cfreturn variables.instance.ModuleName>
	</cffunction>

	<cffunction name="setModuleName" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.ModuleName = arguments.data>
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

	<cffunction name="getMinHostVersion" access="public" returntype="string">
		<cfreturn variables.instance.MinHostVersion>
	</cffunction>

	<cffunction name="setMinHostVersion" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.MinHostVersion = arguments.data>
	</cffunction>

	<cffunction name="getAuthor" access="public" returntype="string">
		<cfreturn variables.instance.Author>
	</cffunction>

	<cffunction name="setAuthor" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Author = arguments.data>
	</cffunction>

	<cffunction name="getAuthorURL" access="public" returntype="string">
		<cfreturn variables.instance.AuthorURL>
	</cffunction>

	<cffunction name="setAuthorURL" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.AuthorURL = arguments.data>
	</cffunction>

	<cffunction name="getDocURL" access="public" returntype="string">
		<cfreturn variables.instance.DocURL>
	</cffunction>

	<cffunction name="setDocURL" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.DocURL = arguments.data>
	</cffunction>
	
	<cffunction name="getDefaultEvent" access="public" returntype="string">
		<cfreturn variables.instance.DefaultEvent>
	</cffunction>

	<cffunction name="setDefaultEvent" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.DefaultEvent = arguments.data>
	</cffunction>
	
	<cffunction name="getMemento" access="public" returntype="struct">
		<cfreturn duplicate(variables.instance)>
	</cffunction>
	
	<cffunction name="getPath" access="public" returntype="string">
		<cfreturn variables.instance.Path>
	</cffunction>

	<cffunction name="setPath" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Path = arguments.data>
	</cffunction>
		
</cfcomponent>