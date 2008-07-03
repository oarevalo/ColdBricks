<cfcomponent>
	
	<cfset variables.instance = structNew()>
	<cfset variables.instance.ID = "">
	<cfset variables.instance.Role = "">
	<cfset variables.instance.Username = "">
	<cfset variables.instance.Password = "">
	<cfset variables.instance.FirstName = "">
	<cfset variables.instance.LastName = "">
	<cfset variables.instance.email = "">
	<cfset variables.instance.IsAdministrator = false>
	
	<cffunction name="init" access="public" returntype="userBean">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getID" access="public" returntype="string">
		<cfreturn variables.instance.ID>
	</cffunction>

	<cffunction name="setID" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.ID = arguments.data>
	</cffunction>
	
	<cffunction name="getRole" access="public" returntype="string">
		<cfreturn variables.instance.Role>
	</cffunction>

	<cffunction name="setRole" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Role = arguments.data>
	</cffunction>
	
	<cffunction name="getUsername" access="public" returntype="string">
		<cfreturn variables.instance.Username>
	</cffunction>

	<cffunction name="setUsername" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Username = arguments.data>
	</cffunction>
	
	<cffunction name="getPassword" access="public" returntype="string">
		<cfreturn variables.instance.Password>
	</cffunction>

	<cffunction name="setPassword" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Password = arguments.data>
	</cffunction>
	
	<cffunction name="getFirstName" access="public" returntype="string">
		<cfreturn variables.instance.FirstName>
	</cffunction>

	<cffunction name="setFirstName" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.FirstName = arguments.data>
	</cffunction>
	
	<cffunction name="getLastName" access="public" returntype="string">
		<cfreturn variables.instance.LastName>
	</cffunction>

	<cffunction name="setLastName" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.LastName = arguments.data>
	</cffunction>
	
	<cffunction name="getEmail" access="public" returntype="string">
		<cfreturn variables.instance.Email>
	</cffunction>

	<cffunction name="setEmail" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.Email = arguments.data>
	</cffunction>
	
	<cffunction name="getIsAdministrator" access="public" returntype="boolean">
		<cfreturn variables.instance.IsAdministrator>
	</cffunction>

	<cffunction name="setIsAdministrator" access="public" returntype="void">
		<cfargument name="data" type="boolean" required="true">
		<cfset variables.instance.IsAdministrator = arguments.data>
	</cffunction>
	
</cfcomponent>