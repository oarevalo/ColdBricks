
<h2>Change Password</h2>

<cfoutput>
<form name="frm" method="post" action="index.cfm">
	<input type="hidden" name="event" value="ehGeneral.doChangePassword">
	<table>
		<tr>
			<td><strong>Username:</strong></td>
			<td>#request.requestState.userInfo.username#</td>
		</tr>
		<tr>
			<td><strong>Current Password:</strong></td>
			<td><input type="password" name="curr_pwd" value="" size="50" class="formField"></td>
		</tr>
		<tr valign="top">
			<td><strong>New Password:</strong></td>
			<td>
				<input type="password" name="new_pwd" value="" size="50" class="formField"><br>
				<span style="font-size:10px;"><b style="color:red;">Note:</b> for security reasons passwords must be at least 5 characters long</span>
			</td>
		</tr>
		<tr>
			<td><strong>Confirm New Password:</strong></td>
			<td><input type="password" name="new_pwd2" value="" size="50" class="formField"></td>
		</tr>

	</table>
	<br><br>
	<input type="submit" name="btn" value="Apply Changes">
	<input type="button" name="btnCancel" value="Cancel" onclick="document.location='index.cfm?event=ehGeneral.dspMain'">
</form>
</cfoutput>
