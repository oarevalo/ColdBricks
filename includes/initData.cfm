<cfscript>
	oHelpDAO = getService("DAOFactory").getDAO("help");
	oMiscDAO = getService("DAOFactory").getDAO("misc");
	oSiteDAO = getService("DAOFactory").getDAO("site");
	oUserDAO = getService("DAOFactory").getDAO("user");

	// config files --->
	oHelpDAO.save(id="", name="homePortals-config.xml", description="This is the main configuration file for a HomePortals application. In addition of the main homeportals-config.xml file in the /homePortals/ directory, each application must have its own homePortals-config.xml to override only the settings needed for that particular application.");
	oHelpDAO.save(id="", name="accounts-config.xml.cfm", description="Describes settings related to the storage and operation of accounts. Each application must have its own accounts-config.xml file.");
	oHelpDAO.save(id="", name="module-properties.xml", description="Properties especific to a given module. See individual module documentation to see which properties it uses and their purpose. Settings defined on this file are per-application only");
	oHelpDAO.save(id="", name="module.xml", description="This file provides a template of the HTML used when rendering modules on a page. The HomePortals engine replaces the following tokens at runtime: $MODULE_ID$, $MODULE_ICON$, $MODULE_TITLE$, $MODULE_STYLE$ and $MODULE_CONTENT$");
	oHelpDAO.save(id="", name="moduleNoContainer.xml", description="This file provides a template of the HTML used when rendering modules that have their 'Container' property set to false. HomePortals replaces the following tokens at runtime: $MODULE_ID$, $MODULE_ICON$, $MODULE_TITLE$, $MODULE_STYLE$ and $MODULE_CONTENT$");
	oHelpDAO.save(id="", name="page.xml", description="This file provides the template of the HTML used by the HomePortals engine when rendering a page. The following tokens are available: $PAGE_TITLE$, $PAGE_HTMLHEAD$, $PAGE_ONLOAD$, $PAGE_LAYOUTSECTION[sec][tag]$, $PAGE_CUSTOMSECTION[sec]$");
	oHelpDAO.save(id="", name="default.xml", description="This file is used as a template when creating a new account. The contents of this file are used as the body of the initial page of the new account. Uses $USERNAME$ as token for the new user's username");
	oHelpDAO.save(id="", name="newPage.xml", description="A template used when adding new pages to an account.  Uses $USERNAME$ as token for the new user's username");
	
	// misc data
	oMiscDAO.save(id="", name="fr", value="1-2-3456");

	// user data
	userID = oUserDAO.save(id="", username="admin", firstName="Administrator", lastName="", role="admin", password="admin", email="youremail@yourdomain.com");

	// sites data
	oSiteDAO.save(id="", path="/homePortals", ownerUserID=userID, siteName="HomePortalsEngine", createdDate=dateFormat(now(),"mm/dd/yyyy"), notes="");
</cfscript>
