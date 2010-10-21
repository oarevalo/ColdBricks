<cfparam name="request.requestState.errorInfo" default="">
<cfset errorInfo = request.requestState.errorInfo>

<strong style="color:red;">HomePortals Framework not found!</strong><br><br>

Please make sure you have the latest version of the HomePortals framework properly installed.<br><br>

<a href="http://www.homeportals.net/downloads.cfm" target="_blank">Click Here</a> to download the latest
version.

<cfoutput>
	<br /><br />
	<b>Error:</b>
	#errorInfo.message# #errorInfo.detail#
</cfoutput>