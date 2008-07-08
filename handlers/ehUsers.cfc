<cfcomponent extends="eventHandler">

	<cffunction name="dspMain">
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
			var aPlugins = arrayNew(1);
			
			try {
				oUserDAO = getService("DAOFactory").getDAO("user");
				oSiteDAO = getService("DAOFactory").getDAO("site");
				oUserSiteDAO = getService("DAOFactory").getDAO("userSite");
				oUserPluginDAO = getService("DAOFactory").getDAO("userPlugin");
				
				qryUser = oUserDAO.get(editUserID);
				qrySites = oSiteDAO.getAll();
				qryUserSites = oUserSiteDAO.search(userID = editUserID);
				qryUserPlugins = oUserPluginDAO.search(userID = editUserID);
				qryRoles = getService("permissions").getRoles();
				aPlugins = getService("plugins").getPlugins();

				setValue("qryUser",qryUser);
				setValue("qrySites",qrySites);
				setValue("qryUserSites",qryUserSites);
				setValue("qryUserPlugins",qryUserPlugins);
				setValue("qryRoles",qryRoles);
				setValue("aPlugins",aPlugins);
				setValue("cbPageTitle", "User Management");
				setValue("cbPageIcon", "images/users_48x48.png");

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
			var oUserPluginDAO = 0;
			var editUserID = getValue("editUserID",0);
			var username = getValue("username","");
			var password = getValue("password","");
			var firstName = getValue("firstName","");
			var lastName = getValue("lastName","");
			var email = getValue("email","");
			var lstSiteID = getValue("lstSiteID","");
			var lstPluginID = getValue("lstPluginID","");
			var role = getValue("role","");
			var qry = 0;
			
			try {
				oUserDAO = getService("DAOFactory").getDAO("user");
				oUserSiteDAO = getService("DAOFactory").getDAO("userSite");
				oUserPluginDAO = getService("DAOFactory").getDAO("userPlugin");
				
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
			
				// save plugins
				qry = oUserPluginDAO.search(userID = editUserID);
				if(qry.recordCount gt 0) {
					for(i=1;i lte qry.recordCount;i=i+1) {
						oUserPluginDAO.delete( qry.userPluginID[i] );
					}
				}
	
				if(lstPluginID neq "") {
					for(i=1;i lte listLen(lstPluginID);i=i+1) {
						oUserPluginDAO.save( id = "",
											userID = editUserID,
											pluginID = listGetAt(lstPluginID,i) );
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