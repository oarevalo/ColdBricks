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
	
	<!--- 	<cfif arrayLen(tagInfo.properties) gt 0>
			<b><u>Properties:</u></b><br />
			<cfloop from="1" to="#arrayLen(tagInfo.properties)#" index="i">
				<cfset prop = tagInfo.properties[i]>
				<cfparam name="prop.name" default="property">
				<cfparam name="prop.hint" default="N/A">
				<strong>#prop.name#:</strong> #prop.hint#<br />
			</cfloop>
		</cfif> --->
	</div>
</cfoutput>
