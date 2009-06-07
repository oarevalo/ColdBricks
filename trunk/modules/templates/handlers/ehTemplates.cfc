<cfcomponent extends="ColdBricks.handlers.ehColdBricks">
	
	<cfset variables.homePortalsConfigPath = "/homePortals/config/homePortals-config.xml">
	<cfset variables.view.main = "vwMain">
	<cfset variables.view.template = "vwTemplate">
	<cfset variables.eventHandler = "templates.ehTemplates">

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var oConfig = getHomePortalsConfigBean();
			
			stTemplates = oConfig.getRenderTemplates("page");
			
			if(structKeyExists(stTemplates,"page")) setValue("stPageTemplates", stTemplates.page);
			if(structKeyExists(stTemplates,"module")) setValue("stModuleTemplates", stTemplates.module);
			
			setupMainView();
			
			setView(variables.view.main);
		</cfscript>
	</cffunction>

	<cffunction name="dspTemplate" access="public" returntype="void">
		<cfscript>
			var templateName = getValue("templateName");
			var templateType = getValue("templateType");
			var templateView = getValue("templateView");
			var templateSource = "";
			var oConfig = getHomePortalsConfigBean();
			
			try {
				setLayout("Layout.None");

				if(templateType neq "" and templateName neq "" and templateName neq "__NEW__") {
					st = oConfig.getRenderTemplate(templateName, templateType);
					setValue("templateStruct",st);
					if(fileExists(expandPath(st.href)))
						templateSource = fileRead(expandPath(st.href));
				}

				setValue("templateName",templateName);
				setValue("templateType",templateType);
				setValue("templateView",templateView);
				setValue("templateSource",templateSource);
				setValue("defaultHREF",getDefaultTemplatePath());
				setView(variables.view.template);
							
			} catch(coldbricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}				
		</cfscript>
	</cffunction>

	<cffunction name="doSaveTemplate" access="public" returntype="void">
		<cfscript>
			var href = getValue("templateHREF");
			var name = getValue("templateName");
			var type = getValue("templateType");
			var body = getValue("body");
			var isDefault = getValue("isDefault",false);
			var description = getValue("description");
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("The render template name is required","validation");
				if(href eq "") throw("The render template path is required","validation");
				if(type eq "") throw("The render template type is required","validation");

				// save file
				if(not directoryExists(getDirectoryFromPath(expandPath(href))))
					createDir(getDirectoryFromPath(expandPath(href)));
				fileWrite(expandPath(href), body, "utf-8");
				
				// save config
				oConfigBean = getHomePortalsConfigBean();
				oConfigBean.setRenderTemplate(name, type, href, description, isDefault);
				saveHomePortalsConfigBean( oConfigBean );

				// reload site
				reloadSite();

				setMessage("info", "Render Template saved.");
				setNextEvent(variables.eventHandler & ".dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent(variables.eventHandler & ".dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent(variables.eventHandler & ".dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doDeleteTemplate" access="public" returntype="void">
		<cfscript>
			var name = getValue("templateName");
			var type = getValue("templateType");
			var st = structNew();
			var oConfigBean = 0;
			
			try {
				if(name eq "") throw("You must select a render template to delete","validation");

				oConfigBean = getHomePortalsConfigBean();
				
				try {
					st = oConfigBean.getRenderTemplate(name,type);
					if(fileExists(expandPath(st.href))) {
						fileDelete(expandPath(st.href));
					}
				} catch(any e) {
					// ignore if cant be found
				}
				
				// remove render template
				oConfigBean.removeRenderTemplate(name, type);
				
				// save changes
				saveHomePortalsConfigBean( oConfigBean );

				// reload site
				reloadSite();

				setMessage("info", "Render Template deleted.");
				setNextEvent(variables.eventHandler & ".dspMain");
			
			} catch(validation e) {
				setMessage("warning",e.message);
				setNextEvent(variables.eventHandler & ".dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent(variables.eventHandler & ".dspMain");
			}
		</cfscript>	
	</cffunction>

	<cffunction name="getHomePortalsConfigBean" access="private" returntype="homePortals.components.homePortalsConfigBean">
		<cfscript>
			var oConfigBean = createObject("component","homePortals.components.homePortalsConfigBean").init( expandPath(variables.homePortalsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>

	<cffunction name="saveHomePortalsConfigBean" access="private" returntype="void">
		<cfargument name="configBean" type="homePortals.components.homePortalsConfigBean" required="true">
		<cfset var oFormatter = createObject("component","ColdBricks.components.xmlStringFormatter").init()>
		<cfset fileWrite( expandPath(variables.homePortalsConfigPath), oFormatter.makePretty( arguments.configBean.toXML().xmlRoot ), "utf-8" )>
	</cffunction>

	<cffunction name="setupMainView" access="private" returntype="void">
		<cfscript>
			setValue("currentEventHander", variables.eventHandler);
			setValue("cbPageTitle", "Templates");
			setValue("cbPageIcon", "images/templates_48x48.png");
		</cfscript>
	</cffunction>

	<cffunction name="createDir" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cfdirectory action="create" directory="#arguments.path#">
	</cffunction>
	
	<cffunction name="getDefaultTemplatePath" access="private" returntype="string">
		<cfreturn "/homePortals/templates/">
	</cffunction>
	
</cfcomponent>