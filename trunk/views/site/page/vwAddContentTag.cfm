<cfparam name="request.requestState.tagInfo" default="">
<cfparam name="request.requestState.tag" default="">
<cfparam name="request.requestState.aLayoutregions" default="#arrayNew(1)#">
<cfparam name="request.requestState.id" default="">
<cfparam name="request.requestState.title" default="">

<cfset tagInfo = request.requestState.tagInfo>
<cfset tag = request.requestState.tag>
<cfset aLayoutregions = request.requestState.aLayoutregions>
<cfset id = request.requestState.id>
<cfset title = request.requestState.title>

<cfparam name="tagInfo.hint" default="<em>No description found</em>">
<cfparam name="tagInfo.properties" default="#arrayNew(1)#">

<cfoutput>
	<div style="margin:5px;">
		<b>Name:</b> #tag#
	
		<cfif tagInfo.hint neq "">
			<p>#tagInfo.hint#</p>
		</cfif>
	
		<table>
			<tr>
				<td><b>ID:</b></td>
				<td><input type="text" name="id" value="#id#" class="formField"></td>
			</tr>
			<tr>
				<td><b>Title:</b></td>
				<td><input type="text" name="title" value="#title#" class="formField"></td>
			</tr>
			<tr>
				<td><b>Container?:</b></td>
				<td>
					<input type="checkbox" name="container" 
							style="border:0px;width:15px;"
							value="true" 
							checked="true">
				</td>
			</tr>
			<tr>
				<td><b>Location:</b></td>
				<td>
					<select name="location" class="formField">
						<cfloop from="1" to="#arrayLen(aLayoutregions)#" index="i">
							<option value="#aLayoutregions[i].name#">#aLayoutregions[i].name# (#aLayoutregions[i].type#)</option>
						</cfloop>
					</select>
				</td>
			</tr>
		</table>
		<cfif arrayLen(tagInfo.properties) gt 0>
			<b><u>Properties:</u></b><br />
			<cfloop from="1" to="#arrayLen(tagInfo.properties)#" index="i">
				<cfset prop = tagInfo.properties[i]>
				<cfparam name="prop.name" default="property">
				<cfparam name="prop.hint" default="N/A">
				<strong>#prop.name#:</strong> #prop.hint#<br />
			</cfloop>
		</cfif> 
	</div>
</cfoutput>
