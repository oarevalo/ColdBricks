<cfset stAccessMap = getValue("oUser").getAccessMap()>

<cfif stAccessMap.sites>
	<div class="buttonImage btnLarge">
		<a href="index.cfm?event=sites.ehSites.dspCreate" title="Click here to create a new portal or site"><img src="images/folder_add.png" border="0" align="absmiddle">&nbsp; Create New Site</a>
	</div>	

	<div class="buttonImage btnLarge">
		<a href="index.cfm?event=sites.ehSites.dspRegister" title="Click here to register an existing portal or site in ColdBricks"><img src="images/folder_page.png" border="0" align="absmiddle">&nbsp; Register Site</a>
	</div>	
</cfif>
