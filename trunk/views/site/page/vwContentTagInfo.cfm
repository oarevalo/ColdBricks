<cfparam name="request.requestState.tagInfo" default="">
<cfparam name="request.requestState.tag" default="">
<cfset tagInfo = request.requestState.tagInfo>
<cfset tag = request.requestState.tag>

<cfparam name="tagInfo.hint" default="<em>No description found</em>">
<cfparam name="tagInfo.properties" default="#arrayNew(1)#">

<cfoutput>
	<div style="margin:5px;">
		<b>Name:</b> #tag#
	
		<cfif tagInfo.hint neq "">
			<p>#tagInfo.hint#</p>
		</cfif>
	</div>
</cfoutput>
