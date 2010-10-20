<cfparam name="request.requestState.stTags" default="">
<cfparam name="request.requestState.resourceID" default="">
<cfparam name="request.requestState.resType" default="">

<cfset stTags = request.requestState.stTags>
<cfset resourceID = request.requestState.resourceID>
<cfset resType = request.requestState.resType>

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
		<input type="hidden" name="event" value="page.ehPage.dspAddResource">
		<input type="hidden" name="resourceID" value="#resourceID#">
		<input type="hidden" name="resType" value="#resType#">
	
		<div class="cp_sectionTitle" 
				style="padding:0px;margin:0px;font-size:14px; width:99%;margin-bottom:5px;">
			<div style="margin:4px;">
				Add Resource: #resourceID# (#resType#)
			</div>
		</div>		

		<div style="margin:5px;">
			Select the module type to use for adding the selected resource:<br /><br />
			
			<table>
				<cfloop collection="#stTags#" item="tag">
					<tr valign="top">
						<td style="width:30px;" align="center">
							<input type="radio" name="tag" value="#tag#">
						</td>
						<td>
							<b>#tag#</b>
							<cfif stTags[tag].hint neq "">
								<div style="margin:5px;border:1px solid silver;background-color:##f5f5f5;">
									<div style="margin:5px;">
										<img src="images/information.png" align="absmiddle">
										#stTags[tag].hint#
									</div>
								</div>
							</cfif>
						</td>
					</tr>
				</cfloop>
			</table>
		</div>
		<div style="text-align:center;margin-top:10px;">
			<input type="submit" name="btnAdd" value="Continue >>">
		</div>		
	
	</form>
</cfoutput>