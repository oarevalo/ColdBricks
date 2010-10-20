<cfset getService("UIManager").registerModule(name = "extensions",
												description = "Install and uninstall modules and site templates",
												version = "1.0",
												author = "ColdBricks",
												authorURL = "http://www.coldbricks.com")>
												
<cfset getService("UIManager").registerServerFeature(href = "index.cfm?event=extensions.ehGeneral.dspMain",
												imgSrc = "images/cb-blocks.png",
												alt = "Install/uninstall extensions",
												label = "Extensions Manager",
												accessMapKey = "extensions",
												description = "The Extensions Manager module lets you install and uninstall modules and site templates.")>

<cfset getService("Permissions").addResource(id = "extensions",
											event = "extensions.ehGeneral.*",
											roles = "admin")>
											