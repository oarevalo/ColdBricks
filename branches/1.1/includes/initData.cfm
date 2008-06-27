<cfscript>
	oDataProvider = application.oDataProvider;
	
	oHelpDAO = createObject("component","ColdBricks.components.model.helpDAO").init(oDataProvider);
	oMiscDAO = createObject("component","ColdBricks.components.model.miscDAO").init(oDataProvider);
	oSiteDAO = createObject("component","ColdBricks.components.model.siteDAO").init(oDataProvider);
	oUserDAO = createObject("component","ColdBricks.components.model.userDAO").init(oDataProvider);

	// config files --->
	oHelpDAO.save(id="", name="homePortals-config.xml", description="This is the main configuration file for a HomePortals application. In addition of the main homeportals-config.xml file in the /Home/ directory, each application must have its own homePortals-config.xml to override only the settings needed for that particular application.");
	oHelpDAO.save(id="", name="accounts-config.xml.cfm", description="Describes settings related to the storage and operation of accounts. Each application must have its own accounts-config.xml file.");
	oHelpDAO.save(id="", name="module-properties.xml", description="Properties especific to a given module. See individual module documentation to see which properties it uses and their purpose. Settings defined on this file are per-application only");
	oHelpDAO.save(id="", name="module.xml", description="This file provides a template of the HTML used when rendering modules on a page. The HomePortals engine replaces the following tokens at runtime: $MODULE_ID$, $MODULE_ICON$, $MODULE_TITLE$, $MODULE_STYLE$ and $MODULE_CONTENT$");
	oHelpDAO.save(id="", name="moduleNoContainer.xml", description="This file provides a template of the HTML used when rendering modules that have their 'Container' property set to false. HomePortals replaces the following tokens at runtime: $MODULE_ID$, $MODULE_ICON$, $MODULE_TITLE$, $MODULE_STYLE$ and $MODULE_CONTENT$");
	oHelpDAO.save(id="", name="page.xml", description="This file provides the template of the HTML used by the HomePortals engine when rendering a page. The following tokens are available: $PAGE_TITLE$, $PAGE_HTMLHEAD$, $PAGE_ONLOAD$, $PAGE_LAYOUTSECTION[sec][tag]$, $PAGE_CUSTOMSECTION[sec]$");
	oHelpDAO.save(id="", name="default.xml", description="This file is used as a template when creating a new account. The contents of this file are used as the body of the initial page of the new account. Uses $USERNAME$ as token for the new user's username");
	oHelpDAO.save(id="", name="newPage.xml", description="A template used when adding new pages to an account.  Uses $USERNAME$ as token for the new user's username");
	oHelpDAO.save(id="", name="site.xml", description="A template used for the site descriptor when creating a new account. Uses $USERNAME$ as token for the new user's username");

	// resource types --->
	oHelpDAO.save(id="", name="rt_module", description="Modules are reusable components that allow you page to perform particular tasks. Modules act as mini applications that can do things like displaying calendars, blogs, rss feed contents, etc.");
	oHelpDAO.save(id="", name="rt_content", description="Content resources are blocks of formatted text that can be reused across a site");
	oHelpDAO.save(id="", name="rt_feed", description="Feeds are either RSS or Atom feeds from external sources that you can use with feed-enabled modules to display their contents on your site");
	oHelpDAO.save(id="", name="rt_skin", description="Skins are a way to customize the look and feel of a page. Skins dictate things like colors, fonts, margins and other visual attributes of the page");
	oHelpDAO.save(id="", name="rt_page", description="Page resources are complete pages that you can import to your site");
	oHelpDAO.save(id="", name="rt_pageTemplate", description="A Page Template is a template or pre-defined layout for a page, applying a page template to an existing page can override the layout or section ordering of the page without affecting its contents");
	oHelpDAO.save(id="", name="rt_html", description="HTML resources are blocks of HTML code that can be incorporated into a page. These resources are ideal for adding external widgets into a page.");
	
	// misc data
	oMiscDAO.save(id="", name="fr", value="1-2-3456");

	// user data
	userID = oUserDAO.save(id="", username="admin", firstName="Administrator", lastName="", administrator=1, password="admin", email="info@coldbricks.com");

	// sites data
	oSiteDAO.save(id="", path="/Home", ownerUserID=userID, siteName="HomePortalsEngine", createdDate=dateFormat(now(),"mm/dd/yyyy"), notes="");
</cfscript>
