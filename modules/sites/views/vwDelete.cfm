<cfparam name="request.requestState.siteID" default="">
<cfparam name="request.requestState.qrySite" default="">
<cfset siteID = request.requestState.siteID>
<cfset qrySite = request.requestState.qrySite>

<cfoutput>
<form name="frm" method="post" action="index.cfm">
	<input type="hidden" name="event" value="sites.ehSites.doDelete">
	<input type="hidden" name="siteID" value="#siteID#">
	
	<p style="font-size:14px;line-height:21px;">
		Are you sure you wish to delete the site <b>#qrysite.siteName#</b><br>
	</p>
	
	<p>
		<input type="checkbox" name="deleteFiles" value="true" checked="true"> Delete site files on server?
		&nbsp;&nbsp;&nbsp;
		<b style="color:red;">This action is not reversible!</b>
	</p>
	<br />
	<p>
		<input type="submit" name="btnGo" value="Yes, delete site">
		&nbsp;
		<a href="index.cfm?event=sites.ehSites.dspMain">No, do not delete site</a>
	</p>
</form>
</cfoutput>