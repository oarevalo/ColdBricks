<cfcomponent extends="ColdBricks.handlers.ehColdBricks">

	<cfset variables.homePortalsConfigPath = "/config/homePortals-config.xml">
	<cfset variables.accountsConfigPath = "/config/accounts-config.xml.cfm">
	<cfset variables.modulePropertiesConfigPath = "/config/module-properties.xml">
	<cfset variables.confirmMessage = "Config file changed. New settings will be applied next time the site is reset">
	
	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var oHPConfigBean = 0;
			var oAppConfigBean = 0;
			var panel = "";
	
			try {
				panel = getValue("panel");
				if(panel eq "" and structKeyExists(session,"panel")) panel = session.panel;
				if(panel eq "") panel = "general";
				session.panel = panel;

				// get config config bean with server defaults
				oHPConfigBean = getHomePortalsConfigBean("/homePortals");

				// get config bean for this application
				oAppConfigBean = getAppHomePortalsConfigBean();

				setView("vwMain");
				setValue("panel", panel);
				setValue("oHomePortalsConfigBean", oHPConfigBean );
				setValue("oAppConfigBean", oAppConfigBean );
				setValue("hasAccountsPlugin", structKeyExists(getService("sessionContext").getContext().getHomePortals().getConfig().getPlugins(),"accounts") );
				setValue("hasModulesPlugin", structKeyExists(getService("sessionContext").getContext().getHomePortals().getConfig().getPlugins(),"modules") );

				setValue("cbPageTitle", "Site Settings");
				setValue("cbPageIcon", "configure_48x48.png");
				setValue("cbShowSiteMenu", true);
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");			
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="dspAccounts" access="public" returntype="void">
		<cfscript>
			var oConfigBean = 0;
			var hp = 0;
			var appRoot = 0;
			var configFile = "";
			var oContext = getService("sessionContext").getContext();

			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();
				configFile = expandPath(appRoot & variables.accountsConfigPath);

				// get config bean with mix of base and app settings
				oConfigBean = getAccountsConfigBean();
				oConfigBean.load(configFile);

				configFile = expandPath(appRoot & variables.accountsConfigPath);

				// get struct with only settings defined for this application
				stAppConfig = parseAppAccountsConfigFile(configFile);

				setView("vwAccounts");
				setValue("oAccountsConfigBean", oConfigBean);
				setValue("stAppConfig", stAppConfig );
				setValue("hasAccountsPlugin", structKeyExists(getService("sessionContext").getContext().getHomePortals().getConfig().getPlugins(),"accounts") );
				setValue("hasModulesPlugin", structKeyExists(getService("sessionContext").getContext().getHomePortals().getConfig().getPlugins(),"modules") );

				setValue("cbPageTitle", "Site Settings");
				setValue("cbPageIcon", "configure_48x48.png");
				setValue("cbShowSiteMenu", true);
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");			
			}
		</cfscript>
	</cffunction>	

	<cffunction name="dspModuleProperties" access="public" returntype="void">
		<cfscript>
			var oConfigBean = 0;
			var oConfigBeanBase = 0;
			var hp = 0;
			var appRoot = 0;
			var oContext = getService("sessionContext").getContext();

			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();

				oConfigBeanBase = getModulePropertiesConfigBean();
				oConfigBean = getModulePropertiesConfigBean(appRoot & variables.modulePropertiesConfigPath);

				setView("vwModuleProperties");
				setValue("oModulePropertiesConfigBeanBase", oConfigBeanBase );
				setValue("oModulePropertiesConfigBean", oConfigBean );
				setValue("hasAccountsPlugin", structKeyExists(getService("sessionContext").getContext().getHomePortals().getConfig().getPlugins(),"accounts") );
				setValue("hasModulesPlugin", structKeyExists(getService("sessionContext").getContext().getHomePortals().getConfig().getPlugins(),"modules") );

				setValue("cbPageTitle", "Site Settings");
				setValue("cbPageIcon", "configure_48x48.png");
				setValue("cbShowSiteMenu", true);
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");			
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="dspEditXML" access="public" returntype="void">
		<cfscript>
			var aConfigFiles = arrayNew(1);
			var configFile = getValue("configFile");
			var hp = 0;
			var appRoot = 0;
			var xmlDocStr = "";
			var oContext = getService("sessionContext").getContext();
			var oFormatter = createObject("component","ColdBricks.components.xmlStringFormatter").init();
			
			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();
				if(right(appRoot,1) neq "/") appRoot = appRoot & "/";

				setValue("hasAccountsPlugin", structKeyExists(hp.getConfig().getPlugins(),"accounts") );
				setValue("hasModulesPlugin", structKeyExists(hp.getConfig().getPlugins(),"modules") );
					
				arrayAppend(aConfigFiles, appRoot & variables.homePortalsConfigPath);
			
				if(getValue("hasAccountsPlugin")) {
					arrayAppend(aConfigFiles, appRoot & variables.accountsConfigPath);
				}
				if(getValue("hasModulesPlugin")) {
					arrayAppend(aConfigFiles, appRoot & variables.modulePropertiesConfigPath);
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
				setView("vwEditXML");

				setValue("cbPageTitle", "Site Settings");
				setValue("cbPageIcon", "configure_48x48.png");
				setValue("cbShowSiteMenu", true);
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");			
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
					dspMain();
					return;
				}

				writeFile( expandPath( configFile ), xmlContent);
				
				// go to the xml editor
				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
			setNextEvent("siteConfig.ehSiteConfig.dspMain","configFile=#configFile#");
		</cfscript>
	</cffunction>	
	
	<cffunction name="doSaveGeneral" access="public" returntype="void">
		<cfscript>
			var appSettings = getValue("appSettings");
			var xmlDoc = xmlNew();
			
			try {
				// only validate the settings that will be overriden
				if(listFind(appSettings,"defaultPage") and defaultPage eq "") throw("The default page is required","validation");
				if(listFind(appSettings,"contentRoot") and contentRoot eq "") throw("The content root path is required","validation");
				if(listFind(appSettings,"pageCacheSize") and val(pageCacheSize) eq 0) throw("You must enter a valid number for the page cache maximum size","validation");
				if(listFind(appSettings,"pageCacheTTL") and val(pageCacheTTL) eq 0) throw("You must enter a valid number for the page cache TTL","validation");
				if(listFind(appSettings,"catalogCacheSize") and val(catalogCacheSize) eq 0) throw("You must enter a valid number for the resources cache maximum size","validation");
				if(listFind(appSettings,"catalogCacheTTL") and val(catalogCacheTTL) eq 0) throw("You must enter a valid number for the resources cache TTL","validation");
				
				// get saved config
				oAppConfigBean = getAppHomePortalsConfigBean();
				
				// update fields
				if(listFind(appSettings,"defaultPage")) oAppConfigBean.setDefaultPage( getValue("defaultPage") );
				if(listFind(appSettings,"contentRoot")) oAppConfigBean.setContentRoot( getValue("contentRoot") );
				if(listFind(appSettings,"pageCacheSize")) oAppConfigBean.setpageCacheSize( getValue("pageCacheSize") );
				if(listFind(appSettings,"pageCacheTTL")) oAppConfigBean.setpageCacheTTL( getValue("pageCacheTTL") );
				if(listFind(appSettings,"catalogCacheSize")) oAppConfigBean.setCatalogCacheSize( getValue("catalogCacheSize") );
				if(listFind(appSettings,"catalogCacheTTL")) oAppConfigBean.setCatalogCacheTTL( getValue("catalogCacheTTL") );
				
				// convert to xml
				xmlDoc = oAppConfigBean.toXML();
				
				// remove nodes that we are not editing
				if(not listFind(appSettings,"defaultPage")) structDelete(xmlDoc.xmlRoot,"defaultPage");
				if(not listFind(appSettings,"contentRoot")) structDelete(xmlDoc.xmlRoot,"contentRoot");
				if(not listFind(appSettings,"pageCacheSize")) structDelete(xmlDoc.xmlRoot,"pageCacheSize");
				if(not listFind(appSettings,"pageCacheTTL")) structDelete(xmlDoc.xmlRoot,"pageCacheTTL");
				if(not listFind(appSettings,"catalogCacheSize")) structDelete(xmlDoc.xmlRoot,"catalogCacheSize");
				if(not listFind(appSettings,"catalogCacheTTL")) structDelete(xmlDoc.xmlRoot,"catalogCacheTTL");
				
				// write file
				saveAppHomePortalsConfigDoc(xmlDoc, true);
				
				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			}
		</cfscript>
	</cffunction>



	<!--- Base Resources --->
	
	<cffunction name="doAddBaseResource" access="public" returntype="void">
		<cfscript>
			var type = getValue("type");
			var href = getValue("href");
			
			try {
				if(type eq "") throw("The base resource type is required","validation");
				if(href eq "") throw("The base resource value is required","validation");
				
				oConfigBean = getAppHomePortalsConfigBean();
				oConfigBean.addBaseResource(type, href);
				saveAppHomePortalsConfigBean( oConfigBean );
				
				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain","baseResourceEditIndex=0");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doSaveBaseResource" access="public" returntype="void">
		<cfscript>
			var type = getValue("type");
			var href = getValue("href");
			var index = getValue("index");
			var aRes = arrayNew(1);
			
			try {
				if(type eq "") throw("The base resource type is required","validation");
				if(href eq "") throw("The base resource value is required","validation");

				// remove resource
				oConfigBean = getAppHomePortalsConfigBean();
				aRes = oConfigBean.getBaseResourcesByType(type);
				if(index lte arrayLen(aRes))
					oConfigBean.removeBaseResource(type, aRes[index]);
				
				// add new values for resource
				oConfigBean.addBaseResource(type, href);
				
				saveAppHomePortalsConfigBean( oConfigBean );
				
				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain","baseResourceEditIndex=#index#&baseResourceEditType=#type#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			}
		</cfscript>		
	</cffunction>	

	<cffunction name="doDeleteBaseResource" access="public" returntype="void">
		<cfscript>
			var type = getValue("type");
			var href = getValue("href");
			var oConfigBean = 0;
			var aRes = arrayNew(1);
			
			try {
				if(type eq "") throw("The base resource type is required","validation");

				// remove resource
				oConfigBean = getAppHomePortalsConfigBean();
				aRes = oConfigBean.getBaseResourcesByType(type);
				if(index lte arrayLen(aRes))
					oConfigBean.removeBaseResource(type, aRes[index]);

				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
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

				oConfigBean = getAppHomePortalsConfigBean();
				oConfigBean.addResourceLibraryPath(path);
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain","resLibPathEditIndex=0");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
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

				oConfigBean = getAppHomePortalsConfigBean();
				
				// remove resource lib
				aResLibs = oConfigBean.getResourceLibraryPaths();
				if(index lte arrayLen(aResLibs))
					oConfigBean.removeResourceLibraryPath(aResLibs[index]);
				
				// add new values for resource
				oConfigBean.addResourceLibraryPath(path);
				
				// save changes
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain","resLibPathEditIndex=#index#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
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

				oConfigBean = getAppHomePortalsConfigBean();
				
				// remove resource lib
				aResLibs = oConfigBean.getResourceLibraryPaths();
				if(index lte arrayLen(aResLibs))
					oConfigBean.removeResourceLibraryPath(aResLibs[index]);
				
				// save changes
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
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

				oConfigBean = getAppHomePortalsConfigBean();
				oConfigBean.setContentRenderer(name, path);
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
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

				oConfigBean = getAppHomePortalsConfigBean();
				
				// remove content renderer
				oConfigBean.removeContentRenderer(name);
				
				// save changes
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
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

				oConfigBean = getAppHomePortalsConfigBean();
				oConfigBean.setPlugin(name, path);
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			}
		</cfscript>
	</cffunction>	

	<cffunction name="doDeletePlugin" access="public" returntype="void">
		<cfscript>
			var index = getValue("name");
			var oConfigBean = 0;
			var aResLibs = arrayNew(1);
			
			try {
				if(name eq "") throw("You must select a plugin to delete","validation");

				oConfigBean = getAppHomePortalsConfigBean();
				
				// remove content renderer
				oConfigBean.removePlugin(name);
				
				// save changes
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
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

				oConfigBean = getAppHomePortalsConfigBean();
				oConfigBean.setResourceType(name = name,
											folderName = getValue("folderName"),
											description = getValue("description"),
											resBeanPath = getValue("resBeanPath"),
											fileTypes = getValue("fileTypes"));
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doDeleteResourceType" access="public" returntype="void">
		<cfscript>
			var name = getValue("name");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("You must select a resource type to delete","validation");

				oConfigBean = getAppHomePortalsConfigBean();
				
				// remove content renderer
				oConfigBean.removeResourceType(name);
				
				// save changes
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
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

				oConfigBean = getAppHomePortalsConfigBean();
				oConfigBean.setResourceTypeProperty(resType = resTypeEditKey,
													name = name,
													description = getValue("description"),
													type = type,
													values = getValue("values"),
													required = getValue("required"),
													default = getValue("default"),
													label = getValue("label"));
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain","resTypeEditKey=#resTypeEditKey#");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain","resTypeEditKey=#resTypeEditKey#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain","resTypeEditKey=#resTypeEditKey#");
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

				oConfigBean = getAppHomePortalsConfigBean();
				
				// remove content renderer
				oConfigBean.removeResourceTypeProperty(resTypeEditKey, name);
				
				// save changes
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain","resTypeEditKey=#resTypeEditKey#");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain","resTypeEditKey=#resTypeEditKey#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain","resTypeEditKey=#resTypeEditKey#");
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

				oConfigBean = getAppHomePortalsConfigBean();
				oConfigBean.setRenderTemplate(name, type, href, description, isDefault);
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
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

				oConfigBean = getAppHomePortalsConfigBean();
				
				// remove render template
				oConfigBean.removeRenderTemplate(name, type);
				
				// save changes
				saveAppHomePortalsConfigBean( oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspMain");
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
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();

				if(moduleName eq "") throw("The module name is required","validation");
				if(propertyName eq "") throw("The property name is required","validation");

				oConfigBean = getModulePropertiesConfigBean(appRoot & "/config/module-properties.xml");
				oConfigBean.setProperty(moduleName, propertyName, propertyValue);
				saveModulePropertiesConfigBean( appRoot & "/config/module-properties.xml", oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspModuleProperties","index=0");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspModuleProperties");
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
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();

				if(moduleName eq "") throw("The module name is required","validation");
				if(propertyName eq "") throw("The property name is required","validation");
				if(val(index) eq 0) throw("You must select a module property to edit","validation");

				oConfigBean = getModulePropertiesConfigBean(appRoot & "/config/module-properties.xml");
				
				// remove old entry
				oConfigBean.removeProperty(oldModuleName, oldPropertyName);
				
				// add new property
				oConfigBean.setProperty(moduleName, propertyName, propertyValue);
				
				// save changes
				saveModulePropertiesConfigBean( appRoot & "/config/module-properties.xml", oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspModuleProperties","index=#index#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspModuleProperties");
			}
		</cfscript>		
	</cffunction>	

	<cffunction name="doDeleteModuleProperty" access="public" returntype="void">
		<cfscript>
			var moduleName = getValue("moduleName");
			var propertyName = getValue("propertyName");
			var oConfigBean = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();

				oConfigBean = getModulePropertiesConfigBean(appRoot & "/config/module-properties.xml");
				
				// remove resource
				oConfigBean.removeProperty(moduleName, propertyName);
				
				// save changes
				saveModulePropertiesConfigBean( appRoot & "/config/module-properties.xml", oConfigBean );

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspModuleProperties");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspModuleProperties");
			}
		</cfscript>	
	</cffunction>	
	
	
	<!--- Accounts Plugin Config --->

	<cffunction name="doSaveAccounts" access="public" returntype="void">
		<cfscript>
			var appSettings = getValue("appSettings");
			var xmlDoc = xmlNew();
			var xmlNode = 0;
			var i = 0;
			var hp = 0;
			var appRoot = 0;
			var configFile = 0;
			var oContext = getService("sessionContext").getContext();

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
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();
				configFile = expandPath(appRoot & "/config/accounts-config.xml.cfm");

				if(listFind(appSettings,"accountsRoot") and accountsRoot eq "") throw("The accounts root directory is required","validation");
				if(listFind(appSettings,"storageType") and storageType eq "") throw("The storage type is required","validation");

				if(listFind(appSettings,"newAccountTemplate") and newAccountTemplate eq "") throw("The location of the 'New Account' template is required","validation");
				if(listFind(appSettings,"newPageTemplate") and newPageTemplate eq "") throw("The location of the 'New Page' template is required","validation");

				switch(storageType) {
					case "xml":
						if(dataroot eq "") throw("For 'XML File' storage, data root is required","validation");
						break;

					case "db":
						if(listFind(appSettings,"datasource") and datasource eq "") throw("For 'Database' storage, the datasource is required","validation");
						if(listFind(appSettings,"dbType") and dbType eq "") throw("For 'Database' storage, the database type is required","validation");
						break;

					default:
						throw("You have selected an invalid storage type.","validation");
				} 

				// create root element
				xmlDoc.xmlRoot = xmlElemNew(xmlDoc,"homePortalsAccounts");

				// build xml doc with only the selected settings
				for(i=1;i lte listLen(appSettings);i=i+1) {
					key = listGetAt(appSettings,i);
					xmlNode = xmlElemNew(xmlDoc,key);
					xmlNode.xmlText = getValue(key);
					arrayAppend(xmlDoc.xmlRoot.xmlChildren, xmlNode);
				}
	
				// write file
				writeFile(configFile, toString(xmlDoc));

				setMessage("info", variables.confirmMessage);
				setNextEvent("siteConfig.ehSiteConfig.dspAccounts");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("siteConfig.ehSiteConfig.dspAccounts");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("siteConfig.ehSiteConfig.dspAccounts");
			}
		</cfscript>
	</cffunction>

	
	<!--- Private Methods ---->	
	
	<cffunction name="writeFile" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cfargument name="content" type="string" required="true">
		<cffile action="write" file="#arguments.path#" output="#arguments.content#">
	</cffunction>


	<cffunction name="getHomePortalsConfigBean" access="private" returntype="homePortals.components.homePortalsConfigBean">
		<cfargument name="appRoot" type="string" required="true">
		<cfscript>
			var oConfigBean = createObject("component","homePortals.components.homePortalsConfigBean").init( expandPath(appRoot & variables.homePortalsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="getAppHomePortalsConfigBean" access="private" returntype="homePortals.components.homePortalsConfigBean">
		<cfscript>
			var oContext = getService("sessionContext").getContext();
			var appRoot = oContext.getHomePortals().getConfig().getAppRoot();
			var oConfigBean = createObject("component","homePortals.components.homePortalsConfigBean").init( expandPath(appRoot & variables.homePortalsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>


	<cffunction name="getAccountsConfigBean" access="private" returntype="homePortalsAccounts.components.accountsConfigBean">
		<cfscript>
			var oConfigBean = createObject("component","homePortalsAccounts.components.accountsConfigBean").init( expandPath("/homePortalsAccounts" & variables.accountsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="getModulePropertiesConfigBean" access="private" returntype="homePortalsModules.components.modulePropertiesConfigBean">
		<cfargument name="configPath" type="string" required="false" default="#variables.modulePropertiesConfigPath#">
		<cfscript>
			var oConfigBean = 0;
			if(fileExists(expandPath(arguments.configPath)))
				oConfigBean = createObject("component","homePortalsModules.components.modulePropertiesConfigBean").init( expandPath(arguments.configPath) );
			else
				oConfigBean = createObject("component","homePortalsModules.components.modulePropertiesConfigBean").init( );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="saveModulePropertiesConfigBean" access="private" returntype="void">
		<cfargument name="configPath" type="string" required="false" default="#variables.modulePropertiesConfigPath#">
		<cfargument name="configBean" type="homePortalsModules.components.modulePropertiesConfigBean" required="true">
		<cfset writeFile( expandPath(arguments.configPath), toString( arguments.configBean.toXML() ) )>
	</cffunction>
		
	<cffunction name="parseAppAccountsConfigFile" access="private" returntype="struct">
		<cfargument name="configFile" type="string" required="true">
		<cfscript>
			var xmlDoc = 0;
			var stAppConfig = structNew();
			var i = 0;
			
			// now get current config xml
			xmlDoc = xmlParse(arguments.configFile);

			for(i=1;i lte arrayLen(xmlDoc.xmlRoot.xmlChildren);i=i+1) {
				xmlNode = xmlDoc.xmlRoot.xmlChildren[i];
				stAppConfig[xmlNode.xmlName] = xmlNode.xmlText;
			}
						
			return stAppConfig;
		</cfscript>
	</cffunction>	
	


	<cffunction name="saveAppHomePortalsConfigBean" access="private" returntype="void">
		<cfargument name="configBean" type="homePortals.components.homePortalsConfigBean" required="true">
		<cfargument name="includeGeneralSettings" type="boolean" required="false" default="no">
		<cfscript>
			var oContext = getService("sessionContext").getContext();
			var appRoot = oContext.getHomePortals().getConfig().getAppRoot();
			saveHomePortalsConfigDoc(appRoot, arguments.configBean.toXML(), arguments.includeGeneralSettings);
		</cfscript>
	</cffunction>		

	<cffunction name="saveAppHomePortalsConfigDoc" access="private" returntype="void">
		<cfargument name="xmlDoc" type="XML" required="true">
		<cfargument name="includeGeneralSettings" type="boolean" required="false" default="no">
		<cfscript>
			var oContext = getService("sessionContext").getContext();
			var appRoot = oContext.getHomePortals().getConfig().getAppRoot();
			saveHomePortalsConfigDoc(appRoot, arguments.xmlDoc, arguments.includeGeneralSettings);
		</cfscript>
	</cffunction>		
	
	<cffunction name="saveHomePortalsConfigDoc" access="private" returntype="void">
		<cfargument name="appRoot" type="string" required="true">
		<cfargument name="xmlDoc" type="XML" required="true">
		<cfargument name="includeGeneralSettings" type="boolean" required="false" default="no">
		
		<cfscript>
			var filePath = arguments.appRoot & variables.homePortalsConfigPath;
			var oFormatter = createObject("component","ColdBricks.components.xmlStringFormatter").init();
			
			structDelete(arguments.xmlDoc.xmlRoot.xmlAttributes, "version");
			if(arguments.xmlDoc.xmlRoot.baseResourceTypes.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "baseResourceTypes");
			if(arguments.xmlDoc.xmlRoot.initialEvent.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "initialEvent");
			if(arguments.xmlDoc.xmlRoot.homePortalsPath.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "homePortalsPath");
			if(arguments.xmlDoc.xmlRoot.appRoot.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "appRoot");
			if(arguments.xmlDoc.xmlRoot.bodyOnLoad.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "bodyOnLoad");
			if(arguments.xmlDoc.xmlRoot.pageProviderClass.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "pageProviderClass");
			
			// remove nodes that we are not editing
			if(not arguments.includeGeneralSettings) {
				if(arguments.xmlDoc.xmlRoot.defaultPage.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "defaultPage");
				if(arguments.xmlDoc.xmlRoot.contentRoot.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "contentRoot");
				if(arguments.xmlDoc.xmlRoot.pageCacheSize.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "pageCacheSize");
				if(arguments.xmlDoc.xmlRoot.pageCacheTTL.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "pageCacheTTL");
				if(arguments.xmlDoc.xmlRoot.catalogCacheSize.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "catalogCacheSize");
				if(arguments.xmlDoc.xmlRoot.catalogCacheTTL.xmlText eq "") structDelete(arguments.xmlDoc.xmlRoot, "catalogCacheTTL");
			}
			
			if(arrayLen(arguments.xmlDoc.xmlRoot.baseResources.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "baseResources");
			if(arrayLen(arguments.xmlDoc.xmlRoot.contentRenderers.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "contentRenderers");
			if(arrayLen(arguments.xmlDoc.xmlRoot.plugins.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "plugins");
			if(arrayLen(arguments.xmlDoc.xmlRoot.resourceTypes.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "resourceTypes");
			if(arrayLen(arguments.xmlDoc.xmlRoot.resourceLibraryPaths.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "resourceLibraryPaths");
			if(arrayLen(arguments.xmlDoc.xmlRoot.renderTemplates.xmlChildren) eq 0) structDelete(arguments.xmlDoc.xmlRoot, "renderTemplates");
	
			fileWrite(expandPath(filePath), oFormatter.makePretty(arguments.xmlDoc.xmlRoot), "utf-8");

			// reload site
			reloadSite();
		</cfscript>
	</cffunction>	
		
		
</cfcomponent>