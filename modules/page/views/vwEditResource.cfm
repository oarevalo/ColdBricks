<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.oCatalog" default="">
<cfparam name="request.requestState.done" default="false">

<cfparam name="request.requestState.resourceID" default="">
<cfparam name="request.requestState.resType" default="">
<cfparam name="request.requestState.fullhref" default="">
<cfparam name="request.requestState.fileContent" default="">

<cfparam name="request.requestState.type" default="">

<cfset oPage = request.requestState.oPage>
<cfset oCatalog = request.requestState.oCatalog>
<cfset done = request.requestState.done>

<cfset resourceID = request.requestState.resourceID>
<cfset resType = request.requestState.resType>
<cfset fileContent = request.requestState.fileContent>
<cfset fileName = "">
<cfset fullhref = request.requestState.fullhref>
<cfset type = request.requestState.type>

<cfif fullhref neq "">
	<cfset fileName = getFileFromPath( fullhref )>
</cfif>


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
	<cfif type eq "richtext">
		<script language="javascript" type="text/javascript" src="/ColdBricks/includes/tiny_mce/tiny_mce.js"></script>
		<script type="text/javascript">
			tinyMCE.init({
				mode : "exact",
				elements : "body",
				theme : "advanced",
				plugins : "table",
				theme_advanced_toolbar_location : "top",
				theme_advanced_toolbar_align : "left",
				theme_advanced_path : "false",
				theme_advanced_buttons1 : "bold,italic,underline,separator,justifyleft,justifycenter,justifyright,separator,bullist,numlist,separator,outdent,indent,separator,link,unlink,separator,image,hr,separator,forecolor,backcolor,separator,help",
				theme_advanced_buttons2 : "fontselect,fontsizeselect,formatselect,tablecontrols",
				theme_advanced_buttons3 : "",
				//valid_elements : "*[*]"
				relative_urls : false
			});	
		</script>
	</cfif>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>
	<form name="frm" action="index.cfm" method="post" style="margin:0px;padding:0px;">
		<input type="hidden" name="event" value="resources.ehResources.doSaveResourceFile">
		<input type="hidden" name="resourceID" value="#resourceID#">
		<input type="hidden" name="fileName" value="#fileName#">
		<input type="hidden" name="type" value="#resType#">
		
		<div class="cp_sectionTitle" 
				style="padding:0px;margin:0px;font-size:14px; width:99%;margin-bottom:5px;">
			<div style="margin:4px;">
				Edit '#resourceID#' (#resType#)
			</div>
		</div>

		<div id="pnl_editor">
			<textarea name="body" 
						wrap="off" 
						onkeypress="checkTab(event)" 
						onkeydown="checkTabIE()"	
						id="body" 
						style="width:98%;border:1px solid silver;padding:2px;height:400px;">#HTMLEditFormat(fileContent)#</textarea>
		</div>
		
		<div class="pagingControls"style="clear:both;">
			<input type="button" name="btnSave" value="Apply Changes" onclick="saveResourceFile(this.form)">
			&nbsp;&nbsp;
			<a href="?event=resources.ehResources.dspMain">Resource Management...</a>
		</div>
	</form>
</cfoutput>

<cfif isBoolean(done) and done>
	<script type="text/javascript">
		setTimeout("fb.end()",100);
	</script>
</cfif>