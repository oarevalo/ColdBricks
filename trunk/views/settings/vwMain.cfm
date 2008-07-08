<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.baseResourceEditIndex" default="">
<cfparam name="request.requestState.baseResourceEditType" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	baseResourceEditIndex = request.requestState.baseResourceEditIndex;
	baseResourceEditType = request.requestState.baseResourceEditType;
	
	resourceLibraryPath = oHomePortalsConfigBean.getResourceLibraryPath();
	accountsRoot = oHomePortalsConfigBean.getAccountsRoot();
	defaultAccount = oHomePortalsConfigBean.getDefaultAccount();
	pageCacheSize = oHomePortalsConfigBean.getPageCacheSize();
	pageCacheTTL = oHomePortalsConfigBean.getPageCacheTTL();
	contentCacheSize = oHomePortalsConfigBean.getContentCacheSize();
	contentCacheTTL = oHomePortalsConfigBean.getContentCacheTTL();
	
	try{ rt_page = oHomePortalsConfigBean.getRenderTemplate("page"); } catch(any e) { rt_page = ""; }
	try{ rt_module = oHomePortalsConfigBean.getRenderTemplate("module"); } catch(any e) { rt_module = ""; }
	try{ rt_moduleNC = oHomePortalsConfigBean.getRenderTemplate("moduleNoContainer"); } catch(any e) { rt_moduleNC = ""; }
	
	lstBaseResourceTypes = oHomePortalsConfigBean.getBaseResourceTypes();
		
</cfscript>

<script type="text/javascript">
	function confirmDeleteBaseResource(type, index) {
		if(confirm("Delete base resource?")) {
			document.location = "index.cfm?event=ehSettings.doDeleteBaseResource&type=" + type + "&index=" + index;
		}
	}
	
	function submitForm(event) {
		document.frm.event.value = event;
		document.frm.submit();
	}
</script>

<cfoutput>
<div>
	[ <a href="index.cfm?event=ehSettings.dspMain"><strong>General</strong></a> ] &nbsp;&nbsp;
	[ <a href="index.cfm?event=ehSettings.dspAccounts">Accounts</a> ] &nbsp;&nbsp;
	[ <a href="index.cfm?event=ehSettings.dspModuleProperties">Module Properties</a> ] &nbsp;&nbsp;
	[ <a href="index.cfm?event=ehSettings.dspEditXML">Edit Config Files</a> ] &nbsp;&nbsp;
</div>

<br>

