<cfsetting showdebugoutput="false">
<cfparam name="request.requestState.oModule" default="">
<cfparam name="request.requestState.tagInfo" default="">

<cfset oModule = request.requestState.oModule>
<cfset tagInfo = request.requestState.tagInfo>
<cfset thisModule = oModule.toStruct()>


<cfset lstBaseAttribs = "location,id,title,container,style,icon,moduleType,class,output">
<cfparam name="thisModule.ID" default="">
<cfparam name="thisModule.title" default="">
<cfparam name="thisModule.container" default="true">
<cfset lstAttribs = structKeyList(thisModule)>
<cfset lstAttribs = listSort(lstAttribs,"textnocase")>

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

	<table class="tblProperties" border="1">
		<tr><td colspan="2" style="color:black;"><b>General Properties</b></td></tr>
		<tr valign="top"><th style="text-align:left;">ID:</th><td>#thisModule.ID#</td></tr>
		<tr valign="top"><th style="text-align:left;">Type:</th><td>#thisModule.moduleType#</td></tr>
		<tr valign="top"><th style="text-align:left;">Title:</th><td>#thisModule.Title#</td></tr>
		<tr valign="top"><th style="text-align:left;">Container:</th><td>#yesNoFormat(thisModule.container)#</td></tr>
		<!--- <tr valign="top"><th style="text-align:left;">Icon URL:</th><td>#thisModule.icon#</td></tr> --->

	<!--- 	<tr><td colspan="2" style="color:black;"><b>Display Properties</b></td></tr>
		<tr valign="top"><th style="text-align:left;">CSS Class:</th><td>#thisModule.class#</td></tr>
		<tr valign="top"><th style="text-align:left;">CSS Style:</th><td>#thisModule.style#</td></tr>
		<tr valign="top"><th style="text-align:left;">Output:</th><td>#yesNoFormat(thisModule.output)#</td></tr>
 --->
		
		<tr><td colspan="2" style="color:black;padding-top:5px;"><b>Module Properties</b></td></tr>
		<cfloop from="1" to="#arrayLen(tagInfo.properties)#" index="i">
			<cfset prop = duplicate(tagInfo.properties[i])>
			<cfparam name="prop.name" default="property">
			<cfparam name="thisModule[prop.name]" default="">
			<tr valign="top"><th style="text-align:left;">#prop.name#:</th><td>#thisModule[prop.name]#</td></tr>
		</cfloop>
		
		<!--- <cfloop list="#lstAttribs#" index="attr">
			<cfif not listFindNoCase(lstBaseAttribs,attr)>
				<tr valign="top"><th style="text-align:left;">#attr#:</th><td>#thisModule[attr]#</td></tr>
			</cfif>
		</cfloop> --->
	</table>
</cfoutput>


