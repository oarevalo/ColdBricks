<cfcomponent extends="eventHandler">

<cffunction name="onApplicationStart">
	<!--- setup data directory (if needed for xml data storage) --->
	<cfset checkDataRoot()>
</cffunction>

<cffunction name="onRequestStart">
	<!--- code to execute at the beginning of each request --->
	<cfscript>
		var appTitle = getSetting("applicationTitle", application.applicationName);
		var event = getEvent();
		var hostName = CreateObject("java", "java.net.InetAddress").getLocalHost().getHostName();
		var versionTag = getSetting("versionTag");
		var lstFreeEvents = "ehGeneral.doLogin,ehGeneral.dspLogin,ehGeneral.doRegister,ehGeneral.dspRegister";
		var firstRunDate = "";
		var ls = "";
		var isAllowed = true;
		var oUser = 0;
		var oContext = getService("sessionContext").getContext();
	
		// get user object in session (if exists)
		if(oContext.hasUser())
			oUser = oContext.getUser();
		else {
			oUser = createObject("component","ColdBricks.components.model.userBean").init();
			oContext.setUser(oUser);
		}
		

		try {
			// check for data directory
			checkDataRoot();
			
		} catch(any e) {
			writeOutput("Fatal Error. Cannot continue: " & e.message);
			getService("bugTracker").notifyService(e.message, e);
			abort();
		}
			
		try {
			// check login
			if(not listFindNoCase(lstFreeEvents,event) and (oUser.getID() eq 0 or oUser.getID() eq "")) {
				setMessage("Warning","Please enter your username and password");
				setNextEvent("ehGeneral.dspLogin");
			}

			// check authorization
			isAllowed = getService("permissions").isAllowed(event, oUser.getRole());
			if(not isAllowed) {
				setMessage("Warning","The requested action is restricted.");
				setNextEvent("ehGeneral.dspMain");
			}

			// set generally available values on the request context
			setValue("hostName", hostName);
			setValue("applicationTitle", appTitle);
			setValue("oUser", oUser);
			setValue("versionTag", versionTag);
			setValue("oContext", oContext);

		} catch(any e) {
			setMessage("error",e.message);
			getService("bugTracker").notifyService(e.message, e);
		}
	</cfscript>
</cffunction>

<cffunction name="onRequestEnd">
	<!--- code to execute at the end of each request --->
</cffunction>


<cffunction name="dspLogin">
	<cfscript>
		setView("vwLogin");
		setLayout("layout.clean");
	</cfscript>
</cffunction>

<cffunction name="dspMain">
	<cfscript>
		var oSiteDAO = 0;
		var oUserDAO = 0;
		var qrySites = 0;
		var oUser = getValue("oUser");
		var aPlugins = arrayNew(1);

		try {
			// if this is a regular user then go to sites screen
			if(not oUser.getIsAdministrator()) 	setNextEvent("ehSites.dspMain");

			oSiteDAO = getService("DAOFactory").getDAO("site");
			oUserSiteDAO = getService("DAOFactory").getDAO("userSite");
			
			qrySites = oSiteDAO.getAll();
			qryUserSites = oUserSiteDAO.search(userID = oUser.getID());

			aPlugins = getService("plugins").getPluginsByType("admin");

			setValue("qrySites",qrySites);
			setValue("qryUserSites",qryUserSites);
			setValue("aPlugins",aPlugins);
			setView("vwMain");
		
		} catch(any e) {
			setMessage("error",e.message);
			getService("bugTracker").notifyService(e.message, e);
			setView("");
		}
	</cfscript>
</cffunction>

<cffunction name="dspChangePassword">
	<cfset setView("vwChangePassword")>
</cffunction>

<cffunction name="dspHomePortalsCheck">
	<cfscript>
		var oHomePortals = 0;
		
		setLayout("Layout.None");
		
		try {
			// check existence of homeportals engine
			oHomePortals = createObject("Component","Home.Components.homePortals").init();
			
			setValue("hpVersion", oHomePortals.getConfig().getVersion());
				
			setView("vwHomePortalsCheck");		
		} catch(any e) {
			setView("vwHomePortalsCheckError");		
		}
	</cfscript>
</cffunction>

