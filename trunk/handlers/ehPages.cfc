<cfcomponent extends="eventHandler">

	<cffunction name="dspMain">
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

	<cffunction name="dspNode">
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

	<cffunction name="dspTreeNode">
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


		
	<cffunction name="doCreateDirectory">
		<cfscript>
			var path = getValue("path");
			var name = getValue("name");
			
			try {
				if(name eq "") throw("Directory name cannot be empty","coldBricks.validation");
				
				if(directoryExists(expandPath(path & "/" & name)))
					throw("You are trying to create a directory that already exists","coldBricks.validation");
			
				createDir(expandPath(path & "/" & name));
				
				setMessage("info", "Directory created");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
			setNextEvent("ehSiteMap.dspMain");
		</cfscript>		
	</cffunction>	
				
	<cffunction name="doSaveFile">
		<cfscript>
			var path = getValue("path");
			var name = getValue("name");
			var account = getValue("account");
			var page = getValue("page");
			var update = getValue("update",false);
			var type = getValue("type");
			var crlf = chr(13);
			var fileContent = "";
			var fileName = "";
			var oPageRenderer = 0;
			var hp = 0;
			var oContext = getService("sessionContext").getContext();

			try {
				if(account eq "") throw("Account name cannot be empty","coldBricks.validation");
				
				if(update) {
					fileName = path;
					
				} else {
					if(name eq "") throw("File name cannot be empty");

					fileName = path & "/" & name;
					
					if(type eq "dynamic") {
						if(right(fileName,4) neq ".cfm") fileName = fileName & ".cfm";
					
					} else if(type eq "static") {
						if(right(fileName,4) neq ".htm") fileName = fileName & ".htm";
					}
				
					if(fileExists(expandPath(fileName)))
						throw("You are trying to create a file that already exists","coldBricks.validation");
				}
				
				// remove .xml from page name
				page = left(page,len(page)-4);	

				switch(type) {
					
					case "dynamic":
						fileContent = "<!--- generated file mapping --->" & crlf;
						fileContent = fileContent & "<!--- DO NOT DELETE THESE COMMENTS -- REQUIRED FOR COLDBRICKS SITEMAP TOOL --->" & crlf;
						fileContent = fileContent & "<!--- $CB_SM_ACCOUNT:[#account#] --->" & crlf;
						fileContent = fileContent & "<!--- $CB_SM_PAGE:[#page#] --->" & crlf;
						fileContent = fileContent & "<!--- FINISHED COLDBRICKS COMMENTS --->" & crlf;
						fileContent = fileContent & "<cfset account=""#account#"">" & crlf;
						fileContent = fileContent & "<cfset page=""#page#"">" & crlf;
						fileContent = fileContent & "<cfinclude template=""/Home/common/Templates/page.cfm"">";
						break;
				
					case "static":
						hp = oContext.getHomePortals();
						
						// put a refernce to the homeportals object in the application scope. 
						// This is needed for the rendering
						application.homePortals = hp;
					
						// load and parse page
						oPageRenderer = hp.loadPage(account, page);
					
						// render page html
						fileContent = oPageRenderer.renderPage();						

						// remove the hp reference from the app scope
						structDelete(application,"homePortals");
						
						break;
						
					default:
						throw("Invalid page type","coldBricks.validation");
				}
			
				writeFile(expandPath(fileName), fileContent);
				setMessage("info", "File created");
		
			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
			setNextEvent("ehSiteMap.dspNode","account=#account#&path=#path#");
		</cfscript>		
	</cffunction>	
				
	<cffunction name="doDeleteNode">
		<cfscript>
			var path = getValue("path");
			var isFile = false;
			
			try {
				isFile = right(path,4) eq ".cfm" or right(path,4) eq ".htm";
				
				if(not isFile) {
					if(not directoryExists(expandPath(path)))
						throw("You are trying to delete a directory that does not exist","coldBricks.validation");
				
					deleteDir(expandPath(path));
					setMessage("info", "Directory deleted");

				} else {
					if(not fileExists(expandPath(path)))
						throw("You are trying to delete a directory that does not exist","coldBricks.validation");
				
					deleteFile(expandPath(path));
					setMessage("info", "File created");
				}

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
			setNextEvent("ehSiteMap.dspMain");
		</cfscript>		
	</cffunction>			
		
	<cffunction name="writeFile" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cfargument name="content" type="string" required="true">
		<cffile action="write" file="#arguments.path#" output="#arguments.content#" >
	</cffunction>

	<cffunction name="deleteFile" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cffile action="delete" file="#arguments.path#">
	</cffunction>

	<cffunction name="createDir" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cfdirectory action="create" directory="#arguments.path#">
	</cffunction>

	<cffunction name="deleteDir" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cfdirectory action="delete" recurse="true" directory="#arguments.path#">
	</cffunction>

	<cffunction name="readFile" access="private" returntype="string">
		<cfargument name="path" type="string" required="true">
		<cfset var txt = "">
		<cffile action="read" file="#arguments.path#" variable="txt">
		<cfreturn txt>
	</cffunction>
		
</cfcomponent>