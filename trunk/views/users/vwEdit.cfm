<cfparam name="request.requestState.qryUser" default="#queryNew("")#">
<cfparam name="request.requestState.qryUserSites" default="#queryNew("")#">
<cfparam name="request.requestState.qryUser" default="#queryNew("")#">
<cfparam name="request.requestState.qryRoles" default="#queryNew("")#">
<cfparam name="request.requestState.editUserID" default="0">

<cfset qryUser = request.requestState.qryUser>
<cfset qryUserSites = request.requestState.qryUserSites>
<cfset qrySites = request.requestState.qrySites>
<cfset qryRoles = request.requestState.qryRoles>
<cfset editUserID = request.requestState.editUserID>

<cfparam name="username" default="#qryUser.username#">
<cfparam name="password" default="#qryUser.password#">
<cfparam name="firstName" default="#qryUser.firstName#">
<cfparam name="lastName" default="#qryUser.lastName#">
<cfparam name="email" default="#qryUser.email#">
<cfparam name="role" default="#qryUser.role#">

<cfif isDefined("qryUser.administrator") and qryUser.role eq "">
	<cfif isBoolean(qryUser.administrator) and qryUser.administrator>
		<cfset tmpRole = "admin">
	<cfelse>
		<cfset tmpRole = "mngr">
	</cfif>
<cfelse>
	<cfset tmpRole = qryUser.role>
</cfif>

<cfset isAdmin = (tmpRole eq "admin")>


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
			<td><strong>Role:</strong></td>
			<td>
				<select name="role" class="formField">
					<cfloop query="qryRoles">
						<option value="#qryRoles.name#" <cfif tmpRole eq qryRoles.name>selected</cfif>>#qryRoles.label#</option>
					</cfloop>
				</select>
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
