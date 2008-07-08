<cfoutput>
<form name="frm" method="post" action="index.cfm">
	<input type="hidden" name="event" value="ehSites.doRegister">

<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>
			<table>
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
						<input type="text" name="name" value="" size="50" class="formField" onblur="if(this.form.appRoot.value=='') this.form.appRoot.value='/'+this.value"> 
						&nbsp; <span style="color:red;font-weight:bold;">required</span>
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td colspan="2">
						<strong>Application Root:</strong>
						<div style="color:##666;line-height:18px;width:600px;">
							Enter the URL path to where the site is deployed. Paths are always relative
							to the web root. For a site deployed on the webroot enter "/".
						</div>
					</td>
				</tr>
				<tr valign="top">
					<td>&nbsp;</td>
					<td>
						<input type="text" name="appRoot" value="" size="50" class="formField"> 
						&nbsp; <span style="color:red;font-weight:bold;">required</span>
					</td>
				</tr>
			</table>
		</td>
		<td rowspan="5" width="200">
			<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
				<div style="margin:10px;">
					<h2>Registering Sites</h2>
					<p>
						You can manage an existing HomePortals-powered application within ColdBricks. To access the site using
						ColdBricks you must first register it as a ColdBricks site.
					</p>
					<p>
						Registering a site for ColdBricks use does not modify the application in any way. ColdBricks does not add
						any special files to it
					</p>
					<p>
						<b span style="color:red;">CAUTION:</b> If you register a site and then use the 'Delete Site' option, ColdBricks
						will attempt to delete all site files under the site's root directory.
					</p>
				</div>
			</div>			
		</td>
	</table>
		
	
	<br><br>
	<input type="submit" name="btn" value="Register Site">
	<input type="button" name="btnCancel" value="Cancel" onclick="document.location='index.cfm?event=ehSites.dspMain'">
</form>	
</cfoutput>
		