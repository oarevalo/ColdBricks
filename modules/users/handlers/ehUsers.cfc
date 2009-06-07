<cfcomponent extends="ColdBricks.handlers.ehColdBricks">

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var oUserDAO = 0;
			var qryUsers = 0;
			
			try {
				oUserDAO = getService("DAOFactory").getDAO("user");
				qryUsers = oUserDAO.getAll();
				qryRoles = getService("permissions").getRoles();

				setValue("qryUsers",qryUsers);
				setValue("qryRoles",qryRoles);
				setValue("cbPageTitle", "User Management");
				setValue("cbPageIcon", "images/users_48x48.png");
				
				setView("vwMain");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");
			}
		</cfscript>	
	</cffunction>
	
	<cffunction name="dspEdit" access="public" returntype="void">
		<cfscript>
			var oUserDAO = 0;
			var oUserSiteDAO = 0;
			var oSiteDAO = 0;
			var qryUser = 0;
			var qryRoles = 0;
			var editUserID = getValue("editUserID",0);
			
			try {
				oUserDAO = getService("DAOFactory").getDAO("user");
				oSiteDAO = getService("DAOFactory").getDAO("site");
				oUserSiteDAO = getService("DAOFactory").getDAO("userSite");
				
				qryUser = oUserDAO.get(editUserID);
				qrySites = oSiteDAO.getAll();
				qryUserSites = oUserSiteDAO.search(userID = editUserID);
				qryRoles = getService("permissions").getRoles();

				setValue("qryUser",qryUser);
				setValue("qrySites",qrySites);
				setValue("qryUserSites",qryUserSites);
				setValue("qryRoles",qryRoles);
				setValue("cbPageTitle", "User Management");
				setValue("cbPageIcon", "images/users_48x48.png");

				setView("vwEdit");
			
			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="doSave" access="public" returntype="void">
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
			var qry = 0;
			
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
				qry = oUserSiteDAO.search(userID = editUserID);
				if(qry.recordCount gt 0) {
					for(i=1;i lte qry.recordCount;i=i+1) {
						oUserSiteDAO.delete( qry.userSiteID[i] );
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
				setNextEvent("users.ehUsers.dspEdit","editUserID=#editUserID#&username=#username#&firstName=#firstName#&lastName=#lastName#&email=#email#&password=#password#&administrator=#administrator#");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("users.ehUsers.dspEdit","editUserID=#editUserID#");
			}

			setNextEvent("users.ehUsers.dspMain");
		</cfscript>		
	</cffunction>

	<cffunction name="doDelete" access="public" returntype="void">
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

			setNextEvent("users.ehUsers.dspMain");
		</cfscript>				
	</cffunction>

</cfcomponent>	