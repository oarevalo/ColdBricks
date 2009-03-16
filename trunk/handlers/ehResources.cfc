<cfcomponent extends="eventHandler">

	<cffunction name="dspMain">
		<cfscript>
			var oCatalog = 0;
			var rebuildCatalog = getValue("rebuildCatalog",false);
			var aResourceTypes = arrayNew(1);
			var qryResources = queryNew(""); 
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();
			
			// get resource types
			oResourceLibrary = createObject("component","homePortals.components.resourceLibrary");
			aResourceTypes = oResourceLibrary.getResourceTypes();
						
			// create catalog object and instantiate for this page
			hp = oContext.getHomePortals();
			oCatalog = hp.getCatalog();
			
			// rebuild catalog if requested
			if(rebuildCatalog) {
				oCatalog.index();
				setMessage("info", "Catalog has been rebuilt.");
			}

			// get resources
			qryResources = oCatalog.getResources();
								
			// pass data to the view	
			setValue("oCatalog", oCatalog);	
			setValue("aResourceTypes", aResourceTypes);	
			setValue("qryResources", qryResources);	

			setValue("cbPageTitle", "Site Resources");
			setValue("cbPageIcon", "folder2_yellow_48x48.png");
			setValue("cbShowSiteMenu", true);

			setView("site/resources/vwMain");
		</cfscript>		
	</cffunction>
	
	<cffunction name="dspResourceType">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var id = getValue("id","NEW");
			var pkg = getValue("pkg","");
			var oResourceBean = 0;
			var oHelpDAO = 0;
			var qryHelp = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();

				qryResources = oCatalog.getResourcesByType(resourceType);
				if(id neq "") {
					if(id eq "NEW") {
						oResourceBean = createObject("component","homePortals.components.resourceBean").init();
						oResourceBean.setType(resourceType); 
						oResourceBean.setAccessType("general"); 
						oResourceBean.setPackage(pkg); 
					} else
						oResourceBean = oCatalog.getResourceNode(resourceType,id);


					setValue("qryAccounts", hp.getAccountsService().GetAccounts() );
					setValue("oResourceBean", oResourceBean);	
				}
				
				// get info on resource type
				oHelpDAO = getService("DAOFactory").getDAO("help");
				qryHelp = oHelpDAO.search(name = "rt_#resourceType#");
				if(qryHelp.recordCount gt 0) setValue("resourceTypeInfo", qryHelp.description);
				
				
				// set values
				setValue("resourceType", resourceType);	
				setValue("qryResources", qryResources);	
				setValue("package", pkg);	
				setValue("resourcesRoot", hp.getConfig().getResourceLibraryPath());
				
				switch(resourceType) {
					case "module":
						setView("site/resources/vwResourceType_module");
						break;

					case "feed":
						setValue("resTypeLabel","Feeds");
						setView("site/resources/vwResourceType_editable");
						break;

					case "content":
						setValue("resTypeLabel","Content");
						setView("site/resources/vwResourceType_editable");
						break;
						
					case "page":
						setValue("resTypeLabel","Pages");
						setView("site/resources/vwResourceType_editable");
						break;

					case "pageTemplate":
						setValue("resTypeLabel","Page Templates");
						setView("site/resources/vwResourceType_editable");
						break;

					case "skin":
						setValue("resTypeLabel","Skins");
						setView("site/resources/vwResourceType_editable");
						break;

					case "html":
						setValue("resTypeLabel","HTML");
						setView("site/resources/vwResourceType_editable");
						break;

				}
				
							
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="dspResourceTypeList">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var oHelpDAO = 0;
			var qryHelp = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();

				// get resources
				qryResources = oCatalog.getResourcesByType(resourceType);
				
				// get info on resource type
				oHelpDAO = getService("DAOFactory").getDAO("help");
				qryHelp = oHelpDAO.search(name = "rt_#resourceType#");
				if(qryHelp.recordCount gt 0) setValue("resourceTypeInfo", qryHelp.description);
				
				switch(resourceType) {
					case "module":  	resTypeLabel="Modules"; resTypeIcon="brick.png"; break;
					case "feed":  		resTypeLabel="Feeds"; resTypeIcon="feed-icon16x16.gif"; break;
					case "content":  	resTypeLabel="Content"; resTypeIcon="folder_page.png"; break;
					case "page":  		resTypeLabel="Page"; resTypeIcon="page.png"; break;
					case "pageTemplate":  resTypeLabel="Page Templates"; resTypeIcon="page_code.png"; break;
					case "skin":  		resTypeLabel="Skins"; resTypeIcon="css.png"; break;
					case "html":  		resTypeLabel="HTML"; resTypeIcon="html.png"; break;
				}
				
				// set values
				setValue("resourceType", resourceType);	
				setValue("qryResources", qryResources);	
				setValue("resourcesRoot", hp.getConfig().getResourceLibraryPath());
				
				setView("site/resources/vwResourceTypeList");
				setValue("resTypeLabel", resTypeLabel );
				setValue("resTypeIcon", resTypeIcon );

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="dspImport">
		<cfscript>
			var oUser = getValue("oUser");
			var sourceSiteID = getValue("sourceSiteID");
			var oResourceLibrary = 0;
			var resRoot = "";
			var qrySourceSite = 0;
			var qrySites = 0;
			
			oSiteDAO = getService("DAOFactory").getDAO("site");

			if(oUser.getIsAdministrator()) {
				// administrator can import from all sites
				qrySites = oSiteDAO.getAll();
			} else {	
				// regular users can only import from homePortals site
				qrySites = oSiteDAO.search(name="HomePortalsEngine");	
			}

			// get source site
			if(sourceSiteID neq "") {
				qrySourceSite = oSiteDAO.get(sourceSiteID);
				resRoot = getResourceLibraryPathFromSite(qrySourceSite.path);
				oResourceLibrary = createObject("component","homePortals.components.resourceLibrary").init(resRoot);
				qryResources = oResourceLibrary.getResourcePackagesList();
				setValue("qryResources", qryResources);
			}
					
			setValue("qrySites",qrySites);		
			setValue("cbPageTitle", "Site Resources > Import Packages");
			setValue("cbPageIcon", "folder2_yellow_48x48.png");
			setValue("cbShowSiteMenu", true);

			setView("site/resources/vwImport");	
		</cfscript>
	</cffunction>


	<cffunction name="doSaveResource">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var id = getValue("id","");
			var pkg = getValue("pkg","");
			var name = getValue("name","");
			var access = getValue("access","");
			var description = getValue("description","");
			var href = getValue("href","");
			var body = getValue("body","");
			var oResourceBean = 0;
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();

			try {		
				hp = oContext.getHomePortals();

				if(name eq "") throw("The resource name cannot be empty","coldBricks.validation"); 
				if(body eq "" and resourceType neq "feed") throw("The resource body cannot be empty","coldBricks.validation"); 
				if(id eq "") id = createUUID();

				// if we have a name then use that for the ID
				if(name neq "") {
					id = replace(name," ","-","ALL");
				}

				// create the bean for the new resource
				oResourceBean = createObject("component","homePortals.components.resourceBean").init();	
				oResourceBean.setID(id);
				oResourceBean.setName(name);
				oResourceBean.setAccessType(access); 
				oResourceBean.setDescription(description); 
				oResourceBean.setPackage(pkg); 
				oResourceBean.setType(resourceType); 
				oResourceBean.setHREF(href);
				resourceLibraryPath = hp.getConfig().getResourceLibraryPath();

				/// add the new resource to the library
				oResourceLibrary = createObject("component","homePortals.components.resourceLibrary").init(resourceLibraryPath);
				oResourceLibrary.saveResource(oResourceBean, body);
			
				// update catalog
				hp.getCatalog().reloadPackage(resourceType,pkg);

				setMessage("info","Resource saved");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("ehResources.dspMain");
		</cfscript>
	</cffunction>
	
	<cffunction name="doDeleteResource">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var id = getValue("id","");
			var pkg = getValue("pkg","");
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();

			try {		
				hp = oContext.getHomePortals();
				resourceLibraryPath = hp.getConfig().getResourceLibraryPath();

				/// remove resource from the library
				oResourceLibrary = createObject("component","homePortals.components.resourceLibrary").init(resourceLibraryPath);
				oResourceLibrary.deleteResource(id, resourceType, pkg);

				// remove from catalog
				hp.getCatalog().deleteResourceNode(resourceType, id);

				setMessage("info","Resource deleted");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("ehResources.dspMain");
		</cfscript>	
	</cffunction>
	
	<cffunction name="doImport">
		<cfscript>
			var oUser = getValue("oUser");
			var sourceSiteID = getValue("sourceSiteID");
			var lstPackages = getValue("lstPackages");
			var resRootSrc = ""; var resRootTgt = "";
			var oContext = getService("sessionContext").getContext();
			
			try {				
				oSiteDAO = getService("DAOFactory").getDAO("site");
	
				qrySourceSite = oSiteDAO.get(sourceSiteID);
				if(qrySourceSite.recordCount eq 0) throw("Site not found!","coldBricks.validation");
				
				// resource library root from source site
				resRootSrc = getResourceLibraryPathFromSite(qrySourceSite.path);
	
				// resource library root from target site
				resRootTgt = getResourceLibraryPathFromSite(oContext.getSiteInfo().getPath());
	
				// copy packages
				for(i=1;i lte listLen(lstPackages);i=i+1) {
					
					pkg = listGetAt(lstPackages,i);
					directoryCopy(
								expandPath(resRootSrc & "/" & pkg),
								expandPath(resRootTgt & "/" & pkg),
								"overwrite"
							);
					
				}
	
				setMessage("info","Selected resource packages imported succesfully!");
				setNextEvent("ehResources.dspMain","rebuildCatalog=true");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehResources.dspImport");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehResources.dspImport");
			}
		</cfscript>	
	</cffunction>
	
	
	<cffunction name="getResourceLibraryPathFromSite" returntype="string" access="private">
		<cfargument name="path" type="string" required="true">
		<cfset var qryDir = queryNew("")>
		<cfset var configFile = arguments.path & "/config/homePortals-config.xml">
		<cfset var xmlDoc = 0>
		<cfset var resRoot = "">
		
		<cfif fileExists(expandPath(configFile))>
			<cfset xmlDoc = xmlParse(expandPath(configFile))>
			<cfset resRoot = xmlDoc.xmlRoot.resourceLibraryPath.xmlText>
		<cfelse>
			<cfthrow message="Invalid site" type="coldBricks.validation">
		</cfif>
		
		<cfreturn resRoot>
	</cffunction>
	
	<cffunction name="directoryCopy" output="true">
		<cfargument name="source" required="true" type="string">
		<cfargument name="destination" required="true" type="string">
		<cfargument name="nameconflict" required="true" default="overwrite">
		<!---
		 Copies a directory.
		 
		 @param source 	 Source directory. (Required)
		 @param destination 	 Destination directory. (Required)
		 @param nameConflict 	 What to do when a conflict occurs (skip, overwrite, makeunique). Defaults to overwrite. (Optional)
		 @return Returns nothing. 
		 @author Joe Rinehart (joe.rinehart@gmail.com) 
		 @version 1, July 27, 2005 
		--->	
		<cfset var contents = "" />
		<cfset var dirDelim = "/">

		<cfif server.OS.Name contains "Windows">
			<cfset dirDelim = "\" />
		</cfif>
		
		<cfif not(directoryExists(arguments.destination))>
			<cfdirectory action="create" directory="#arguments.destination#">
		</cfif>
		
		<cfdirectory action="list" directory="#arguments.source#" name="contents">
		
		<cfloop query="contents">
			<cfif contents.type eq "file">
				<cffile action="copy" source="#arguments.source##dirDelim##name#" destination="#arguments.destination##dirDelim##name#" nameconflict="#arguments.nameConflict#">
			<cfelseif contents.type eq "dir" and name neq ".svn">
				<cfset directoryCopy(arguments.source & dirDelim & name, arguments.destination & dirDelim &  name) />
			</cfif>
		</cfloop>
	</cffunction>
	
	
</cfcomponent>