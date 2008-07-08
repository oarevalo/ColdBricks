<cfparam name="request.requestState.qryUsers" default="#queryNew("")#">
<cfparam name="request.requestState.oUser" default="0">
<cfparam name="request.requestState.qryRoles" default="#queryNew("")#">

<cfset qryUsers = request.requestState.qryUsers>
<cfset oUser = request.requestState.oUser>
<cfset qryRoles = request.requestState.qryRoles>

<cfquery name="qryUsers" dbtype="query">
	SELECT qryUsers.*, qryRoles.label as roleLabel
		FROM qryUsers, qryRoles
		WHERE qryUsers.role = qryRoles.name
		
</cfquery>

<script type="text/javascript">
	function confirmDelete(ID) {
		if(confirm("Delete User?")) {
			var url = "index.cfm?event=ehUsers.doDelete&editUserID=" + ID;
			document.location = url;
		}
	}
</script>

<h2><img src="images/users_48x48.png" align="absmiddle"> User Management</h2>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>
			<div style="margin-top:10px;border:1px solid #ccc;height:400px;overflow:auto;">	
				<table class="browseTable" style="width:100%">	
					<tr>
						<th width="20">No</th>
						<th width="150">Username</th>
						<th>Full Name</th>
						<th>Role</th>
						<th width="70">Action</th>
					</tr>
					<cfoutput query="qryUsers">
						<tr <cfif qryUsers.currentRow mod 2>class="altRow"</cfif>>
							<td>#qryUsers.currentRow#</td>
							<td><a href="index.cfm?event=ehUsers.dspEdit&editUserID=#qryUsers.userID#">#qryUsers.username#</a></td>
							<td>#qryUsers.lastname#, #qryUsers.firstname#</td></td>
							<td align="center" width="100">#qryUsers.roleLabel#</td>
							<td align="center">
								<a href="index.cfm?event=ehUsers.dspEdit&editUserID=#qryUsers.userID#"><img src="images/user_edit.png" align="absmiddle" border="0" alt="Edit User" title="Edit User"></a>
								<a onclick="confirmDelete('#qryUsers.userID#')" href="##"><img src="images/user_delete.png" align="absmiddle" border="0" alt="Delete User" title="Delete User"></a>
							</td>
						</tr>
					</cfoutput>
					<cfif qryUsers.recordCount eq 0>
						<tr><td colspan="5"><em>No records found!</em></td></tr>
					</cfif>
				</table>
			</div>	

			<p>
				<cfif oUser.getIsAdministrator()>
					<input type="button" 
							name="btnCreate" 
							value="Create New User" 
							onClick="document.location='?event=ehUsers.dspEdit'">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</cfif>
				<b>Legend:</b> &nbsp;&nbsp;
				<img src="images/user_edit.png" align="absmiddle" border="0" alt="Edit User" title="Edit User"> Edit User Info &nbsp;&nbsp;
				<img src="images/user_delete.png" align="absmiddle" border="0" alt="Delete User" title="Delete User"> Delete User&nbsp;&nbsp;
			</p>
		</td>
		
		<td width="200">
			<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
				<div style="margin:10px;">
					<h2>ColdBricks Users</h2>
					<p>
						This screen allows you to manage all ColdBricks users. From here you can add, delete and edit user information.
					</p>
					<p>
						Please note that ColdBricks users are different from site accounts. ColdBricks users have full control of entire sites
						and can modify configuration, manage accounts, add and modify pages, etc.
					</p>
					<p>
						Only administrator users can create/delete sites, manage other users and modify server configuration. All other users
						can only manage the sites assigned to them.
					</p>
				</div>
			</div>
		</td>
	</tr>
</table>
			
