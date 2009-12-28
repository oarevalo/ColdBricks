<cfcomponent extends="ColdBricks.handlers.ehColdBricks">
	
	<cffunction name="dspMain" access="public" returntype="void">
		<cfset setNextEvent("extensions.ehGeneral.dspModules")>
	</cffunction>

	<cffunction name="dspModules" access="public" returntype="void">
		<cfscript>
			try {
				ui = getService("UIManager");
				
				setValue("modules", ui.getModules());
				setValue("cbPageTitle", "Extensions Manager");
				setValue("cbPageIcon", "images/cb-blocks.png");
				setView("vwModules");

			} catch(any e) {
				setMessage("error",e.message);
				setNextEvent("ehGeneral.dspMain");			
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspSiteTemplates" access="public" returntype="void">
		<cfscript>
			try {
				ui = getService("siteTemplates");
				
				setValue("siteTemplates", ui.getSiteTemplates());
				setValue("cbPageTitle", "Extensions Manager");
				setValue("cbPageIcon", "images/cb-blocks.png");
				setView("vwSiteTemplates");

			} catch(any e) {
				setMessage("error",e.message);
				setNextEvent("ehGeneral.dspMain");			
			}
		</cfscript>
	</cffunction>

	<cffunction name="doUninstall" access="public" returntype="void">
		<cfset var name = getValue("name")>
		<cfset var type = getValue("type")>
		<cfset var fullpath = "">

		<cftry>
			<cfswitch expression="#type#">
				<cfcase value="module">
					<cfset uninstallModule(name)>
					<cfset nextEvent = "extensions.ehGeneral.dspModules">
				</cfcase>
				<cfcase value="siteTemplate">
					<cfset uninstallSiteTemplate(name)>
					<cfset nextEvent = "extensions.ehGeneral.dspSiteTemplates">
				</cfcase>
			</cfswitch>
			
			<cfset setMessage("info","The #type# has been uninstalled. You must reset ColdBricks now")>
			<cfset setNextEvent(nextEvent,"showReset=true")>

			<cfcatch type="any">
				<cfset setMessage("error",cfcatch.message)>
				<cfset setNextEvent(nextEvent)>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="doInstall" access="public" returntype="void">
		<cfset var installURL = getValue("installURL")>
		<cfset var installZip = getValue("installZip")>
		<cfset var type = getValue("type")>
		<cfset var basePath = "">
		<cfset var src = "">
		<cfset var srcType = "">
		<cfset var nextEvent = "ehGeneral.dspMain">

		<cftry>
			<cfswitch expression="#type#">
				<cfcase value="module">
					<cfset basePath = getSetting("externalModulesRoot") & "/">
					<cfset nextEvent = "extensions.ehGeneral.dspModules">
				</cfcase>
				<cfcase value="siteTemplate">
					<cfset basePath = getSetting("siteTemplatesRoot") & "/">
					<cfset nextEvent = "extensions.ehGeneral.dspSiteTemplates">
				</cfcase>
			</cfswitch>

			<cfif installURL neq "" and getValue("btnInstallURL") neq "">
				<cfset src = installURL>
				<cfset srcType = "URL">
			<cfelseif installZip neq "">
				<cfset src = installZip>
				<cfset srcType = "ZIP">
			<cfelse>
				<cfthrow message="Please provide a URL or archive to install">
			</cfif>

			<cfset installExtension(basePath, src, srcType)>

			<cfset setMessage("info","The #type# has been installed. You must reset ColdBricks now")>
			<cfset setNextEvent(nextEvent,"showReset=true")>

			<cfcatch type="any">
				<cfset setMessage("error",cfcatch.message)>
				<cfset setNextEvent(nextEvent)>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="installExtension" access="public" returntype="void">
		<cfargument name="installBasePath" type="string" required="true">
		<cfargument name="installSource" type="string" required="true">
		<cfargument name="installType" type="string" required="true">
		
		<cfset var zippath = getTempFile(getTempDirectory(),"coldbricksinstall")>
		
		<cfif arguments.installType eq "URL">
			<!--- this is a URL install --->
			<cfset path = arguments.installBasePath & getFileFromPath(arguments.installSource)>		
			
			<cfif left(arguments.installSource,4) neq "http">
				<cfset arguments.installSource = "http://" & arguments.installSource>
			</cfif>

			<cfhttp method="get" 
					url="#arguments.installSource#" 
					getasbinary="auto"
					result="content"
					throwonerror="true"
					redirect="true"
					file="#getFileFromPath(zipPath)#"
					path="#getTempDirectory()#">
			<cfif content.text>
				<cfthrow message="Extension archive not found or not available">
			</cfif>

		<cfelseif arguments.installType eq "ZIP">
			<!--- this is a ZIP install --->
			<cffile action="upload" destination="#zippath#" nameconflict="overwrite" filefield="#arguments.installSource#">
		
		<cfelse>
			<cfthrow message="Unknown install source type">
		</cfif>

		<cfif not directoryExists(expandPath(arguments.installBasePath))>
			<cfdirectory action="create" directory="#expandPath(arguments.installBasePath)#" mode="777">
		</cfif>

		<cfzip action="unzip" destination="#expandPath(arguments.installBasePath)#" file="#zippath#" overwrite="yes" recurse="true"></cfzip>

		<cffile action="delete" file="#zippath#">

	</cffunction>	
	
	
	
	<cffunction name="uninstallModule" access="private" returntype="void">
		<cfargument name="name" type="string" required="true">
		<cfset var fullPath = "">
		<cfset var ui = getService("UIManager")>
		
		<cfif not ui.hasModule(arguments.name)>
			<cfthrow message="Module '#arguments.name#' not found">
		</cfif>
		
		<cfif directoryExists(expandPath("/ColdBricks/modules/#arguments.name#"))>
			<cfset fullpath = "/ColdBricks/modules/#arguments.name#">
		<cfelseif directoryExists(expandPath(getSetting("externalModulesRoot") & "/#arguments.name#"))>
			<cfset fullpath = getSetting("externalModulesRoot") & "/#arguments.name#">
		<cfelse>
			<cfthrow message="Module not found">
		</cfif>
		
		<cfdirectory action="delete" directory="#expandPath(fullpath)#" recurse="true">
	</cffunction>

	<cffunction name="uninstallSiteTemplate" access="private" returntype="void">
		<cfargument name="name" type="string" required="true">
		<cfset var path = getSetting("siteTemplatesRoot")>
		<cfset var fullPath = path & "/" & arguments.name>
		<cfset var ui = getService("siteTemplates")>
		
		<cfif not ui.hasSiteTemplate(arguments.name)>
			<cfthrow message="SiteTemplate '#arguments.name#' not found">
		</cfif>
		
		<cfif not directoryExists(expandPath(fullPath))>
			<cfthrow message="SiteTemplate directory not found">
		</cfif>
		
		<cfdirectory action="delete" directory="#expandPath(fullpath)#" recurse="true">
	</cffunction>

</cfcomponent>