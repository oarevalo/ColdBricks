<cfset appRoot = getService("sessionContext").getContext().getHomePortals().getConfig().getAppRoot()>

<cfif appRoot eq "/">
	<cfset tmpAppRoot = "">
<cfelse>
	<cfset tmpAppRoot = appRoot>
</cfif>

<div class="buttonImage btnLarge">
	<a href="#appRoot#" target="_blank" title="Open site in a different window"><img src="images/magnifier.png" border="0" align="absmiddle"> Preview Site</a>
</div>	

<div class="buttonImage btnLarge">
	<a href="#tmpAppRoot#/index.cfm?resetApp=1" target="_blank" title="Open the site reloading site settings"><img src="images/arrow_refresh.png" border="0" align="absmiddle"> Reset Site</a>
</div>	
