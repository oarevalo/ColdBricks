<cfcomponent hint="This service is used to manage access permissions to resources">
	
	<!--- this structure is used to store all resources that should be controlled --->
	<cfset variables.mapResToRoles = structNew()>
	<cfset variables.mapRoleToRes = structNew()>
	<cfset variables.mapIDtoEvent = structNew()>
	<cfset variables.qryRoles = queryNew("name,label,description")>
	
	<!--- this is the default action when a resource has not been defined --->
	<cfset variables.defaultAction = "deny">
	
	<cffunction name="init" access="public" returntype="permissionsService" hint="constructor">
		<cfargument name="configHREF" type="string" required="true" hint="path to config file">
		<cfif arguments.configHREF neq "">
			<cfset loadConfig(expandPath(arguments.configHREF))>
		</cfif>
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
				
				// check if this is a resource open to all roles
				if(variables.mapResToRoles[arguments.resource] eq "*" and arguments.lstRoles neq "") return true;
				
				// check each role
				for(i=1; i lte listLen(arguments.lstRoles);i=i+1) {
					role = listGetAt(arguments.lstRoles,i);
					if(structKeyExists(variables.mapRoleToRes, role) 
							and listFindNoCase(variables.mapRoleToRes[role], arguments.resource)) {
						return true;
					}
				}
				
				// permission is explicitly assigned to another role, so is not allowed
				return false;
				
			} else {
			
				// if specific resource not found, then check for alternate forms token.* or *.token
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
			return (variables.defaultAction eq "allow");
		</cfscript>
	</cffunction>

	<cffunction name="buildAccessMap" access="public" returntype="struct" hint="builds and returns a struct with flags that determine access to each resource defined for the given role">
		<cfargument name="role" type="string" required="true">
		<cfset var stRet = structNew()>
		<cfset var key = "">
		
		<cfloop collection="#variables.mapIDtoEvent#" item="key">
			<cfset stRet[key] = isAllowed(variables.mapIDtoEvent[key], arguments.role)>
		</cfloop>
		
		<cfreturn stRet>
	</cffunction>

	<cffunction name="loadConfig" access="private" returntype="void" hint="loads and parses the config file">
		<cfargument name="configPath" type="string" required="false">
		
		<cfscript>
			var xmlDoc = 0;
			var xmlNode = 0;
			var i = 0; 
			
			if(not fileExists(configPath))
				throw("Permissions config file not found!");
				
			xmlDoc = xmlParse(configPath);
			
			if(xmlDoc.xmlRoot.xmlName neq "permissions-config")
				throw("Invalid config file");
				
			// get default permission	
			if(structKeyExists(xmlDoc.xmlRoot.xmlAttributes,"default"))
				variables.defaultAction = xmlDoc.xmlRoot.xmlAttributes.default;
			
			// create a query of defined roles
			if(structKeyExists(xmlDoc.xmlRoot,"roles")) {
				for(i=1;i lte arrayLen(xmlDoc.xmlRoot.roles.xmlChildren);i=i+1) {
					xmlNode = xmlDoc.xmlRoot.roles.xmlChildren[i];
					if(xmlNode.xmlName eq "role") {
						addRole(xmlNode.xmlAttributes.name, xmlNode.xmlAttributes.label, xmlNode.xmlText);
					}
				}
			}
				
			// parse roles/permissions assignments	
			for(i=1;i lte arrayLen(xmlDoc.xmlRoot.resources.xmlChildren);i=i+1) {
				xmlNode = xmlDoc.xmlRoot.resources.xmlChildren[i];
				if(xmlNode.xmlName eq "resource") {
					addResource(xmlNode.xmlAttributes.id, xmlNode.xmlAttributes.event, xmlNode.xmlAttributes.roles);
				}
			}	
		</cfscript>
	</cffunction>

	<cffunction name="getRoles" access="public" returntype="query" hint="Returns a query with all declared roles">
		<cfreturn variables.qryRoles>
	</cffunction>

	<cffunction name="addRole" access="public" returntype="void" hint="Adds a role entry.">
		<cfargument name="name" type="string" required="true">
		<cfargument name="label" type="string" required="false" default="">
		<cfargument name="description" type="string" required="true" default="">
		<cfscript>
			if(arguments.label eq "") arguments.label = arguments.name;
			
			queryAddRow(variables.qryRoles,1);
			querySetCell(variables.qryRoles, "name", arguments.name);
			querySetCell(variables.qryRoles, "label", arguments.label);
			querySetCell(variables.qryRoles, "description", arguments.description);		
		</cfscript>
	</cffunction>
	
	<cffunction name="addResource" access="public" returntype="void" hint="Adds a resource permission declaration. Takes an ID to identify the resource and the list of roles allowed access to that resource">
		<cfargument name="id" type="string" required="true">
		<cfargument name="event" type="string" required="true">
		<cfargument name="roles" type="string" required="true">
		<cfscript>
			var tmpRole = "";
			var j = 0;
			
			// mapping between resources and roles
			variables.mapResToRoles[arguments.event] = arguments.roles;
			variables.mapIDtoEvent[arguments.id] = arguments.event;

			// mapping between a role to its resources
			for(j=1;j lte listLen(arguments.roles);j=j+1) {
				tmpRole = listGetAt(arguments.roles,j);
				if(not structKeyExists(variables.mapRoleToRes, tmpRole))
					variables.mapRoleToRes[tmpRole] = arguments.event;
				else
					variables.mapRoleToRes[tmpRole] = listAppend(variables.mapRoleToRes[tmpRole], arguments.event);
			}		
		</cfscript>
	</cffunction>


	<cffunction name="throw" access="private" hint="Facade for cfthrow">
		<cfargument name="message" 		type="String" required="yes">
		<cfargument name="type" 		type="String" required="no" default="custom">
		<cfthrow type="#arguments.type#" message="#arguments.message#">
	</cffunction>
</cfcomponent>