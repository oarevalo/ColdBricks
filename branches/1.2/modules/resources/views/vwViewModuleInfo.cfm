<cfparam name="request.requestState.oResourceBean" default="">
<cfparam name="request.requestState.id" default="">

<cfset oResourceBean = request.requestState.oResourceBean>
<cfset id = request.requestState.id>

<cfoutput>
<div style="border:1px dashed ##ccc;height:440px;overflow:auto;">	
<table width="98%" style="margin-top:0px;margin-bottom:0px;">
	<tr valign="top">
		<td>
			<h1 style="margin-top:0px;">#oResourceBean.getid()#</h1>
		</td>
		<td align="right" style="font-size:10px;">
			<strong>Name:</strong> #oResourceBean.getpackage()#/#oResourceBean.getid()#<br>
			<strong>Access:</strong> #oResourceBean.getaccesstype()#<br>
			<strong>Package:</strong> #oResourceBean.getpackage()#
		</td>
	</tr>
</table>

<h2 style="margin-top:0px;" class="title">Description:</h2>
#oResourceBean.getdescription()#

<cfset aResources = oResourceBean.getIndex()>
<cfif arrayLen(aResources) gt 0>
	<h2 class="title">Resources:</h2>
	<ul style="margin-left:20px;">
		<cfloop from="1" to="#arrayLen(aResources)#" index="i">
			<cfset tmpNode = aResources[i]>
			<li>[#tmpNode.type#] &nbsp;-&nbsp; <a href="#tmpNode.href#" target="_blank">#tmpNode.href#</a></li>
		</cfloop>
	</ul>
</cfif>

<cfset aAttributes = oResourceBean.getAttributes()>
	<cfif arrayLen(aAttributes) gt 0>
	<h2 class="title">Attributes:</h2>
	<table class="tblGrid tblModProps" align="center">
		<tr>
			<th width="10">&nbsp;</th>
			<th>Name</th>
			<th>&nbsp;Req.&nbsp;</th>
			<th>&nbsp;Type&nbsp;</th>
			<th>&nbsp;Default&nbsp;</th>
			<th>Description</th>
		</tr>
		<cfloop from="1" to="#arrayLen(aAttributes)#" index="i">
			<cfset tmpNode = aAttributes[i]>
			<cfparam name="tmpNode.name" default="">
			<cfparam name="tmpNode.required" default="false">
			<cfparam name="tmpNode.default" default="">
			<cfparam name="tmpNode.type" default="">
			<cfparam name="tmpNode.resourcetype" default="">
			<cfparam name="tmpNode.description" default="">
			<cfparam name="tmpNode.values" default="">
			<tr>
				<td><strong>#i#</strong></td>
				<td>#tmpNode.name#</td>
				<td align="center">#YesNoFormat(tmpNode.required)#</td>
				<td align="center">
					#tmpNode.type#
					<cfif tmpNode.type eq "resource" or tmpNode.type eq "resourceOnly"><br>[#tmpNode.resourceType#]</cfif>
				</td>
				<td align="center">#tmpNode.default#</td>
				<td>
					#tmpNode.description#
					<cfif tmpNode.type eq "list" and tmpNode.values neq "">
						<br><em><b>Possible Values:</b> #tmpNode.values#</em>
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
</cfif>

<cfset aListeners = oResourceBean.getEventListeners()>
	<cfif arrayLen(aListeners) gt 0>
	<h2 class="title">Event Listeners:</h2>
	<table class="tblGrid tblModProps" align="center">
		<tr>
			<th width="10">&nbsp;</th>
			<th>Object Name</th>
			<th>Event Name</th>
			<th>Event Handler</th>
		</tr>
		<cfloop from="1" to="#arrayLen(aListeners)#" index="i">
			<cfset tmpNode = aListeners[i]>
			<cfparam name="tmpNode.objectName" default="">
			<cfparam name="tmpNode.eventName" default="">
			<cfparam name="tmpNode.eventHandler" default="">
			<tr>
				<td><strong>#i#</strong></td>
				<td>#tmpNode.objectName#</td>
				<td>#tmpNode.eventName#</td>
				<td>#tmpNode.eventHandler#</td>
			</tr>
		</cfloop>
	</table>
</cfif>


<cfset aMethods = oResourceBean.getMethods()>
<cfset aEvents = oResourceBean.getEvents()>

<cfif arrayLen(aMethods) gt 0 or arrayLen(aEvents) gt 0>
	<h2 class="title">API:</h2>
	<table class="tblGrid tblModProps" align="center">
		<tr>
			<th width="10">&nbsp;</th>
			<th>Name</th>
			<th>Description</th>
		</tr>
		<tr><td colspan="3"><b><em>Methods:</em></b></tr>
		<cfloop from="1" to="#arrayLen(aMethods)#" index="i">
			<cfset tmpNode = aMethods[i]>
			<cfparam name="tmpNode.name" default="">
			<cfparam name="tmpNode.description" default="">
			<tr>
				<td><strong>#i#</strong></td>
				<td>#tmpNode.name#</td>
				<td>#tmpNode.description#</td>
			</tr>
		</cfloop>
		<cfif arrayLen(aMethods) eq 0>
			<tr><td colspan="3"><em>None</em></td></tr>
		</cfif>

		<tr><td colspan="3"><b><em>Events:</em></b></tr>
		<cfloop from="1" to="#arrayLen(aEvents)#" index="i">
			<cfset tmpNode = aEvents[i]>
			<cfparam name="tmpNode.name" default="">
			<cfparam name="tmpNode.description" default="">
			<tr>
				<td><strong>#i#</strong></td>
				<td>#tmpNode.name#</td>
				<td>#tmpNode.description#</td>
			</tr>
		</cfloop>
		<cfif arrayLen(aEvents) eq 0>
			<tr><td colspan="3"><em>None</em></td></tr>
		</cfif>
	</table>
</cfif>


<cfif oResourceBean.getScreenshot() neq "">
	<h2 class="title">Images:</h2>
	<img src="#oResourceBean.getScreenshot()#" alt="resource screenshot" title="resource screenshot">
</cfif>
</div>
</cfoutput>

<input type="button" 
		name="btnCancel" 
		value="Return To Module Listing" 
		onClick="selectResourceType('module')"
		style="margin-top:8px;">
