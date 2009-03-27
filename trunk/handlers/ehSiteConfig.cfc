<cfcomponent extends="ehColdBricks">

	<cfset variables.homePortalsConfigPath = "/homePortals/config/homePortals-config.xml">
	<cfset variables.accountsConfigPath = "/homePortals/config/accounts-config.xml.cfm">
	<cfset variables.modulePropertiesConfigPath = "/homePortals/config/module-properties.xml">
	
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

				configFile = expandPath(appRoot & "/config/homePortals-config.xml");

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
				configFile = expandPath(appRoot & "/config/accounts-config.xml.cfm");

				// get config bean with mix of base and app settings
				oConfigBean = getAccountsConfigBean();
				oConfigBean.load(configFile);

				configFile = expandPath(appRoot & "/config/accounts-config.xml.cfm");

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
				oConfigBean = getModulePropertiesConfigBean(appRoot & "/config/module-properties.xml");

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
				
				arrayAppend(aConfigFiles, "#appRoot#config/homePortals-config.xml");
				arrayAppend(aConfigFiles, "#appRoot#config/accounts-config.xml.cfm");
				arrayAppend(aConfigFiles, "#appRoot#config/module-properties.xml");
			
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

				oConfigBean = getModulePropertiesConfigBean(appRoot & "/config/module-properties.xml");
				oConfigBean.setProperty(moduleName, propertyName, propertyValue);
				saveModulePropertiesConfigBean( appRoot & "/config/module-properties.xml", oConfigBean );

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

				oConfigBean = getModulePropertiesConfigBean(appRoot & "/config/module-properties.xml");
				
				// remove old entry
				oConfigBean.removeProperty(oldModuleName, oldPropertyName);
				
				// add new property
				oConfigBean.setProperty(moduleName, propertyName, propertyValue);
				
				// save changes
				saveModulePropertiesConfigBean( appRoot & "/config/module-properties.xml", oConfigBean );

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

				oConfigBean = getModulePropertiesConfigBean(appRoot & "/config/module-properties.xml");
				
				// remove resource
				oConfigBean.removeProperty(moduleName, propertyName);
				
				// save changes
				saveModulePropertiesConfigBean( appRoot & "/config/module-properties.xml", oConfigBean );

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
				configFile = expandPath(appRoot & "/config/homePortals-config.xml");

				// make sure we have the appRoot defined and that it didnt change
				if(not listfind(appSettings,"appRoot")) appSettings = listAppend(appSettings,"appRoot");
				setValue("appRoot", appRoot);

				// only validate the settings that will be overriden
				if(listFind(appSettings,"defaultPage") and defaultPage eq "") throw("The default page is required","validation");
				if(listFind(appSettings,"pageCacheSize") and val(pageCacheSize) eq 0) throw("You must enter a valid number for the page cache maximum size","validation");
				if(listFind(appSettings,"pageCacheTTL") and val(pageCacheTTL) eq 0) throw("You must enter a valid number for the page cache TTL","validation");
				if(listFind(appSettings,"contentCacheSize") and val(contentCacheSize) eq 0) throw("You must enter a valid number for the content cache maximum size","validation");
				if(listFind(appSettings,"contentCacheTTL") and val(contentCacheTTL) eq 0) throw("You must enter a valid number for the content cache TTL","validation");
				if(listFind(appSettings,"rssCacheSize") and val(rssCacheSize) eq 0) throw("You must enter a valid number for the content RSS maximum size","validation");
				if(listFind(appSettings,"rssCacheTTL") and val(rssCacheTTL) eq 0) throw("You must enter a valid number for the content RSS TTL","validation");
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
				configFile = expandPath(appRoot & "/config/homePortals-config.xml");

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
				configFile = expandPath(appRoot & "/config/homePortals-config.xml");

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
				configFile = expandPath(appRoot & "/config/homePortals-config.xml");

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

	<cffunction name="getHomePortalsConfigBean" access="private" returntype="homePortals.components.homePortalsConfigBean">
		<cfscript>
			var oConfigBean = createObject("component","homePortals.components.homePortalsConfigBean").init( expandPath(variables.homePortalsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="getAccountsConfigBean" access="private" returntype="homePortals.components.accounts.accountsConfigBean">
		<cfscript>
			var oConfigBean = createObject("component","homePortals.components.accounts.accountsConfigBean").init( expandPath(variables.accountsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="getModulePropertiesConfigBean" access="private" returntype="homePortals.components.modulePropertiesConfigBean">
		<cfargument name="configPath" type="string" required="false" default="#variables.modulePropertiesConfigPath#">
		<cfscript>
			var oConfigBean = 0;
			if(fileExists(expandPath(arguments.configPath)))
				oConfigBean = createObject("component","homePortals.components.modulePropertiesConfigBean").init( expandPath(arguments.configPath) );
			else
				oConfigBean = createObject("component","homePortals.components.modulePropertiesConfigBean").init( );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="saveModulePropertiesConfigBean" access="private" returntype="void">
		<cfargument name="configPath" type="string" required="false" default="#variables.modulePropertiesConfigPath#">
		<cfargument name="configBean" type="homePortals.components.modulePropertiesConfigBean" required="true">
		<cfset writeFile( expandPath(arguments.configPath), toString( arguments.configBean.toXML() ) )>
	</cffunction>
		
	<cffunction name="parseAppHomePortalsConfigFile" access="private" returntype="struct">
		<cfargument name="configFile" type="string" required="true">
		<cfscript>
			var xmlDoc = 0;
			var aNode = 0;
			var aNodes = 0;
			var i = 0;
			var j = 0;
			var xmlNode = 0;
			var stAppConfig = structNew();
			
			// now get current config xml
			xmlDoc = xmlParse(arguments.configFile);

			for(j=1;j lte arrayLen(xmlDoc.xmlRoot.xmlChildren);j=j+1) {
				xmlNode = xmlDoc.xmlRoot.xmlChildren[j];
				switch(xmlNode.xmlName) {
					
					case "renderTemplates":
						aNode = xmlSearch(xmlDoc,"//renderTemplates/renderTemplate[@type='page']");
						if(arrayLen(aNode) gt 0) stAppConfig.rt_page = aNode[1].xmlAttributes.href;
			
						aNode = xmlSearch(xmlDoc,"//renderTemplates/renderTemplate[@type='module']");
						if(arrayLen(aNode) gt 0) stAppConfig.rt_module = aNode[1].xmlAttributes.href;
			
						aNode = xmlSearch(xmlDoc,"//renderTemplates/renderTemplate[@type='moduleNoContainer']");
						if(arrayLen(aNode) gt 0) stAppConfig.rt_moduleNC = aNode[1].xmlAttributes.href;
						break;
						
					case "baseResources":
						aNodes = xmlNode.xmlChildren;
						if(arrayLen(aNodes) gt 0) stAppConfig.baseResources = structNew();
						for(i=1;i lte arrayLen(aNodes);i=i+1) {
							aNode = aNodes[i];
							if(aNode.xmlName eq "resource") {
								if(not structKeyExists(stAppConfig.baseResources, aNode.xmlAttributes.type))
									stAppConfig.baseResources[aNode.xmlAttributes.type] = arrayNew(1);
								arrayAppend(stAppConfig.baseResources[aNode.xmlAttributes.type], aNode.xmlAttributes.href);	
							}
						}
						break;			
									
					case "contentRenderers":
						aNodes = xmlDoc.xmlRoot.contentRenderers.xmlChildren;
						if(arrayLen(aNodes) gt 0) stAppConfig.contentRenderers = structNew();
						for(i=1;i lte arrayLen(aNodes);i=i+1) {
							aNode = xmlDoc.xmlRoot.contentRenderers.xmlChildren[i];
							if(aNode.xmlName eq "contentRenderer") {
								if(not structKeyExists(stAppConfig.contentRenderers, aNode.xmlAttributes.moduleType))
									stAppConfig.contentRenderers[aNode.xmlAttributes.moduleType] = arrayNew(1);
								arrayAppend(stAppConfig.contentRenderers[aNode.xmlAttributes.moduleType], aNode.xmlAttributes.path);	
							}
						}
						break;			
										
					default:
						stAppConfig[xmlNode.xmlName] = xmlNode.xmlText;
				
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

					case "contentRenderers":					
						xmlNode = xmlElemNew(xmlDoc,"contentRenderers");
						arrayAppend(xmlDoc.xmlRoot.xmlChildren, xmlNode);
		
						for(key in arguments.stAppConfig.contentRenderers) {
							if(isArray(arguments.stAppConfig.contentRenderers[key])) {
								for(i=1;i lte arrayLen(stAppConfig.contentRenderers[key]);i=i+1) {
									xmlNode = xmlElemNew(xmlDoc,"contentRenderer");
									xmlNode.xmlAttributes["moduleType"] = key;
									xmlNode.xmlAttributes["path"] = arguments.stAppConfig.contentRenderers[key][i];
									arrayAppend(xmlDoc.xmlRoot.contentRenderers.xmlChildren, xmlNode);
								}
							}
						}
						break;
						
					default:
						// we need this switch statement to maintain the correct case when writing back to the XML
						switch(key) {
							case "homePortalsPath":			keyName = "homePortalsPath"; break;
							case "resourceLibraryPath":		keyName = "resourceLibraryPath"; break;
							case "appRoot":					keyName = "appRoot"; break;
							case "contentRoot":				keyName = "contentRoot"; break;
							case "defaultPage":				keyName = "defaultPage"; break;
							case "initialEvent":			keyName = "initialEvent"; break;
							case "layoutSections":			keyName = "layoutSections"; break;
							case "pageCacheSize":			keyName = "pageCacheSize"; break;
							case "pageCacheTTL":			keyName = "pageCacheTTL"; break;
							case "contentCacheSize":		keyName = "contentCacheSize"; break;
							case "contentCacheTTL":			keyName = "contentCacheTTL"; break;
							case "rssCacheSize":			keyName = "rssCacheSize"; break;
							case "rssCacheTTL":				keyName = "rssCacheTTL"; break;
							case "pageProviderClass":		keyName = "pageProviderClass"; break;
							case "baseResourceTypes":		keyName = "baseResourceTypes"; break;
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