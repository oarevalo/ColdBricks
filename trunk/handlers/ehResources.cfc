<cfcomponent extends="ehColdBricks">

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var rebuildCatalog = getValue("rebuildCatalog",false);
			var resType = getValue("resType");
			var oCatalog = 0;
			var stResourceTypes = structNew();
			var qryResources = queryNew(""); 
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();
			
			// create catalog object and instantiate for this page
			hp = oContext.getHomePortals();
			oCatalog = hp.getCatalog();
			
			// get resource types
			stResourceTypes = hp.getResourceLibraryManager().getResourceTypesInfo();
						
			// rebuild catalog if requested
			if(rebuildCatalog) {
				oCatalog.index();
				setMessage("info", "Catalog has been rebuilt.");
			}

			// get resources
			qryResources = oCatalog.getResources();
								
			// check if we have a saved resource type
			if(resType eq "" and oContext.getResourceType() neq "") {
				resType = oContext.getResourceType();
			}					
								
			// pass data to the view	
			setValue("oCatalog", oCatalog);	
			setValue("stResourceTypes", stResourceTypes);	
			setValue("qryResources", qryResources);	
			setValue("resType", resType);	

			setValue("cbPageTitle", "Site Resources");
			setValue("cbPageIcon", "folder2_yellow_48x48.png");
			setValue("cbShowSiteMenu", true);

			setView("site/resources/vwMain");
		</cfscript>		
	</cffunction>
	
	<cffunction name="dspResourceType" access="public" returntype="void">
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
			var tmp = "";
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();

				qryResources = oCatalog.getResourcesByType(resourceType);
				if(id neq "") {
					if(id eq "NEW") {
						oResourceBean = createObject("component","homePortals.components.resourceBean").init();
						oResourceBean.setType(resourceType); 
						oResourceBean.setPackage(pkg); 
					} else
						oResourceBean = oCatalog.getResourceNode(resourceType,id);

					setValue("oResourceBean", oResourceBean);	
				}
				
				// get info on resource type
				oHelpDAO = getService("DAOFactory").getDAO("help");
				qryHelp = oHelpDAO.search(name = "rt_#resourceType#");
				if(qryHelp.recordCount gt 0) setValue("resourceTypeInfo", qryHelp.description);
				
				// get resource types
				tmp = hp.getResourceLibraryManager().getResourceTypesInfo();
				setValue("resourceTypeConfig", tmp[resourceType]);
				
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
	
	<cffunction name="dspResourceTypeList" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var resLibIndex = val(getValue("resLibIndex",""));
			var package = getValue("pkg","");
			var oHelpDAO = 0;
			var qryHelp = 0;
			var qryResources = queryNew("");
			var oContext = getService("sessionContext").getContext();
			var aResLibs = arrayNew(1);
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();
				oResLibManager = hp.getResourceLibraryManager();

				// check if we have a saved context
				if(resourceType eq "" and oContext.getResourceType() neq "")  resourceType = oContext.getResourceType();
				if(resLibIndex eq 0 and oContext.getResLibIndex() gt 0)  resLibIndex = oContext.getResLibIndex();
				if(package eq "" and oContext.getPackage() neq "" and package neq "__ALL__")  package = oContext.getPackage();

				if(package eq "__ALL__") package = "";

				// if we are changing to a different res type, then clear the package
				if(resourceType neq oContext.getResourceType()) {
					package = "";
				}

				// get resources
				aResLibs = oResLibManager.getResourceLibraries();
				if(resLibIndex eq 0 and arrayLen(aResLibs) gt 0) resLibIndex = 1;
				if(resLibIndex gt 0) {
					qryResources = oCatalog.getResourcesByType(resourceType, aResLibs[resLibIndex].getPath());
					qryPackages = aResLibs[resLibIndex].getResourcePackagesList(resourceType);
				}
				
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
					default:
						resTypeLabel = resourceType;
						resTypeIcon = "folder.png";
				}
				
				// store selection on context
				oContext.setResourceType(resourceType);
				oContext.setPackage(package);
				oContext.setResLibIndex(resLibIndex);
				
				// set values
				setValue("resourceType", resourceType);	
				setValue("qryResources", qryResources);	
				setValue("resourcesRoot", hp.getConfig().getResourceLibraryPath());
				setValue("aResLibs", aResLibs);	
				setValue("resLibIndex", resLibIndex);	
				setValue("package", package);	
				setValue("qryPackages", qryPackages);	

				setView("site/resources/vwResourceTypeList");
				setValue("resTypeLabel", resTypeLabel );
				setValue("resTypeIcon", resTypeIcon );

			} catch(lock e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="dspResource" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var resLibIndex = val(getValue("resLibIndex",""));
			var package = getValue("pkg","");
			var id = getValue("id","");
			var oContext = getService("sessionContext").getContext();
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();
				
				// check if we have a saved context
				if(resourceType eq "" and oContext.getResourceType() neq "")  resourceType = oContext.getResourceType();
				if(resLibIndex eq 0 and oContext.getResLibIndex() gt 0)  resLibIndex = oContext.getResLibIndex();
				if(package eq "" and oContext.getPackage() neq "")  package = oContext.getPackage();

				// if we are changing to a different res type, then clear the package
				if(resourceType neq oContext.getResourceType()) {
					package = "";
				}
				

				// get resource
				if(id eq "NEW") id = "";
				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				qryPackages = aResLibs[resLibIndex].getResourcePackagesList(resourceType);
				if(id neq "")
					oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, id);
				else
					oResourceBean = aResLibs[resLibIndex].getNewResource(resourceType);
				
				tmp = hp.getResourceLibraryManager().getResourceTypesInfo();
				
				
				// store selection on context
				oContext.setResourceType(resourceType);
				oContext.setPackage(package);
				oContext.setResLibIndex(resLibIndex);
				
				setValue("resourceType", resourceType);	
				setValue("resLibIndex", resLibIndex);	
				setValue("package", package);	
				setValue("id", id);	
				setValue("qryPackages", qryPackages);	
				setValue("oResourceBean", oResourceBean);	
				setValue("resourceTypeConfig", tmp[resourceType]);
				
				setView("site/resources/vwResource");
							
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}						
		</cfscript>	
	</cffunction>
	
	<cffunction name="dspImport" access="public" returntype="void">
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


	<cffunction name="doSaveResource" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = "";
			var resLibIndex = 0;
			var package = getValue("package");
			var packageNew = getValue("package_new");
			var id = getValue("id","");
			var description = getValue("description","");
			var href = getValue("href","");
			var oResourceBean = 0;
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();

			try {		
				hp = oContext.getHomePortals();

				if(id eq "") throw("Resource ID cannot be empty","coldBricks.validation"); 
				if(package eq "" and packageNew eq "") throw("Package name cannot be empty","coldBricks.validation"); 
				
				if(package eq "") package = packageNew;

				// check if we have a saved context
				resourceType = oContext.getResourceType();
				resLibIndex = oContext.getResLibIndex();

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();

				// create the bean for the new resource
				oResourceBean = aResLibs[resLibIndex].getNewResource(resourceType);
				oResourceBean.setID(id);
				oResourceBean.setDescription(description); 
				oResourceBean.setPackage(package); 
				oResourceBean.setHREF(href);

				props = oResourceBean.getProperties();
				for(key in props) {
					oResourceBean.setProperty(key, getValue("cp_#key#"));
				}

				/// add the new resource to the library
				aResLibs[resLibIndex].saveResource(oResourceBean);
			
				// update catalog
				hp.getCatalog().reloadPackage(resourceType,package);

				setMessage("info","Resource saved");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(lock e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("ehResources.dspMain");
		</cfscript>
	</cffunction>

	<cffunction name="doSaveResource_old" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var id = getValue("id","");
			var pkg = getValue("pkg","");
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
	
	<cffunction name="doDeleteResource" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = "";
			var id = getValue("id","");
			var pkg = getValue("pkg","");
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();

			try {		
				hp = oContext.getHomePortals();

				// check if we have a saved context
				resourceType = oContext.getResourceType();
				resLibIndex = oContext.getResLibIndex();

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				aResLibs[resLibIndex].deleteResource(id, resourceType, pkg);

				// remove from catalog
				hp.getCatalog().deleteResourceNode(resourceType, id);

				setMessage("info","Resource deleted");

			} catch(lock e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("ehResources.dspMain");
		</cfscript>	
	</cffunction>
	
	<cffunction name="doImport" access="public" returntype="void">
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
	
	<cffunction name="doCreatePackage" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var resourceType = getValue("resourceType","");
			var resLibIndex = getValue("resLibIndex","");
			var name = getValue("name","");

			try {		
				setMessage("warning","not implemented");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("ehResources.dspMain");
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
	
	<cffunction name="directoryCopy" output="true" access="private" returntype="void">
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