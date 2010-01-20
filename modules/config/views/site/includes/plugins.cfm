<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.pluginEditKey" default="">
<cfparam name="request.requestState.oAppConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	pluginEditKey = request.requestState.pluginEditKey;
	oAppConfigBean = request.requestState.oAppConfigBean;
	
	dspEvent = "config.ehSiteConfig.dspMain";
	
	lstStandardPlugins = "modules,accounts";
</cfscript>

<script type="text/javascript">
	function confirmDeletePlugin(name) {
		if(confirm("Delete plugin?")) {
			document.location = "index.cfm?event=config.ehSiteConfig.doDeletePlugin&name=" + name;
		}
	}
</script>

<cfoutput>
	<tr><td colspan="2"><h2>Plugins:</h2></td></tr>
	<tr>
		<td colspan="2">
			<div class="formFieldTip">
				Plugins are a mechanism used to extend the functionality or features of an application.
			</div>
		
			<br /><b>Standard Plugins</b><br /><br />
		
			<cfset stHPPlugins = oHomePortalsConfigBean.getPlugins()>
			<cfset stAppPlugins = oAppConfigBean.getPlugins()>
		
			<div  style="border:1px solid silver;">
			<form name="frmAddPlugin" action="index.cfm" method="post">
				<input type="hidden" name="event" value="config.ehSiteConfig.doUpdateStandardPlugins">
				<table width="100%">
					<tr valign="top">
						<td style="width:50px;text-align:center;">
							<input type="checkbox" name="chkModulesPlugin" value="1"
									<cfif structKeyExists(stHPPlugins,"modules")>
										disabled="true"
										checked
									<cfelseif structKeyExists(stAppPlugins,"modules")>
										checked
									</cfif>
									>
						</td>
						<td>
							<b>Module Resources plugin</b><br />
							This plugin provides a resource library of ready-to-use interactive widgets
							that can be added directly to pages.
						</td>
					</tr>
					<tr valign="top">
						<td style="width:50px;text-align:center;">
							<input type="checkbox" name="chkAccountsPlugin" value="1"
									<cfif structKeyExists(stHPPlugins,"accounts")>
										disabled="true"
										checked
									<cfelseif structKeyExists(stAppPlugins,"accounts")>
										checked
									</cfif>
									>
						</td>
						<td>
							<b>Accounts plugin</b><br />
							This plugin adds support for creating user accounts and assigning pages to 
							each user.
						</td>
					</tr>
				</table>
				<p style="margin-left:10px;">
					<input type="submit" name="btnSave" value="Apply Changes" style="font-size:11px;">
				</p>
			</form>
			</div>
			<br /><br />
			
			<b>Custom Plugins</b><br /><br />
			
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
					<cfif not listFindNoCase(lstStandardPlugins,key)>
						<tr <cfif index mod 2>class="altRow"</cfif>>
							<td style="width:50px;" align="right"><strong>#index#.</strong></td>
							<td style="width:100px;" align="center">#key#</td>
							<td>#stPlugins[key]#</td>
							<td align="center">
								< base >
							</td>
						</tr>
						<cfset index++>
					</cfif>
				</cfloop>				
				
				<cfset stPlugins = oAppConfigBean.getPlugins()>
				<cfloop collection="#stPlugins#" item="key">
					<cfif not listFindNoCase(lstStandardPlugins,key)>
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
					</cfif>
				</cfloop>
				
				<cfif index eq 1>
					<tr><td colspan="4"><em>No Custom Plugins Found</em></td></tr>
				</cfif>
			</table>
			<cfif pluginEditKey eq "__NEW__">
				<form name="frmAddPlugin" action="index.cfm" method="post">
					<input type="hidden" name="event" value="config.ehSiteConfig.doSavePlugin">
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
					<cfset path = oAppConfigBean.getPlugin(pluginEditKey)>
					<cfcatch type="any">
						<cfset path = "">
					</cfcatch>
				</cftry>
				<form name="frmEditPlugin" action="index.cfm" method="post">
					<input type="hidden" name="event" value="config.ehSiteConfig.doSavePlugin">
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
				<a href="index.cfm?event=#dspEvent#&pluginEditKey=__NEW__">Click Here</a> to register a custom plugin
			</cfif>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>
