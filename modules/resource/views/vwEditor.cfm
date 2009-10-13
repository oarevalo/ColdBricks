<cfparam name="request.requestState.resourceType" default="">
<cfparam name="request.requestState.resourceID" default="">
<cfparam name="request.requestState.oResourceBean" default="">
<cfparam name="request.requestState.package" default="">
<cfparam name="request.requestState.fileContent" default="">
<cfparam name="request.requestState.type" default="">
<cfparam name="request.requestState.fullhref" default="">
<cfparam name="request.requestState.resLibIndex" default="">

<cfscript>
	resourceType = request.requestState.resourceType;
	resourceID = request.requestState.resourceID;
	oResourceBean = request.requestState.oResourceBean;
	package = request.requestState.package;
	fileContent = request.requestState.fileContent;
	type = request.requestState.type;
	fullhref = request.requestState.fullhref;
	resLibIndex = request.requestState.resLibIndex;
	fileName = "";

	if(fullhref neq "") {
		fileName = getFileFromPath( fullhref );
	}
</cfscript>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="modules/resource/includes/resourceEditor.js"></script>
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
	<div class="cp_sectionTitle" 
			style="padding:0px;margin:0px;font-size:14px; width:99%;margin-bottom:5px;">
		<div style="margin:4px;">
			Edit Resource Target : '#resourceID#' (#resourceType#)
		</div>
	</div>
	
	<form name="frm" action="index.cfm" method="post" style="margin:0px;padding:0px;">
		<input type="hidden" name="event" value="resource.ehResource.doSaveFile">
		<input type="hidden" name="resourceID" value="#resourceID#">
		<input type="hidden" name="resourceType" value="#resourceType#">
		<input type="hidden" name="package" value="#package#">
		<input type="hidden" name="resLibIndex" value="#resLibIndex#">
		<input type="hidden" name="fileName" value="#fileName#">
		<input type="hidden" name="type" value="#type#">
		<div>

			<div id="pnl_editor">
				<textarea name="body" 
							wrap="off" 
							onkeypress="checkTab(event)" 
							onkeydown="checkTabIE()"	
							id="body" 
							style="width:98%;border:1px solid silver;padding:2px;height:395px;">#HTMLEditFormat(fileContent)#</textarea>
			</div>
			
			<div class="pagingControls"style="clear:both;">
				<div style="float:right;font-weight:normal;">
					<b>Path:</b> 
					<cfif len(fullhref) gt 35>
						<a href="##" onclick="alert('#fullhref#')">#left(fullhref,10)#...#right(fullhref,20)#</a>
					<cfelse>
						#fullhref#
					</cfif>
				</div>
				<input type="button" name="btnSave" value="Apply Changes" onclick="resourceEditor.saveFile(this.form)">
				&nbsp;&nbsp;&nbsp;
				<input type="button" name="btnCancel" value="Cancel" onclick="resourceEditor.main('#jsStringFormat(resourceID)#','#jsStringFormat(resourceType)#','#jsStringFormat(package)#','#resLibIndex#')">
			</div>

		</div>
	</form>
</cfoutput>