<table style="margin:0px;padding:0px;width:100%;" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>

			<form name="frm" method="post" action="index.cfm">
				<input type="hidden" name="event" value="">
			
				<table class="dataFormTable">
					<tr><td colspan="2"><h2>General Settings:</h2></td></tr>
					<tr>
						<td width="150"><strong>Default Account:</strong></td>
						<td><input type="text" name="defaultAccount" value="#defaultAccount#" size="30" class="formField"></td>
					</tr>
					<tr>
						<td width="150"><strong>Page Cache Max Size:</strong></td>
						<td><input type="text" name="pageCacheSize" value="#pageCacheSize#" size="30" class="formField"></td>
					</tr>
					<tr>
						<td width="150"><strong>Page Cache TTL (min):</strong></td>
						<td><input type="text" name="pageCacheTTL" value="#pageCacheTTL#" size="30" class="formField"></td>
					</tr>
					<tr>
						<td width="150"><strong>Content Cache Max Size:</strong></td>
						<td><input type="text" name="contentCacheSize" value="#contentCacheSize#" size="30" class="formField"></td>
					</tr>
					<tr>
						<td width="150"><strong>Content Catch TTL (min):</strong></td>
						<td><input type="text" name="contentCacheTTL" value="#contentCacheTTL#" size="30" class="formField"></td>
					</tr>
					<tr>
						<td width="150"><strong>Accounts Root:</strong></td>
						<td><input type="text" name="accountsRoot" value="#accountsRoot#" size="30" class="formField"></td>
					</tr>
					<tr>
						<td width="150"><strong>Resource Library Root:</strong></td>
						<td><input type="text" name="resourceLibraryPath" value="#resourceLibraryPath#" size="30" class="formField"></td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><h2>Base Resources:</h2></td></tr>
					<tr>
						<td colspan="2">
						
							<table style="width:100%;border:1px solid silver;">
								<tr>
									<th style="background-color:##ccc;width:50px;">No.</th>
									<th style="background-color:##ccc;width:100px;">Type</th>
									<th style="background-color:##ccc;">Value</th>
									<th style="background-color:##ccc;width:100px;">Action</th>
								</tr>
								<cfset index = 1>
								<cfloop list="#lstBaseResourceTypes#" index="resType">
									<cfset aRes = oHomePortalsConfigBean.getBaseResourcesByType(resType)>
									<cfloop from="1" to="#arrayLen(aRes)#" index="i">
										<tr <cfif index mod 2>class="altRow"</cfif>>
											<td style="width:50px;" align="right"><strong>#index#.</strong></td>
											<td style="width:100px;" align="center">#resType#</td>
											<td><a href="#aRes[i]#" target="_blank">#aRes[i]#</a></td>
											<td align="center">
												<a href="index.cfm?event=ehSettings.dspMain&baseResourceEditIndex=#i#&baseResourceEditType=#resType#"><img src="images/page_edit.png" border="0" alt="Edit base resource" title="Edit base resource"></a>
												<a href="##" onclick="confirmDeleteBaseResource('#resType#',#i#)"><img src="images/page_delete.png" border="0" alt="Delete base resource" title="Delete base resource"></a>
											</td>
										</tr>
										<cfset index = index + 1>
									</cfloop>
								</cfloop>
							</table>
							<cfif baseResourceEditIndex eq 0>
								<form name="frmAddBaseResource" action="index.cfm" method="post">
									<table style="width:100%;border:1px solid silver;margin-top:5px;">
										<tr>
											<td style="width:50px;" align="center"><strong>New:</strong></td>
											<td style="width:100px;">
												<select name="type" style="width:100px;font-size:11px;">
													<cfloop list="#lstBaseResourceTypes#" index="resType">
														<option value="#resType#">#resType#</option>
													</cfloop>
												</select>
											</td>
											<td>
												<input type="text" name="href" value="" style="width:340px;font-size:11px;">
											</td>
											<td style="width:100px;" align="center">
												<input type="button" name="btnSave" value="Apply" style="font-size:11px;" onclick="submitForm('ehSettings.doAddBaseResource')">
												<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=ehSettings.dspMain'">
											</td>
										</tr>
									</table>
								</form>
							<cfelseif baseResourceEditIndex gt 0>
								<cftry>
									<cfset aRes = oHomePortalsConfigBean.getBaseResourcesByType(baseResourceEditType)>
									<cfset baseResourceEditHREF = aRes[baseResourceEditIndex]>
									<cfcatch type="any">
										<cfset baseResourceEditHREF = "">
									</cfcatch>
								</cftry>
								<form name="frmEditBaseResource" action="index.cfm" method="post">
									<input type="hidden" name="index" value="#baseResourceEditIndex#">

									<table style="width:100%;border:1px solid silver;margin-top:5px;">
										<tr>
											<td style="width:50px;" align="center"><strong>Edit:</strong></td>
											<td style="width:100px;">
												<select name="type" style="width:100px;font-size:11px;">
													<cfloop list="#lstBaseResourceTypes#" index="resType">
														<option value="#resType#" <cfif resType eq baseResourceEditType>selected</cfif>>#resType#</option>
													</cfloop>
												</select>
											</td>
											<td>
												<input type="text" name="href" value="#baseResourceEditHREF#" style="width:340px;font-size:11px;">
											</td>
											<td style="width:100px;" align="center">
												<input type="button" name="btnSave" value="Apply" style="font-size:11px;" onclick="submitForm('ehSettings.doSaveBaseResource')">
												<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=ehSettings.dspMain'">
											</td>
										</tr>
									</table>
								</form>
							<cfelse>
								<br>
								<a href="index.cfm?event=ehSettings.dspMain&baseResourceEditIndex=0">Click Here</a> to add a base resources
							</cfif>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><h2>Render Templates:</h2></td></tr>
					<tr>
						<td width="150"><strong>Page:</strong></td>
						<td>
							<input type="text" name="rt_page" value="#rt_page#" size="30" class="formField">
							<a href="index.cfm?event=ehSettings.dspEditXML&configFile=#rt_page#">Edit XML</a>
						</td>
					</tr>
					<tr>
						<td width="150"><strong>Module:</strong></td>
						<td>
							<input type="text" name="rt_module" value="#rt_module#" size="30" class="formField">
							<a href="index.cfm?event=ehSettings.dspEditXML&configFile=#rt_module#">Edit XML</a>
						</td>
					</tr>
					<tr>
						<td width="150"><strong>Module (w/o Container):</strong></td>
						<td>
							<input type="text" name="rt_moduleNC" value="#rt_moduleNC#" size="30" class="formField">
							<a href="index.cfm?event=ehSettings.dspEditXML&configFile=#rt_moduleNC#">Edit XML</a>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td colspan="2" align="center" style="padding-top:5px;">
							<input type="button" name="btnSave" value="Apply Changes" onclick="submitForm('ehSettings.doSaveGeneral')">
						</td>
					</tr>
				</table>
			</form>


		</td>
		<td width="200">
			<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
				<div style="margin:10px;">
					<h2>General Settings</h2>
					This screen allows you to manipulate all HomePortals configuration settings. 
					These settings provide the default configuration for all HomePortals-based 
					applications running on this server.<br><br>
				</div>
			</div>
		</td>
	</tr>
</table>
</cfoutput>

