<cfcomponent extends="eventHandler">
	
	<cfset variables.homePortalsConfigPath = "/Home/Config/homePortals-config.xml">
	<cfset variables.accountsConfigPath = "/Home/Config/accounts-config.xml.cfm">
	<cfset variables.modulePropertiesConfigPath = "/Home/Config/module-properties.xml">
	
	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			try {
				setView("settings/vwMain");
				setValue("oHomePortalsConfigBean", getHomePortalsConfigBean() );
				
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
				setView("settings/vwAccounts");
				setValue("oAccountsConfigBean", getAccountsConfigBean() );
				
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
				setView("settings/vwModuleProperties");
				setValue("oModulePropertiesConfigBean", getModulePropertiesConfigBean() );
				
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
			
			try {
				arrayAppend(aConfigFiles, "/Home/Config/homePortals-config.xml");
				arrayAppend(aConfigFiles, "/Home/Config/accounts-config.xml.cfm");
				arrayAppend(aConfigFiles, "/Home/Config/module-properties.xml");
				arrayAppend(aConfigFiles, "/Home/Common/Templates/Render/module.xml");
				arrayAppend(aConfigFiles, "/Home/Common/Templates/Render/moduleNoContainer.xml");
				arrayAppend(aConfigFiles, "/Home/Common/Templates/Render/page.xml");
				arrayAppend(aConfigFiles, "/Home/Common/AccountTemplates/default.xml");
				arrayAppend(aConfigFiles, "/Home/Common/AccountTemplates/newPage.xml");
				arrayAppend(aConfigFiles, "/Home/Common/AccountTemplates/site.xml");
			
				if(configFile neq "") {
					xmlDoc = xmlParse(expandPath(configFile));
					setValue("xmlDoc", xmlDoc);

					// get help on selected file
					oDataProvider = application.oDataProvider;
					oHelpDAO = createObject("component","ColdBricks.components.model.helpDAO").init(oDataProvider);
					qryHelp = oHelpDAO.search(name = getFileFromPath(configFile));
					setValue("qryHelp", qryHelp);
				}
			
				setValue("aConfigFiles", aConfigFiles);
				setValue("configFile", configFile);
				setView("settings/vwEditXML");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");			
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

				writeFile( expandPath( configFile ), xmlContent);
				
				// go to the xml editor
				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
			setNextEvent("ehSettings.dspEditXML","configFile=#configFile#");
		</cfscript>
	</cffunction>	
		
	<cffunction name="doSaveGeneral" access="public" returntype="void">
		<cfscript>
			var defaultAccount = getValue("defaultAccount");
			var pageCacheSize = getValue("pageCacheSize");
			var pageCacheTTL = getValue("pageCacheTTL");
			var contentCacheSize = getValue("contentCacheSize");
			var contentCacheTTL = getValue("contentCacheTTL");
			var accountsRoot = getValue("accountsRoot");
			var resourceLibraryPath = getValue("resourceLibraryPath");
			var rt_page = getValue("rt_page");
			var rt_module = getValue("rt_module");
			var rt_moduleNC = getValue("rt_moduleNC");

			try {
				if(defaultAccount eq "") throw("The default account is required","validation");
				if(val(pageCacheSize) eq 0) throw("You must enter a valid number for the page cache maximum size","validation");
				if(val(pageCacheTTL) eq 0) throw("You must enter a valid number for the page cache TTL","validation");
				if(val(contentCacheSize) eq 0) throw("You must enter a valid number for the content cache maximum size","validation");
				if(val(contentCacheTTL) eq 0) throw("You must enter a valid number for the content cache TTL","validation");
				if(accountsRoot eq "") throw("The accounts root directory is required","validation");
				if(resourceLibraryPath eq "") throw("The resources library directory is required","validation");
				if(rt_page eq "") throw("The location of the 'page' render template is required","validation");
				if(rt_module eq "") throw("The location of the 'module' render template is required","validation");
				if(rt_moduleNC eq "") throw("The location of the 'module no container' render template is required","validation");
				
				// set new values
				oConfigBean = getHomePortalsConfigBean();
				oConfigBean.setDefaultAccount(defaultAccount);
				oConfigBean.setPageCacheSize(pageCacheSize);
				oConfigBean.setPageCacheTTL(pageCacheTTL);
				oConfigBean.setContentCacheSize(contentCacheSize);
				oConfigBean.setContentCacheTTL(contentCacheTTL);
				oConfigBean.setAccountsRoot(accountsRoot);
				oConfigBean.setResourceLibraryPath(resourceLibraryPath);
			
				oConfigBean.setRenderTemplate("page", rt_page);
				oConfigBean.setRenderTemplate("module", rt_module);
				oConfigBean.setRenderTemplate("moduleNoContainer", rt_moduleNC);
			
				// save changes
				saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSettings.dspMain");
			}

		</cfscript>
	</cffunction>	
		
	<cffunction name="doAddBaseResource" access="public" returntype="void">
		<cfscript>
			var type = getValue("type");
			var href = getValue("href");
			var oConfigBean = 0;
			
			try {
				if(type eq "") throw("The base resource type is required","validation");
				if(href eq "") throw("The base resource value is required","validation");

				oConfigBean = getHomePortalsConfigBean();
				oConfigBean.addBaseResource(type, href);
				saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSettings.dspMain","baseResourceEditIndex=0");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSettings.dspMain");
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

				oConfigBean = getHomePortalsConfigBean();
				
				// remove resource
				aRes = oConfigBean.getBaseResourcesByType(type);
				if(index lte arrayLen(aRes))
					oConfigBean.removeBaseResource(type, aRes[index]);
				
				// add new values for resource
				oConfigBean.addBaseResource(type, href);
				
				// save changes
				saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSettings.dspMain","baseResourceEditIndex=#index#&baseResourceEditType=#type#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSettings.dspMain");
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

				oConfigBean = getHomePortalsConfigBean();
				
				// remove resource
				aRes = oConfigBean.getBaseResourcesByType(type);
				if(index lte arrayLen(aRes))
					oConfigBean.removeBaseResource(type, aRes[index]);
				
				// save changes
				saveHomePortalsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("ehSettings.dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSettings.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSettings.dspMain");
			}
		</cfscript>	
	</cffunction>	

	<cffunction name="doSaveAccounts" access="public" returntype="void">
		<cfscript>
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
			var siteTemplate = getValue("siteTemplate");

			try {
				if(accountsRoot eq "") throw("The accounts root directory is required","validation");
				if(storageType eq "") throw("The storage type is required","validation");

				if(newAccountTemplate eq "") throw("The location of the 'New Account' template is required","validation");
				if(newPageTemplate eq "") throw("The location of the 'New Page' template is required","validation");
				if(siteTemplate eq "") throw("The location of the 'New Site' template is required","validation");

				switch(storageType) {
					case "xml":
						if(storageFileHREF eq "") throw("For 'XML' storage, the storage file location is required","validation");
						break;

					case "db":
						if(datasource eq "") throw("For 'Database' storage, the datasource is required","validation");
						if(accountsTable eq "") throw("For 'Database' storage, the accounts table name is required","validation");
						if(dbType eq "") throw("For 'Database' storage, the database type is required","validation");
						break;

					case "custom":
						if(storageCFC eq "") throw("For 'Custom CFC' storage, the path to your custom CFC that wil handle accounts storage is required","validation");
						break;
						
					default:
						throw("You have selected an invalid storage type.","validation");
				} 

				// set new values
				oConfigBean = getAccountsConfigBean();
				oConfigBean.setAccountsRoot(accountsRoot);
				oConfigBean.setStorageType(storageType);
				oConfigBean.setStorageCFC(storageCFC);
				oConfigBean.setAccountsTable(accountsTable);
				oConfigBean.setDatasource(datasource);
				oConfigBean.setUsername(username);
				oConfigBean.setPassword(password);
				oConfigBean.setDBType(dbType);
				oConfigBean.setStorageFileHREF(storageFileHREF);
				oConfigBean.setNewAccountTemplate(newAccountTemplate);
				oConfigBean.setNewPageTemplate(newPageTemplate);
				oConfigBean.setSiteTemplate(siteTemplate);
			
				// save changes
				saveAccountsConfigBean( oConfigBean );

				setMessage("info", "Config file changed. You must reset all sites for all changes to be effective");
				setNextEvent("ehSettings.dspAccounts");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSettings.dspAccounts");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSettings.dspAccounts");
			}
		</cfscript>
	</cffunction>

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
				setNextEvent("ehSettings.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSettings.dspModuleProperties","index=0");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSettings.dspModuleProperties");
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
				setNextEvent("ehSettings.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSettings.dspModuleProperties","index=#index#");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSettings.dspModuleProperties");
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
				setNextEvent("ehSettings.dspModuleProperties");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSettings.dspModuleProperties");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSettings.dspModuleProperties");
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

	<cffunction name="saveHomePortalsConfigBean" access="private" returntype="void">
		<cfargument name="configBean" type="Home.Components.homePortalsConfigBean" required="true">
		<cfset writeFile( expandPath(variables.homePortalsConfigPath), toString( arguments.configBean.toXML() ) )>
	</cffunction>

	<cffunction name="getAccountsConfigBean" access="private" returntype="Home.Components.accountsConfigBean">
		<cfscript>
			var oConfigBean = createObject("component","Home.Components.accountsConfigBean").init( expandPath(variables.accountsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="saveAccountsConfigBean" access="private" returntype="void">
		<cfargument name="configBean" type="Home.Components.accountsConfigBean" required="true">
		<cfset writeFile( expandPath(variables.accountsConfigPath), toString( arguments.configBean.toXML() ) )>
	</cffunction>

	<cffunction name="getModulePropertiesConfigBean" access="private" returntype="Home.Components.modulePropertiesConfigBean">
		<cfscript>
			var oConfigBean = createObject("component","Home.Components.modulePropertiesConfigBean").init( expandPath(variables.modulePropertiesConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="saveModulePropertiesConfigBean" access="private" returntype="void">
		<cfargument name="configBean" type="Home.Components.modulePropertiesConfigBean" required="true">
		<cfset writeFile( expandPath(variables.modulePropertiesConfigPath), toString( arguments.configBean.toXML() ) )>
	</cffunction>
				
</cfcomponent>