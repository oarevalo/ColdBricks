<cfcomponent>
	
	<cfset variables.siteTemplatesMap = structNew()>
	<cfset variables.DEFAULT_ICON_PATH = "/ColdBricks/images/Globe_48x48.png">
	<cfset variables.DEFAULT_ICON_FILENAME = "site-thumbnail.png">

	<cffunction name="init" access="public" returntype="siteTemplateService" hint="Constructor">
		<cfargument name="siteTemplatesRoot" type="string" required="true">
		<cfset variables.siteTemplatesMap = structNew()>
		<cfset registerTemplates( arguments.siteTemplatesRoot )>
		<cfreturn this>
	</cffunction>

	<cffunction name="registerTemplates" access="private" returntype="void" hint="Searches for installed site templates">
		<cfargument name="siteTemplatesRoot" type="string" required="true">
		
		<cfset var qryDir = 0>
		
		<!--- if the templates directory doesnt exist, then get out --->
		<cfif arguments.siteTemplatesRoot eq "" or not directoryExists(expandPath(arguments.siteTemplatesRoot))>
			<cfreturn>
		</cfif>

		<!--- get existing modules --->
		<cfdirectory action="list" directory="#expandPath(arguments.siteTemplatesRoot)#" name="qryDir">

		<!--- get only directories, and filter out special purpose dirs --->
		<cfquery name="qryDir" dbtype="query">
			SELECT *
				FROM qryDir
				WHERE type = 'Dir'
					AND Name NOT LIKE '.%'
				ORDER BY Name
		</cfquery>
				
		<cfloop query="qryDir">
			<cftry>
				<cfset registerTemplate( arguments.siteTemplatesRoot & "/" & qryDir.name )>

				<cfcatch type="any">
					<!--- problem reading the xml file.. too bad... --->
				</cfcatch>
			</cftry>
		</cfloop>
		
	</cffunction>

	<cffunction name="registerTemplate" access="public" returntype="void" hint="Registers a new ColdBricks SiteTemplate by giving its directory">
		<cfargument name="templatePath" type="string" required="true">

		<cfset var st = structNew()>
		<cfset var tmp = "">
		<cfset var xmlDoc = arrayNew(1)>
		<cfset var name = listlast(arguments.templatePath,"\/")>

		<!--- create basic map entry --->
		<cfset st.name = name>
		<cfset st.path = arguments.templatePath>
		<cfset st.description = "">
		<cfset st.title = name>
		<cfset st.thumbHREF = variables.DEFAULT_ICON_PATH>
		<cfset st.version = "">
		<cfset st.author = "">
		<cfset st.authorURL = "">

		<!--- build path of plugin manifest file --->
		<cfset tmp = expandPath(arguments.templatePath & "/site-template.xml")>
		
		<!--- check if the directory contains a siteTemplate.xml file --->
		<cfif fileExists(tmp)>
			<cfset xmlDoc = xmlParse(tmp)>
			<cfif structKeyExists(xmlDoc.xmlRoot,"title")>
				<cfset st.title = xmlDoc.xmlRoot.title.xmlText>
			</cfif>
			<cfif structKeyExists(xmlDoc.xmlRoot,"description")>
				<cfset st.description = xmlDoc.xmlRoot.description.xmlText>
			</cfif>
			<cfif structKeyExists(xmlDoc.xmlRoot,"version")>
				<cfset st.version = xmlDoc.xmlRoot.version.xmlText>
			</cfif>
			<cfif structKeyExists(xmlDoc.xmlRoot,"author")>
				<cfset st.author = xmlDoc.xmlRoot.author.xmlText>
			</cfif>
			<cfif structKeyExists(xmlDoc.xmlRoot,"authorURL")>
				<cfset st.authorURL = xmlDoc.xmlRoot.authorURL.xmlText>
			</cfif>
		</cfif>

		<!--- check if site has a thumbnail icon --->
		<cfif fileExists(expandPath(arguments.templatePath & "/" & variables.DEFAULT_ICON_FILENAME))>
			<cfset st.thumbHREF = arguments.templatePath & "/" & variables.DEFAULT_ICON_FILENAME>
		</cfif>
		
		<cfset variables.siteTemplatesMap[name] = duplicate(st)>
	</cffunction>

	<cffunction name="getSiteTemplates" access="public" returntype="array" hint="Returns an array with all registered site templates">
		<cfset var aRtn = arrayNew(1)>
		<cfset var key = "">
		<cfloop collection="#variables.siteTemplatesMap#" item="key">
			<cfset arrayAppend(aRtn, variables.siteTemplatesMap[key])>
		</cfloop>
		<cfreturn aRtn>
	</cffunction>

	<cffunction name="getSiteTemplate" access="public" returntype="struct" hint="Retrieves a registered site template by its name">
		<cfargument name="name" type="string" required="true">
		<cfif structKeyExists(variables.siteTemplatesMap, arguments.name)>
			<cfreturn variables.siteTemplatesMap[arguments.name]>
		<cfelse>
			<cfthrow message="Site Template not found" type="siteTemplateService.siteTemplateNotFound">
		</cfif>
	</cffunction>

	<cffunction name="hasSiteTemplate" access="public" returntype="boolean" hint="Checks if there is a registered site template by its name">
		<cfargument name="name" type="string" required="true">
		<cfreturn structKeyExists(variables.siteTemplatesMap, arguments.name)>
	</cffunction>
			
</cfcomponent>