<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.baseResourceEditIndex" default="">
<cfparam name="request.requestState.baseResourceEditType" default="">
<cfparam name="request.requestState.stAppConfig" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	baseResourceEditIndex = request.requestState.baseResourceEditIndex;
	baseResourceEditType = request.requestState.baseResourceEditType;
	stAppConfig = request.requestState.stAppConfig;
	
	appRoot = oHomePortalsConfigBean.getAppRoot();
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
	function confirmDeleteBaseResource(type, href) {
		if(confirm("Delete base resource?")) {
			document.location = "index.cfm?event=ehSiteConfig.doDeleteBaseResource&type=" + type + "&href=" + href;
		}
	}
	
	function submitForm(event) {
		document.frm.event.value = event;
		document.frm.submit();
	}
	
	function toggleField(chk,fld) {
		document.getElementById("fld_"+fld).disabled = !chk;
	}
</script>

<cfoutput>
<cfmodule template="../../../includes/menu_site.cfm" title="Site Settings" icon="configure_48x48.png">

<div>
	[ <a href="index.cfm?event=ehSiteConfig.dspMain"><strong>General</strong></a> ] &nbsp;&nbsp;
	[ <a href="index.cfm?event=ehSiteConfig.dspAccounts">Accounts</a> ] &nbsp;&nbsp;
	[ <a href="index.cfm?event=ehSiteConfig.dspModuleProperties">Module Properties</a> ] &nbsp;&nbsp;
	[ <a href="index.cfm?event=ehSiteConfig.dspEditXML">Edit Config Files</a> ] &nbsp;&nbsp;
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
						<td width="170">
							<input type="checkbox" name="appSettings" value="accountsRoot" checked disabled>
							<strong>Application Root:</strong>
						</td>
						<td><input type="text" name="appRoot" value="#appRoot#" id="fld_appRoot" size="30" class="formField" disabled></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="accountsRoot" <cfif structKeyExists(stAppConfig,"accountsRoot")>checked</cfif> onclick="toggleField(this.checked,'accountsRoot')">
							<strong>Accounts Root:</strong>
						</td>
						<td><input type="text" name="accountsRoot" value="#accountsRoot#" id="fld_accountsRoot" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"accountsRoot")>disabled</cfif>></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="resourceLibraryPath" <cfif structKeyExists(stAppConfig,"resourceLibraryPath")>checked</cfif> onclick="toggleField(this.checked,'resourceLibraryPath')">
							<strong>Resource Library Root:</strong>
						</td>
						<td><input type="text" name="resourceLibraryPath" value="#resourceLibraryPath#" id="fld_resourceLibraryPath" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"resourceLibraryPath")>disabled</cfif>></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="defaultAccount" <cfif structKeyExists(stAppConfig,"defaultAccount")>checked</cfif> onclick="toggleField(this.checked,'defaultAccount')">
							<strong>Default Account:</strong>
						</td>
						<td><input type="text" name="defaultAccount" value="#defaultAccount#" id="fld_defaultAccount" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"defaultAccount")>disabled</cfif>></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="pageCacheSize" <cfif structKeyExists(stAppConfig,"pageCacheSize")>checked</cfif> onclick="toggleField(this.checked,'pageCacheSize')">
							<strong>Page Cache Max Size:</strong>
						</td>
						<td><input type="text" name="pageCacheSize" value="#pageCacheSize#" id="fld_pageCacheSize" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"pageCacheSize")>disabled</cfif>></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="pageCacheTTL" <cfif structKeyExists(stAppConfig,"pageCacheTTL")>checked</cfif> onclick="toggleField(this.checked,'pageCacheTTL')">
							<strong>Page Cache TTL (min):</strong>
						</td>
						<td><input type="text" name="pageCacheTTL" value="#pageCacheTTL#" id="fld_pageCacheTTL" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"pageCacheTTL")>disabled</cfif>></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="contentCacheSize" <cfif structKeyExists(stAppConfig,"contentCacheSize")>checked</cfif> onclick="toggleField(this.checked,'contentCacheSize')">
							<strong>Content Cache Max Size:</strong>
						</td>
						<td><input type="text" name="contentCacheSize" value="#contentCacheSize#" id="fld_contentCacheSize" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"contentCacheSize")>disabled</cfif>></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="contentCacheTTL" <cfif structKeyExists(stAppConfig,"contentCacheTTL")>checked</cfif> onclick="toggleField(this.checked,'contentCacheTTL')">
							<strong>Content Catch TTL (min):</strong>
						</td>
						<td><input type="text" name="contentCacheTTL" value="#contentCacheTTL#" id="fld_contentCacheTTL" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"contentCacheTTL")>disabled</cfif>></td>
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
										
										<cfset isFromApp = structKeyExists(stAppConfig,"baseResources") 
															and structKeyExists(stAppConfig.baseResources, resType)
															and listFindNoCase(arrayToList(stAppConfig.baseResources[resType]),aRes[i])>
										
										<tr <cfif index mod 2>class="altRow"</cfif>>
											<td style="width:50px;" align="right"><strong>#index#.</strong></td>
											<td style="width:100px;" align="center">#resType#</td>
											<td><a href="#aRes[i]#" target="_blank">#aRes[i]#</a></td>
											<td align="center">
												<cfif isFromApp>
													<a href="index.cfm?event=ehSiteConfig.dspMain&baseResourceEditIndex=#i#&baseResourceEditType=#resType#"><img src="images/page_edit.png" border="0" alt="Edit base resource" title="Edit base resource"></a>
													<a href="##" onclick="confirmDeleteBaseResource('#resType#','#jsstringFormat(urlencodedformat(aRes[i]))#')"><img src="images/page_delete.png" border="0" alt="Delete base resource" title="Delete base resource"></a>
												<cfelse>
													< base >
												</cfif>
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
												<input type="button" name="btnSave" value="Apply" style="font-size:11px;" onclick="submitForm('ehSiteConfig.doAddBaseResource')">
												<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=ehSiteConfig.dspMain'">
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
									<input type="hidden" name="type_old" value="#baseResourceEditType#">
									<input type="hidden" name="href_old" value="#baseResourceEditHREF#">

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
												<input type="button" name="btnSave" value="Apply" style="font-size:11px;" onclick="submitForm('ehSiteConfig.doSaveBaseResource')">
												<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=ehSiteConfig.dspMain'">
											</td>
										</tr>
									</table>
								</form>
							<cfelse>
								<br>
								<img src="images/page_add.png" align="absmiddle"> <a href="index.cfm?event=ehSiteConfig.dspMain&baseResourceEditIndex=0"><strong>Click Here</strong></a> <strong>to add a base resource</strong>
							</cfif>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><h2>Render Templates:</h2></td></tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="rt_page" <cfif structKeyExists(stAppConfig,"rt_page")>checked</cfif> onclick="toggleField(this.checked,'rt_page')">
							<strong>Page:</strong>
						</td>
						<td>
							<input type="text" name="rt_page" value="#rt_page#" id="fld_rt_page" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"rt_page")>disabled</cfif>>
							<cfif structKeyExists(stAppConfig,"rt_page")>
								<a href="index.cfm?event=ehSiteConfig.dspEditXML&configFile=#rt_page#">Edit XML</a>
							</cfif>
						</td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="rt_module" <cfif structKeyExists(stAppConfig,"rt_module")>checked</cfif> onclick="toggleField(this.checked,'rt_module')">
							<strong>Module:</strong>
						</td>
						<td>
							<input type="text" name="rt_module" value="#rt_module#" id="fld_rt_module" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"rt_module")>disabled</cfif>>
							<cfif structKeyExists(stAppConfig,"rt_module")>
								<a href="index.cfm?event=ehSiteConfig.dspEditXML&configFile=#rt_module#">Edit XML</a>
							</cfif>
						</td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="rt_moduleNC" <cfif structKeyExists(stAppConfig,"rt_moduleNC")>checked</cfif> onclick="toggleField(this.checked,'rt_moduleNC')">
							<strong>Module (w/o Container):</strong>
						</td>
						<td>
							<input type="text" name="rt_moduleNC" value="#rt_moduleNC#" id="fld_rt_moduleNC" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"rt_moduleNC")>disabled</cfif>>
							<cfif structKeyExists(stAppConfig,"rt_moduleNC")>
								<a href="index.cfm?event=ehSiteConfig.dspEditXML&configFile=#rt_moduleNC#">Edit XML</a>
							</cfif>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td colspan="2" align="center" style="padding-top:5px;">
							<input type="button" name="btnSave" value="Apply Changes" onclick="submitForm('ehSiteConfig.doSaveGeneral')">
						</td>
					</tr>
				</table>
			</form>


		</td>
		<td width="200">
			<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
				<div style="margin:10px;">
					<h2>Site Settings</h2>
					This screen allows you to manipulate the general settings for this site.
					<br><br>
					The values shown in the disabled fields are the default values set in
					the main server settings screen. To override a default value mark the checkbox
					and enter the new value. New values are only applied to the current site.
				</div>
			</div>
		</td>
	</tr>
</table>
</cfoutput>

