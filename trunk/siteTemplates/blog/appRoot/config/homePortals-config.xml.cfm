<?xml version="1.0" encoding="UTF-8"?>
<homePortals version="3.0">

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
		<resource href="$APP_ROOT$/includes/footer.cfm" type="footer"/>
	</baseResources>
	
</homePortals>
