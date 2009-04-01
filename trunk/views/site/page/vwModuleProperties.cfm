<cfsetting showdebugoutput="false">
<cfparam name="request.requestState.stModule" default="">

<cfset lstBaseAttribs = "id,moduleType,title,container">
<cfset thisModule = request.requestState.stModule>
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

	<table style="width:170px;margin:5px;">
		<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>ID:</td><td>#thisModule.ID#</td></tr>
		<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>Type:</td><td>#thisModule.moduleType#</td></tr>
		<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>Title:</td><td>#thisModule.Title#</td></tr>
		<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>Container:</td><td>#yesNoFormat(thisModule.container)#</td></tr>
		<cfloop list="#lstAttribs#" index="attr">
			<cfif not listFindNoCase(lstBaseAttribs,attr)>
				<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;" nowrap>#attr#:</td><td>#thisModule[attr]#</td></tr>
			</cfif>
		</cfloop>
	</table>
</cfoutput>


