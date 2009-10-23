<cfcomponent extends="ColdBricks.handlers.ehColdBricks">

	<cfset variables.accountsConfigPath = "/homePortalsAccounts/config/accounts-config.xml.cfm">
	<cfset variables.modulePropertiesConfigPath = "/homePortalsModules/config/module-properties.xml">
	
	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			try {
				configBean = getService("configManager").getHomePortalsConfigBean();
				
				panel = getValue("panel");
				if(panel eq "" and structKeyExists(session,"panel")) panel = session.panel;
				if(panel eq "") panel = "general";
				session.panel = panel;
				
				setView("server/vwMain");
				setValue("panel", panel);
				setValue("cbPageTitle", "Server Settings");
				setValue("cbPageIcon", "images/configure_48x48.png");

				setValue("oHomePortalsConfigBean", configBean );
				
				setValue("hasAccountsPlugin", structKeyExists(configBean.getPlugins(),"accounts") );
				setValue("hasModulesPlugin", structKeyExists(configBean.getPlugins(),"modules") );
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");			
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspAccounts" access="public" returntype="void">
		<cfscript>
			try {
				configBean = getService("configManager").getHomePortalsConfigBean();
				
				setView("server/vwAccounts");
				setValue("oAccountsConfigBean", getAccountsConfigBean() );
				setValue("cbPageTitle", "Server Settings");
				setValue("cbPageIcon", "images/configure_48x48.png");
				setValue("hasAccountsPlugin", structKeyExists(configBean.getPlugins(),"accounts") );
				setValue("hasModulesPlugin", structKeyExists(configBean.getPlugins(),"modules") );
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");			
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspModuleProperties" access="public" returntype="void">
		<cfscript>
			try {
				configBean = getService("configManager").getHomePortalsConfigBean();
				
				setView("server/vwModuleProperties");
				setValue("oModulePropertiesConfigBean", getModulePropertiesConfigBean() );
				setValue("cbPageTitle", "Server Settings");
				setValue("cbPageIcon", "images/configure_48x48.png");
				setValue("hasAccountsPlugin", structKeyExists(configBean.getPlugins(),"accounts") );
				setValue("hasModulesPlugin", structKeyExists(configBean.getPlugins(),"modules") );
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");			
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspEditXML" access="public" returntype="void">
		<cfscript>
			var aConfigFiles = arrayNew(1);
			var configFile = getValue("configFile");
			var oHelpDAO = 0;
			var xmlDoc = 0;
			var xmlDocStr = "";
			var qryHelp = 0;
			var oFormatter = createObject("component","ColdBricks.components.xmlStringFormatter").init();
			var hpConfigPath = getSetting("homePortalsConfigPath");
			
			try {
				configBean = getService("configManager").getHomePortalsConfigBean();
				
				setValue("hasAccountsPlugin", structKeyExists(configBean.getPlugins(),"accounts") );
				setValue("hasModulesPlugin", structKeyExists(configBean.getPlugins(),"modules") );
				
				arrayAppend(aConfigFiles, "/homePortals" & hpConfigPath);

				if(getValue("hasAccountsPlugin")) {
					arrayAppend(aConfigFiles, variables.accountsConfigPath);
					arrayAppend(aConfigFiles, "/homePortalsAccounts/common/pages/default.xml");
					arrayAppend(aConfigFiles, "/homePortalsAccounts/common/pages/newPage.xml");
				}
				if(getValue("hasModulesPlugin")) {
					arrayAppend(aConfigFiles, variables.modulePropertiesConfigPath);
				}
			
				if(configFile neq "") {
					xmlDoc = xmlParse(expandPath(configFile));
					xmlDocStr = oFormatter.makePretty(xmlDoc.xmlRoot);
					setValue("xmlDoc", xmlDocStr);

					// get help on selected file
					oHelpDAO = getService("DAOFactory").getDAO("help");
					qryHelp = oHelpDAO.search(name = getFileFromPath(configFile));
					setValue("qryHelp", qryHelp);
				}
			
				setValue("aConfigFiles", aConfigFiles);
				setValue("configFile", configFile);
				setView("server/vwEditXML");
				setValue("cbPageTitle", "Server Settings");
				setValue("cbPageIcon", "images/configure_48x48.png");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");			
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="doSaveConfigFile" access="public" returntype="void">
		<cfscript>
			var xmlContent = getValue("xmlContent","");
			var configFile = getValue("configFile","");
			
			try {
				if(configFile eq "") {
					throw("You must select a config file from the list to edit","coldBricks.validation");
				}
				
				if(not isXml(xmlContent)) {
					setMessage("error", "The given content is not a valid XML document");
					dspEditXML();
					return;
				}

				fileWrite( expandPath( configFile ), xmlContent, "utf-8");
				
				// go to the xml editor
				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
			setNextEvent("config.ehSettings.dspEditXML","configFile=#configFile#");
		</cfscript>
	</cffunction>	
		
	<cffunction name="doSaveGeneral" access="public" returntype="void">
		<cfscript>
			var contentRoot = getValue("contentRoot");
			var defaultPage = getValue("defaultPage");
			var pageCacheSize = getValue("pageCacheSize");
			var pageCacheTTL = getValue("pageCacheTTL");
			var catalogCacheSize = getValue("catalogCacheSize");
			var catalogCacheTTL = getValue("catalogCacheTTL");

			try {
				if(val(pageCacheSize) eq 0) throw("You must enter a valid number for the page cache maximum size","validation");
				if(val(pageCacheTTL) eq 0) throw("You must enter a valid number for the page cache TTL","validation");
				if(val(catalogCacheSize) eq 0) throw("You must enter a valid number for the resources cache maximum size","validation");
				if(val(catalogCacheTTL) eq 0) throw("You must enter a valid number for the resources cache TTL","validation");
				
				// set new values
				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				oConfigBean.setDefaultPage(defaultPage);
				oConfigBean.setPageCacheSize(pageCacheSize);
				oConfigBean.setPageCacheTTL(pageCacheTTL);
				oConfigBean.setCatalogCacheSize(catalogCacheSize);
				oConfigBean.setCatalogCacheTTL(catalogCacheTTL);
				oConfigBean.setContentRoot(contentRoot);
			
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}

		</cfscript>
	</cffunction>	


	<!--- Base Resources --->
		
	<cffunction name="doAddBaseResource" access="public" returntype="void">
		<cfscript>
			var type = getValue("type");
			var href = getValue("href");
			var oConfigBean = 0;
			
			try {
				if(type eq "") throw("The base resource type is required","validation");
				if(href eq "") throw("The base resource value is required","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				oConfigBean.addBaseResource(type, href);
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain","baseResourceEditIndex=0");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>
	</cffunction>	

	<cffunction name="doSaveBaseResource" access="public" returntype="void">
		<cfscript>
			var type = getValue("type");
			var index = getValue("index");
			var href = getValue("href");
			var oConfigBean = 0;
			var aRes = arrayNew(1);
			
			try {
				if(type eq "") throw("The base resource type is required","validation");
				if(val(index) eq 0) throw("You must select a base resource to edit","validation");
				if(href eq "") throw("The base resource value is required","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				// remove resource
				aRes = oConfigBean.getBaseResourcesByType(type);
				if(index lte arrayLen(aRes))
					oConfigBean.removeBaseResource(type, aRes[index]);
				
				// add new values for resource
				oConfigBean.addBaseResource(type, href);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain","baseResourceEditIndex=#index#&baseResourceEditType=#type#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>		
	</cffunction>	

	<cffunction name="doDeleteBaseResource" access="public" returntype="void">
		<cfscript>
			var type = getValue("type");
			var index = getValue("index");
			var oConfigBean = 0;
			var aRes = arrayNew(1);
			
			try {
				if(type eq "") throw("The base resource type is required","validation");
				if(val(index) eq 0) throw("You must select a base resource to delete","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				// remove resource
				aRes = oConfigBean.getBaseResourcesByType(type);
				if(index lte arrayLen(aRes))
					oConfigBean.removeBaseResource(type, aRes[index]);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>	
	</cffunction>	


	<!--- Resource Libraries --->

	<cffunction name="doAddResLibPath" access="public" returntype="void">
		<cfscript>
			var path = getValue("path");
			var oConfigBean = 0;
			
			try {
				if(path eq "") throw("The resource library path is required","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				oConfigBean.addResourceLibraryPath(path);
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain","resLibPathEditIndex=0");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>
	</cffunction>	

	<cffunction name="doSaveResLibPath" access="public" returntype="void">
		<cfscript>
			var index = getValue("index");
			var path = getValue("path");
			var oConfigBean = 0;
			var aResLibs = arrayNew(1);
			
			try {
				if(val(index) eq 0) throw("You must select a resource library to edit","validation");
				if(path eq "") throw("The resource library path is required","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				// remove resource lib
				aResLibs = oConfigBean.getResourceLibraryPaths();
				if(index lte arrayLen(aResLibs))
					oConfigBean.removeResourceLibraryPath(aResLibs[index]);
				
				// add new values for resource
				oConfigBean.addResourceLibraryPath(path);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain","resLibPathEditIndex=#index#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>		
	</cffunction>	

	<cffunction name="doDeleteResLibPath" access="public" returntype="void">
		<cfscript>
			var index = getValue("index");
			var oConfigBean = 0;
			var aResLibs = arrayNew(1);
			
			try {
				if(val(index) eq 0) throw("You must select a resource library to delete","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				// remove resource lib
				aResLibs = oConfigBean.getResourceLibraryPaths();
				if(index lte arrayLen(aResLibs))
					oConfigBean.removeResourceLibraryPath(aResLibs[index]);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>	
	</cffunction>	


	<!--- Content Renderers --->

	<cffunction name="doSaveContentRenderer" access="public" returntype="void">
		<cfscript>
			var path = getValue("path");
			var name = getValue("name");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("The content renderer name is required","validation");
				if(path eq "") throw("The content renderer path is required","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				oConfigBean.setContentRenderer(name, path);
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>
	</cffunction>	

	<cffunction name="doDeleteContentRenderer" access="public" returntype="void">
		<cfscript>
			var index = getValue("name");
			var oConfigBean = 0;
			var aResLibs = arrayNew(1);
			
			try {
				if(name eq "") throw("You must select a content renderer to delete","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				// remove content renderer
				oConfigBean.removeContentRenderer(name);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>	
	</cffunction>	


	<!--- Plugins --->

	<cffunction name="doSavePlugin" access="public" returntype="void">
		<cfscript>
			var path = getValue("path");
			var name = getValue("name");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("The plugin name is required","validation");
				if(path eq "") throw("The plugin path is required","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				oConfigBean.setPlugin(name, path);
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>
	</cffunction>	

	<cffunction name="doDeletePlugin" access="public" returntype="void">
		<cfscript>
			var name = getValue("name");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("You must select a plugin to delete","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				// remove content renderer
				oConfigBean.removePlugin(name);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>	
	</cffunction>	


	<!--- Resource Types --->

	<cffunction name="doSaveResourceType" access="public" returntype="void">
		<cfscript>
			var name = getValue("name");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("The resource type name is required","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				oConfigBean.setResourceType(name = name,
											folderName = getValue("folderName"),
											description = getValue("description"),
											resBeanPath = getValue("resBeanPath"),
											fileTypes = getValue("fileTypes"));
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doDeleteResourceType" access="public" returntype="void">
		<cfscript>
			var name = getValue("name");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("You must select a resource type to delete","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				// remove content renderer
				oConfigBean.removeResourceType(name);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>	
	</cffunction>

	<cffunction name="doSaveResourceTypeProperty" access="public" returntype="void">
		<cfscript>
			var resTypeEditKey = getValue("resTypeEditKey");
			var resTypePropEditKey = getValue("resTypePropEditKey");
			var name = getValue("name");
			var type = getValue("type");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("The resource type property name is required","validation");
				if(resTypeEditKey eq "") throw("The resource type name is required","validation");

				if(type eq "resource") type = "resource:" & getValue("resourceType");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				oConfigBean.setResourceTypeProperty(resType = resTypeEditKey,
													name = name,
													description = getValue("description"),
													type = type,
													values = getValue("values"),
													required = getValue("required"),
													default = getValue("default"),
													label = getValue("label"));
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain","resTypeEditKey=#resTypeEditKey#");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain","resTypeEditKey=#resTypeEditKey#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain","resTypeEditKey=#resTypeEditKey#");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doDeleteResourceTypeProperty" access="public" returntype="void">
		<cfscript>
			var resTypeEditKey = getValue("resTypeEditKey");
			var name = getValue("name");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("You must select a resource type to delete","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				// remove content renderer
				oConfigBean.removeResourceTypeProperty(resTypeEditKey, name);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain","resTypeEditKey=#resTypeEditKey#");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain","resTypeEditKey=#resTypeEditKey#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain","resTypeEditKey=#resTypeEditKey#");
			}
		</cfscript>	
	</cffunction>


	<!--- Render Templates --->

	<cffunction name="doSaveRenderTemplate" access="public" returntype="void">
		<cfscript>
			var href = getValue("href");
			var name = getValue("name");
			var type = getValue("type");
			var isDefault = getValue("isDefault",false);
			var description = getValue("description");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("The render template name is required","validation");
				if(href eq "") throw("The render template path is required","validation");
				if(type eq "") throw("The render template type is required","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				oConfigBean.setRenderTemplate(name, type, href, description, isDefault);
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>
	</cffunction>	

	<cffunction name="doDeleteRenderTemplate" access="public" returntype="void">
		<cfscript>
			var name = getValue("name");
			var type = getValue("type");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("You must select a render template to delete","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				// remove render template
				oConfigBean.removeRenderTemplate(name, type);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>	
	</cffunction>	


	<!--- Resource Library Types --->

	<cffunction name="doSaveResourceLibraryType" access="public" returntype="void">
		<cfscript>
			var oConfigBean = 0;
			
			try {
				if(getValue("prefix") eq "") throw("The resource library type prefix is required","validation");
				if(getValue("path") eq "") throw("The resource library type path is required","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				oConfigBean.setResourceLibraryType(prefix = getValue("prefix"),
													path = getValue("path"));
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doDeleteResourceLibraryType" access="public" returntype="void">
		<cfscript>
			var prefix = getValue("prefix");
			var oConfigBean = 0;
			
			try {
				if(prefix eq "") throw("You must select a resource library type to delete","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				// remove content renderer
				oConfigBean.removeResourceLibraryType(prefix);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>	
	</cffunction>

	<cffunction name="doSaveResourceLibraryTypeProperty" access="public" returntype="void">
		<cfscript>
			var resLibTypeEditKey = getValue("resLibTypeEditKey");
			var name = getValue("name");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("The resource library type property name is required","validation");
				if(resLibTypeEditKey eq "") throw("The resource library type is required","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				oConfigBean.setResourceLibraryTypeProperty(prefix = resLibTypeEditKey,
															name = name,
															value = getValue("value"));
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain","resLibTypeEditKey=#resLibTypeEditKey#");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain","resLibTypeEditKey=#resLibTypeEditKey#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain","resLibTypeEditKey=#resLibTypeEditKey#");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doDeleteResourceLibraryTypeProperty" access="public" returntype="void">
		<cfscript>
			var resLibTypeEditKey = getValue("resLibTypeEditKey");
			var name = getValue("name");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("You must select a resource library type to delete","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				// remove content renderer
				oConfigBean.removeResourceLibraryTypeProperty(resLibTypeEditKey, name);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain","resLibTypeEditKey=#resLibTypeEditKey#");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain","resLibTypeEditKey=#resLibTypeEditKey#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain","resLibTypeEditKey=#resLibTypeEditKey#");
			}
		</cfscript>	
	</cffunction>



	<!--- Page Properties --->

	<cffunction name="doSaveProperty" access="public" returntype="void">
		<cfscript>
			var value = getValue("value");
			var name = getValue("name");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("The page property name is required","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				oConfigBean.setPageProperty(name, value);
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>
	</cffunction>	

	<cffunction name="doDeleteProperty" access="public" returntype="void">
		<cfscript>
			var name = getValue("name");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("You must select a page property to delete","validation");

				oConfigBean = getService("configManager").getHomePortalsConfigBean();
				
				oConfigBean.removePageProperty(name);
				
				// save changes
				getService("configManager").saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspMain");
			}
		</cfscript>	
	</cffunction>	



	<!--- Accounts Plugin Config --->

	<cffunction name="doSaveAccounts" access="public" returntype="void">
		<cfscript>
			var accountsRoot = getValue("accountsRoot");
			var defaultAccount = getValue("defaultAccount");
			var storageType = getValue("storageType");
			var datasource = getValue("datasource");
			var username = getValue("username");
			var password = getValue("password");
			var dbType = getValue("dbType");
			var newAccountTemplate = getValue("newAccountTemplate");
			var newPageTemplate = getValue("newPageTemplate");
			var dataroot = getValue("dataroot");

			try {
				if(accountsRoot eq "") throw("The accounts root directory is required","validation");
				if(storageType eq "") throw("The storage type is required","validation");

				if(newAccountTemplate eq "") throw("The location of the 'New Account' template is required","validation");
				if(newPageTemplate eq "") throw("The location of the 'New Page' template is required","validation");

				switch(storageType) {
					case "xml":
						if(dataroot eq "") throw("For 'XML File' storage, data root is required","validation");
						break;

					case "db":
						if(datasource eq "") throw("For 'Database' storage, the datasource is required","validation");
						if(dbType eq "") throw("For 'Database' storage, the database type is required","validation");
						break;

					default:
						throw("You have selected an invalid storage type.","validation");
				} 

				// set new values
				oConfigBean = getAccountsConfigBean();
				oConfigBean.setAccountsRoot(accountsRoot);
				oConfigBean.setDefaultAccount(defaultAccount);
				oConfigBean.setStorageType(storageType);
				oConfigBean.setDatasource(datasource);
				oConfigBean.setUsername(username);
				oConfigBean.setPassword(password);
				oConfigBean.setDBType(dbType);
				oConfigBean.setNewAccountTemplate(newAccountTemplate);
				oConfigBean.setNewPageTemplate(newPageTemplate);
				oConfigBean.setDataRoot(dataroot);
			
				// save changes
				saveAccountsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspAccounts");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspAccounts");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspAccounts");
			}
		</cfscript>
	</cffunction>


	<!--- Module Properties Plugin Config --->

	<cffunction name="doAddModuleProperty" access="public" returntype="void">
		<cfscript>
			var moduleName = getValue("moduleName");
			var propertyName = getValue("propertyName");
			var propertyValue = getValue("propertyValue");
			var oConfigBean = 0;
			
			try {
				if(moduleName eq "") throw("The module name is required","validation");
				if(propertyName eq "") throw("The property name is required","validation");

				oConfigBean = getModulePropertiesConfigBean();
				oConfigBean.setProperty(moduleName, propertyName, propertyValue);
				saveModulePropertiesConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspModuleProperties","index=0");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspModuleProperties");
			}
		</cfscript>
	</cffunction>	

	<cffunction name="doSaveModuleProperty" access="public" returntype="void">
		<cfscript>
			var moduleName = getValue("moduleName");
			var propertyName = getValue("propertyName");
			var propertyValue = getValue("propertyValue");
			var oldModuleName = getValue("old_moduleName");
			var oldPropertyName = getValue("old_propertyName");
			var index = getValue("index");
			var oConfigBean = 0;
			
			try {
				if(moduleName eq "") throw("The module name is required","validation");
				if(propertyName eq "") throw("The property name is required","validation");
				if(val(index) eq 0) throw("You must select a module property to edit","validation");

				oConfigBean = getModulePropertiesConfigBean();
				
				// remove old entry
				oConfigBean.removeProperty(oldModuleName, oldPropertyName);
				
				// add new property
				oConfigBean.setProperty(moduleName, propertyName, propertyValue);
				
				// save changes
				saveModulePropertiesConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspModuleProperties","index=#index#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspModuleProperties");
			}
		</cfscript>		
	</cffunction>	

	<cffunction name="doDeleteModuleProperty" access="public" returntype="void">
		<cfscript>
			var moduleName = getValue("moduleName");
			var propertyName = getValue("propertyName");
			var oConfigBean = 0;
			
			try {
				oConfigBean = getModulePropertiesConfigBean();
				
				// remove resource
				oConfigBean.removeProperty(moduleName, propertyName);
				
				// save changes
				saveModulePropertiesConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("config.ehSettings.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("config.ehSettings.dspModuleProperties");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("config.ehSettings.dspModuleProperties");
			}
		</cfscript>	
	</cffunction>	
		
	
	<!--- Private Methods ---->	
		
	<cffunction name="getAccountsConfigBean" access="private" returntype="homePortalsAccounts.components.accountsConfigBean">
		<cfscript>
			var oConfigBean = createObject("component","homePortalsAccounts.components.accountsConfigBean").init( expandPath(variables.accountsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="saveAccountsConfigBean" access="private" returntype="void">
		<cfargument name="configBean" type="homePortalsAccounts.components.accountsConfigBean" required="true">
		<cfset fileWrite( expandPath(variables.accountsConfigPath), toString( arguments.configBean.toXML() ), "utf-8" )>
	</cffunction>

	<cffunction name="getModulePropertiesConfigBean" access="private" returntype="homePortalsModules.components.modulePropertiesConfigBean">
		<cfscript>
			var oConfigBean = createObject("component","homePortalsModules.components.modulePropertiesConfigBean").init( expandPath(variables.modulePropertiesConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="saveModulePropertiesConfigBean" access="private" returntype="void">
		<cfargument name="configBean" type="homePortalsModules.components.modulePropertiesConfigBean" required="true">
		<cfset fileWrite( expandPath(variables.modulePropertiesConfigPath), toString( arguments.configBean.toXML() ), "utf-8" )>
	</cffunction>
				
</cfcomponent>