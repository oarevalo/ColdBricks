<cfoutput>
	<table cellspacing="5">
		<tr>
			<td width="60">
				<strong>Site Template:</strong><br>
			</td>
			<td style="color:##999;font-weight:bold;font-size:12px;" id="siteTemplate2">#siteTemplate#</td>
		</tr>
		<tr>
			<td colspan="2">
				<strong>Site Name:</strong>
				<div style="color:##666;line-height:18px;width:600px;">
					Enter a name to identify the new site. Name must contain only letters, digits, underscore, and spaces.
				</div>
			</td>
		</tr>
		<tr valign="top">
			<td width="100">&nbsp;</td>
			<td>
				<input type="text" id="name" name="name" value="" size="50" class="formField" onblur="onChangeSiteName(this.value)"> 
				&nbsp; <span style="color:red;font-weight:bold;">required</span>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2">
				<strong>Application Root:</strong>
				<div style="color:##666;line-height:18px;width:600px;">
					Enter the URL path to where the new site will be deployed. Paths are always relative
					to the web root. To deploy the site to the webroot enter "/".
				</div>
			</td>
		</tr>
		<tr valign="top">
			<td>&nbsp;</td>
			<td>
				<input type="text" id="appRoot" name="appRoot" value="" size="50" class="formField"> 
				&nbsp; <span style="color:red;font-weight:bold;">required</span>
			</td>
		</tr>
		<cfif siteTemplate eq "">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2">
					<strong>Content Root:</strong>
					<div style="color:##666;line-height:18px;width:600px;">
						Enter the URL path to where the new site will be deployed. Paths are always relative
						to the web root. To deploy the site to the webroot enter "/".
					</div>
				</td>
			</tr>
			<tr valign="top">
				<td>&nbsp;</td>
				<td>
					<input type="text" id="contentRoot" name="contentRoot" value="" size="50" class="formField"> 
					&nbsp; <span style="color:red;font-weight:bold;">required</span>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2">
					<strong>Resource Library Root:</strong>
					<div style="color:##666;line-height:18px;width:600px;">
						Resource Library root is the path to the location of the resources library you wish to use for
						this site. A resource library contains all reusable content that is used to create a site, such as
						modules, skins, contents, feeds, etc. 
						Paths are always relative to the web root. 
					</div>
				</td>
			</tr>		
			<tr valign="top">
				<td>&nbsp;</td>
				<td>
					<input type="radio" name="useDefault_rl" value="1" checked="true"> <input type="text" id="resourcesRoot" name="resourcesRoot" value="" size="50" class="formField"><br />
					<input type="radio" name="useDefault_rl" value="0"> <strong>None</strong> <br />
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2">
					<input type="checkbox" name="pluginAccounts" value="1"> <strong>Use Accounts Plugin:</strong>
					<div style="color:##666;line-height:18px;width:600px;">
						The Accounts plugin allows you to create a multiuser site in which every user has their own
						'space' or microsite within the larger site. You can use this plugin to build multiuser portals,
						social networking sites or personalized start pages.
					</div>
				</td>
			</tr>		
			<tr valign="top">
				<td>&nbsp;</td>
				<td>
					<strong>Accounts Root:</strong>
					<div style="color:##666;line-height:18px;width:500px;">
						Path within the content repository where to store all account pages.
					</div>
					<input type="text" name="accountsRoot" value="/accounts" size="50" class="formField">
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2">
					<input type="checkbox" name="pluginModules" value="1"> <strong>Use Modules Plugin:</strong>
					<div style="color:##666;line-height:18px;width:600px;">
						The Modules plugin provides a widget platform to build interactive widgets or modules that
						can be used on pages. The HomePortalsModules plugin comes pre-loaded with multiple widgets
						that are ready to use like calendars, rss readers, mini-blogs, etc.<br />
						<b>* This plugin requires the Accounts plugin.</b>
					</div>
				</td>
			</tr>		
		</cfif>
	</table>				

	<br>
	<p>
		<input type="button" name="btnBack" value="<< Back" onclick="document.location='index.cfm?event=ehSites.dspCreate'">&nbsp;
		<input type="submit" name="btn" value="Create Site">
	</p>
</cfoutput>
