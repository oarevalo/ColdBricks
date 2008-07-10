<cfcomponent>
	
	<cfset variables.pluginsRoot = "">
	<cfset variables.pluginsMap = structNew()>

	<cffunction name="init" access="public" returntype="void" hint="Constructor">
		<cfargument name="pluginsRoot" type="string" required="true">
		
		<cfset variables.pluginsRoot = arguments.pluginsRoot>
		
		<cfset registerPlugins()>
		
	</cffunction>

	<cffunction name="registerPlugins" access="private" returntype="void" hint="Searches for installed plugins">
		<cfset var qryDir = 0>
		<cfset var oPlugin = 0>
		<cfset var tmp = "">
		<cfset var i = 0>
		<cfset var aNodes = arrayNew(1)>
		
		<!--- if the plugins directory doesnt exist, then get out --->
		<cfif variables.pluginsRoot eq "" or not directoryExists(expandPath(variables.pluginsRoot))>
			<cfreturn>
		</cfif>
		
		<!--- get existing modules --->
		<cfdirectory action="list" directory="#expandPath(variables.pluginsRoot)#" name="qryDir">

		<!--- get only directories, and filter out special purpose dirs --->
		<cfquery name="qryDir" dbtype="query">
			SELECT *
				FROM qryDir
				WHERE type = 'Dir'
					AND Name NOT LIKE '.%'
				ORDER BY Name
		</cfquery>
				
		<cfoutput query="qryDir">
			<cftry>
				<!--- build path of plugin manifest file --->
				<cfset tmp = expandPath(variables.pluginsRoot & "/" & qryDir.name & "/plugin.xml")>
				
				<!--- check if the directory contains a plugin.xml file --->
				<cfif fileExists(tmp)>
					<!--- read and parse xml doc --->
					<cfset xmlDoc = xmlParse(tmp)>
					
					<!--- build plugin bean --->
					<cfset oPlugin = createObject("component","plugin").init(qryDir.name, variables.pluginsRoot & "/" & qryDir.name)>
					
					<!--- mandatory properties --->
					<cfset oPlugin.setID(xmlDoc.xmlRoot.xmlAttributes.id)>
					<cfset oPlugin.setName(xmlDoc.xmlRoot.xmlAttributes.name)>
					<cfset oPlugin.setVersion(xmlDoc.xmlRoot.xmlAttributes.version)>
					<cfset oPlugin.setDefaultEvent(xmlDoc.xmlRoot.defaultEvent.xmlText)>
					<cfset oPlugin.setType(xmlDoc.xmlRoot.type.xmlText)>
					
					<!--- optional properties --->
					<cfif structKeyExists(xmlDoc.xmlRoot,"description")>
						<cfset oPlugin.setDescription(xmlDoc.xmlRoot.description.xmlText)>
					</cfif>
					<cfif structKeyExists(xmlDoc.xmlRoot,"iconSrc")>
						<cfset oPlugin.setIconSrc(xmlDoc.xmlRoot.iconSrc.xmlText)>
					</cfif>
					<cfif structKeyExists(xmlDoc.xmlRoot,"custom-settings")>
						<cfset aNodes = xmlDoc.xmlRoot["custom-settings"].xmlChildren>
						<cfloop from="1" to="#arrayLen(aNodes)#" index="i">
							<cfset oPlugin.setCustomSetting(aNodes[i].xmlAttributes.name, aNodes[i].xmlText)>
						</cfloop>
					</cfif>
					
					<cfset addPlugin(oPlugin)>
				</cfif>
				
				<cfcatch type="any">
					<!--- An error ocurred while loading the plugin --->
					<b>An error ocurred while registering a plugin.</b><br><br>
					<cfif isDefined("qryDir.name")>
						<b>Plugin:</b> #qryDir.name#<br>
					</cfif>
					<b>Error:</b> #cfcatch.message# #cfcatch.detail#<br>
					<br>
					Please correct the error or remove the plugin in order to continue
					<Cfabort>
				</cfcatch>
			</cftry>
		</cfoutput>
	</cffunction>

	<cffunction name="addPlugin" access="public" returntype="void" hint="Adds a reference to a plugin">
		<cfargument name="plugin" type="plugin" required="true">
		<cfset variables.pluginsMap[ arguments.plugin.getID() ] = arguments.plugin>
	</cffunction>

	<cffunction name="getPlugin" access="public" returntype="plugin" hint="Retrieves a registered plugin object by its ID">
		<cfargument name="id" type="string" required="true">
		<cfif structKeyExists(variables.pluginsMap, arguments.id)>
			<cfreturn variables.pluginsMap[arguments.id]>
		<cfelse>
			<cfthrow message="Plugin not found" type="pluginService.pluginNotFound">
		</cfif>
	</cffunction>

	<cffunction name="getPluginByModuleName" access="public" returntype="plugin" hint="Retrieves a registered plugin object by its associated module name">
		<cfargument name="moduleName" type="string" required="true">
		<cfset var plugin = "">
		<cfset var found = false>
		<cfloop collection="#variables.pluginsMap#" item="plugin">
			<cfif variables.pluginsMap[plugin].getModuleName() eq arguments.moduleName>
				<cfreturn variables.pluginsMap[plugin]>
			</cfif>
		</cfloop>
		<cfthrow message="Plugin not found" type="pluginService.pluginNotFound">
	</cffunction>

	<cffunction name="getPlugins" access="public" returntype="array" hint="Returns an array with all registered plugins">
		<cfset var aRtn = arrayNew(1)>
		<cfset var plugin = "">
		<cfloop collection="#variables.pluginsMap#" item="plugin">
			<cfset arrayAppend(aRtn, variables.pluginsMap[plugin])>
		</cfloop>
		<cfreturn aRtn>
	</cffunction>
	
	<cffunction name="getPluginsByType" access="public" returntype="array" hint="Returns an array with all registered plugins of the given type">
		<cfargument name="type" type="string" required="true">
		<cfset var aRtn = arrayNew(1)>
		<cfset var plugin = "">
		<cfloop collection="#variables.pluginsMap#" item="plugin">
			<cfif variables.pluginsMap[plugin].getType() eq arguments.type>
				<cfset arrayAppend(aRtn, variables.pluginsMap[plugin])>
			</cfif>
		</cfloop>
		<cfreturn aRtn>
	</cffunction>
	
</cfcomponent>