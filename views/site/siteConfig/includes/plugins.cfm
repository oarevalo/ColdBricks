<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.pluginEditKey" default="">
<cfparam name="request.requestState.oAppConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	pluginEditKey = request.requestState.pluginEditKey;
	oAppConfigBean = request.requestState.oAppConfigBean;
	
	dspEvent = "ehSiteConfig.dspMain";
</cfscript>

<script type="text/javascript">
	function confirmDeletePlugin(name) {
		if(confirm("Delete plugin?")) {
			document.location = "index.cfm?event=ehSiteConfig.doDeletePlugin&name=" + name;
		}
	}
</script>

<cfoutput>
	<tr><td colspan="2"><h2>Plugins:</h2></td></tr>
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
				<cfset stPlugins = oHomePortalsConfigBean.getPlugins()>
				<cfloop collection="#stPlugins#" item="key">
					<tr <cfif index mod 2>class="altRow"</cfif>>
						<td style="width:50px;" align="right"><strong>#index#.</strong></td>
						<td style="width:100px;" align="center">#key#</td>
						<td>#stPlugins[key]#</td>
						<td align="center">
							< base >
						</td>
					</tr>
					<cfset index++>
				</cfloop>				
				
				<cfset index = 1>
				<cfset stPlugins = oAppConfigBean.getPlugins()>
				<cfloop collection="#stPlugins#" item="key">
					<tr <cfif index mod 2>class="altRow"</cfif> <cfif pluginEditKey eq key>style="font-weight:bold;"</cfif>>
						<td style="width:50px;" align="right"><strong>#index#.</strong></td>
						<td style="width:100px;" align="center"><a href="index.cfm?event=#dspEvent#&pluginEditKey=#key#">#key#</a></td>
						<td>#stPlugins[key]#</td>
						<td align="center">
							<a href="index.cfm?event=#dspEvent#&pluginEditKey=#key#"><img src="images/page_edit.png" border="0" alt="Edit plugin" title="Edit plugin"></a>
							<a href="##" onclick="confirmDeletePlugin('#key#')"><img src="images/page_delete.png" border="0" alt="Delete plugin" title="Delete plugin"></a>
						</td>
					</tr>
					<cfset index++>
				</cfloop>
			</table>
			<cfif pluginEditKey eq "__NEW__">
				<form name="frmAddPlugin" action="index.cfm" method="post">
					<input type="hidden" name="event" value="ehSiteConfig.doSavePlugin">
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
			<cfelseif pluginEditKey neq "">
				<cftry>
					<cfset path = oHomePortalsConfigBean.getPlugin(pluginEditKey)>
					<cfcatch type="any">
						<cfset path = "">
					</cfcatch>
				</cftry>
				<form name="frmEditPlugin" action="index.cfm" method="post">
					<input type="hidden" name="event" value="ehSiteConfig.doSavePlugin">
					<input type="hidden" name="name" value="#pluginEditKey#">

					<table style="width:100%;border:1px solid silver;margin-top:5px;">
						<tr>
							<td style="width:50px;" align="center"><strong>Edit:</strong></td>
							<td style="width:100px;">
								<strong>Name:</strong><br />
								#pluginEditKey#
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
				<a href="index.cfm?event=#dspEvent#&pluginEditKey=__NEW__">Click Here</a> to register a plugin
			</cfif>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>
