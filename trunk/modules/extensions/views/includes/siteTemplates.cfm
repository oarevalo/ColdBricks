<cfoutput>
	<form name="frmInstall" method="post" action="index.cfm" enctype="multipart/form-data">
		<input type="hidden" name="event" value="extensions.ehGeneral.doInstall">
		<input type="hidden" name="type" value="siteTemplate">
		<table class="browseTable" style="border:1px solid silver;background-color:##ebebeb;" cellpadding="3" cellspacing="0">
			<tr><td colspan="2"><b>Install ColdBricks SiteTemplate:</b></td></tr>
			<tr>
				<td style="width:110px;">Install from URL:</td>
				<td>
					http://<input type="text" name="installURL" value="" class="formField">
					<input type="submit" name="btnInstallURL" value="Install">
				</td>
			</tr>
			<tr>
				<td>Install from archive:</td>
				<td>
					<input type="file" name="installZip" value="">
					<input type="submit" name="btnInstallZIP" value="Install">
				</td>
			</tr>
		</table>
	</form>
	<br />

	<table class="browseTable">
		<tr>
			<th>Name</th>
			<th style="width:60px;">Version</th>
			<th>Description</th>
			<th style="width:100px;">Author</th>
			<th style="width:70px;">Actions</th>
		</tr>
		<cfloop from="1" to="#arrayLen(rs.siteTemplates)#" index="i">
			<tr <cfif index mod 2>class="altRow"</cfif>>
				<td><strong>#rs.siteTemplates[i].name#</strong></td>
				<td align="center">#rs.siteTemplates[i].version#</td>
				<td>#rs.siteTemplates[i].description#</td>
				<td align="center">
					<cfif rs.siteTemplates[i].author neq "" and rs.siteTemplates[i].authorurl neq "">
						<a href="#rs.modules[i].authorurl#" target="_blank">#rs.siteTemplates[i].author#</a>
					<cfelseif rs.siteTemplates[i].author neq "" and rs.siteTemplates[i].authorurl eq "">
						#rs.siteTemplates[i].author#
					<cfelseif rs.siteTemplates[i].author eq "" and rs.siteTemplates[i].authorurl neq "">
						<a href="#rs.siteTemplates[i].authorurl#" target="_blank">website</a>
					</cfif>
				</td>
				<td align="center">
					<a href="##" onclick="confirmUninstall('#jsStringFormat(rs.siteTemplates[i].name)#')"><img src="images/delete.png" align="absmiddle" border="0" alt="Uninstall"></a>
					<a href="##" onclick="confirmUninstall('#jsStringFormat(rs.siteTemplates[i].name)#')">Uninstall</a>
				</td>
			</tr>
			<cfset index = index + 1>
		</cfloop>
		<cfif arrayLen(rs.siteTemplates) eq 0>
			<tr>
				<td colspan="5"><em>There are no SiteTemplates installed</em></td>
			</tr>
		</cfif>
	</table>
</cfoutput>