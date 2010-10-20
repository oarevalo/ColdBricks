<cfparam name="request.requestState.tagInfo" default="">
<cfparam name="request.requestState.tag" default="">
<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.oCatalog" default="">
<cfparam name="request.requestState.done" default="false">

<cfparam name="request.requestState.resourceID" default="">
<cfparam name="request.requestState.resType" default="">

<cfset tagInfo = request.requestState.tagInfo>
<cfset tag = request.requestState.tag>
<cfset oPage = request.requestState.oPage>
<cfset oCatalog = request.requestState.oCatalog>
<cfset done = request.requestState.done>

<cfset resourceID = request.requestState.resourceID>
<cfset resType = request.requestState.resType>

<cfset aLayoutRegions = oPage.getLayoutRegions()>
<cfset lstModuleAttribs = "">
<cfset lstIgnoreAttribs = "">

<cfparam name="forceResourceType" default="#resType#">
<cfparam name="forceResourceID" default="#resourceID#">


<cfsavecontent variable="tmpHTML">
<link type="text/css" rel="stylesheet" href="includes/css/style.css" />
<link type="text/css" rel="stylesheet" href="includes/floatbox/floatbox.css" />
<script type="text/javascript" src="includes/floatbox/floatbox.js"></script>
<script type="text/javascript">
	function hideMessageBox() {
		var d = document.getElementById("app_messagebox");
		d.style.display = "none";
	}		
</script>
<style type="text/css">
	#app_messagebox {
		top:5px;
	}
	.formField {
		width:250px !important;
	}
</style>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>
	<form name="frm" action="index.cfm" method="post" style="margin:0px;padding:0px;">
		<input type="hidden" name="event" value="page.ehPage.doAddContentTag">
		<input type="hidden" name="tag" value="#tag#">

		<div class="cp_sectionTitle" 
				style="padding:0px;margin:0px;font-size:14px; width:99%;margin-bottom:5px;">
			<div style="margin:4px;">
				<div style="width:170px;float:right;font-size:10px;">
					Add To:
					<select name="location" style="width:120px;font-size:10px;">
						<cfloop from="1" to="#arrayLen(aLayoutregions)#" index="i">
							<option value="#aLayoutregions[i].name#">#aLayoutregions[i].name# (#aLayoutregions[i].type#)</option>
						</cfloop>
					</select>
				</div>
				Add New '#tag#' Module:
			</div>
		</div>		
			
		<div style="margin:5px;">
			<cfif tagInfo.hint neq "">
				<div style="margin:5px;border:1px solid silver;background-color:##f5f5f5;">
					<div style="margin:5px;">
						<img src="images/information.png" align="absmiddle">
						#tagInfo.hint#
					</div>
				</div>
			</cfif>
		
			<cfinclude template="includes/contentProps_module.cfm">
		</div>
		<div style="text-align:center;">
			<input type="submit" name="btnAdd" value="Add Content">
		</div>
		<input type="hidden" name="_moduleAttribs" id="_moduleAttribs" value="#lstModuleAttribs#">
	</form>
</cfoutput>

<cfif isBoolean(done) and done>
	<script type="text/javascript">
		setTimeout("fb.end()",100);
	</script>
</cfif>