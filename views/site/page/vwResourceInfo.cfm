<cfparam name="request.requestState.oResourceBean" default="">
<cfparam name="request.requestState.resourceID" default="">
<cfparam name="request.requestState.resType" default="">

<cfset oResourceBean = request.requestState.oResourceBean>
<cfset resourceID = request.requestState.resourceID>
<cfset resType = request.requestState.resType>

<cfif resType eq "module" or oResourceBean.getName() eq "">
	<cfset tmpResTitle = resourceID>
<cfelse>
	<cfset tmpResTitle = oResourceBean.getName()>
</cfif>

<cfoutput>
	<div style="border-bottom:1px solid black;background-color:##ccc;text-align:left;line-height:22px;">
		<a href="javascript:addResource('#jsstringformat(resourceID)#','#resType#');"><img src="images/add.png" align="absmiddle" border="0" alt="Add To Page" title="Add To Page"> Add To Page</a>
	</div>
	
	<div style="width:160px;">
	<table style="margin:5px;">
		<tr valign="top"><td style="font-size:10px;color:##999;text-align:right;width:30px;">Type:</td><td>#resType#</td></tr>
		<tr valign="top"><td style="font-size:10px;color:##999;text-align:right;width:30px;">ID/Name:</td><td>#tmpResTitle#</td></tr>
		<tr valign="top"><td style="font-size:10px;color:##999;text-align:right;width:30px;">Package:</td><td>#oResourceBean.getPackage()#</td></tr>
		<tr valign="top"><td style="font-size:10px;color:##999;text-align:right;width:30px;">Access:</td><td>#oResourceBean.getAccessType()#</td></tr>
		<cfif resType eq "feed">
			<cfset tmpHREF = oResourceBean.getHREF()>
			<tr valign="top"><td style="font-size:10px;color:##999;text-align:right;width:30px;">URL:</td><td><a href="#tmpHREF#" target="_blank"><span style="color:green;">View Feed Source</span></a></td></tr>
		</cfif>
	</table>

	<div style="margin:5px;">
		<div style="font-size:10px;color:##999;text-align:right;width:30px;">Description:</div>
		<cfif oResourceBean.getDescription() neq "">
			#oResourceBean.getDescription()#
		<cfelse>
			N/A
		</cfif>
	</div>

	<div style="margin:5px;">
		<div style="font-size:10px;color:##999;text-align:right;width:30px;">Author:</div>
		<div style="float:right;">
			<cfif oResourceBean.getAuthorEmail() neq "">
				<cfset tmpHREF = oResourceBean.getAuthorEmail()>
				<a href="mailto:#tmpHREF#" style="white-space:normal"><img src="images/email.png" alt="#tmpHREF#" title="#tmpHREF#" align="absmiddle" border="0"></a>
			</cfif>
			<cfif oResourceBean.getAuthorURL() neq "">
				<cfset tmpHREF = oResourceBean.getAuthorURL()>
				<a href="#tmpHREF#" target="_blank" style="white-space:normal"><img src="images/world_link.png" alt="#tmpHREF#" title="#tmpHREF#" align="absmiddle" border="0"></a>
			</cfif>
		</div>
		<cfif oResourceBean.getAuthorName() neq "">
			#oResourceBean.getAuthorName()#<br>
		<cfelse>
			N/A<br>
		</cfif>
	</div>
	</div>
</cfoutput>