<cffunction name="doLogin">
	<cfset var usr = getValue("usr")>
	<cfset var pwd = getValue("pwd")>
	<cfset var oUserDAO = 0>
	<cfset var oUser = 0>
	<cfset var oContext = 0>

	<cfscript>
		try {
			oUserDAO = getService("DAOFactory").getDAO("user");

			qry = oUserDAO.search(username = usr, password = pwd);

			if(qry.recordCount eq 0) 
				throw("Invalid username/password","coldBricks.validation");
			else {
				oUser = createObject("component","ColdBricks.components.model.userBean").init();
				oUser.setID(qry.userID);
				oUser.setRole("user");
				oUser.setFirstName(qry.firstName);
				oUser.setLastName(qry.lastName);
				oUser.setUsername(qry.username);
				oUser.setPassword(qry.password);
				oUser.setEmail(qry.email);
				oUser.setIsAdministrator(qry.administrator);
				if(qry.administrator) oUser.setRole( listAppend(oUser.getRole(),"admin") );
				
				oContext = getService("sessionContext").getContext();
				oContext.setUser(oUser);
			}

			setNextEvent("ehGeneral.dspMain");
		
		} catch(coldBricks.validation e) {
			setMessage("warning",e.message);
			setNextEvent("ehGeneral.dspLogin");

		} catch(any e) {
			setMessage("error",e.message);
			getService("bugTracker").notifyService(e.message, e);
			setNextEvent("ehGeneral.dspLogin");
		}			
	</cfscript>
</cffunction>

<cffunction name="doLogoff">
	<cfset getService("sessionContext").flushContext()>
	<cfset setNextEvent("ehGeneral.dspMain")>
</cffunction>

<cffunction name="doChangePassword">
	<cfscript>
		var oUserDAO = 0;
		var oUser = getValue("oUser");
		var curr_pwd = getValue("curr_pwd","");
		var new_pwd = getValue("new_pwd","");
		var new_pwd2 = getValue("new_pwd2","");
		
		try {
			oUserDAO = getService("DAOFactory").getDAO("user");
			
			// validate record
			if(curr_pwd neq oUser.getPassword()) throw("Invalid password","coldBricks.validation");
			if(new_pwd neq new_pwd2) throw("Password confirmation did not match","coldBricks.validation");
			if(len(new_pwd) lt 5) throw("Password must be at least 5 characters long","coldBricks.validation");
			
			// save record
			oUserDAO.save(id = oUser.getID(),
							password = new_pwd
							);

			getService("sessionContext").getContext().setUser( oUser.setPassword(new_pwd) );

			setMessage("info","Your password has been changed. You must log-in again for changes to take effect");
		
		} catch(coldBricks.validation e) {
			setMessage("warning",e.message);
			setNextEvent("ehGeneral.dspChangePassword");

		} catch(any e) {
			setMessage("error",e.message);
			getService("bugTracker").notifyService(e.message, e);
			setNextEvent("ehGeneral.dspChangePassword");
		}

		setNextEvent("ehGeneral.dspMain");
	</cfscript>				
</cffunction>

<cffunction name="setupDataDirectory" access="private" returntype="void">
	<cfargument name="dataRoot" type="string" required="true">
	<cfset var tmpFile = "">
	<cfset var pathSeparator =  createObject("java","java.lang.System").getProperty("file.separator")>
	
	<!--- check for invalid names --->
	<cfif listFindNoCase("/,/Home,/ColdBricks",arguments.dataRoot) or arguments.dataRoot eq "">
		<cfthrow message="The dataRoot property is invalid." type="ColdBricks.setup.invalidDataRoot">
	</cfif>
	
	<cfif not directoryExists(expandPath(arguments.dataRoot))>
		<!--- create data directory --->
		<cfdirectory action="create" directory="#expandPath(arguments.dataRoot)#">
		
		<!--- add application.cfm file to block direct access --->
		<cfset tmpFile = expandPath(arguments.dataRoot) & pathSeparator & "Application.cfm">
		<cffile action="write" file="#tmpFile#" output="<cfabort>">
				
		<!--- initialize data files --->
		<cfinclude template="/ColdBricks/includes/initData.cfm">
	</cfif>
</cffunction>

<cffunction name="checkDataRoot" access="private" returntype="void">
	<cfscript>
		var dataRoot = getSetting("dataRoot");
		
		if(not directoryExists(expandPath(dataRoot))) {
			setupDataDirectory(dataRoot);
			redirect("index.cfm");
		}
	</cfscript>
</cffunction>

</cfcomponent>