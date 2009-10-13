<cfset getService("Permissions").addResource(id = "resource",
											event = "resource.ehResource.*",
											roles = "admin,mngr,edit,cont")>
											