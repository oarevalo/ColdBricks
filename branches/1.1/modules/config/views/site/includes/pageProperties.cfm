<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.propertyEditKey" default="">
<cfparam name="request.requestState.oAppConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	propertyEditKey = request.requestState.propertyEditKey;
	oAppConfigBean = request.requestState.oAppConfigBean;
	
	dspEvent = "config.ehSiteConfig.dspMain";
</cfscript>

<script type="text/javascript">
	function confirmDeleteProperty(name) {
		if(confirm("Delete page property?")) {
			document.location = "index.cfm?event=config.ehSiteConfig.doDeleteProperty&name=" + name;
		}
	}
</script>

<cfoutput>
	<tr><td colspan="2"><h2>Page Properties:</h2></td></tr>
	<tr>
		<td colspan="2">
			<div class="formFieldTip">
				Page Properties are user-defined values that are globally accessible from pages, templates and modules.
				Page properties defined at the config level can be overriden by properties defined at page level.
			</div>

			<table style="width:100%;border:1px solid silver;">
				<tr>
					<th style="background-color:##ccc;width:50px;">No.</th>
					<th style="background-color:##ccc;width:100px;">Name</th>
					<th style="background-color:##ccc;">Value</th>
					<th style="background-color:##ccc;width:100px;">Action</th>
				</tr>
				<cfset index = 1>
				<cfset stProperties = oHomePortalsConfigBean.getPageProperties()>
				<cfloop collection="#stProperties#" item="key">
					<tr <cfif index mod 2>class="altRow"</cfif> <cfif propertyEditKey eq key>style="font-weight:bold;"</cfif>>
						<td style="width:50px;" align="right"><strong>#index#.</strong></td>
						<td style="width:100px;" align="center"><a href="index.cfm?event=#dspEvent#&propertyEditKey=#key#">#key#</a></td>
						<td>#stProperties[key]#</td>
						<td align="center">
							< base >
						</td>
					</tr>
					<cfset index++>
				</cfloop>

				<cfset stProperties = oAppConfigBean.getPageProperties()>
				<cfloop collection="#stProperties#" item="key">
					<tr <cfif index mod 2>class="altRow"</cfif> <cfif propertyEditKey eq key>style="font-weight:bold;"</cfif>>
						<td style="width:50px;" align="right"><strong>#index#.</strong></td>
						<td style="width:100px;" align="center"><a href="index.cfm?event=#dspEvent#&propertyEditKey=#key#">#key#</a></td>
						<td>#stProperties[key]#</td>
						<td align="center">
							<a href="index.cfm?event=#dspEvent#&propertyEditKey=#key#"><img src="images/page_edit.png" border="0" alt="Edit page property" title="Edit page property"></a>
							<a href="##" onclick="confirmDeleteProperty('#key#')"><img src="images/page_delete.png" border="0" alt="Delete page property" title="Delete page property"></a>
						</td>
					</tr>
					<cfset index++>
				</cfloop>
			</table>
			<cfif propertyEditKey eq "__NEW__">
				<form name="frmAddProperty" action="index.cfm" method="post">
					<input type="hidden" name="event" value="config.ehSiteConfig.doSaveProperty">
					<table style="width:100%;border:1px solid silver;margin-top:5px;">
						<tr>
							<td style="width:50px;" align="center"><strong>New:</strong></td>
							<td style="width:100px;">
								<strong>Name:</strong><br />
								<input type="text" name="name" value="" style="width:100px;" class="formField">
							</td>
							<td>
								<strong>Value:</strong><br />
								<input type="text" name="value" value="" style="width:340px;" class="formField">
							</td>
							<td style="width:100px;" align="center">
								<input type="submit" name="btnSave" value="Apply" style="font-size:11px;">
								<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=#dspEvent#'">
							</td>
						</tr>
					</table>
				</form>
			<cfelseif propertyEditKey neq "">
				<cftry>
					<cfset value = oAppConfigBean.getPageProperty(propertyEditKey)>
					<cfcatch type="any">
						<cfset value = "">
					</cfcatch>
				</cftry>
				<form name="frmEditProperty" action="index.cfm" method="post">
					<input type="hidden" name="event" value="config.ehSiteConfig.doSaveProperty">
					<input type="hidden" name="name" value="#propertyEditKey#">

					<table style="width:100%;border:1px solid silver;margin-top:5px;">
						<tr>
							<td style="width:50px;" align="center"><strong>Edit:</strong></td>
							<td style="width:100px;">
								<strong>Name:</strong><br />
								#propertyEditKey#
							</td>
							<td>
								<strong>Value:</strong><br />
								<input type="text" name="value" value="#value#" style="width:340px;" class="formField">
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
				<a href="index.cfm?event=#dspEvent#&propertyEditKey=__NEW__">Click Here</a> to add a page property
			</cfif>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>
