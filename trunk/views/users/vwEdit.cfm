<cfparam name="request.requestState.qryUser" default="#queryNew("")#">
<cfparam name="request.requestState.qryUserSites" default="#queryNew("")#">
<cfparam name="request.requestState.qryUser" default="#queryNew("")#">
<cfparam name="request.requestState.editUserID" default="0">

<cfset qryUser = request.requestState.qryUser>
<cfset qryUserSites = request.requestState.qryUserSites>
<cfset qrySites = request.requestState.qrySites>
<cfset editUserID = request.requestState.editUserID>

<cfparam name="username" default="#qryUser.username#">
<cfparam name="password" default="#qryUser.password#">
<cfparam name="firstName" default="#qryUser.firstName#">
<cfparam name="lastName" default="#qryUser.lastName#">
<cfparam name="email" default="#qryUser.email#">
<cfparam name="administrator" default="#qryUser.administrator#">

<cfset isAdmin = isBoolean(administrator) and administrator>

<h2>Add/Edit User</h2>

<cfoutput>
<form name="frm" method="post" action="index.cfm">
	<input type="hidden" name="event" value="ehUsers.doSave">
	<input type="hidden" name="editUserID" value="#editUserID#">
	<table>
		<tr>
			<td><strong>Username:</strong></td>
			<td><input type="text" name="username" value="#username#" size="50" class="formField"></td>
		</tr>
		<tr>
			<td><strong>Password:</strong></td>
			<td><input type="text" name="password" value="#password#" size="50" class="formField"></td>
		</tr>
		<tr>
			<td><strong>First Name:</strong></td>
			<td><input type="text" name="firstName" value="#firstName#" size="50" class="formField"></td>
		</tr>
		<tr>
			<td><strong>Last Name:</strong></td>
			<td><input type="text" name="lastName" value="#lastName#" size="50" class="formField"></td>
		</tr>
		<tr>
			<td><strong>Email:</strong></td>
			<td><input type="text" name="email" value="#email#" size="50" class="formField"></td>
		</tr>
		<tr>
			<td><strong>Administrator:</strong></td>
			<td>
				<input type="checkbox" name="administrator" value="1" <cfif isAdmin>checked</cfif>>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<cfif not isAdmin>
		<tr valign="top">
			<td><strong>Allowed Sites:</strong></td>
			<td>
				<cfset lstUserSites = valueList(qryUserSites.siteID)>
				<select name="lstSiteID" multiple="true" size="5" class="formField">
					<cfloop query="qrySites">
						<option value="#qrySites.siteID#" <cfif listFind(lstUserSites,qrySites.siteID)>selected</cfif>>#qrySites.siteName#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		</cfif>
	</table>
	<br><br>
	<input type="submit" name="btn" value="Apply Changes">
	<input type="button" name="btnCancel" value="Cancel" onclick="document.location='index.cfm?event=ehUsers.dspMain'">
</form>
</cfoutput>
