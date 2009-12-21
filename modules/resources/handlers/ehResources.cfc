<cfcomponent extends="ColdBricks.handlers.ehColdBricks">

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var rebuildCatalog = getValue("rebuildCatalog",false);
			var resourceType = "";
			var libpath = ""; 
			var resLibIndex = -1;
			var package = ""; 
			var id = ""; 

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
								
			setResourceContext();
			resourceType = getValue("resourceType");
			resLibIndex = getValue("resLibIndex");
			package = getValue("pkg");
				
								
			// pass data to the view	
			setValue("oCatalog", oCatalog);	
			setValue("stResourceTypes", stResourceTypes);	
			setValue("qryResources", qryResources);	
			setValue("resourceType", resourceType);	
			setValue("resLibIndex", resLibIndex);	
			setValue("id", id);	
			setValue("pkg", package);	

			setValue("cbPageTitle", "Site Resources");
			setValue("cbPageIcon", "folder2_yellow_48x48.png");
			setValue("cbShowSiteMenu", true);

			setView("vwMain");
		</cfscript>		
	</cffunction>
		
	<cffunction name="dspResourceTypeList" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var resLibIndex = val(getValue("resLibIndex",""));
			var package = getValue("pkg","");
			var qryResources = queryNew("");
			var qryPackages = queryNew("");
			var oContext = getService("sessionContext").getContext();
			var aResLibs = arrayNew(1);
			var oResType = 0;
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();
				oResLibManager = hp.getResourceLibraryManager();

				setResourceContext();
				resourceType = getValue("resourceType");
				resLibIndex = getValue("resLibIndex");
				package = getValue("pkg");

				// if we are changing to a different res type, then clear the package
				if(resourceType neq oContext.getResourceType()) {
					package = "";
					resLibIndex = -1;
				}
				if(resLibIndex neq oContext.getResLibIndex()) {
					package = "";
				}

				// get resources
				aResLibs = oResLibManager.getResourceLibraries();
				//if(resLibIndex eq 0 and arrayLen(aResLibs) gt 0) resLibIndex = 1;
				if(resLibIndex gt 0) {
					qryResources = oCatalog.getResourcesByType(resourceType, aResLibs[resLibIndex].getPath());
					qryPackages = aResLibs[resLibIndex].getResourcePackagesList(resourceType);
				} else {
					qryResources = oCatalog.getResourcesByType(resourceType);
				
				}
				
				// get info on resource type
				oResType = hp.getResourceLibraryManager().getResourceTypeInfo(resourceType);
				setValue("resourceTypeInfo", oResType.getDescription());
				resTypeLabel = oResType.getFolderName();
								
				switch(resourceType) {
					case "module":  	resTypeIcon="brick.png"; break;
					case "feed":  		resTypeIcon="feed-icon16x16.gif"; break;
					case "content":  	resTypeIcon="folder_page.png"; break;
					case "page":  		resTypeIcon="page.png"; break;
					case "pageTemplate":  resTypeIcon="page_code.png"; break;
					case "skin":  		resTypeIcon="css.png"; break;
					case "html":  		resTypeIcon="html.png"; break;
					default:
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

				setView("vwResourceTypeList");
				setValue("resTypeLabel", resTypeLabel );
				setValue("resTypeIcon", resTypeIcon );

			} catch(any e) {
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
				if(id neq "NEW" and reslibindex lte 0) setValue("reslibindex", -1);
				
				// check if we have a saved context
				setResourceContext();
				resourceType = getValue("resourceType");
				resLibIndex = getValue("resLibIndex");
				package = getValue("pkg");
			
				if(reslibindex lte 0) throw("Please select a resource library first","coldbricks.validation");

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
				
				setValue("oCatalog", hp.getCatalog() );
				setValue("resourceType", resourceType);	
				setValue("resLibIndex", resLibIndex);	
				setValue("package", package);	
				setValue("id", id);	
				setValue("qryPackages", qryPackages);	
				setValue("oResourceBean", oResourceBean);	
				setValue("resourceTypeConfig", tmp[resourceType]);
				
				setView("vwResource");
							
			} catch(coldbricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("resources.ehResources.dspResourceTypeList","resourceType=#resourceType#");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("resources.ehResources.dspResourceTypeList","resourceType=#resourceType#");
			}						
		</cfscript>	
	</cffunction>
	
	<cffunction name="dspResourceEditor" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var oResourceBean = 0;
			var id = getValue("id");
			var type = getValue("type","plain");
			var oContext = getService("sessionContext").getContext();
			var fileContent = "";
			var href = "";
			var	fullhref = "";
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();

				resourceType = oContext.getResourceType();
				resLibIndex = oContext.getResLibIndex();
				package = oContext.getPackage();
				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();

				if(id eq "") throw("Please select a resource to edit/create its target file","coldBricks.validation");
				
				oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, id);
				
				// read file
				if(oResourceBean.targetFileExists()) {
					fileContent = oResourceBean.readFile();
					setValue("fullhref", oResourceBean.getFullHREF());	
				}
				
				// set values
				setValue("id", id);	
				setValue("resourceType", resourceType);	
				setValue("package", package);	
				setValue("type", type);	
				setValue("fileContent", fileContent);	
				setValue("oResourceBean", oResourceBean);	
				setValue("resLibIndex", resLibIndex);	
				
				setView("vwResourceEditor");
				
			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
							
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	
	</cffunction>

	<cffunction name="dspUploadResource" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			var fileContent = "";
			var href = "";
			var	fullhref = "";
			var	done = getValue("done",false);
			
			try {
				setLayout("Layout.Clean");

				hp = oContext.getHomePortals();

				setResourceContext();
				resourceType = getValue("resourceType");
				resLibIndex = getValue("resLibIndex");
				package = getValue("pkg");

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();

				if(resLibIndex gt 0) {
					oContext.setResLibIndex(resLibIndex);
					qryPackages = aResLibs[resLibIndex].getResourcePackagesList(resourceType);
					setValue("qryPackages", qryPackages);	
				}

				// set values
				setValue("resourceType", resourceType);	
				setValue("package", package);	
				setValue("resLibIndex", resLibIndex);	
				setValue("aResLibs", aResLibs);	
				setValue("done", done);
				
				setView("vwUploadResource");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspCreateResource" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			var fileContent = "";
			var href = "";
			var	fullhref = "";
			var	done = getValue("done",false);
			
			try {
				setLayout("Layout.Clean");

				hp = oContext.getHomePortals();

				setResourceContext();
				resourceType = getValue("resourceType");
				resLibIndex = getValue("resLibIndex");
				package = getValue("pkg");

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();

				if(resLibIndex gt 0) {
					oContext.setResLibIndex(resLibIndex);
					qryPackages = aResLibs[resLibIndex].getResourcePackagesList(resourceType);
					setValue("qryPackages", qryPackages);	

					aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
					qryPackages = aResLibs[resLibIndex].getResourcePackagesList(resourceType);
					oResourceBean = aResLibs[resLibIndex].getNewResource(resourceType);
					tmp = hp.getResourceLibraryManager().getResourceTypesInfo();
					setValue("oResourceBean", oResourceBean);	
					setValue("resourceTypeConfig", tmp[resourceType]);
				}

				// set values
				setValue("resourceType", resourceType);	
				setValue("package", package);	
				setValue("resLibIndex", resLibIndex);	
				setValue("aResLibs", aResLibs);	
				setValue("oCatalog", hp.getCatalog());	
				setValue("done", done);
				
				setView("vwCreateResource");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="dspSelectResourceLibrary" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			var fileContent = "";
			var href = "";
			var	fullhref = "";
			
			try {
				setLayout("Layout.Clean");

				hp = oContext.getHomePortals();

				resourceType = oContext.getResourceType();
				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();

				// set values
				setValue("resourceType", resourceType);	
				setValue("aResLibs", aResLibs);	
				
				setView("vwSelectResourceLibrary");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
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

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("resources.ehResources.dspMain","id=#id#");
		</cfscript>
	</cffunction>

	<cffunction name="doSaveResourceFile" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var id = getValue("id","");
			var body = getValue("body","");
			var fileName = getValue("fileName","");
			var oResourceBean = 0;
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();
			var type = getValue("type","plain");
			var contentType = "text/html";

			try {		
				hp = oContext.getHomePortals();

				if(id eq "") throw("Please select a resource to edit/create its target file","coldBricks.validation");
				if(type eq "plain")
					contentType = "text/plain";

				resourceType = oContext.getResourceType();
				resLibIndex = oContext.getResLibIndex();
				package = oContext.getPackage();
				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, id);
				oResourceType = hp.getResourceLibraryManager().getResourceTypeInfo(resourceType);

				// update the bean 
				aResLibs[resLibIndex].saveResourceFile(oResourceBean, body, fileName, contentType);
		
				// update catalog
				hp.getCatalog().reloadPackage(resourceType,package);

				setMessage("info","Resource target saved");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("resources.ehResources.dspMain");
		</cfscript>
	</cffunction>
	
	<cffunction name="doDeleteResource" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = "";
			var id = getValue("id","");
			var oResourceLibrary = 0;
			var fileHREF = "";
			var oContext = getService("sessionContext").getContext();

			try {		
				hp = oContext.getHomePortals();

				if(getValue("resLibIndex") lte 0) setValue("resLibIndex",-1);

				// check if we have a saved context
				setResourceContext();
				resourceType = getValue("resourceType");
				resLibIndex = getValue("resLibIndex");
				package = getValue("pkg");

				if(reslibindex lte 0) throw("Please select a resource library first","coldbricks.validation");

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, id);

				// delete resource
				aResLibs[resLibIndex].deleteResource(id, resourceType, package);

				// remove from catalog
				hp.getCatalog().deleteResourceNode(resourceType, id);

				setMessage("info","Resource deleted");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("resources.ehResources.dspMain");
		</cfscript>	
	</cffunction>
	
	<cffunction name="doUploadFile" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = "";
			var resLibIndex = 0;
			var package = getValue("package");
			var id = getValue("id","");
			var resFile = getValue("resFile");
			var oResourceBean = 0;
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();
			var pathSeparator =  createObject("java","java.lang.System").getProperty("file.separator");

			try {		
				hp = oContext.getHomePortals();

				if(id eq "") throw("Resource ID cannot be empty","coldBricks.validation"); 
				if(package eq "") throw("Package name cannot be empty","coldBricks.validation"); 
				if(resFile eq "") throw("Please select a file to upload","coldBricks.validation"); 
				
				// check if we have a saved context
				resourceType = oContext.getResourceType();
				resLibIndex = oContext.getResLibIndex();

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				oResourceType = hp.getResourceLibraryManager().getResourceTypeInfo(resourceType);

				// upload file
				path = getTempFile(getTempDirectory(),"coldbricksResourceUpload");
				stFileInfo = fileUpload(resFile, path);
				if(not stFileInfo.fileWasSaved) 
					throw("File upload failed","coldBricks.validation");
				path = stFileInfo.serverDirectory & pathSeparator & stFileInfo.serverFile;

				// create the bean for the new resource
				oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, id);
				aResLibs[resLibIndex].addResourceFile(oResourceBean, path, stFileInfo.clientFile, stFileInfo.contentType & "/" & stFileInfo.contentSubType);

				// update catalog
				hp.getCatalog().reloadPackage(resourceType,package);

				// delete temp file
				fileDelete(path);

				setMessage("info","Resource target uploaded");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("resources.ehResources.dspMain","id=#id#");
		</cfscript>
	</cffunction>
		
	<cffunction name="doDeleteResourceFile" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = "";
			var resLibIndex = 0;
			var package = "";
			var id = getValue("id","");
			var oResourceBean = 0;
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();

			try {		
				hp = oContext.getHomePortals();

				if(id eq "") throw("Resource ID cannot be empty","coldBricks.validation"); 
				
				// check if we have a saved context
				resourceType = oContext.getResourceType();
				resLibIndex = oContext.getResLibIndex();
				package = oContext.getPackage();

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();

				// create the bean for the new resource
				oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, id);
				oResourceBean.deleteFile();
			
				// update catalog
				hp.getCatalog().reloadPackage(resourceType,package);

				setMessage("info","Resource target deleted");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("resources.ehResources.dspMain","id=#id#");
		</cfscript>	
	</cffunction>	
		
	<cffunction name="doUploadResource" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = "";
			var resLibIndex = getValue("resLibIndex");
			var package = getValue("package");
			var packageNew = getValue("package_new");
			var id = getValue("id","");
			var resFile = getValue("resFile");
			var oResourceBean = 0;
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();
			var pathSeparator =  createObject("java","java.lang.System").getProperty("file.separator");

			try {		
				hp = oContext.getHomePortals();

				if(resLibIndex lte 0) throw("Please select a resource library","coldBricks.validation"); 
				if(package eq "" and packageNew eq "") throw("Package name cannot be empty","coldBricks.validation"); 
				if(resFile eq "") throw("Please select a file to upload","coldBricks.validation"); 
				
				if(package eq "") package = packageNew;
				
				// check if we have a saved context
				resourceType = oContext.getResourceType();

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				oResourceType = hp.getResourceLibraryManager().getResourceTypeInfo(resourceType);

				// upload file
				path = getTempFile(getTempDirectory(),"coldbricksResourceUpload");
				stFileInfo = fileUpload(resFile, path);
				if(not stFileInfo.fileWasSaved) 
					throw("File upload failed","coldBricks.validation");
				path = stFileInfo.serverDirectory & pathSeparator & stFileInfo.serverFile;

				id = getFileFromPath(stFileInfo.clientFile);
				if(listLen(id,".") gt 1) id = listDeleteAt(id,listLen(id,"."),".");

				// create the bean for the new resource
				oResourceBean = aResLibs[resLibIndex].getNewResource(resourceType);
				oResourceBean.setID( id );
				oResourceBean.setPackage(package); 

				/// add the new resource to the library
				aResLibs[resLibIndex].saveResource(oResourceBean);
				aResLibs[resLibIndex].addResourceFile(oResourceBean, path, stFileInfo.clientFile, stFileInfo.contentType & "/" & stFileInfo.contentSubType);

				// update catalog
				hp.getCatalog().reloadPackage(resourceType,package);

				// delete temp file
				fileDelete(path);

				setMessage("info","Resource target uploaded");
				setNextEvent("resources.ehResources.dspUploadResource","done=true");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("resources.ehResources.dspUploadResource");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("resources.ehResources.dspUploadResource");
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="doCreateResource" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = "";
			var resLibIndex = val(getValue("resLibIndex"));
			var package = getValue("package");
			var packageNew = getValue("package_new");
			var id = getValue("id","");
			var description = getValue("description","");
			var oResourceBean = 0;
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();

			try {		
				hp = oContext.getHomePortals();

				if(id eq "") throw("Resource ID cannot be empty","coldBricks.validation"); 
				if(resLibIndex lte 0) throw("Please select a resource library []","coldBricks.validation"); 
				if(package eq "" and packageNew eq "") throw("Package name cannot be empty","coldBricks.validation"); 
				
				if(package eq "") package = packageNew;

				// check if we have a saved context
				resourceType = oContext.getResourceType();

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				oResourceType = hp.getResourceLibraryManager().getResourceTypeInfo(resourceType);

				// create the bean for the new resource
				oResourceBean = aResLibs[resLibIndex].getNewResource(resourceType);
				oResourceBean.setID( id );
				oResourceBean.setDescription(description); 
				oResourceBean.setPackage(package); 

				props = oResourceBean.getProperties();
				for(key in props) {
					oResourceBean.setProperty(key, getValue("cp_#key#"));
				}
	
				/// add the new resource to the library
				aResLibs[resLibIndex].saveResource(oResourceBean);

				// update catalog
				hp.getCatalog().reloadPackage(resourceType,package);

				setMessage("info","Resource created");
				setNextEvent("resources.ehResources.dspCreateResource","done=true");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("resources.ehResources.dspCreateResource");
		</cfscript>
	</cffunction>
	
	
	<cffunction name="getResourceLibraryPathFromSite" returntype="string" access="private">
		<cfargument name="path" type="string" required="true">
		<cfset var qryDir = queryNew("")>
		<cfset var configFile = arguments.path & "/config/homePortals-config.xml.cfm">
		<cfset var xmlDoc = 0>
		<cfset var resRoot = "">
		
		<cfif fileExists(expandPath(configFile))>
			<cfset xmlDoc = xmlParse(expandPath(configFile))>
			<cfset resRoot = xmlDoc.xmlRoot.resourceLibraryPaths.xmlChildren[1].xmlText>
		<cfelse>
			<cfthrow message="Invalid site" type="coldBricks.validation">
		</cfif>
		
		<cfreturn resRoot>
	</cffunction>
	
	<cffunction name="fileUpload" access="private" returntype="struct">
		<cfargument name="fieldName" type="string" required="true">
		<cfargument name="destPath" type="string" required="true">
		
		<cfset var stFile = structNew()>
		
		<cffile action="upload" 
				filefield="resFile" 
				nameconflict="makeunique"  
				result="stFile"
				destination="#expandPath(arguments.destPath)#">
		
		<cfreturn stFile>
	</cffunction>	
		
	<cffunction name="setResourceContext" access="private">
		<cfscript>
			var resType = getValue("resourceType");
			var libpath = getValue("libpath"); 
			var resLibIndex = val(getValue("resLibIndex",""));
			var package = getValue("pkg"); 
			var id = getValue("id"); 
			
			var oContext = getService("sessionContext").getContext();
			var hp = oContext.getHomePortals();
			var aResLibs = 0;
			var oResource = 0;
			var i = 0;
			
			if(id neq "" and id neq "NEW" and resType neq "" and (libPath eq "auto" or resLibIndex eq -1)) {
				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				oResource = hp.getCatalog().getResourceNode(resType, id);
				for(i=1;i lte arrayLen(aResLibs);i++) {
					if(aResLibs[i].getPath() eq oResource.getResourceLibrary().getPath()) {
						resLibIndex = i;
						package = oResource.getPackage();
						break;
					}
				}
			}					
								
			// check if we have a saved resource context
			if(resType eq "" and oContext.getResourceType() neq "")  resType = oContext.getResourceType();
			if(resLibIndex eq 0 and oContext.getResLibIndex() gt 0)  resLibIndex = oContext.getResLibIndex();
			if(package eq "" and oContext.getPackage() neq "")  package = oContext.getPackage();					
			
			//if(resLibIndex eq -1) resLibIndex = 0;					
			if(package eq "__ALL__") package = "";					
			
			setValue("resourceType", resType);
			setValue("resLibIndex", resLibIndex);
			setValue("pkg", package);
		</cfscript>
	</cffunction>
		
</cfcomponent>