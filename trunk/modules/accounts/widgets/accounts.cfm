<cfset oContext = getService("sessionContext").getContext()>
<cfset hp = oContext.getHomePortals()>
<cfset stAccessMap = getValue("oUser").getAccessMap()>

<cfif not(hp.getPluginManager().hasPlugin("accounts") and stAccessMap.accounts)>
	<cfexit method="exittemplate">
</cfif>

<cfscript>
	oAccService = getAccountsService();
	qryAccounts = oAccService.search();
	defaultAccount = oAccService.getConfig().getDefaultAccount();
</cfscript>

<cfoutput>
	<strong>No of Accounts:</strong> #qryAccounts.recordCount#<br><br>
	<strong>Default Account:</strong> #defaultAccount#<br><br>
	<img src="images/add.png" align="absmiddle"> <a href="index.cfm?event=accounts.ehAccounts.dspCreate"> Create Account</a>
</cfoutput>