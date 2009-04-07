<cfcomponent extends="ehColdBricks">

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var oSiteDAO = 0;
			var oUserDAO = 0;
			var qrySites = 0;
			var oUser = getValue("oUser");
			
			try {
				oSiteDAO = getService("DAOFactory").getDAO("site");
				oUserSiteDAO = getService("DAOFactory").getDAO("userSite");
				
				qrySites = oSiteDAO.getAll();
				qryUserSites = oUserSiteDAO.search(userID = oUser.getID());

				// if this is a regular user that has only one site, then 
				// go directly to that site
				if(not oUser.getIsAdministrator() and qryUserSites.recordCount eq 1)
					setNextEvent("ehSite.doLoadSite","siteID=#qryUserSites.siteID#");

				setValue("qrySites",qrySites);
				setValue("qryUserSites",qryUserSites);
				setValue("cbPageTitle", "Site Management");
				setValue("cbPageIcon", "images/folder_desktop_48x48.png");
				setView("sites/vwMain");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setView("");
			}
		</cfscript>	
	</cffunction>

	<cffunction name="dspCreate" access="public" returntype="void">
		<cfset var siteTemplatesRoot = getSetting("siteTemplatesRoot")>
		<cfset var qrySiteTemplates = 0>
		
		<cfdirectory action="list" directory="#expandPath(siteTemplatesRoot)#" name="qrySiteTemplates">
		<cfquery name="qrySiteTemplates" dbtype="query">
			SELECT *
				FROM qrySiteTemplates
				WHERE type like 'Dir'
					and name not like '%.svn'
				ORDER BY name
		</cfquery>
			
		<cfset setValue("siteTemplatesRoot", siteTemplatesRoot)>
		<cfset setValue("qrySiteTemplates", qrySiteTemplates)>
		<cfset setValue("cbPageTitle", "Site Management > Create New Site")>
		<cfset setValue("cbPageIcon", "images/folder_desktop_48x48.png")>
		
		<cfset setView("sites/vwCreate")>	
	</cffunction>

	<cffunction name="dspDelete" access="public" returntype="void">
		<cfscript>
			var siteID = getValue("siteID");
			var oSiteDAO = 0;
			var qrySite = 0;
			
			try {			
				// get site information
				oSiteDAO = getService("DAOFactory").getDAO("site");
				qrySite = oSiteDAO.get(siteID);

				if(qrySite.path eq "/")
					throw("Sites located at the root level cannot be deleted from within this application.","coldBricks.validation");

				setValue("qrySite",qrySite);
				setValue("cbPageTitle", "Site Management > Confirm Site Deletion");
				setValue("cbPageIcon", "images/folder_desktop_48x48.png");
				setView("sites/vwDelete");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSites.dspMain");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSites.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspRegister" access="public" returntype="void">
		<cfset setValue("cbPageTitle", "Site Management > Register Existing Site")>
		<cfset setValue("cbPageIcon", "images/folder_desktop_48x48.png")>
		<cfset setView("sites/vwRegister")>
	</cffunction>

	<cffunction name="doCreate" access="public" returntype="void">
		<cfscript>
			var appRoot = getValue("appRoot");
			var accountsRoot = getValue("accountsRoot");
			var resourcesRoot = getValue("resourcesRoot");
			var name = getValue("name");
			var useDefault_ar = getValue("useDefault_ar",0);
			var useDefault_rl = getValue("useDefault_rl",0);
			var siteTemplate = getValue("siteTemplate");
			var defaultAccount = "default";
			var oUser = getValue("oUser");
			
			var siteTemplatePath = getSetting("siteTemplatesRoot");
			
			var bCreateAccountDir = false;
			var bCreateResourceDir = false;
			
			var oSiteDAO = 0;
			var qrySiteCheck = 0;
			var siteID = 0;
			
			try {
				if(name eq "") throw("Site name cannot be empty","coldBricks.validation");
				if(appRoot eq "") throw("Application root cannot be empty","coldBricks.validation");
				if(siteTemplate eq 0) throw("Select a site template or select ''Custom...'' to customize site structure","coldBricks.validation");

				// check that application root and name only contains valid characters
				if(reFind("[^A-Za-z0-9_\ ]",name)) throw("The site name can only contain characters from the alphabet, digits, the underscore symbol and the space","coldbricks.validation");
				if(reFind("[^A-Za-z0-9_/\-]",appRoot)) throw("The application root can only contain characters from the alphabet, digits, the underscore symbol and the backslash","coldbricks.validation");

				// make sure the approot doesnt exist already
				if(appRoot neq "/" and directoryExists(expandPath(appRoot))) 
					throw("The given application directory already exists. Please select a different directory","coldBricks.validation");
				
				// check that the directory is not a restricted one
				if(left(appRoot,6) eq "/homePortals/" 
					or appRoot eq "/homePortals"
					or left(appRoot,11) eq "/ColdBricks") {
					throw("You are trying to use a restricted directory as the application root. Please select a different application root.","coldBricks.validation");
				}
				
				// check if site is already registered in coldbricks
				oSiteDAO = getService("DAOFactory").getDAO("site");
				qrySiteCheck = oSiteDAO.search(siteName = name);
				if(qrySiteCheck.recordCount gt 0) 
					throw("There is already another site registered with the name '#name#', please select a different site name.","coldBricks.validation");

				// make sure application root path start and end with / for consistency and to avoid problems later
				if(left(appRoot,1) neq "/") throw("All paths must be relative to the website root and start with '/'","coldBricks.validation");
				if(right(appRoot,1) neq "/") appRoot = appRoot & "/";

				if(siteTemplate neq "") {
					// create template-based site
					accountsRoot = appRoot & "accounts/";
					resourcesRoot = appRoot & "resourceLibrary/";

					// copy application skeletons
					directoryCopy(expandPath(siteTemplatePath & "/" & siteTemplate & "/appRoot"), expandPath(appRoot));
					directoryCopy(expandPath(siteTemplatePath & "/" & siteTemplate & "/accountsRoot"), expandPath(accountsRoot));
					directoryCopy(expandPath(siteTemplatePath & "/" & siteTemplate & "/resourcesRoot"), expandPath(resourcesRoot));
					
				} else {
					// create custom site
					if(useDefault_ar eq 0 and accountsRoot eq "") throw("Accounts root cannot be empty","coldBricks.validation");
					if(useDefault_rl eq 0 and resourcesRoot eq "") throw("Resource Library root cannot be empty","coldBricks.validation");
					if(useDefault_ar eq 1) accountsRoot = appRoot & "accounts";
					if(useDefault_rl eq 1) resourcesRoot = appRoot & "resourceLibrary";
					if(useDefault_rl eq 2) resourcesRoot = "/homePortals/resourceLibrary";

					// check if we need to create the accounts root
					if(not directoryExists(expandPath(accountsRoot))) {
						bCreateAccountDir = true;
					}
		
					// check if we need to create the resources root
					if(not directoryExists(expandPath(resourcesRoot))) {
						bCreateResourceDir = true;
					}

					// make sure all paths start and end with / for consistency and to avoid problems later
					if(left(accountsRoot,1) neq "/") throw("All paths must be relative to the website root and start with '/'","coldBricks.validation");
					if(left(resourcesRoot,1) neq "/") throw("All paths must be relative to the website root and start with '/'","coldBricks.validation");
					if(right(accountsRoot,1) neq "/") accountsRoot = accountsRoot & "/";
					if(right(resourcesRoot,1) neq "/") resourcesRoot = resourcesRoot & "/";

					// copy application skeleton
					directoryCopy(expandPath(siteTemplatePath & "/default/appRoot"), expandPath(appRoot));

					if(bCreateAccountDir) {
						// copy accounts skeleton
						directoryCopy(expandPath(siteTemplatePath & "/default/accountsRoot"), expandPath(accountsRoot));
					}
	
					if(bCreateResourceDir) {
						// copy res library skeleton
						directoryCopy(expandPath(siteTemplatePath & "/default/resourcesRoot"), expandPath(resourcesRoot));
					}

				}		
				
				// replace tokens on copied files
				replaceTokens(appRoot & "/Application.cfc", name, appRoot, accountsRoot, resourcesRoot);
				
				// process all files in the config directory for Tokens
				qryDir = listDir(expandPath(appRoot & "/config"));
				for(i=1;i lte qryDir.recordCount;i=i+1) {
					if(qryDir.type[i] eq "file") {
						replaceTokens(appRoot & "/config/" & qryDir.name[i], name, appRoot, accountsRoot, resourcesRoot);
					}
				}

				// create site record for coldbricks
				siteID = oSiteDAO.save(id=0, siteName=name, path=appRoot, ownerUserID=oUser.getID(), createdDate=dateFormat(now(),"mm/dd/yyyy"), notes="");

				setMessage("info", "The new site has been created.");

				setNextEvent("ehGeneral.dspMain","loadSiteID=#siteID#");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSites.dspCreate","appRoot=#appRoot#&name=#name#");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSites.dspCreate");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doDelete" access="public" returntype="void">
		<cfscript>
			var siteID = getValue("siteID");
			var deleteFiles = getValue("deleteFiles", false);
			var oSiteDAO = 0;
			var qrySite = 0;
			
			try {			
				// get site information
				oSiteDAO = getService("DAOFactory").getDAO("site");
				qrySite = oSiteDAO.get(siteID);

				// make sure we are deleting something safe (if directory exists at all)
				if(qrySite.path neq "/" 
					and left(qrySite.path,6) neq "/homePortals/"
					and qrySite.path neq "/homePortals" 
					and left(qrySite.path,11) neq "/ColdBricks"
					and left(qrySite.path,1) eq "/" ) {
				} else {
					throw("You are trying to delete a restricted directory","coldBricks.validation");
				}

				// delete files (if requested and directory exists)
				if(isBoolean(deleteFiles) and deleteFiles and directoryExists( expandPath(qrySite.path))) {
					deleteDir( expandPath(qrySite.path) );
				}
				
				// delete from local datastore
				oSiteDAO.delete(siteID);
				
				setMessage("info", "Site deleted");
				setNextEvent("ehSites.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSites.dspDelete","siteID=#siteID#");
				
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSites.dspDelete");
			}
		</cfscript>	
	</cffunction>
	
	<cffunction name="doRegister" access="public" returntype="void">
		<cfscript>
			var appRoot = getValue("appRoot");
			var name = getValue("name");
			var oUser = getValue("oUser");

			var oSiteDAO = 0;
			var qrySiteCheck = 0;
			var siteID = 0;

			try {
				if(name eq "") throw("Site name cannot be empty","coldBricks.validation");
				if(appRoot eq "") throw("Application root cannot be empty","coldBricks.validation");

				// check if site is already registered in coldbricks
				oSiteDAO = getService("DAOFactory").getDAO("site");
				qrySiteCheck = oSiteDAO.search(siteName = name);
				if(qrySiteCheck.recordCount gt 0) 
					throw("There is already another site registered with the name '#name#', please select a different site name.","coldBricks.validation");

				// make sure the approot points to an existing directory
				if(not directoryExists(expandPath(appRoot))) 
					throw("The given application directory does not exist. If you wish to create a new site use the 'Create Site' option.","coldBricks.validation");

				// check that the directory is not a restricted one
				if(left(appRoot,11) eq "/ColdBricks") {
					throw("You are trying to use a restricted directory as the application root. Please select a different application root.","coldBricks.validation");
				}

				// check that the target directory points to a valid homeportals application
				if( Not (directoryExists(expandPath(appRoot & "/config"))
						and fileExists(expandPath(appRoot & "/config/homePortals-config.xml"))) )
					throw("The given application directory does not see,s point to a standard HomePortals application. Please check the directory and try again.","coldBricks.validation");

				// create site record for coldbricks
				siteID = oSiteDAO.save(id=0, siteName=name, path=appRoot, ownerUserID=oUser.getID(), createdDate=dateFormat(now(),"mm/dd/yyyy"), notes="");

				setMessage("info", "The site has been registered.");
				
				setNextEvent("ehGeneral.dspMain","loadSiteID=#siteID#");

				setNextEvent("ehSites.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehSites.dspRegister","appRoot=#appRoot#&name=#name#");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSites.dspRegister");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doArchiveSite" access="public" returntype="void">
		<cfset var siteID = getValue("siteID")>
		<cfset var oSiteDAO = 0>
		<cfset var qrySite = 0>
		<cfset var dataRoot = getSetting("dataRoot")>
		<cfset var archivesPath = dataRoot & "/archives">
		<cfset var zipFilePath = "">
		<cfset var zipFileName = "">
		<cfset var deleteAfterDownload = getSetting("deleteAfterArchiveDownload")>
		<cfset var oCF8Extras = 0>
		
		<cftry>
			<!--- get site information ---->
			<cfset oSiteDAO = getService("DAOFactory").getDAO("site")>
			<cfset qrySite = oSiteDAO.get(siteID)>
		
			<!--- make sure the directory exists --->
			<cfif not directoryExists(expandPath(qrySite.path))>
				<cfthrow message="The application directory does not exist!" type="coldBricks.validation">
			</cfif>
		
			<!--- make sure the archives directory exists --->
			<cfif not directoryExists(expandPath(archivesPath))>
				<cfdirectory action="create" directory="#expandPath(archivesPath)#">
			</cfif>
			
			<!--- set name --->
			<cfset zipFileName = qrySite.siteName & "_" & dateFormat(now(),"mmddyy") & "_" & timeFormat(now(),"hhmmss") & ".zip">
			<cfset zipFilePath = expandPath( archivesPath & "/" & zipFileName)>
			
			<!--- create zip file --->
			<cfset oCF8Extras = createObject("component","ColdBricks.components.services.cf8extras").init()>
			<cfset oCF8Extras.createZip(zipFilePath, expandPath(qrySite.path))>
		
			<!--- download file --->
			<cfheader name="content-disposition" value="inline; filename=#zipFileName#">
			<cfif deleteAfterDownload>
				<cfcontent file="#zipFilePath#" type="application/zip" deletefile="true">
			<cfelse>
				<cfcontent file="#zipFilePath#" type="application/zip">
			</cfif>
		
			<cfset setMessage("info","Archive of site #qrySite.siteName# has been created. Archive name: #zipFileName#")>
		
			<cfcatch type="coldBricks.validation">
				<cfset setMessage("warning",cfcatch.message)>
			</cfcatch>
			<cfcatch type="any">
				<cfset setMessage("error",cfcatch.message)>
				<cfset getService("bugTracker").notifyService(cfcatch.message, cfcatch)>
			</cfcatch>
		</cftry>
		
		<cfset setNextEvent("ehSites.dspMain")>
	</cffunction>

	<cffunction name="replaceTokens" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="appRoot" type="string" required="true">
		<cfargument name="accountsRoot" type="string" required="true">
		<cfargument name="resourcesRoot" type="string" required="true">
		<cfscript>
			var txtDoc = "";
			
			txtDoc = readFile(expandPath(arguments.path));
			txtDoc = replace(txtDoc, "$APP_NAME$", arguments.name, "ALL");
			txtDoc = replace(txtDoc, "$APP_ROOT$", arguments.appRoot, "ALL");
			txtDoc = replace(txtDoc, "$ACCOUNTS_ROOT$", arguments.accountsRoot, "ALL");
			txtDoc = replace(txtDoc, "$RESOURCES_ROOT$", arguments.resourcesRoot, "ALL");
			writeFile(expandPath(arguments.path), txtDoc);
		
		</cfscript>
	</cffunction>

	<cffunction name="writeFile" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cfargument name="content" type="string" required="true">
		<cffile action="write" file="#arguments.path#" output="#arguments.content#">
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

	<cffunction name="listDir" access="private" returntype="query">
		<cfargument name="path" type="string" required="true">
		<cfset var qry = queryNew("")>
		<cfdirectory action="list" directory="#arguments.path#" name="qry">
		<cfreturn qry>
	</cffunction>

</cfcomponent>	