<cfcomponent hint="This service is used to manage access permissions to resources">
	
	<!--- this structure is used to store all resources that should be controlled --->
	<cfset variables.mapResToRoles = structNew()>
	<cfset variables.mapRoleToRes = structNew()>
	
	<!--- this is the default action when a resource has not been defined --->
	<cfset variables.defaultAction = "deny">
	
	<cffunction name="init" access="public" returntype="permissionsService" hint="constructor">
		<cfargument name="configHREF" type="string" required="true" hint="path to config file">
		<cfset stResources = structNew()>
		<cfset loadConfig(expandPath(arguments.configHREF))>
		<cfreturn this>
	</cffunction>

	<cffunction name="isAllowed" access="public" returnType="boolean" hint="Returns True if the given resource is allowed for the given list of roles">
		<cfargument name="resource" type="string" required="true">
		<cfargument name="lstRoles" type="string" required="true">
		
		<cfscript>
			var role = "";
			var token1 = "";
			var token2 = "";
			var token3 = "";
			var i = 0;

			// check for specific resource			
			if( structKeyExists(variables.mapResToRoles, arguments.resource) ) {
				
				// check if this is an open resource
				if(variables.mapResToRoles[arguments.resource] eq "") return true;
				
				// check each role
				for(i=1; i lte listLen(arguments.lstRoles);i=i+1) {
					role = listGetAt(arguments.lstRoles,i);
					if(structKeyExists(variables.mapRoleToRes, role) 
							and listFindNoCase(variables.mapRoleToRes[role], arguments.resource)) {
						return true;
					}
				}
			} else {
			
				// if specific resource not found, then check for alternat forms token.* or *.token
				if(listLen(arguments.resource,".") eq 2) {
					token1 = listFirst(arguments.resource,".");
					token2 = listLast(arguments.resource,".");
					
					// check for resources in the form token.*
					if(structKeyExists(variables.mapResToRoles, token1 & ".*"))
						return isAllowed(token1 & ".*", arguments.lstRoles);
	
					// check for resources in the form *.token
					if(structKeyExists(variables.mapResToRoles, "*." & token2))
						return isAllowed("*." & token2, arguments.lstRoles);
				} 

				// check for resources of the form token.*.*
				if(listLen(arguments.resource,".") eq 3) {
					token1 = listFirst(arguments.resource,".");
					token2 = listGetAt(arguments.resource,2,".");
					
					// check for resources in the form token.*.*
					if(structKeyExists(variables.mapResToRoles, token1 & ".*.*"))	return isAllowed(token1 & ".*.*", arguments.lstRoles);
	
					// check for resources in the form *.token.*
					if(structKeyExists(variables.mapResToRoles, token1 & "." & token2 & ".*"))		return isAllowed(token1 & "." & token2 & ".*", arguments.lstRoles);
				} 
			}

			// resource is not defined, return default permission
			return false;
		</cfscript>
	</cffunction>

	<cffunction name="loadConfig" access="private" returntype="void" hint="loads and parses the config file">
		<cfargument name="configPath" type="string" required="false">
		
		<cfscript>
			var xmlDoc = 0;
			var xmlNode = 0;
			var tmpResID = "";
			var tmpRoles = ""; var tmpRole = "";
			var i = 0; var j=0;
			
			if(not fileExists(configPath))
				throw("Permissions config file not found!");
				
			xmlDoc = xmlParse(configPath);
			
			if(xmlDoc.xmlRoot.xmlName neq "permissions-config")
				throw("Invalid config file");
				
			if(structKeyExists(xmlDoc.xmlRoot.xmlAttributes,"default"))
				variables.defaultAction = xmlDoc.xmlRoot.xmlAttributes.default;
				
			for(i=1;i lte arrayLen(xmlDoc.xmlRoot.xmlChildren);i=i+1) {
				xmlNode = xmlDoc.xmlRoot.xmlChildren[i];
				if(xmlNode.xmlName eq "resource") {
					tmpResID = xmlNode.xmlAttributes.id;
					tmpRoles = xmlNode.xmlAttributes.roles;

					// mapping between resources and roles
					variables.mapResToRoles[tmpResID] = tmpRoles;

					// mapping between a role to its resources
					for(j=1;j lte listLen(tmpRoles);j=j+1) {
						tmpRole = listGetAt(tmpRoles,j);
						if(not structKeyExists(variables.mapRoleToRes, tmpRole))
							variables.mapRoleToRes[tmpRole] = tmpResID;
						else
							variables.mapRoleToRes[tmpRole] = listAppend(variables.mapRoleToRes[tmpRole], tmpResID);
					}
				}
			}	
		</cfscript>
	</cffunction>

	<cffunction name="throw" access="private" hint="Facade for cfthrow">
		<cfargument name="message" 		type="String" required="yes">
		<cfargument name="type" 		type="String" required="no" default="custom">
		<cfthrow type="#arguments.type#" message="#arguments.message#">
	</cffunction>
</cfcomponent>