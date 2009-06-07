<cfparam name="request.requestState.oAccountsConfigBean" default="">
<cfparam name="request.requestState.stAppConfig" default="">
<cfscript>
	oAccountsConfigBean = request.requestState.oAccountsConfigBean;
	stAppConfig = request.requestState.stAppConfig;
	
	accountsRoot = oAccountsConfigBean.getAccountsRoot();
	defaultAccount = oAccountsConfigBean.getDefaultAccount();
	newAccountTemplate = oAccountsConfigBean.getNewAccountTemplate();
	newPageTemplate = oAccountsConfigBean.getNewPageTemplate();
	storageType = oAccountsConfigBean.getStorageType();
	datasource = oAccountsConfigBean.getDatasource();
	username = oAccountsConfigBean.getUsername();
	password = oAccountsConfigBean.getPassword();
	dbType = oAccountsConfigBean.getDBType();
	dataroot = oAccountsConfigBean.getDataRoot();

	hasAccountsPlugin = request.requestState.oContext.getHomePortals().getPluginManager().hasPlugin("accounts");
	hasModulesPlugin = request.requestState.oContext.getHomePortals().getPluginManager().hasPlugin("modules");
</cfscript>

<script type="text/javascript">
	function toggleField(chk,fld) {
		document.getElementById("fld_"+fld).disabled = !chk;
	}
</script>

<cfoutput>
<div>
	[ <a href="index.cfm?event=siteConfig.ehSiteConfig.dspMain">General</a> ] &nbsp;&nbsp;
	<cfif hasAccountsPlugin>[ <a href="index.cfm?event=siteConfig.ehSiteConfig.dspAccounts"><strong>Accounts</strong></a> ] &nbsp;&nbsp;</cfif>
	<cfif hasModulesPlugin>[ <a href="index.cfm?event=siteConfig.ehSiteConfig.dspModuleProperties">Module Properties</a> ] &nbsp;&nbsp;</cfif>
	[ <a href="index.cfm?event=siteConfig.ehSiteConfig.dspEditXML">Edit Config Files</a> ] &nbsp;&nbsp;
</div>

<br>

