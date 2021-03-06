<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.oCatalog" default="">
<cfparam name="request.requestState.oModule" default="">
<cfparam name="request.requestState.tagInfo" default="">
<cfparam name="request.requestState.pageHREF" default="">
<cfparam name="request.requestState.stModuleTemplates" default="">

<cfscript>
	oPage = request.requestState.oPage;
	oCatalog = request.requestState.oCatalog;
		
	oModule = request.requestState.oModule;
	tagInfo = request.requestState.tagInfo;
	thisPageHREF = request.requestState.pageHREF;	
	stModuleTemplates = request.requestState.stModuleTemplates;	
	thisModule = oModule.toStruct();

	lstBaseAttribs = "location,id,title,container,style,icon,moduleType,class,output,moduleTemplate";
	lstAllAttribs = structKeyList(thisModule);
	lstCustomAttribs = "";
	lstModuleAttribs = "";
	lstIgnoreAttribs = lstBaseAttribs;
	
	title = oPage.getTitle();
</cfscript>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="modules/resource/includes/resourceEditor.js"></script>
	<link type="text/css" rel="stylesheet" href="includes/floatbox/floatbox.css" />
	<script type="text/javascript" src="includes/floatbox/floatbox.js"></script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">


<cfoutput>
	<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="8" cellspacing="0">
		<tr>
			<td nowrap="yes">
				<strong>Title:</strong> #title#
			</td>
			<td align="right">
				<cfmodule template="../../../includes/sitePageSelector.cfm">
			</td>
		</tr>
	</table>

	<form name="frmModule" action="index.cfm?event=page.ehPage.doSaveModule" method="post" style="margin:0px;padding:0px;">
		<input type="hidden" name="event" value="page.ehPage.doSaveModule" />
		<input type="hidden" name="location" value="#thisModule.location#" />
		<input type="hidden" name="id" value="#thisModule.ID#">
		<input type="hidden" name="moduleType" value="#thisModule.moduleType#">

		<br>

		<table width="100%">
			<tr valign="top">
				<td>
					<cfinclude template="includes/contentProps_general.cfm">
					<br>
					<cfinclude template="includes/contentProps_display.cfm">
					<br>
					<cfset useResourceEditor = true>
					<cfinclude template="includes/contentProps_module.cfm">
					<br>
					<cfinclude template="includes/contentProps_custom.cfm">
					<br>
				</td>
				<td style="width:10px;">&nbsp;</td>
				<td style="border:1px solid ##ccc;background-color:##ebebeb;width:250px;font-size:14px;line-height:18px;">
					<cfinclude template="vwContentTagInfo.cfm">
				</td>
			</tr>
		</table>

		<p>
			<input type="hidden" name="_baseAttribs" id="_baseAttribs" value="#lstBaseAttribs#">
			<input type="hidden" name="_moduleAttribs" id="_moduleAttribs" value="#lstModuleAttribs#">	
			<input type="hidden" name="_customAttribs" id="_customAttribs" value="#lstCustomAttribs#">	

			<input type="button" 
					name="btnCancel" 
					value="Return To Page Editor" 
					onClick="document.location='?event=page.ehPage.dspMain'">
			&nbsp;&nbsp;
			<input type="submit" name="btnSave" value="Apply Changes">
		</p>
	</form>
</cfoutput>
