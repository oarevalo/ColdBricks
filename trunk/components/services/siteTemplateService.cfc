<cfcomponent>
	
	<cfset variables.siteTemplatesRoot = "">
	<cfset variables.siteTemplatesMap = structNew()>
	<cfset variables.DEFAULT_ICON_PATH = "/ColdBricks/images/Globe_48x48.png">
	<cfset variables.DEFAULT_ICON_FILENAME = "site-thumbnail.png">

	<cffunction name="init" access="public" returntype="siteTemplateService" hint="Constructor">
		<cfargument name="siteTemplatesRoot" type="string" required="true">
		<cfset variables.siteTemplatesRoot = arguments.siteTemplatesRoot>
		<cfset variables.siteTemplatesMap = structNew()>
		<cfset registerTemplates()>
		<cfreturn this>
	</cffunction>

	<cffunction name="registerTemplates" access="private" returntype="void" hint="Searches for installed site templates">
		<cfset var qryDir = 0>
		<cfset var tmp = "">
		<cfset var st = 0>
		<cfset var xmlDoc = arrayNew(1)>
		
		<!--- if the templates directory doesnt exist, then get out --->
		<cfif variables.siteTemplatesRoot eq "" or not directoryExists(expandPath(variables.siteTemplatesRoot))>
			<cfreturn>
		</cfif>

		<!--- clear up any existing templates --->
		<cfset variables.siteTemplatesMap = structNew()>
		
		<!--- get existing modules --->
		<cfdirectory action="list" directory="#expandPath(variables.siteTemplatesRoot)#" name="qryDir">

		<!--- get only directories, and filter out special purpose dirs --->
		<cfquery name="qryDir" dbtype="query">
			SELECT *
				FROM qryDir
				WHERE type = 'Dir'
					AND Name NOT LIKE '.%'
				ORDER BY Name
		</cfquery>
				
		<cfloop query="qryDir">
			<!--- create basic map entry --->
			<cfset st = structNew()>
			<cfset st.name = qryDir.name>
			<cfset st.path = variables.siteTemplatesRoot & "/" & qryDir.name>
			<cfset st.description = "">
			<cfset st.title = qryDir.name>
			<cfset st.thumbHREF = variables.DEFAULT_ICON_PATH>

			<cftry>
				<!--- build path of plugin manifest file --->
				<cfset tmp = expandPath(variables.siteTemplatesRoot & "/" & qryDir.name & "/site-template.xml")>
				
				<!--- check if the directory contains a siteTemplate.xml file --->
				<cfif fileExists(tmp)>
					<cfset xmlDoc = xmlParse(tmp)>
					<cfif structKeyExists(xmlDoc.xmlRoot,"title")>
						<cfset st.title = xmlDoc.xmlRoot.title.xmlText>
					</cfif>
					<cfif structKeyExists(xmlDoc.xmlRoot,"description")>
						<cfset st.description = xmlDoc.xmlRoot.description.xmlText>
					</cfif>
				</cfif>

				<cfcatch type="any">
					<!--- problem reading the xml file.. too bad... --->
				</cfcatch>
			</cftry>

			<!--- check if site has a thumbnail icon --->
			<cfif fileExists(expandPath(variables.siteTemplatesRoot & "/" & qryDir.name & "/" & variables.DEFAULT_ICON_FILENAME))>
				<cfset st.thumbHREF = variables.siteTemplatesRoot & "/" & qryDir.name & "/" & variables.DEFAULT_ICON_FILENAME>
			</cfif>
			
			<cfset variables.siteTemplatesMap[qryDir.name] = duplicate(st)>
		</cfloop>
		
	</cffunction>

	<cffunction name="getSiteTemplates" access="public" returntype="array" hint="Returns an array with all registered site templates">
		<cfset var aRtn = arrayNew(1)>
		<cfset var key = "">
		<cfloop collection="#variables.siteTemplatesMap#" item="key">
			<cfset arrayAppend(aRtn, variables.siteTemplatesMap[key])>
		</cfloop>
		<cfreturn aRtn>
	</cffunction>

	<cffunction name="getSiteTemplate" access="public" returntype="plugin" hint="Retrieves a registered site template by its name">
		<cfargument name="name" type="string" required="true">
		<cfif structKeyExists(variables.siteTemplatesMap, arguments.name)>
			<cfreturn variables.siteTemplatesMap[arguments.name]>
		<cfelse>
			<cfthrow message="Site Template not found" type="siteTemplateService.siteTemplateNotFound">
		</cfif>
	</cffunction>
		
</cfcomponent>