<cfcomponent extends="ColdBricks.handlers.ehColdBricks">

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var resLibIndex = val(getValue("resLibIndex",""));
			var package = getValue("package","");
			var resourceID = getValue("resourceID","");
			var oContext = getService("sessionContext").getContext();
			var qryPackages = 0;
			var oResourceBean = 0;
			var resourceTypeConfig = 0;
			
			try {
				setLayout("Layout.Clean");

				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();

				if(resourceID eq "NEW") resourceID = "";
				
				if(resLibIndex eq 0) 
					resLibIndex = getDefaultResLibIndex(resourceID,resourceType);


				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				
				if(reslibindex gt 0) {

					// figure out the package name
					
					qryPackages = aResLibs[resLibIndex].getResourcePackagesList(resourceType);

					if(package eq "") {
						if(resourceID neq "")
							package = getDefaultResPackage(resourceID,resourceType);
	
						else if(qryPackages.recordCount gt 0)
							package = qryPackages.name;
					}
					
					
					// get the resource
					
					if(resourceID neq "")
						oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, resourceID);
					else
						oResourceBean = aResLibs[resLibIndex].getNewResource(resourceType);
					
					tmp = hp.getResourceLibraryManager().getResourceTypesInfo();

					setValue("oResourceBean", oResourceBean);	
					setValue("qryPackages", qryPackages);	
					setValue("resourceTypeConfig", tmp[resourceType]);
				}

				setValue("oCatalog", hp.getCatalog() );
				setValue("resourceType", resourceType);	
				setValue("resLibIndex", resLibIndex);	
				setValue("package", package);	
				setValue("resourceID", resourceID);	
				setValue("aResLibs", aResLibs);
				
				setView("vwMain");
							
			} catch(coldbricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("resource.ehResource.dspClose");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("resource.ehResource.dspClose");
			}						
		</cfscript>	
	</cffunction>
	
	<cffunction name="dspEditor" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var oResourceBean = 0;
			var resourceType = getValue("resourceType","");
			var resLibIndex = val(getValue("resLibIndex",""));
			var package = getValue("package","");
			var resourceID = getValue("resourceID","");
			var type = getValue("type","plain");
			var oContext = getService("sessionContext").getContext();
			var fileContent = "";
			var href = "";
			var	fullhref = "";
			
			try {
				setLayout("Layout.Clean");

				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();

				if(resourceID eq "") throw("Please select a resource to edit/create its target file","coldBricks.validation");
				if(val(resLibIndex) eq 0) 
					resLibIndex = getDefaultResLibIndex(resourceID,resourceType);
				if(reslibindex lte 0) 
					throw("Please select a resource library first","coldbricks.validation");
				
				oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, resourceID);
				
				// read file
				if(oResourceBean.targetFileExists()) {
					fileContent = oResourceBean.readFile();
					setValue("fullhref", oResourceBean.getFullHREF());	
				}
				
				// set values
				setValue("resourceID", resourceID);	
				setValue("resourceType", resourceType);	
				setValue("package", package);	
				setValue("type", type);	
				setValue("fileContent", fileContent);	
				setValue("oResourceBean", oResourceBean);	
				setValue("resLibIndex", resLibIndex);	
				
				setView("vwEditor");
				
			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
							
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	
	</cffunction>
	
	<cffunction name="dspClose" access="public" returntype="void">
		<cfset setLayout("Layout.Clean")>
		<cfset setView("vwClose")>
	</cffunction>

	
	<cffunction name="doSave" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var resLibIndex = val(getValue("resLibIndex",""));
			var package = getValue("package","");
			var packageNew = getValue("package_new");
			var resourceID = getValue("resourceID","");
			var description = getValue("description","");
			var href = getValue("href","");
			var oResourceBean = 0;
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();

			try {		
				hp = oContext.getHomePortals();

				if(resourceID eq "") throw("Resource ID cannot be empty","coldBricks.validation"); 
				if(package eq "" and packageNew eq "") throw("Package name cannot be empty","coldBricks.validation"); 
				if(package eq "") package = packageNew;

				if(resourceID neq "NEW" and val(resLibIndex) eq 0) 
					resLibIndex = getDefaultResLibIndex(resourceID,resourceType);
				
				if(reslibindex lte 0) 
					throw("Please select a resource library first","coldbricks.validation");
	
				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();

				// create the bean for the new resource
				oResourceBean = aResLibs[resLibIndex].getNewResource(resourceType);
				oResourceBean.setID(resourceID);
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
		
			setNextEvent("resource.ehResource.dspMain","resourceID=#resourceID#&package=#package#&resourceType=#resourceType#");
		</cfscript>
	</cffunction>

	<cffunction name="doSaveFile" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var resLibIndex = val(getValue("resLibIndex",""));
			var package = getValue("package","");
			var resourceID = getValue("resourceID","");
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

				if(resourceID eq "") throw("Please select a resource to edit/create its target file","coldBricks.validation");
				if(val(resLibIndex) eq 0) 
					resLibIndex = getDefaultResLibIndex(resourceID,resourceType);
				if(reslibindex lte 0) 
					throw("Please select a resource library first","coldbricks.validation");
				if(type eq "plain")
					contentType = "text/plain";

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, resourceID);
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
		
			setNextEvent("resource.ehResource.dspMain","resourceID=#resourceID#&package=#package#&resourceType=#resourceType#");
		</cfscript>
	</cffunction>
	
	<cffunction name="doDelete" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var resLibIndex = val(getValue("resLibIndex",""));
			var package = getValue("package","");
			var resourceID = getValue("resourceID","");
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();

			try {		
				hp = oContext.getHomePortals();
				setLayout("Layout.Clean");

				if(val(resLibIndex) eq 0) 
					resLibIndex = getDefaultResLibIndex(resourceID,resourceType);

				if(reslibindex lte 0) 
					throw("Please select a resource library first","coldbricks.validation");

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, resourceID);

				// delete resource
				aResLibs[resLibIndex].deleteResource(resourceID, resourceType, package);

				// remove from catalog
				hp.getCatalog().deleteResourceNode(resourceType, resourceID);

				setMessage("info","Resource deleted");
				setNextEvent("resource.ehResource.dspClose");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("resource.ehResource.dspMain","resourceID=#resourceID#&package=#package#&resourceType=#resourceType#");
			}
			
		</cfscript>	
	</cffunction>
	
	<cffunction name="doUploadFile" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var resLibIndex = val(getValue("resLibIndex",""));
			var package = getValue("package","");
			var resourceID = getValue("resourceID","");
			var resFile = getValue("resFile");
			var oResourceBean = 0;
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();
			var pathSeparator =  createObject("java","java.lang.System").getProperty("file.separator");

			try {		
				hp = oContext.getHomePortals();

				if(resourceID eq "") throw("Resource ID cannot be empty","coldBricks.validation"); 
				if(package eq "") throw("Package name cannot be empty","coldBricks.validation"); 
				if(resFile eq "") throw("Please select a file to upload","coldBricks.validation"); 
				
				if(val(resLibIndex) eq 0) 
					resLibIndex = getDefaultResLibIndex(resourceID,resourceType);

				if(reslibindex lte 0) 
					throw("Please select a resource library first","coldbricks.validation");

				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();
				oResourceType = hp.getResourceLibraryManager().getResourceTypeInfo(resourceType);

				// upload file
				path = getTempFile(getTempDirectory(),"coldbricksResourceUpload");
				stFileInfo = fileUpload(resFile, path);
				if(not stFileInfo.fileWasSaved) 
					throw("File upload failed","coldBricks.validation");
				path = stFileInfo.serverDirectory & pathSeparator & stFileInfo.serverFile;

				/// update resource in library
				oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, resourceID);
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
		
			setNextEvent("resource.ehResource.dspMain","resourceID=#resourceID#&package=#package#&resourceType=#resourceType#");
		</cfscript>
	</cffunction>
		
	<cffunction name="doDeleteFile" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oCatalog = 0;
			var resourceType = getValue("resourceType","");
			var resLibIndex = val(getValue("resLibIndex",""));
			var package = getValue("package","");
			var resourceID = getValue("resourceID","");
			var oResourceBean = 0;
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var oContext = getService("sessionContext").getContext();

			try {		
				hp = oContext.getHomePortals();

				if(resourceID eq "") throw("Resource ID cannot be empty","coldBricks.validation"); 
				if(val(resLibIndex) eq 0) 
					resLibIndex = getDefaultResLibIndex(resourceID,resourceType);

				if(reslibindex lte 0) 
					throw("Please select a resource library first","coldbricks.validation");
				
				aResLibs = hp.getResourceLibraryManager().getResourceLibraries();

				// get reference to resource
				oResourceBean = aResLibs[resLibIndex].getResource(resourceType, package, resourceID);
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
		
			setNextEvent("resource.ehResource.dspMain","resourceID=#resourceID#&package=#package#&resourceType=#resourceType#");
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

	<cffunction name="getDefaultResLibIndex" access="private" returntype="numeric">
		<cfargument name="resourceId" type="string" required="false" default="">
		<cfargument name="resourceType" type="string" required="false" default="">
		<cfset var index = -1>
		<cfset var oContext = getService("sessionContext").getContext()>
		<cfset var hp = oContext.getHomePortals()>
		<cfset var aResLibs = hp.getResourceLibraryManager().getResourceLibraries()>
		<cfset var path = "">
		<cfset var oResourceBean = 0>
		
		<cfif arguments.resourceID neq "">
			<cfset oResourceBean = hp.getCatalog().getResourceNode(arguments.resourceType, arguments.resourceID)>
			<cfset path = oResourceBean.getResourceLibrary().getPath()>
		<cfelse>
			<cfset oConfigBean = getService("configManager").getAppHomePortalsConfigBean(oContext)>
			<cfset aTemp = oConfigBean.getResourceLibraryPaths()>
			<cfif arrayLen(aTemp)>
				<cfset path = aTemp[1]>
			</cfif>
		</cfif>
		
		<cfloop from="1" to="#arrayLen(aResLibs)#" index="i">
			<cfif aResLibs[i].getPath() eq path>
				<cfset index = i>
			</cfif>
		</cfloop>
		
		<cfreturn index>
	</cffunction>

	<cffunction name="getDefaultResPackage" access="private" returntype="string">
		<cfargument name="resourceId" type="string" required="false" default="">
		<cfargument name="resourceType" type="string" required="false" default="">
		<cfset var pkg = "">
		<cfset var oContext = getService("sessionContext").getContext()>
		<cfset var hp = oContext.getHomePortals()>
		<cfset var oResourceBean = 0>

		<cfif arguments.resourceID neq "">
			<cfset oResourceBean = hp.getCatalog().getResourceNode(arguments.resourceType, arguments.resourceID)>
			<cfset pkg = oResourceBean.getPackage()>
		</cfif>
		<cfreturn pkg>		
	</cffunction>
		
</cfcomponent>