<cfparam name="request.requestState.siteID" default="">
<cfparam name="request.requestState.qrySite" default="">
<cfset siteID = request.requestState.siteID>
<cfset qrySite = request.requestState.qrySite>

<cfoutput>
<form name="frm" method="post" action="index.cfm">
	<input type="hidden" name="event" value="ehSites.doDelete">
	<input type="hidden" name="siteID" value="#siteID#">
	
	<p style="font-size:14px;line-height:21px;">
		Are you sure you wish to delete the site <b>#qrysite.siteName#</b> and all its related files? <br>
		<b style="color:red;">This action is not reversible!</b>
	</p>
	
	<p>
		<input type="submit" name="btnGo" value="Yes, delete site">
		&nbsp;
		<a href="index.cfm?event=ehSites.dspMain">No, do not delete site</a>
	</p>
</form>
</cfoutput>