<cfparam name="request.requestState.tagInfo" default="">
<cfset tagInfo = request.requestState.tagInfo>

<cfoutput>
	<cfloop collection="#taginfo#" item="fld">
		<cfif isSimpleValue(tagInfo[fld])>
			<b>#fld#:</b> #tagInfo[fld]#<br />
		</cfif>
	</cfloop>
</cfoutput>
