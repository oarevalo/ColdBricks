<cfcomponent extends="eventHandler">

	<cfset variables.homePortalsConfigPath = "/Home/Config/homePortals-config.xml">
	<cfset variables.accountsConfigPath = "/Home/Config/accounts-config.xml.cfm">
	<cfset variables.modulePropertiesConfigPath = "/Home/Config/module-properties.xml">
	
	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var oConfigBean = 0;
			var hp = 0;
			var appRoot = 0;
			var configFile = "";
			var stAppConfig = structNew();
			var oContext = getService("sessionContext").getContext();

			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();

				configFile = expandPath(appRoot & "/Config/homePortals-config.xml");

				// get config bean with mix of base and app settings
				oConfigBean = getHomePortalsConfigBean();
				oConfigBean.load(configFile);

				// get struct with only settings defined for this application
				stAppConfig = parseAppHomePortalsConfigFile(configFile);

				setView("site/siteConfig/vwMain");
				setValue("oHomePortalsConfigBean", oConfigBean );
				setValue("stAppConfig", stAppConfig );

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
				configFile = expandPath(appRoot & "/Config/accounts-config.xml.cfm");

				// get config bean with mix of base and app settings
				oConfigBean = getAccountsConfigBean();
				oConfigBean.load(configFile);

				configFile = expandPath(appRoot & "/Config/accounts-config.xml.cfm");

				// get struct with only settings defined for this application
				stAppConfig = parseAppAccountsConfigFile(configFile);

				setView("site/siteConfig/vwAccounts");
				setValue("oAccountsConfigBean", oConfigBean);
				setValue("stAppConfig", stAppConfig );

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
				oConfigBean = getModulePropertiesConfigBean(appRoot & "/Config/module-properties.xml");

				setView("site/siteConfig/vwModuleProperties");
				setValue("oModulePropertiesConfigBeanBase", oConfigBeanBase );
				setValue("oModulePropertiesConfigBean", oConfigBean );

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
	
	<cffunction name="dspEditXML">
		<cfscript>
			var aConfigFiles = arrayNew(1);
			var configFile = getValue("configFile");
			var hp = 0;
			var appRoot = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();
				if(right(appRoot,1) neq "/") appRoot = appRoot & "/";
				
				arrayAppend(aConfigFiles, "#appRoot#Config/homePortals-config.xml");
				arrayAppend(aConfigFiles, "#appRoot#Config/accounts-config.xml.cfm");
				arrayAppend(aConfigFiles, "#appRoot#Config/module-properties.xml");
			
				if(configFile neq "") {
					xmlDoc = xmlParse(expandPath(configFile));
					setValue("xmlDoc", xmlDoc);
					
					// get help on selected file
					oHelpDAO = getService("DAOFactory").getDAO("help");
					qryHelp = oHelpDAO.search(name = getFileFromPath(configFile));
					setValue("qryHelp", qryHelp);
				}
			
				setValue("aConfigFiles", aConfigFiles);
				setValue("configFile", configFile);
				setView("site/siteConfig/vwEditXML");

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
			setNextEvent("ehSiteConfig.dspMain","configFile=#configFile#");
		</cfscript>
	</cffunction>	
	
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

				oConfigBean = getModulePropertiesConfigBean(appRoot & "/Config/module-properties.xml");
				oConfigBean.setProperty(moduleName, propertyName, propertyValue);
				saveModulePropertiesConfigBean( appRoot & "/Config/module-properties.xml", oConfigBean );

				setMessage("info", "Config file changed. You must reset this sites for all changes to be effective");
				setNextEvent("ehSiteConfig.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSiteConfig.dspModuleProperties","index=0");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSiteConfig.dspModuleProperties");
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

				oConfigBean = getModulePropertiesConfigBean(appRoot & "/Config/module-properties.xml");
				
				// remove old entry
				oConfigBean.removeProperty(oldModuleName, oldPropertyName);
				
				// add new property
				oConfigBean.setProperty(moduleName, propertyName, propertyValue);
				
				// save changes
				saveModulePropertiesConfigBean( appRoot & "/Config/module-properties.xml", oConfigBean );

				setMessage("info", "Config file changed. You must reset this sites for all changes to be effective");
				setNextEvent("ehSiteConfig.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSiteConfig.dspModuleProperties","index=#index#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSiteConfig.dspModuleProperties");
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

				oConfigBean = getModulePropertiesConfigBean(appRoot & "/Config/module-properties.xml");
				
				// remove resource
				oConfigBean.removeProperty(moduleName, propertyName);
				
				// save changes
				saveModulePropertiesConfigBean( appRoot & "/Config/module-properties.xml", oConfigBean );

				setMessage("info", "Config file changed. You must reset this sites for all changes to be effective");
				setNextEvent("ehSiteConfig.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSiteConfig.dspModuleProperties");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSiteConfig.dspModuleProperties");
			}
		</cfscript>	
	</cffunction>	
	
	<cffunction name="doSaveGeneral" access="public" returntype="void">
		<cfscript>
			var appSettings = getValue("appSettings");
			var xmlDoc = xmlNew();
			var i = 0;
			var hp = 0;
			var appRoot = 0;
			var configFile = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();
				configFile = expandPath(appRoot & "/Config/homePortals-config.xml");

				// make sure we have the appRoot defined and that it didnt change
				if(not listfind(appSettings,"appRoot")) appSettings = listAppend(appSettings,"appRoot");
				setValue("appRoot", appRoot);

				// only validate the settings that will be overriden
				if(listFind(appSettings,"defaultAccount") and defaultAccount eq "") throw("The default account is required","validation");
				if(listFind(appSettings,"pageCacheSize") and val(pageCacheSize) eq 0) throw("You must enter a valid number for the page cache maximum size","validation");
				if(listFind(appSettings,"pageCacheTTL") and val(pageCacheTTL) eq 0) throw("You must enter a valid number for the page cache TTL","validation");
				if(listFind(appSettings,"contentCacheSize") and val(contentCacheSize) eq 0) throw("You must enter a valid number for the content cache maximum size","validation");
				if(listFind(appSettings,"contentCacheTTL") and val(contentCacheTTL) eq 0) throw("You must enter a valid number for the content cache TTL","validation");
				if(listFind(appSettings,"accountsRoot") and accountsRoot eq "") throw("The accounts root directory is required","validation");
				if(listFind(appSettings,"resourceLibraryPath") and resourceLibraryPath eq "") throw("The resources library directory is required","validation");
				if(listFind(appSettings,"rt_page") and rt_page eq "") throw("The location of the 'page' render template is required","validation");
				if(listFind(appSettings,"rt_module") and rt_module eq "") throw("The location of the 'module' render template is required","validation");
				if(listFind(appSettings,"rt_moduleNC") and rt_moduleNC eq "") throw("The location of the 'module no container' render template is required","validation");
				
				// get original config
				stAppConfig = parseAppHomePortalsConfigFile(configFile);

				// update selected values
				for(i=1;i lte listLen(appSettings);i=i+1) {
					key = listGetAt(appSettings,i);
					stAppConfig[key] = getValue(key);
				}

				// build xml doc with only the selected settings
				xmlDoc = buildAppHomePortalsConfigXML(stAppConfig);

				// write file
				writeFile(configFile, toString(xmlDoc));
				
				setMessage("info", "Config file changed. You must reset this sites for all changes to be effective");
				setNextEvent("ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSiteConfig.dspMain");
			}
		</cfscript>
	</cffunction>

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
			var storageType = getValue("storageType");
			var storageCFC = getValue("storageCFC");
			var accountsTable = getValue("accountsTable");
			var datasource = getValue("datasource");
			var username = getValue("username");
			var password = getValue("password");
			var dbType = getValue("dbType");
			var storageFileHREF = getValue("storageFileHREF");
			var newAccountTemplate = getValue("newAccountTemplate");
			var newPageTemplate = getValue("newPageTemplate");

			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();
				configFile = expandPath(appRoot & "/Config/accounts-config.xml.cfm");

				if(listFind(appSettings,"accountsRoot") and accountsRoot eq "") throw("The accounts root directory is required","validation");
				if(listFind(appSettings,"storageType") and storageType eq "") throw("The storage type is required","validation");

				if(listFind(appSettings,"newAccountTemplate") and newAccountTemplate eq "") throw("The location of the 'New Account' template is required","validation");
				if(listFind(appSettings,"newPageTemplate") and newPageTemplate eq "") throw("The location of the 'New Page' template is required","validation");

				switch(storageType) {
					case "xml":
						if(listFind(appSettings,"storageFileHREF") and storageFileHREF eq "") throw("For 'XML' storage, the storage file location is required","validation");
						break;

					case "db":
						if(listFind(appSettings,"datasource") and datasource eq "") throw("For 'Database' storage, the datasource is required","validation");
						if(listFind(appSettings,"accountsTable") and accountsTable eq "") throw("For 'Database' storage, the accounts table name is required","validation");
						if(listFind(appSettings,"dbType") and dbType eq "") throw("For 'Database' storage, the database type is required","validation");
						break;

					case "custom":
						if(listFind(appSettings,"storageCFC") and storageCFC eq "") throw("For 'Custom CFC' storage, the path to your custom CFC that wil handle accounts storage is required","validation");
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

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("ehSiteConfig.dspAccounts");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSiteConfig.dspAccounts");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSiteConfig.dspAccounts");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doAddBaseResource" access="public" returntype="void">
		<cfscript>
			var type = getValue("type");
			var href = getValue("href");
			var oConfigBean = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();
				configFile = expandPath(appRoot & "/Config/homePortals-config.xml");

				if(type eq "") throw("The base resource type is required","validation");
				if(href eq "") throw("The base resource value is required","validation");
				
				// get app settings
				stAppConfig = parseAppHomePortalsConfigFile(configFile);

				// make sure we have the appRoot defined and that it didnt change
				stAppConfig.appRoot = appRoot;

				if(not structKeyExists(stAppConfig, "baseResources"))
					stAppConfig.baseResources = structNew();

				if(not structKeyExists(stAppConfig.baseResources, type))
					stAppConfig.baseResources[type] = arrayNew(1);
					
				arrayAppend(stAppConfig.baseResources[type], href);

				// build xml doc with only the selected settings
				xmlDoc = buildAppHomePortalsConfigXML(stAppConfig);

				// write file
				writeFile(configFile, toString(xmlDoc));

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSiteConfig.dspMain","baseResourceEditIndex=0");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSiteConfig.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doSaveBaseResource" access="public" returntype="void">
		<cfscript>
			var type = getValue("type");
			var href = getValue("href");
			var type_old = getValue("type_old");
			var href_old = getValue("href_old");
			var oConfigBean = 0;
			var aRes = arrayNew(1);
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();
				configFile = expandPath(appRoot & "/Config/homePortals-config.xml");

				if(type eq "") throw("The base resource type is required","validation");
				if(href eq "") throw("The base resource value is required","validation");

				// get app settings
				stAppConfig = parseAppHomePortalsConfigFile(configFile);

				// make sure we have the appRoot defined and that it didnt change
				stAppConfig.appRoot = appRoot;

				// remove resource
				if(structKeyExists(stAppConfig, "baseResources")
					and structKeyExists(stAppConfig.baseResources, type_old)) {
					for(i=1;i lte arrayLen(stAppConfig.baseResources[type_old]);i=i+1) {
						if(stAppConfig.baseResources[type_old][i] eq href_old) {
							arrayDeleteAt(stAppConfig.baseResources[type_old], i);
						}
					}	
				}

				if(not structKeyExists(stAppConfig.baseResources, type))
					stAppConfig.baseResources[type] = arrayNew(1);

				arrayAppend(stAppConfig.baseResources[type], href);

				// build xml doc with only the selected settings
				xmlDoc = buildAppHomePortalsConfigXML(stAppConfig);

				// write file
				writeFile(configFile, toString(xmlDoc));

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSiteConfig.dspMain","baseResourceEditIndex=#index#&baseResourceEditType=#type#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSiteConfig.dspMain");
			}
		</cfscript>		
	</cffunction>	

	<cffunction name="doDeleteBaseResource" access="public" returntype="void">
		<cfscript>
			var type = getValue("type");
			var href = getValue("href");
			var oConfigBean = 0;
			var aRes = arrayNew(1);
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				appRoot = hp.getConfig().getAppRoot();
				configFile = expandPath(appRoot & "/Config/homePortals-config.xml");

				if(type eq "") throw("The base resource type is required","validation");

				// get app settings
				stAppConfig = parseAppHomePortalsConfigFile(configFile);

				// make sure we have the appRoot defined and that it didnt change
				stAppConfig.appRoot = appRoot;

				// remove resource
				if(structKeyExists(stAppConfig, "baseResources")
					and structKeyExists(stAppConfig.baseResources, type)) {
					for(i=1;i lte arrayLen(stAppConfig.baseResources[type]);i=i+1) {
						if(stAppConfig.baseResources[type][i] eq href) {
							arrayDeleteAt(stAppConfig.baseResources[type], i);
						}
					}	
				}

				// build xml doc with only the selected settings
				xmlDoc = buildAppHomePortalsConfigXML(stAppConfig);

				// write file
				writeFile(configFile, toString(xmlDoc));

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("ehSiteConfig.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSiteConfig.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSiteConfig.dspMain");
			}
		</cfscript>	
	</cffunction>	
	
	
	<cffunction name="writeFile" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cfargument name="content" type="string" required="true">
		<cffile action="write" file="#arguments.path#" output="#arguments.content#">
	</cffunction>

	<cffunction name="getHomePortalsConfigBean" access="private" returntype="Home.Components.homePortalsConfigBean">
		<cfscript>
			var oConfigBean = createObject("component","Home.Components.homePortalsConfigBean").init( expandPath(variables.homePortalsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="getAccountsConfigBean" access="private" returntype="Home.Components.accountsConfigBean">
		<cfscript>
			var oConfigBean = createObject("component","Home.Components.accountsConfigBean").init( expandPath(variables.accountsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="getModulePropertiesConfigBean" access="private" returntype="Home.Components.modulePropertiesConfigBean">
		<cfargument name="configPath" type="string" required="false" default="#variables.modulePropertiesConfigPath#">
		<cfscript>
			var oConfigBean = createObject("component","Home.Components.modulePropertiesConfigBean").init( expandPath(arguments.configPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="saveModulePropertiesConfigBean" access="private" returntype="void">
		<cfargument name="configPath" type="string" required="false" default="#variables.modulePropertiesConfigPath#">
		<cfargument name="configBean" type="Home.Components.modulePropertiesConfigBean" required="true">
		<cfset writeFile( expandPath(arguments.configPath), toString( arguments.configBean.toXML() ) )>
	</cffunction>
		
	<cffunction name="parseAppHomePortalsConfigFile" access="private" returntype="struct">
		<cfargument name="configFile" type="string" required="true">
		<cfscript>
			var xmlDoc = 0;
			var aNode = 0;
			var aNodes = 0;
			var i = 0;
			var stAppConfig = structNew();
			
			// now get current config xml
			xmlDoc = xmlParse(arguments.configFile);
			
			if(structKeyExists(xmlDoc.xmlRoot,"defaultAccount")) stAppConfig.defaultAccount = xmlDoc.xmlRoot.defaultAccount.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"pageCacheSize")) stAppConfig.pageCacheSize = xmlDoc.xmlRoot.pageCacheSize.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"pageCacheTTL")) stAppConfig.pageCacheTTL = xmlDoc.xmlRoot.pageCacheTTL.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"contentCacheSize")) stAppConfig.contentCacheSize = xmlDoc.xmlRoot.contentCacheSize.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"contentCacheTTL")) stAppConfig.contentCacheTTL = xmlDoc.xmlRoot.contentCacheTTL.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"resourceLibraryPath")) stAppConfig.resourceLibraryPath = xmlDoc.xmlRoot.resourceLibraryPath.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"accountsRoot")) stAppConfig.accountsRoot = xmlDoc.xmlRoot.accountsRoot.xmlText;

			aNode = xmlSearch(xmlDoc,"//renderTemplates/renderTemplate[@type='page']");
			if(arrayLen(aNode) gt 0) stAppConfig.rt_page = aNode[1].xmlAttributes.href;

			aNode = xmlSearch(xmlDoc,"//renderTemplates/renderTemplate[@type='module']");
			if(arrayLen(aNode) gt 0) stAppConfig.rt_module = aNode[1].xmlAttributes.href;

			aNode = xmlSearch(xmlDoc,"//renderTemplates/renderTemplate[@type='moduleNoContainer']");
			if(arrayLen(aNode) gt 0) stAppConfig.rt_moduleNC = aNode[1].xmlAttributes.href;
			
			if(structKeyExists(xmlDoc.xmlRoot,"baseResources")) {
				aNodes = xmlDoc.xmlRoot.baseResources.xmlChildren;
				if(arrayLen(aNodes) gt 0) stAppConfig.baseResources = structNew();
				for(i=1;i lte arrayLen(aNodes);i=i+1) {
					aNode = xmlDoc.xmlRoot.baseResources.xmlChildren[i];
					if(aNode.xmlName eq "resource") {
						if(not structKeyExists(stAppConfig.baseResources, aNode.xmlAttributes.type))
							stAppConfig.baseResources[aNode.xmlAttributes.type] = arrayNew(1);
						arrayAppend(stAppConfig.baseResources[aNode.xmlAttributes.type], aNode.xmlAttributes.href);	
					}
				}
			}
			
			return stAppConfig;
		</cfscript>
	</cffunction>	

	<cffunction name="parseAppAccountsConfigFile" access="private" returntype="struct">
		<cfargument name="configFile" type="string" required="true">
		<cfscript>
			var xmlDoc = 0;
			var stAppConfig = structNew();
			
			// now get current config xml
			xmlDoc = xmlParse(arguments.configFile);
			
			if(structKeyExists(xmlDoc.xmlRoot,"accountsRoot")) stAppConfig["accountsRoot"] = xmlDoc.xmlRoot.accountsRoot.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"storageType")) stAppConfig["storageType"] = xmlDoc.xmlRoot.storageType.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"storageFileHREF")) stAppConfig["storageFileHREF"] = xmlDoc.xmlRoot.storageFileHREF.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"datasource")) stAppConfig["datasource"] = xmlDoc.xmlRoot.datasource.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"username")) stAppConfig["username"] = xmlDoc.xmlRoot.username.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"password")) stAppConfig["password"] = xmlDoc.xmlRoot.password.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"dbType")) stAppConfig["dbType"] = xmlDoc.xmlRoot.dbType.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"storageCFC")) stAppConfig["storageCFC"] = xmlDoc.xmlRoot.storageCFC.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"newAccountTemplate")) stAppConfig["newAccountTemplate"] = xmlDoc.xmlRoot.newAccountTemplate.xmlText;
			if(structKeyExists(xmlDoc.xmlRoot,"newPageTemplate")) stAppConfig["newPageTemplate"] = xmlDoc.xmlRoot.newPageTemplate.xmlText;
			
			return stAppConfig;
		</cfscript>
	</cffunction>	
	
	<cffunction name="buildAppHomePortalsConfigXML" access="private" returntype="xml">
		<cfargument name="stAppConfig" type="struct" required="true">
		<cfscript>
			var xmlDoc = xmlNew();
			var key = "";
			var xmlNode = 0;
			var i = 0;
			var keyName = "";
					
			// create root element
			xmlDoc.xmlRoot = xmlElemNew(xmlDoc,"homePortals");

			// build xml doc with only the selected settings
			for(key in arguments.stAppConfig) {
		
				switch(key) {
					
					case "rt_page":
					case "rt_module":
					case "rt_moduleNC":
						if(not structKeyExists(xmlDoc.xmlRoot,"renderTemplates")) {
							xmlNode = xmlElemNew(xmlDoc,"renderTemplates");
							arrayAppend(xmlDoc.xmlRoot.xmlChildren, xmlNode);
						}
						
						xmlNode = xmlElemNew(xmlDoc,"renderTemplate");
						xmlNode.xmlAttributes["type"] = listLast(key,"_");
						xmlNode.xmlAttributes["href"] = arguments.stAppConfig[key];
						arrayAppend(xmlDoc.xmlRoot.renderTemplates.xmlChildren, xmlNode);
						break;
					
					case "baseResources":					
						xmlNode = xmlElemNew(xmlDoc,"baseResources");
						arrayAppend(xmlDoc.xmlRoot.xmlChildren, xmlNode);
		
						for(key in arguments.stAppConfig.baseResources) {
							if(isArray(arguments.stAppConfig.baseResources[key])) {
								for(i=1;i lte arrayLen(stAppConfig.baseResources[key]);i=i+1) {
									xmlNode = xmlElemNew(xmlDoc,"resource");
									xmlNode.xmlAttributes["type"] = key;
									xmlNode.xmlAttributes["href"] = arguments.stAppConfig.baseResources[key][i];
									arrayAppend(xmlDoc.xmlRoot.baseResources.xmlChildren, xmlNode);
								}
							}
						}
						break;

					default:
						switch(key) {
							case "appRoot":			keyName = "appRoot"; break;
							case "resourceLibraryPath":	keyName = "resourceLibraryPath"; break;
							case "accountsRoot":	keyName = "accountsRoot"; break;
							case "defaultAccount":	keyName = "defaultAccount"; break;
							case "pageCacheSize":	keyName = "pageCacheSize"; break;
							case "pageCacheTTL":	keyName = "pageCacheTTL"; break;
							case "contentCacheSize":	keyName = "contentCacheSize"; break;
							case "contentCacheTTL":	keyName = "contentCacheTTL"; break;
						}
						xmlNode = xmlElemNew(xmlDoc, keyName);
						xmlNode.xmlText = arguments.stAppConfig[key];
						arrayAppend(xmlDoc.xmlRoot.xmlChildren, xmlNode);
						break;
				}
			}
			return xmlDoc;
		</cfscript>
	</cffunction>
		
</cfcomponent>