<table style="margin:0px;padding:0px;width:100%;" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>

			<form name="frm" method="post" action="index.cfm">
				<input type="hidden" name="event" value="siteConfig.ehSiteConfig.doSaveAccounts">
			
				<table class="dataFormTable">
					<tr><td colspan="2"><h2>General Settings:</h2></td></tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="accountsRoot" <cfif structKeyExists(stAppConfig,"accountsRoot")>checked</cfif> onclick="toggleField(this.checked,'accountsRoot')">
							<strong>Accounts Root:</strong>
						</td>
						<td><input type="text" name="accountsRoot" value="#accountsRoot#" id="fld_accountsRoot" size="30" class="formField" <cfif not structKeyExists(stAppConfig,"accountsRoot")>disabled</cfif>></td>
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
							<input type="checkbox" name="appSettings" value="storageType" <cfif structKeyExists(stAppConfig,"storageType")>checked</cfif> onclick="toggleField(this.checked,'storageType')">
							<strong>Account Storage Type:</strong>
						</td>
						<td>
							<select name="storageType" class="formField" id="fld_storageType" <cfif not structKeyExists(stAppConfig,"accountsRoot")>disabled</cfif>>
								<option value="xml" <cfif storageType eq "xml">selected</cfif>>XML File</option>
								<option value="db" <cfif storageType eq "db">selected</cfif>>Database</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2">
						<h2 style="margin-bottom:6px;">XML Storage Settings:</h2>
						<div style="font-size:11px;line-height:18px;color:red;"><b>Note:</b> Settings on this section are only applicable when the selected Account Storage is 'XML File'</div>
					</td></tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="dataroot" <cfif structKeyExists(stAppConfig,"dataroot")>checked</cfif> onclick="toggleField(this.checked,'dataroot')">
							<strong>Data Root:</strong>
						</td>
						<td><input type="text" name="dataroot" value="#dataroot#" size="30" class="formField" id="fld_dataroot" <cfif not structKeyExists(stAppConfig,"dataroot")>disabled</cfif>></td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2">
						<h2 style="margin-bottom:6px;">DB Storage Settings:</h2>
						<div style="font-size:11px;line-height:18px;color:red;"><b>Note:</b> Settings on this section are only applicable when the selected Account Storage is 'Database'</div>
					</td></tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="datasource" <cfif structKeyExists(stAppConfig,"datasource")>checked</cfif> onclick="toggleField(this.checked,'datasource')">
							<strong>Datasource:</strong>
						</td>
						<td><input type="text" name="datasource" value="#datasource#" size="30" class="formField" id="fld_datasource" <cfif not structKeyExists(stAppConfig,"datasource")>disabled</cfif>></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="username" <cfif structKeyExists(stAppConfig,"username")>checked</cfif> onclick="toggleField(this.checked,'username')">
							<strong>Username:</strong>
						</td>
						<td><input type="text" name="username" value="#username#" size="30" class="formField" id="fld_username" <cfif not structKeyExists(stAppConfig,"username")>disabled</cfif>></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="password" <cfif structKeyExists(stAppConfig,"password")>checked</cfif> onclick="toggleField(this.checked,'password')">
							<strong>password:</strong>
						</td>
						<td><input type="text" name="password" value="#password#" size="30" class="formField" id="fld_password" <cfif not structKeyExists(stAppConfig,"password")>disabled</cfif>></td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="dbType" <cfif structKeyExists(stAppConfig,"dbType")>checked</cfif> onclick="toggleField(this.checked,'dbType')">
							<strong>DB Type:</strong>
						</td>
						<td>
							<select name="dbType" class="formField" id="fld_dbType" <cfif not structKeyExists(stAppConfig,"dbType")>disabled</cfif>>
								<option value="MSSQL" <cfif dbType eq "MSSQL">selected</cfif>>MS SQL Server</option>
								<option value="MySQL" <cfif dbType eq "MySQL">selected</cfif>>MySQL</option>
								<option value="Other" <cfif dbType neq "MSSQL" and dbType neq "MySQL">selected</cfif>>Other</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><h2>Account Templates:</h2></td></tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="newAccountTemplate" <cfif structKeyExists(stAppConfig,"newAccountTemplate")>checked</cfif> onclick="toggleField(this.checked,'newAccountTemplate')">
							<strong>New Account:</strong>
						</td>
						<td>
							<input type="text" name="newAccountTemplate" value="#newAccountTemplate#" size="30" class="formField" id="fld_newAccountTemplate" <cfif not structKeyExists(stAppConfig,"newAccountTemplate")>disabled</cfif>>
							<cfif structKeyExists(stAppConfig,"newAccountTemplate")>
								<a href="index.cfm?event=siteConfig.ehSiteConfig.dspEditXML&configFile=#newAccountTemplate#">Edit XML</a>
							</cfif>
						</td>
					</tr>
					<tr>
						<td width="170">
							<input type="checkbox" name="appSettings" value="newPageTemplate" <cfif structKeyExists(stAppConfig,"newPageTemplate")>checked</cfif> onclick="toggleField(this.checked,'newPageTemplate')">
							<strong>New Page:</strong>
						</td>
						<td>
							<input type="text" name="newPageTemplate" value="#newPageTemplate#" size="30" class="formField" id="fld_newPageTemplate" <cfif not structKeyExists(stAppConfig,"newPageTemplate")>disabled</cfif>>
							<cfif structKeyExists(stAppConfig,"newPageTemplate")>
								<a href="index.cfm?event=siteConfig.ehSiteConfig.dspEditXML&configFile=#newPageTemplate#">Edit XML</a>
							</cfif>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td colspan="2" align="center" style="padding-top:5px;">
							<input type="submit" name="btnSave" value="Apply Changes">
						</td>
					</tr>
				</table>
			</form>

		</td>
		<td width="200">
			<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
				<div style="margin:10px;">
					<h2>Account Settings</h2>
					From this screen you can configure how the Accounts are managed in the current site.
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

