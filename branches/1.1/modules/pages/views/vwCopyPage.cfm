<cfset rs = request.requestState>

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
	<div class="cp_sectionTitle" 
			style="padding:0px;margin:0px;font-size:14px; width:99%;margin-bottom:5px;">
		<div style="margin:4px;">
			Copy Page
		</div>
	</div>
	<form name="frm" id="frmCopyPage" action="index.cfm" method="post" style="margin:0px;padding:0px;" target="_parent">
		<input type="hidden" name="event" value="pages.ehPages.doCopyPage">
		<input type="hidden" name="parentPath" value="#rs.parentPath#">
		<input type="hidden" name="pagePath" value="#rs.pagePath#">
		<input type="hidden" name="nextEvent" value="pages.ehPages.dspMain">
		<div style="margin:10px;">
			<input type="checkbox" name="layoutOnly" value="1"> <strong>Copy Layout Only?</strong>
			
			<div class="formFieldTip" style="margin-top:10px;">
				Check this option if you want to make a copy of only the page layout, template used and properties,
				but not its contents.
			</div>
		</div>
		<p align="center">
			<input type="submit" name="btn" value="Copy Page">
		</p>
	</form>
</cfoutput>