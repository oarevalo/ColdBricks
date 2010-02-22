<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.pluginEditKey" default="">
<cfparam name="request.requestState.oAppConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	pluginEditKey = request.requestState.pluginEditKey;
	oAppConfigBean = request.requestState.oAppConfigBean;
	
	dspEvent = "config.ehSiteConfig.dspMain";
	
	lstStandardPlugins = "";

	aHPPlugins = oHomePortalsConfigBean.getPlugins();
	aAppPlugins = oAppConfigBean.getPlugins();
	stHPPlugins = structNew();
	stAppPlugins = structNew();
	for(i=1;i lte arrayLen(aHPPlugins);i++) {
		stHPPlugins[aHPPlugins[i].name] = aHPPlugins[i].path;
	}
	for(i=1;i lte arrayLen(aAppPlugins);i++) {
		stAppPlugins[aAppPlugins[i].name] = aAppPlugins[i].path;
	}
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
		
			<br /><b>Built-in Plugins</b><br /><br />
		
			<cfdirectory action="list" directory="#expandPath('/homePortals/plugins')#" name="qryDir">
			<div style="border:1px solid silver;">
			<form name="frmAddPlugin" action="index.cfm" method="post">
				<input type="hidden" name="event" value="config.ehSiteConfig.doUpdateStandardPlugins">
				<table width="100%">
					<tr>
						<td align="center" style="background-color:##ccc;width:50px;"><strong>Enable</strong></td>
						<td align="center" style="background-color:##ccc;width:50px;"><strong>Disable</strong></td>
						<td style="background-color:##ccc;"><strong>Plugin</strong></td>
						<td align="center" style="background-color:##ccc;width:50px;"><strong>Status</strong></td>
					</tr>
					<cfset index = 1>
					<cfloop query="qryDir">
						<cfset pluginCFCPath = "">
						<cfif left(qryDir.name,1) neq ".">
							<cfif qryDir.type eq "Dir" and fileExists(expandPath("/homePortals/plugins/#qryDir.name#/plugin.cfc"))>
								<cfset pluginCFCPath = "/homePortals/plugins/#qryDir.name#/plugin.cfc">
								<cfset pluginName = qryDir.name>
							<cfelseif qryDir.type eq "File" and righ(qryDir.name,4) eq ".cfc">	
								<cfset pluginCFCPath = "/homePortals/plugins/#qryDir.name#">
								<cfset pluginName = replaceNoCase(qryDir.name,".cfc","")>
							</cfif>
							<cfset pluginEnabled = (structKeyExists(stHPPlugins,pluginName) or structKeyExists(stAppPlugins,pluginName))>
							<cfif pluginCFCPath neq "">
								<cfset md = getMetaData(createObject("component",pluginCFCPath))>
								<cfset lstStandardPlugins = listAppend(lstStandardPlugins, pluginName)>
								<tr <cfif index mod 2>class="altRow"</cfif>>
									<td align="center">
										<input type="radio" name="plugin_#pluginName#" value="#pluginCFCPath#"
												<cfif structKeyExists(stHPPlugins,pluginName) or structKeyExists(stAppPlugins,pluginName)>
													disabled="true"
													checked="true"
												</cfif>
												>
									</td>
									<td align="center">
										<input type="radio" name="plugin_#pluginName#" value="__REMOVE__"
												<cfif structKeyExists(stHPPlugins,pluginName) or !structKeyExists(stAppPlugins,pluginName)>
													disabled="true"
												</cfif>
												>
									</td>
									<td <cfif Not pluginEnabled>style="color:##999;"</cfif>>
										<b><cfif structKeyExists(md,"displayName")>#md.displayName#<cfelse>#pluginName#</cfif> plugin</b><br />
										<cfif structKeyExists(md,"hint")>#md.hint#<cfelse>Enable/disable this plugin</cfif>
									</td>
									<td align="center">
										<cfif pluginEnabled>
											<span style="color:green;font-weight:bold;">Enabled</span>
										<cfelse>
											<span style="color:silver;font-weight:bold;">Disabled</span>
										</cfif>
									</td>
								</tr>
								<cfset index++>
							</cfif>
						</cfif>
					</cfloop>
				</table>
				<input type="hidden" name="pluginNames" value="#lstStandardPlugins#">
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
				<cfset aPlugins = oHomePortalsConfigBean.getPlugins()>
				<cfloop array="#aPlugins#" index="plugin">
					<cfif not listFindNoCase(lstStandardPlugins,plugin.name)>
						<tr <cfif index mod 2>class="altRow"</cfif>>
							<td style="width:50px;" align="right"><strong>#index#.</strong></td>
							<td style="width:100px;" align="center">#plugin.name#</td>
							<td>#plugin.path#</td>
							<td align="center">
								< base >
							</td>
						</tr>
						<cfset index++>
					</cfif>
				</cfloop>				
				
				<cfset aPlugins = oAppConfigBean.getPlugins()>
					<cfloop array="#aPlugins#" index="plugin">
						<cfset key = plugin.name>
						<cfif not listFindNoCase(lstStandardPlugins,plugin.name)>
						<tr <cfif index mod 2>class="altRow"</cfif> <cfif pluginEditKey eq key>style="font-weight:bold;"</cfif>>
							<td style="width:50px;" align="right"><strong>#index#.</strong></td>
							<td style="width:100px;" align="center"><a href="index.cfm?event=#dspEvent#&pluginEditKey=#key#">#key#</a></td>
							<td>#plugin.path#</td>
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
