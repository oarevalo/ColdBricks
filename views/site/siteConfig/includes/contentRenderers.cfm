<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.contentRendererEditKey" default="">
<cfparam name="request.requestState.oAppConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	contentRendererEditKey = request.requestState.contentRendererEditKey;
	oAppConfigBean = request.requestState.oAppConfigBean;

	dspEvent = "ehSiteConfig.dspMain";
</cfscript>

<script type="text/javascript">
	function confirmDeleteContentRenderer(name) {
		if(confirm("Delete content renderer?")) {
			document.location = "index.cfm?event=ehSiteConfig.doDeleteContentRenderer&name=" + name;
		}
	}
</script>

<cfoutput>
	<tr><td colspan="2"><h2>Content Renderers:</h2></td></tr>
	<tr>
		<td colspan="2">
		
			<table style="width:100%;border:1px solid silver;">
				<tr>
					<th style="background-color:##ccc;width:50px;">No.</th>
					<th style="background-color:##ccc;width:100px;">Name</th>
					<th style="background-color:##ccc;">Path</th>
					<th style="background-color:##ccc;width:100px;">Action</th>
				</tr>
				<cfset index = 1>
				<cfset stContRenders = oHomePortalsConfigBean.getContentRenderers()>
				<cfloop collection="#stContRenders#" item="key">
					<tr <cfif index mod 2>class="altRow"</cfif>>
						<td style="width:50px;" align="right"><strong>#index#.</strong></td>
						<td style="width:100px;" align="center">#key#</td>
						<td>#stContRenders[key]#</td>
						<td align="center">
							< base >
						</td>
					</tr>
					<cfset index++>
				</cfloop>

				<cfset index = 1>
				<cfset stContRenders = oAppConfigBean.getContentRenderers()>
				<cfloop collection="#stContRenders#" item="key">
					<tr <cfif index mod 2>class="altRow"</cfif> <cfif contentRendererEditKey eq key>style="font-weight:bold;"</cfif>>
						<td style="width:50px;" align="right"><strong>#index#.</strong></td>
						<td style="width:100px;" align="center"><a href="index.cfm?event=#dspEvent#&contentRendererEditKey=#key#">#key#</a></td>
						<td>#stContRenders[key]#</td>
						<td align="center">
							<a href="index.cfm?event=#dspEvent#&contentRendererEditKey=#key#"><img src="images/page_edit.png" border="0" alt="Edit content renderer" title="Edit content renderer"></a>
							<a href="##" onclick="confirmDeleteContentRenderer('#key#')"><img src="images/page_delete.png" border="0" alt="Delete content renderer" title="Delete content renderer"></a>
						</td>
					</tr>
					<cfset index++>
				</cfloop>
			</table>
			<cfif contentRendererEditKey eq "__NEW__">
				<form name="frmAddContentRenderer" action="index.cfm" method="post">
					<input type="hidden" name="event" value="ehSiteConfig.doSaveContentRenderer">
					<table style="width:100%;border:1px solid silver;margin-top:5px;">
						<tr>
							<td style="width:50px;" align="center"><strong>New:</strong></td>
							<td style="width:100px;">
								<strong>Name:</strong><br />
								<input type="text" name="name" value="" style="width:100px;" class="formField">
							</td>
							<td>
								<strong>Path:</strong><br />
								<input type="text" name="path" value="" style="width:340px;" class="formField">
							</td>
							<td style="width:100px;" align="center">
								<input type="submit" name="btnSave" value="Apply" style="font-size:11px;">
								<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=#dspEvent#'">
							</td>
						</tr>
					</table>
				</form>
			<cfelseif contentRendererEditKey neq "">
				<cftry>
					<cfset path = oAppConfigBean.getContentRenderer(contentRendererEditKey)>
					<cfcatch type="any">
						<cfset path = "">
					</cfcatch>
				</cftry>
				<form name="frmEditBaseResource" action="index.cfm" method="post">
					<input type="hidden" name="event" value="ehSiteConfig.doSaveContentRenderer">
					<input type="hidden" name="name" value="#contentRendererEditKey#">

					<table style="width:100%;border:1px solid silver;margin-top:5px;">
						<tr>
							<td style="width:50px;" align="center"><strong>Edit:</strong></td>
							<td style="width:100px;">
								<strong>Name:</strong><br />
								#contentRendererEditKey#
							</td>
							<td>
								<strong>Path:</strong><br />
								<input type="text" name="path" value="#path#" style="width:340px;" class="formField">
							</td>
							<td style="width:100px;" align="center">
								<input type="submit" name="btnSave" value="Apply" style="font-size:11px;">
								<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=#dspEvent#'">
							</td>
						</tr>
					</table>
				</form>
			<cfelse>
				<br>
				<a href="index.cfm?event=#dspEvent#&contentRendererEditKey=__NEW__">Click Here</a> to add a content renderer
			</cfif>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>
