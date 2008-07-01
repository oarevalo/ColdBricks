<cfparam name="request.requestState.viewTemplatePath" default="">

<!--- this is to avoid caching --->
<meta http-equiv="Expires" content="0">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<cfheader name="Expires" value="0">
<cfheader name="Pragma" value="no-cache">
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">

<cfinclude template="../includes/message.cfm">

<cfif request.requestState.viewTemplatePath neq "">
	<cfinclude template="#request.requestState.viewTemplatePath#">
</cfif>
