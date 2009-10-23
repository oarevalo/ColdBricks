<cfparam name="request.requestState.hpVersion" default="">
<cfset hpVersion = request.requestState.hpVersion>

<cfoutput>
	<strong style="color:green;">HomePortals Framework detected.</strong><br><br>
	Version: #hpVersion#
	<br><br>
	<a href="http://www.homeportals.net/checkVersion.cfm?ver=#hpVersion#" target="_blank">Check For Updates</a>
</cfoutput>
