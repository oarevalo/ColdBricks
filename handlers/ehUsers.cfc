<cfcomponent extends="eventHandler">

	<cffunction name="dspMain">
		<cfscript>
			var oDataProvider = 0;
			var oUserDAO = 0;
			var qryUsers = 0;
			
			try {
				oDataProvider = application.oDataProvider;
				oUserDAO = createObject("component","ColdBricks.components.model.userDAO").init(oDataProvider);
				qryUsers = oUserDAO.getAll();

				setValue("qryUsers",qryUsers);
				setView("users/vwMain");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");
			}
		</cfscript>	
	</cffunction>
	
	<cffunction name="dspEdit">
		<cfscript>
			var oDataProvider = 0;
			var oUserDAO = 0;
			var qryUser = 0;
			var editUserID = getValue("editUserID",0);
			
			try {
				oDataProvider = application.oDataProvider;
				oUserDAO = createObject("component","ColdBricks.components.model.userDAO").init(oDataProvider);
				oUserSiteDAO = createObject("component","ColdBricks.components.model.userSiteDAO").init(oDataProvider);
				oSiteDAO = createObject("component","ColdBricks.components.model.siteDAO").init(oDataProvider);
				
				qryUser = oUserDAO.get(editUserID);
				qryUserSites = oUserSiteDAO.search(userID = editUserID);
				qrySites = oSiteDAO.getAll();

				setValue("qryUser",qryUser);
				setValue("qryUserSites",qryUserSites);
				setValue("qrySites",qrySites);
				setView("users/vwEdit");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doSave">
		<cfscript>
			var oDataProvider = 0;
			var oUserDAO = 0;
			var editUserID = getValue("editUserID",0);
			var username = getValue("username","");
			var password = getValue("password","");
			var firstName = getValue("firstName","");
			var lastName = getValue("lastName","");
			var email = getValue("email","");
			var administrator = getValue("administrator",0);
			var lstSiteID = getValue("lstSiteID","");
			
			try {
				oDataProvider = application.oDataProvider;
				oUserDAO = createObject("component","ColdBricks.components.model.userDAO").init(oDataProvider);
				oUserSiteDAO = createObject("component","ColdBricks.components.model.userSiteDAO").init(oDataProvider);
				
				// validate record
				if(username eq "") throw("Username cannot be empty","coldBricks.validation");
				if(password eq "") throw("Password cannot be empty","coldBricks.validation");
				if(len(password) lt 5) throw("Password must be at least 5 characters long","coldBricks.validation");
				
				// save record
				editUserID = oUserDAO.save(id = editUserID,
											username = username,
											password = password,
											firstName = firstName,
											lastName = lastName,
											email = email,
											administrator = administrator
											);

				// save sites
				qryUserSites = oUserSiteDAO.search(userID = editUserID);
				if(qryUserSites.recordCount gt 0) {
					for(i=1;i lte qryUserSites.recordCount;i=i+1) {
						oUserSiteDAO.delete( qryUserSites.userSiteID[i] );
					}
				}
	
				if(lstSiteID neq "") {
					for(i=1;i lte listLen(lstSiteID);i=i+1) {
						oUserSiteDAO.save( id = "",
										userID = editUserID,
										siteID = listGetAt(lstSiteID,i) );
					}
				}
			
				setMessage("info","User information saved");
			
			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehUsers.dspEdit","editUserID=#editUserID#&username=#username#&firstName=#firstName#&lastName=#lastName#&email=#email#&password=#password#&administrator=#administrator#");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehUsers.dspEdit","editUserID=#editUserID#");
			}

			setNextEvent("ehUsers.dspMain");
		</cfscript>		
	</cffunction>

	<cffunction name="doDelete">
		<cfscript>
			var oDataProvider = 0;
			var oUserDAO = 0;
			var editUserID = getValue("editUserID",0);
			
			try {
				oDataProvider = application.oDataProvider;
				oUserDAO = createObject("component","ColdBricks.components.model.userDAO").init(oDataProvider);
				
				// save record
				oUserDAO.delete(editUserID);

				setMessage("info","User deleted");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}

			setNextEvent("ehUsers.dspMain");
		</cfscript>				
	</cffunction>

</cfcomponent>	