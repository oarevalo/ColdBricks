<cfcomponent extends="eventHandler">

	<cffunction name="dspMain">
		<cfscript>
			var oUserDAO = 0;
			var qryUsers = 0;
			
			try {
				oUserDAO = getService("DAOFactory").getDAO("user");
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
			var oUserDAO = 0;
			var oUserSiteDAO = 0;
			var oSiteDAO = 0;
			var qryUser = 0;
			var qryRoles = 0;
			var editUserID = getValue("editUserID",0);
			
			try {
				oUserDAO = getService("DAOFactory").getDAO("user");
				oUserSiteDAO = getService("DAOFactory").getDAO("userSite");
				oSiteDAO = getService("DAOFactory").getDAO("site");
				
				qryUser = oUserDAO.get(editUserID);
				qryUserSites = oUserSiteDAO.search(userID = editUserID);
				qrySites = oSiteDAO.getAll();
				qryRoles = getService("permissions").getRoles();

				setValue("qryUser",qryUser);
				setValue("qryUserSites",qryUserSites);
				setValue("qrySites",qrySites);
				setValue("qryRoles",qryRoles);
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
			var oUserDAO = 0;
			var oUserSiteDAO = 0;
			var editUserID = getValue("editUserID",0);
			var username = getValue("username","");
			var password = getValue("password","");
			var firstName = getValue("firstName","");
			var lastName = getValue("lastName","");
			var email = getValue("email","");
			var lstSiteID = getValue("lstSiteID","");
			var role = getValue("role","");
			
			try {
				oUserDAO = getService("DAOFactory").getDAO("user");
				oUserSiteDAO = getService("DAOFactory").getDAO("userSite");
				
				// validate record
				if(username eq "") throw("Username cannot be empty","coldBricks.validation");
				if(password eq "") throw("Password cannot be empty","coldBricks.validation");
				if(len(password) lt 5) throw("Password must be at least 5 characters long","coldBricks.validation");
				if(role eq "") throw("User role cannot be empty","coldBricks.validation");
				
				// save record
				editUserID = oUserDAO.save(id = editUserID,
											username = username,
											password = password,
											firstName = firstName,
											lastName = lastName,
											email = email,
											role = role
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
			var oUserDAO = 0;
			var editUserID = getValue("editUserID",0);
			
			try {
				oUserDAO = getService("DAOFactory").getDAO("user");
				
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