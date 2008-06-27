<!--- footer --->
<cfparam name="request.requestState.versionTag" default="">
<cfset versionTag = request.requestState.versionTag>

<div id="footer">
	Copyright 2007-2008 - <a href="http://www.coldbricks.com">ColdBricks.com</a><br>
	<cfoutput>Version: <strong>#versionTag#</strong></cfoutput>
</div>