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
					<cfset oPlugin = createObject("component","plugin").init()>
					
					<!--- mandatory properties --->
					<cfset oPlugin.setModuleName(qryDir.name)>
					<cfset oPlugin.setID(xmlDoc.xmlRoot.xmlAttributes.id)>
					<cfset oPlugin.setName(xmlDoc.xmlRoot.xmlAttributes.name)>
					<cfset oPlugin.setVersion(xmlDoc.xmlRoot.xmlAttributes.version)>
					<cfset oPlugin.setDefaultEvent(xmlDoc.xmlRoot.defaultEvent.xmlText)>
					<cfset oPlugin.setPath(variables.pluginsRoot & "/" & qryDir.name)>
					
					<!--- optional properties --->
					<cfif structKeyExists(xmlDoc.xmlRoot,"description")>
						<cfset oPlugin.setDescription(xmlDoc.xmlRoot.description.xmlText)>
					</cfif>
					<cfif structKeyExists(xmlDoc.xmlRoot,"iconSrc")>
						<cfset oPlugin.setIconSrc(xmlDoc.xmlRoot.iconSrc.xmlText)>
					</cfif>
					<cfif structKeyExists(xmlDoc.xmlRoot,"type")>
						<cfset oPlugin.setType(xmlDoc.xmlRoot.type.xmlText)>
					</cfif>
					<cfif structKeyExists(xmlDoc.xmlRoot,"minHostVersion")>
						<cfset oPlugin.setMinHostVersion(xmlDoc.xmlRoot.minHostVersion.xmlText)>
					</cfif>
					<cfif structKeyExists(xmlDoc.xmlRoot,"author")>
						<cfset oPlugin.setAuthor(xmlDoc.xmlRoot.author.xmlText)>
					</cfif>
					<cfif structKeyExists(xmlDoc.xmlRoot,"authorURL")>
						<cfset oPlugin.setAuthorURL(xmlDoc.xmlRoot.authorURL.xmlText)>
					</cfif>
					<cfif structKeyExists(xmlDoc.xmlRoot,"docURL")>
						<cfset oPlugin.setDocURL(xmlDoc.xmlRoot.docURL.xmlText)>
					</cfif>
					
					<cfset addPlugin(oPlugin)>
				</cfif>
				
				<cfcatch type="any">
					<!--- ignore --->
				</cfcatch>
			</cftry>
		</cfoutput>
	</cffunction>

	<cffunction name="addPlugin" access="public" returntype="void">
		<cfargument name="plugin" type="plugin" required="true">
		<cfset variables.pluginsMap[ arguments.plugin.getID() ] = arguments.plugin>
	</cffunction>

	<cffunction name="getPlugin" access="public" returntype="plugin">
		<cfargument name="id" type="string" required="true">
		<cfif structKeyExists(variables.pluginsMap, arguments.id)>
			<cfreturn variables.pluginsMap[arguments.id]>
		<cfelse>
			<cfthrow message="pluginService.pluginNotFound">
		</cfif>
	</cffunction>

	<cffunction name="getPlugins" access="public" returntype="array">
		<cfset var aRtn = arrayNew(1)>
		<cfset var plugin = "">
		<cfloop collection="#variables.pluginsMap#" item="plugin">
			<cfset arrayAppend(aRtn, variables.pluginsMap[plugin])>
		</cfloop>
		<cfreturn aRtn>
	</cffunction>
	
	<cffunction name="getPluginsByType" access="public" returntype="array">
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