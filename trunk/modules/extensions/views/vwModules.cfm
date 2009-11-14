<cfset rs = request.requestState>
<cfset index = 1>

<cfoutput>
	<script type="text/javascript">
		function confirmUninstall(name) {
			if(confirm("Are you sure you wish to UNINSTALL module '" + name + "' ?\n\nThis action cannot be undone")) {
				document.location = "index.cfm?event=extensions.ehGeneral.doUninstall&type=modules&name="+name;
			}
		}
	</script>

	<cfif structKeyExists(rs,"showReset")>
		<div style="margin:10px;border:1px solid silver;background-color:##ebebeb;padding:10px;font-weight:bold;margin-left:0px;color:green;">
			To complete the install/uninstall process <a href="index.cfm?event=ehGeneral.doLogoff&resetapp=1">Click Here</a> to reset ColdBricks. You will be 
			asked to login again.
		</div>
	</cfif>

	<cfinclude template="includes/nav.cfm">
	<br>
	<table style="margin:0px;padding:0px;width:100%;" cellpadding="0" cellspacing="0">
		<tr valign="top">
			<td>
				<cfinclude template="includes/modules.cfm">
			</td>
			<td width="200">
				<div class="cp_sectionBox helpBox"  style="margin:0px;margin-left:10px;height:450px;line-height:18px;">
					<div style="margin:10px;">
						<h2>ColdBricks Extensions</h2>
						The Extensions Manager allows you to add or remove features to the base ColdBricks platform
						to customize its features. You can add extensions either by downloading them
						directly from an external source or by installing an already downloaded ZIP archive.
						
						<br><br>
						<div style="font-weight:bold;color:green;text-align:center;">
							Find more extensions at 
							<a href="http://www.coldbricks.com/download.cfm?section=modules" style="color:green !important;"><u>ColdBricks.com</u></a>
						</div>
					</div>
				</div>
			</td>
		</tr>
	</table>
</cfoutput>