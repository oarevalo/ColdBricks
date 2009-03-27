<cfsetting showdebugoutput="false">
<cfparam name="request.requestState.stModule" default="">

<cfset thisModule = request.requestState.stModule>
<cfset lstAttribs = "Name,location,id,Title,Container,Output,Display,ShowPrint,style,moduleHREF">
<cfset lstAllAttribs = structKeyList(thisModule)>

<cfparam name="thisModule.ID" default="">
<cfparam name="thisModule.title" default="">
<cfparam name="thisModule.container" default="true">
<cfparam name="thisModule.resourceID" default="">
<cfparam name="thisModule.resourceType" default="">
<cfparam name="thisModule.cache" default="true">
<cfparam name="thisModule.cacheTTL" default="">
<cfparam name="thisModule.href" default="">

<cfoutput>
	<div style="border-bottom:1px solid black;background-color:##ccc;text-align:left;line-height:22px;">
		<a href="?event=ehPage.dspEditModuleProperties&moduleID=#thisModule.id#"><img src="images/edit-page-yellow.gif" align="absmiddle" border="0" style="margin-left:3px;"></a>
		<a href="?event=ehPage.dspEditModuleProperties&moduleID=#thisModule.id#" style="font-weight:normal;">Edit</a>&nbsp;&nbsp;

		<a href="##" onclick="doDeleteModule('#thisModule.ID#');"><img src="images/waste_small.gif" align="absmiddle" border="0"></a>
		<a href="##" onclick="doDeleteModule('#thisModule.ID#');" style="font-weight:normal;">Delete</a>&nbsp;&nbsp;
		<!---
		<a href="##" onclick="doEvent('ehPage.dspModuleCSS','moduleProperties',{moduleID:'#jsstringformat(thisModule.ID)#'})"><img src="images/color_wheel.png" align="absmiddle" border="0"></a>
		<a href="##" onclick="doEvent('ehPage.dspModuleCSS','moduleProperties',{moduleID:'#jsstringformat(thisModule.ID)#'})">Style</a>
		--->
	</div>

	<table style="width:170px;margin:5px;">
		<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>ID:</td><td>#thisModule.ID#</td></tr>
		<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>Title:</td><td>#thisModule.Title#</td></tr>
		<cfif thisModule.moduleType eq "module">
			<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>Type:</td><td>#thisModule.name#</td></tr>
		</cfif>
		<cfif thisModule.moduleType eq "content">
			<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>Type:</td><td>Content</td></tr>
			<cfif thisModule.resourceID neq "">
				<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>Res. ID:</td><td>#thisModule.resourceID#</td></tr>
				<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>Res. Type:</td><td>#thisModule.resourceType#</td></tr>
				<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>Use Cache?</td><td>#yesNoFormat(thisModule.cache)#</td></tr>
				<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>Cache TTL:</td><td>#thisModule.cacheTTL# mins</td></tr>
			<cfelse>			
				<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>HREF:</td><td>#thisModule.href#</td></tr>
			</cfif>
		</cfif>
	</table>
</cfoutput>


