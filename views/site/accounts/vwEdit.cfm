<!--- Accounts Manager Edit View --->
<cfparam name="request.requestState.accountID" default="">
<cfparam name="request.requestState.stAccountInfo" default="">
<cfparam name="request.requestState.qryAccount" default="">
<cfparam name="request.requestState.accountsRoot" default="">

<cfscript>
	accountID = request.requestState.accountID;
	stAccountInfo = request.requestState.stAccountInfo;
	qryAccount = request.requestState.qryAccount;
	accountsRoot = request.requestState.accountsRoot;
</cfscript>

<cfoutput>
	<br>
	<form name="frm" action="index.cfm" method="post">
	<table class="dataFormTable">
		<tr>
			<td width="100"><strong>Account Name:</strong></td>
			<td>
				<input type="text" name="accountname1" value="#qryAccount.accountname#" size="50" class="formField" disabled="yes">
				<input type="hidden" name="accountname" value="#qryAccount.accountname#">
			</td>
		</tr>
		<tr>
			<td>Account Directory:</td>
			<td><a href="#accountsRoot#/#qryAccount.accountname#" target="_blank">#accountsRoot#/#qryAccount.accountname#</a></td>
		</tr>
		<tr>
			<td colspan="2" style="font-size:9px;font-weight:bold;">
				<cfif qryAccount.createdOn neq "">
					<cfset tmpDate = parseDateTime(qryAccount.createdOn)>
					Account Created On #lsDateFormat(tmpDate)# #lsTimeFormat(tmpDate)#
				</cfif>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" style="font-size:13px;"><strong>Account Profile Information:</strong></td></tr>
		<tr><td colspan="2" style="font-size:10px;">This information is optional and is only applicable when using Accounts to identify individual users.</td></tr>
		<tr>
			<td>First Name:</td>
			<td><input type="text" name="firstName" value="#qryAccount.firstName#" size="50" class="formField"></td>
		</tr>
		<tr>
			<td>Last Name:</td>
			<td><input type="text" name="lastName" value="#qryAccount.lastName#" size="50" class="formField"></td>
		</tr>
		<tr>
			<td>Email:</td>
			<td><input type="text" name="email" value="#qryAccount.email#" size="50" class="formField"></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" style="font-size:13px;"><input type="checkbox" name="changePwd" value="1"> <b>Change Password</b></td></tr>
		<tr>
			<td>New Password:</td>
			<td><input type="password" name="pwd_new" value="" size="50" class="formField"></td>
		</tr>
		<tr>
			<td>Confirm New Password:</td>
			<td><input type="password" name="pwd_new2" value="" size="50" class="formField"></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" style="font-size:10px;">Fields in <strong>bold</strong> are required.</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center" style="padding-top:10px;">
				<input type="hidden" name="accountID" value="#accountID#">
				<input type="hidden" name="event" value="ehAccounts.doSave">
				<input type="submit" name="btnSave" value="Apply Changes">
				<input type="button" name="btnCancel" value="Return To Account Manager" onClick="document.location='?event=ehAccounts.dspMain'">
			</td>
		</tr>
	</table>
	</form>
	
</cfoutput>




