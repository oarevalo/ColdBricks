<cfparam name="request.requestState.qrySites" default="#queryNew("")#">
<cfparam name="request.requestState.qryUserSites" default="#queryNew("")#">
<cfparam name="request.requestState.userInfo" default="#queryNew("")#">

<cfset qrySites = request.requestState.qrySites>
<cfset qryUserSites = request.requestState.qryUserSites>
<cfset userInfo = request.requestState.userInfo>

<!--- if not admin user, then show only allowed sites --->
<cfif not userInfo.administrator>
	<cfquery name="qrySites" dbtype="query">
		SELECT *
			FROM qrySites, qryUserSites
			WHERE qrySites.siteID = qryUserSites.siteID
			ORDER BY siteName
	</cfquery>
</cfif>

<!--- check if there is another site besides the hp engine --->
<cfquery name="qrySitesCheck" dbtype="query">
	SELECT *
		FROM qrySites
		WHERE siteName NOT LIKE 'HomePortalsEngine'
		ORDER BY siteName
</cfquery>


<h2><img src="images/folder_desktop_48x48.png" align="absmiddle"> Site Management</h2>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>
			<cfif userInfo.administrator and qrySitesCheck.recordCount eq 0>
				<div class="helpBox" style="margin-top:10px;padding:10px;border:1px solid silver;">
					<img src="images/quick_start.gif" style="margin-bottom:5px;"><br>
					It seems that you have no sites configured to manage with ColdBricks.
					<cfif qrySites.recordCount eq 1>
						The site you see here, <b>HomePortalsEngine</b>, is the runtime engine for
						the HomePortals framework. <em>It is highly recommended to not modify this site adding 
						your own content.</em><br>
					</cfif>
					<b>To get started with your first site,</b> either <a href="index.cfm?event=ehSites.dspCreate" title="Click here to go to the create site screen">Create a Site</a> 
					or <a href="index.cfm?event=ehSites.dspRegister" title="Click here to register an existing HomePortals-based site on this server">Register an Existing Site</a>
				</div>
			</cfif>
			<div style="margin-top:10px;border:1px solid #ccc;height:400px;overflow:auto;">	
				<table class="browseTable" style="width:100%;">	
					<tr>
						<th width="20">No</th>
						<th>Site</th>
						<th>URL</th>
						<th width="70">Action</th>
					</tr>
					<cfoutput query="qrySites">
						<cfif qrySites.path eq "/">
							<cfset tmpRefreshURL = "/index.cfm?refreshApp=1">
						<cfelse>
							<cfset tmpRefreshURL = qrySites.path & "/index.cfm?refreshApp=1">
						</cfif>
						
						<tr <cfif qrySites.currentRow mod 2>class="altRow"</cfif>>
							<td>#qrySites.currentRow#</td>
							<td><a href="index.cfm?event=ehSite.doLoadSite&siteID=#qrySites.siteID#" onclick="overlay()" alt="Click to open site" title="Click to open site">#qrySites.siteName#</a></td>
							<td><a href="#qrySites.path#" target="_blank" alt="Click to visit site" title="Click to visit site">#qrySites.path#</a></td></td>
							<td align="center">
								<a href="#tmpRefreshURL#" target="_blank"><img src="images/arrow_refresh.png" align="absmiddle" border="0" alt="Reset Site" title="Reset Site"></a>
								<a href="index.cfm?event=ehSite.doLoadSite&siteID=#qrySites.siteID#" onclick="overlay()" ><img src="images/page_edit.png" align="absmiddle" border="0" alt="Open Site" title="Open Site"></a>
								<cfif userInfo.administrator>
									<a href="index.cfm?event=ehSites.dspDelete&siteID=#qrySites.siteID#"><img src="images/page_delete.png" align="absmiddle" border="0" alt="Delete Site" title="Delete Site"></a>
								</cfif>
								<a href="index.cfm?event=ehSites.doArchiveSite&siteID=#qrySites.siteID#"><img src="images/compress.png" align="absmiddle" border="0" alt="Create Achive of Site" title="Create Achive of Site"></a>
							</td>
						</tr>
					</cfoutput>
					<cfif qrySites.recordCount eq 0>
						<tr><td colspan="4"><em>No records found!</em></td></tr>
					</cfif>
				</table>
			</div>	

			<p>
				<cfif userInfo.administrator>
					<input type="button" 
							name="btnCreate" 
							value="Create New Site" 
							onClick="document.location='?event=ehSites.dspCreate'">
					&nbsp;&nbsp;
					<input type="button" 
							name="btnRegister" 
							value="Register Existing Site" 
							onClick="document.location='?event=ehSites.dspRegister'">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</cfif>
				<b>Legend:</b> &nbsp;&nbsp;
				<img src="images/arrow_refresh.png" align="absmiddle" border="0" alt="Reset Site" title="Reset Site"> Reset Site &nbsp;&nbsp;
				<img src="images/page_edit.png" align="absmiddle" border="0" alt="Open Site" title="Open Site"> Open Site &nbsp;&nbsp;
				<cfif userInfo.administrator>
					<img src="images/page_delete.png" align="absmiddle" border="0" alt="Delete Site" title="Delete Site"> Delete Site&nbsp;&nbsp;
				</cfif>
				<img src="images/compress.png" align="absmiddle" border="0" alt="Create Achive of Site" title="Create Achive of Site"> Create Achive of Site &nbsp;&nbsp;
			</p>
		</td>
		
		<td width="200">
			<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
				<div style="margin:10px;">
					<h2>Sites</h2>
					<p>
						<strong>ColdBricks</strong> allows you to manage multiple independent sites or portals. 
					</p>
					<p>
						From this screen you can see all sites that are available for you to manage and access. Only <b>Administrator</b>
						users can have access to all sites on the server; other users may only see sites that are assigned to them.
					</p>
					<p>
						Click on the site name to load and open the site. From there you can manage site configuration, accounts, resources and 
						site map.
					</p>
				</div>
			</div>
		</td>
	</tr>
</table>

<div id="overlay">
     <div>
          <p>Loading site. Please wait...</p>
		<img src="images/animLoading.gif" align="Absmiddle">
     </div>
</div>
