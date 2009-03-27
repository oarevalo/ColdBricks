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
	defaultPage = oHomePortalsConfigBean.getDefaultPage();
	resourceLibraryPath = oHomePortalsConfigBean.getResourceLibraryPath();
	pageCacheSize = oHomePortalsConfigBean.getPageCacheSize();
	pageCacheTTL = oHomePortalsConfigBean.getPageCacheTTL();
	contentCacheSize = oHomePortalsConfigBean.getContentCacheSize();
	contentCacheTTL = oHomePortalsConfigBean.getContentCacheTTL();
	rssCacheSize = oHomePortalsConfigBean.getRSSCacheSize();
	rssCacheTTL = oHomePortalsConfigBean.getRSSCacheTTL();
	contentRoot = oHomePortalsConfigBean.getContentRoot();
	
	try{ rt_page = oHomePortalsConfigBean.getRenderTemplate("page"); } catch(any e) { rt_page = ""; }
	try{ rt_module = oHomePortalsConfigBean.getRenderTemplate("module"); } catch(any e) { rt_module = ""; }
	try{ rt_moduleNC = oHomePortalsConfigBean.getRenderTemplate("moduleNoContainer"); } catch(any e) { rt_moduleNC = ""; }
	
	lstBaseResourceTypes = oHomePortalsConfigBean.getBaseResourceTypes();
	
	hasAccountsPlugin = request.requestState.oContext.getHomePortals().getPluginManager().hasPlugin("accounts");
	hasModulesPlugin = request.requestState.oContext.getHomePortals().getPluginManager().hasPlugin("modules");
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
<div>
	[ <a href="index.cfm?event=ehSiteConfig.dspMain"><strong>General</strong></a> ] &nbsp;&nbsp;
	<cfif hasAccountsPlugin>[ <a href="index.cfm?event=ehSiteConfig.dspAccounts">Accounts</a> ] &nbsp;&nbsp;</cfif>
	<cfif hasModulesPlugin>[ <a href="index.cfm?event=ehSiteConfig.dspModuleProperties">Module Properties</a> ] &nbsp;&nbsp;</cfif>
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
							<input type="checkbox" name="appSettings" value="appRoot" checked disabled>
							<strong>Application Root:</strong>
						</td>
						<td><input type="text" name="appRoot" value="#appRoot#" id="fld_appRoot" size="30" class="formField" disabled></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="contentRoot" <cfif structKeyExists(stAppConfig,"contentRoot")>checked</cfif> onclick="toggleField(this.checked,'contentRoot')">
							<strong>Content Root:</strong>
						</td>
						<td><input type="text" name="contentRoot" value="#contentRoot#" id="fld_contentRoot" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"contentRoot")>disabled</cfif>></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="defaultPage" <cfif structKeyExists(stAppConfig,"defaultPage")>checked</cfif> onclick="toggleField(this.checked,'defaultPage')">
							<strong>Default Page:</strong>
						</td>
						<td><input type="text" name="defaultPage" value="#defaultPage#" id="fld_defaultPage" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"defaultPage")>disabled</cfif>></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="resourceLibraryPath" <cfif structKeyExists(stAppConfig,"resourceLibraryPath")>checked</cfif> onclick="toggleField(this.checked,'resourceLibraryPath')">
							<strong>Resource Library Root:</strong>
						</td>
						<td><input type="text" name="resourceLibraryPath" value="#resourceLibraryPath#" id="fld_resourceLibraryPath" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"resourceLibraryPath")>disabled</cfif>></td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><h2>Caching:</h2></td></tr>
					<tr>
						<td width="170">
							<strong>Pages:</strong>
						</td>
						<td>
							<input type="checkbox" name="appSettings" value="pageCacheSize" <cfif structKeyExists(stAppConfig,"pageCacheSize")>checked</cfif> onclick="toggleField(this.checked,'pageCacheSize')">
							<strong>Max Size:</strong>
							<input type="text" name="pageCacheSize" value="#pageCacheSize#" id="fld_pageCacheSize" size="5" style="width:50px;" class="formField" <cfif not structKeyExists(stAppConfig,"pageCacheSize")>disabled</cfif>>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="appSettings" value="pageCacheTTL" <cfif structKeyExists(stAppConfig,"pageCacheTTL")>checked</cfif> onclick="toggleField(this.checked,'pageCacheTTL')">
							<strong>TTL (min):</strong>
							<input type="text" name="pageCacheTTL" value="#pageCacheTTL#" id="fld_pageCacheTTL" size="5" style="width:50px;" class="formField" <cfif not structKeyExists(stAppConfig,"pageCacheTTL")>disabled</cfif>>	
						</td>
					</tr>
					<tr>
						<td width="170">
							<strong>Content:</strong>
						</td>
						<td>
							<input type="checkbox" name="appSettings" value="contentCacheSize" <cfif structKeyExists(stAppConfig,"contentCacheSize")>checked</cfif> onclick="toggleField(this.checked,'contentCacheSize')">
							<strong>Max Size:</strong>
							<input type="text" name="contentCacheSize" value="#contentCacheSize#" id="fld_contentCacheSize" size="5" style="width:50px;" class="formField" <cfif not structKeyExists(stAppConfig,"contentCacheSize")>disabled</cfif>>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="appSettings" value="contentCacheTTL" <cfif structKeyExists(stAppConfig,"contentCacheTTL")>checked</cfif> onclick="toggleField(this.checked,'contentCacheTTL')">
							<strong>TTL (min):</strong>
							<input type="text" name="contentCacheTTL" value="#contentCacheTTL#" id="fld_contentCacheTTL" size="5" style="width:50px;" class="formField" <cfif not structKeyExists(stAppConfig,"contentCacheTTL")>disabled</cfif>>
						</td>
					</tr>
					<tr>
						<td width="170">
							<strong>RSS Feeds:</strong>
						</td>
						<td>
							<input type="checkbox" name="appSettings" value="rssCacheSize" <cfif structKeyExists(stAppConfig,"rssCacheSize")>checked</cfif> onclick="toggleField(this.checked,'rssCacheSize')">
							<strong>Max Size:</strong>
							<input type="text" name="rssCacheSize" value="#rssCacheSize#" id="fld_rssCacheSize" size="5" style="width:50px;" class="formField" <cfif not structKeyExists(stAppConfig,"rssCacheSize")>disabled</cfif>>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="appSettings" value="rssCacheTTL" <cfif structKeyExists(stAppConfig,"rssCacheTTL")>checked</cfif> onclick="toggleField(this.checked,'rssCacheTTL')">
							<strong>TTL (min):</strong>
							<input type="text" name="rssCacheTTL" value="#rssCacheTTL#" id="fld_rssCacheTTL" size="5" style="width:50px;" class="formField" <cfif not structKeyExists(stAppConfig,"rssCacheTTL")>disabled</cfif>>
						</td>
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

