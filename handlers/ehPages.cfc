<cfcomponent extends="eventHandler">

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				
				oContext.clearAccountSite();
				oContext.setAccountName("");
				oContext.setAccountID("");
				
				setValue("contentRoot", hp.getConfig().getContentRoot() );
				setValue("cbPageTitle", "Pages");
				setValue("cbPageIcon", "images/documents_48x48.png");
				setValue("cbShowSiteMenu", true);
	
				setView("site/pages/vwMain");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspNode" access="public" returntype="void">
		<cfscript>
			var oContext = getService("sessionContext").getContext();
			var path = getValue("path");
			var hp = 0;
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
				qryDir = hp.getPageProvider().listFolder(path);
				path = reReplace(path,"//*","/","all");
				
				setValue("qryDir", qryDir);
				setValue("path", path);
				setView("site/pages/vwNode");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspTreeNode" access="public" returntype="void">
		<cfset var oContext = getService("sessionContext").getContext()>
		<cfset var path = getValue("path")>
		<cfset var hp = oContext.getHomePortals()>
		<cfset var contentRoot = hp.getConfig().getContentRoot()>
		<cfset var qryDir = 0>

		<!--- remove duplicate forward slashes --->
		<cfset path = reReplace(path,"//*","/","all")>

		<cfif path eq "">
			<cfset qryDir = QueryNew("name,type")>
			<cfset queryAddRow(qryDir,1)>
			<cfset querySetCell(qryDir,"name","/")>
			<cfset querySetCell(qryDir,"type","folder")>
			<cfset path = "">
		<cfelse>
			<cfset qryDir = hp.getPageProvider().listFolder(path)>
			<cfquery name="qryDir" dbtype="query">
				SELECT *
					FROM qryDir
					WHERE type like 'folder'
					ORDER BY name
			</cfquery>	
		</cfif>
	
		<cfset setValue("qryDir", qryDir)>
		<cfset setValue("path", path)>
		<cfset setView("site/pages/vwTreeNode")>
		<cfset setLayout("Layout.none")>
	</cffunction>

	<cffunction name="dspNodeInfo" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oAccountSite = 0;
			var oPage = 0;
			var stPage = structNew();
			var path = getValue("path");
			var oContext = getService("sessionContext").getContext();
			
			try {
				setLayout("Layout.None");	

				hp = oContext.getHomePortals();
				if(hp.getPageProvider().pageExists(path)) {
					oPage = hp.getPageProvider().load(path);
					stPage = hp.getPageProvider().query(path);
				}

				setValue("pageExists", hp.getPageProvider().pageExists(path));
				setValue("oPage",oPage);
				setValue("stPage",stPage);
				setValue("path", path);
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setView("site/pages/vwNodeInfo");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>
	</cffunction>


	<cffunction name="doCreateFolder" access="public" returntype="void">
		<cfscript>
			var oContext = getService("sessionContext").getContext();
			var path = getValue("path");
			var name = getValue("name");
			var hp = 0;
			var pp = 0;
			
			try {
				hp = oContext.getHomePortals();
				pp = hp.getPageProvider();
				
				if(name eq "") 
					throw("Folder name cannot be empty","coldBricks.validation");
				
				if(pp.folderExists(path & "/" & name))
					throw("You are trying to create a folder that already exists","coldBricks.validation");
			
				pp.createFolder(path,name);
				
				setMessage("info", "New folder created");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
			setNextEvent("ehPages.dspNode","path=#path#");
		</cfscript>		
	</cffunction>	
				
	<cffunction name="doCreatePage" access="public" returntype="void">
		<cfscript>
			var oContext = getService("sessionContext").getContext();
			var path = getValue("path");
			var name = getValue("name");
			var hp = 0;
			var pp = 0;
			var tmpFirstPart = "";
			var oPage = 0;
			
			try {
				hp = oContext.getHomePortals();
				pp = hp.getPageProvider();
				
				if(name eq "") 
					throw("Page name cannot be empty","coldBricks.validation");
				
				if(pp.pageExists(path & "/" & name))
					throw("You are trying to create a page that already exists","coldBricks.validation");
			
				// if the pageName contains any spaces, then replace them with _
				name = replace(name," ","_","ALL");

				if(right(name,4) eq ".xml") 
					tmpFirstPart = left(name,len(name)-4);
				else
					tmpFirstPart = name;
					
				// check that the page name only contains simple characters
				if(reFind("[^A-Za-z0-9_]",tmpFirstPart)) 
					throw("Page names can only contain characters from the alphabet, digits and the underscore symbol","coldbricks.validation");
			
				oPage = createObject("component","homePortals.components.pageBean").init();
				pp.save(path & "/" & name, oPage);
				
				setMessage("info", "New page created");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
			setNextEvent("ehPages.dspNode","path=#path#");
		</cfscript>		
	</cffunction>	
		
	<cffunction name="doDeleteNodes" access="public" returntype="void">
		<cfscript>
			var path = getValue("path","");
			var pathsToDelete = getValue("pathsToDelete","");
			var oContext = getService("sessionContext").getContext();
			var nextEvent = getValue("nextEvent","ehPages.dspNode");
			var pp = 0;
			var i = 0;
			var type = "";
			var name = "";
			
			try {
				pp = oContext.getHomePortals().getPageProvider();
				
				for(i=1;i lte listLen(pathsToDelete);i=i+1) {
					type = listFirst(listGetAt(pathsToDelete,i),";");
					name = listLast(listGetAt(pathsToDelete,i),";");
					
					if(type eq "page") pp.delete(name);
					if(type eq "folder") pp.deleteFolder(name);
				}
				setMessage("info", "#listLen(pathsToDelete)# Items deleted");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
			setNextEvent(nextEvent,"path=#path#");
		</cfscript>
	</cffunction>		

	<cffunction name="doRenamePage" access="public" returntype="void">
		<cfscript>
			var parentPath = getValue("parentPath","");
			var pagePath = getValue("pagePath","");
			var pageName = getValue("newName","");
			var oContext = getService("sessionContext").getContext();
			var nextEvent = getValue("nextEvent","ehPages.dspNode");
			var pp = 0;
			var tmpFirstPart = "";
			
			try {
				pp = oContext.getHomePortals().getPageProvider();

				if(pageName eq "") throw("The page name cannot be blank.","coldBricks.validation");

				// if the pageName contains any spaces, then replace them with _
				pageName = replace(pageName," ","_","ALL");

				if(right(pageName,4) eq ".xml") {
					tmpFirstPart = left(pageName,len(pageName)-4);
			
					// check that the page name only contains simple characters
					if(reFind("[^A-Za-z0-9_]",tmpFirstPart)) 
						throw("Page names can only contain characters from the alphabet, digits and the underscore symbol","coldbricks.validation");
				}

				pp.move(pagePath, parentPath & "/" & pageName);

				setMessage("info", "Page has been renamed");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
			setNextEvent(nextEvent,"path=#parentPath#");
		</cfscript>
	</cffunction>	

	<cffunction name="doCopyPage" access="public" returntype="void">
		<cfscript>
			var parentPath = getValue("parentPath","");
			var pagePath = getValue("pagePath","");
			var oContext = getService("sessionContext").getContext();
			var nextEvent = getValue("nextEvent","ehPages.dspNode");
			var pp = 0;
			var oPage_src = 0;
			var oPage_tgt = 0;
			var newPath = "";
			
			try {
				pp = oContext.getHomePortals().getPageProvider();

				oPage_src = pp.load(pagePath);

				newPath = parentPath & "/" & getFileFromPath(pagePath) & "_copy";
				oPage_tgt = createObject("component","homePortals.components.pageBean").init(oPage_src.toXML());
				pp.save(newPath, oPage_tgt);

				setMessage("info", "Page has been copied");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
			setNextEvent(nextEvent,"path=#parentPath#");
		</cfscript>
	</cffunction>	
				
</cfcomponent>