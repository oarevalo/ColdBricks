<?xml version="1.0" encoding="UTF-8"?>
<homePortals>

	<appRoot>$APP_ROOT$</appRoot>
	<contentRoot>$CONTENT_ROOT$</contentRoot>
	<resourceLibraryPaths>
		<resourceLibraryPath>$RESOURCES_ROOT$</resourceLibraryPath>
	</resourceLibraryPaths>
	<defaultPage></defaultPage>
	<plugins>
		<plugin name="accounts" path="homePortalsAccounts.components.accountsPlugin" />
		<plugin name="modules" path="homePortalsModules.components.modulesPlugin" />
	</plugins>
	<baseResources>
		<resource href="$APP_ROOT$includes/controlPanel.js" type="script"/>
		<resource href="$APP_ROOT$includes/header.cfm" type="header"/>
		<resource href="$APP_ROOT$includes/footer.cfm" type="footer"/>
		<resource href="$APP_ROOT$includes/coordinates.js" type="script" />
		<resource href="$APP_ROOT$includes/drag.js" type="script" />
		<resource href="$APP_ROOT$includes/dragdrop.js" type="script" />
	</baseResources>
	<renderTemplates>
		<renderTemplate name="page" type="page" href="$APP_ROOT$/Config/page.xml" />
	</renderTemplates>
	
</homePortals>