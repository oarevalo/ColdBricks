<cfparam name="request.requestState.oAccountsConfigBean" default="">
<cfscript>
	oAccountsConfigBean = request.requestState.oAccountsConfigBean;
	
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
</cfscript>


<cfoutput>
<cfinclude template="includes/nav.cfm">

<br>

<table style="margin:0px;padding:0px;width:100%;" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>

			<form name="frm" method="post" action="index.cfm">
				<input type="hidden" name="event" value="ehSettings.doSaveAccounts">
			
				<table class="dataFormTable">
					<tr><td colspan="2"><h2>General Settings:</h2></td></tr>
					<tr>
						<td width="150"><strong>Accounts Root:</strong></td>
						<td><input type="text" name="accountsRoot" value="#accountsRoot#" size="30" class="formField"></td>
					</tr>
					<tr>
						<td width="150"><strong>Default Account:</strong></td>
						<td><input type="text" name="defaultAccount" value="#defaultAccount#" id="fld_defaultAccount" size="30" class="formField"></td>
					</tr>
					<tr>
						<td width="150"><strong>Account Storage Type:</strong></td>
						<td>
							<select name="storageType" class="formField">
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
						<td width="150"><strong>Data Root:</strong></td>
						<td><input type="text" name="dataroot" value="#dataroot#" size="30" class="formField"></td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2">
						<h2 style="margin-bottom:6px;">DB Storage Settings:</h2>
						<div style="font-size:11px;line-height:18px;color:red;"><b>Note:</b> Settings on this section are only applicable when the selected Account Storage is 'Database'</div>
					</td></tr>
					<tr>
						<td width="150"><strong>Datasource:</strong></td>
						<td><input type="text" name="datasource" value="#datasource#" size="30" class="formField"></td>
					</tr>
					<tr>
						<td width="150"><strong>Username:</strong></td>
						<td><input type="text" name="username" value="#username#" size="30" class="formField"></td>
					</tr>
					<tr>
						<td width="150"><strong>password:</strong></td>
						<td><input type="text" name="password" value="#password#" size="30" class="formField"></td>
					</tr>
					<tr>
						<td width="150"><strong>DB Type:</strong></td>
						<td>
							<select name="dbType" class="formField">
								<option value="MSSQL" <cfif dbType eq "MSSQL">selected</cfif>>MS SQL Server</option>
								<option value="MySQL" <cfif dbType eq "MySQL">selected</cfif>>MySQL</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><h2>Account Templates:</h2></td></tr>
					<tr>
						<td width="150"><strong>New Account:</strong></td>
						<td>
							<input type="text" name="newAccountTemplate" value="#newAccountTemplate#" size="30" class="formField">
							<a href="index.cfm?event=ehSettings.dspEditXML&configFile=#newAccountTemplate#">Edit XML</a>
						</td>
					</tr>
					<tr>
						<td width="150"><strong>New Page:</strong></td>
						<td>
							<input type="text" name="newPageTemplate" value="#newPageTemplate#" size="30" class="formField">
							<a href="index.cfm?event=ehSettings.dspEditXML&configFile=#newPageTemplate#">Edit XML</a>
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
					From this screen you can configure the way HomePortals will handle the storage of accounts.
					<br><br>
				</div>
			</div>
		</td>
	</tr>
</table>
</cfoutput>

