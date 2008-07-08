<!--- Accounts Manager Create Account View --->
<cfparam name="username" default="">
<cfparam name="password" default="">
<cfparam name="firstName" default="">
<cfparam name="middleName" default="">
<cfparam name="lastName" default="">
<cfparam name="email" default="">

<cfoutput>
	<br>
	<form name="frm" action="index.cfm" method="post">
		<input type="hidden" name="event" value="ehAccounts.doSave">
		<table class="dataFormTable">
			<tr>
				<td width="100"><strong>Username:</strong></td>
				<td><input type="text" name="username" value="#username#" size="50" class="formField"></td>
			</tr>
			<tr>
				<td width="100"><strong>Password:</strong></td>
				<td><input type="text" name="password" value="#password#" size="50" class="formField"></td>
			</tr>
			<tr>
				<td>First Name:</td>
				<td><input type="text" name="firstName" value="#firstName#" size="50" class="formField"></td>
			</tr>
			<tr>
				<td>Middle Name:</td>
				<td><input type="text" name="middleName" value="#middleName#" size="50" class="formField"></td>
			</tr>
			<tr>
				<td>Last Name:</td>
				<td><input type="text" name="lastName" value="#lastName#" size="50" class="formField"></td>
			</tr>
			<tr>
				<td><strong>Email:</strong></td>
				<td><input type="text" name="email" value="#email#" size="50" class="formField"></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2" style="font-size:10px;">Fields in <strong>bold</strong> are required.</td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center" style="padding-top:5px;">
					<input type="submit" name="btnSave" value="Create Account">
					<input type="button" name="btnCancel" value="Return To Account Manager" onClick="document.location='?event=ehAccounts.dspMain'">
				</td>
			</tr>
		</table>
	</form>
	
</cfoutput>

