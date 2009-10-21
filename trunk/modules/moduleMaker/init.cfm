<cfset getService("UIManager").registerSiteModule(name = "moduleMaker",
												href = "index.cfm?event=moduleMaker.ehModuleMaker.dspMain",
												imgSrc = "images/configure_48x48-2.png",
												alt = "Module Maker",
												label = "Module Maker",
												accessMapKey = "moduleMaker",
												description = "Create your own custom modules to add to your pages")>

<cfset getService("Permissions").addResource(id = "moduleMaker",
											event = "moduleMaker.ehModuleMaker.*",
											roles = "admin,mngr")>
											