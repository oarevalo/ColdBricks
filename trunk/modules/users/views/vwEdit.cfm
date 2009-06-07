<cfparam name="request.requestState.qryUser" default="#queryNew("")#">
<cfparam name="request.requestState.qrySites" default="#queryNew("")#">
<cfparam name="request.requestState.qryRoles" default="#queryNew("")#">
<cfparam name="request.requestState.qryUserSites" default="#queryNew("")#">
<cfparam name="request.requestState.editUserID" default="0">

<cfset qryUser = request.requestState.qryUser>
<cfset qrySites = request.requestState.qrySites>
<cfset qryRoles = request.requestState.qryRoles>
<cfset qryUserSites = request.requestState.qryUserSites>
<cfset editUserID = request.requestState.editUserID>

<cfset lstUserSites = valueList(qryUserSites.siteID)>

<cfparam name="username" default="#qryUser.username#">
<cfparam name="password" default="#qryUser.password#">
<cfparam name="firstName" default="#qryUser.firstName#">
<cfparam name="lastName" default="#qryUser.lastName#">
<cfparam name="email" default="#qryUser.email#">
<cfparam name="role" default="#qryUser.role#">

<cfset isAdmin = (role eq "admin")>

<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
<script type="text/javascript">
	function changeRole(role) {
		showHelp(role);
		
		d1 = document.getElementById("lstSiteID");
		d2 = document.getElementById("lstPluginID");

		d1.disabled = (role=="admin");
		d2.disabled = (role=="admin" || role=="mngr");
	}
	function showHelp(key) {
		var helpText = "";
		<cfoutput query="qryRoles">
			if(key=="#qryRoles.name#") helpText = "#jsstringFormat(qryRoles.description)#";
		</cfoutput>		
		$("helpTextDiv").style.display = "block";
		$("helpTextDiv").innerHTML = "<img src='images/help.png' align='absmiddle'> " + helpText;
	}
	function hideDBHelp() {
		$("helpTextDiv").style.display = "none";
	}	
</script>

<style type="text/css">
#helpTextDiv {
	margin-top:5px;
	border:1px solid #ccc;
	background-color:#ffffe1;
	padding:10px;
	font-size:12px;
	line-height:18px;
	width:400px;
}
</style>

<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>	
			<form name="frm" method="post" action="index.cfm">
				<input type="hidden" name="event" value="users.ehUsers.doSave">
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
						<td>First Name:</td>
						<td><input type="text" name="firstName" value="#firstName#" size="50" class="formField"></td>
					</tr>
					<tr>
						<td>Last Name:</td>
						<td><input type="text" name="lastName" value="#lastName#" size="50" class="formField"></td>
					</tr>
					<tr>
						<td>Email:</td>
						<td><input type="text" name="email" value="#email#" size="50" class="formField"></td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr valign="top">
						<td><strong>Role:</strong></td>
						<td>
							<select name="role" class="formField" onchange="changeRole(this.value)">
								<option value=""></option>
								<cfloop query="qryRoles">
									<option value="#qryRoles.name#" <cfif role eq qryRoles.name>selected</cfif>>#qryRoles.label#</option>
								</cfloop>
							</select>
							<div id="helpTextDiv" style="display:none;"></div>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td colspan="2">
							<table width="100%">
								<tr>
									<td width="50%">
										<strong>Allowed Sites:</strong><br>
										<select id="lstSiteID" name="lstSiteID" multiple="true" size="5" class="formField" style="width:200px;">
											<cfloop query="qrySites">
												<option value="#qrySites.siteID#" <cfif listFind(lstUserSites,qrySites.siteID)>selected</cfif>>#qrySites.siteName#</option>
											</cfloop>
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>
				* Fields in <b>bold</b> are required.
				<br><br>
				<input type="submit" name="btn" value="Apply Changes">
				<input type="button" name="btnCancel" value="Cancel" onclick="document.location='index.cfm?event=users.ehUsers.dspMain'">
			</form>
		</td>
		
		<td width="250">
			<div class="cp_sectionBox helpBox"  style="margin:0px;height:450px;line-height:18px;width:250px;">
				<div style="margin:10px;">
					<h2>Add/Edit Users</h2>
					<p>
						This screen allows you to either create new ColdBricks users or modify details for existing users.
					</p>
					<p>
						<strong>&raquo; User Roles:</strong><br>
						Roles determine the ColdBricks features available to a user. All users must be assigned to a role. 
					</p>
					<p>
						<strong>&raquo; Allowed Sites:</strong><br>
						All non-administrator users must be granted explicit access to one or more sites. Use the select field to choose all sites
						the given user will be allowed to access. 
					</p>
				</div>
			</div>
		</td>
	</tr>
</table>

<cfif role neq "">
	<script type="text/javascript">
		changeRole('#role#');
	</script>
</cfif>

</cfoutput>
