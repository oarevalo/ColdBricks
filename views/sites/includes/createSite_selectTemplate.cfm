<cfoutput>
	<b>Select a site template by clicking on one of the icons below. To create a blank site without using any template, select <u>Default</u>.</b><br><br>

	<div class="dsb_secBox">
		<a href="javascript:selectSiteTemplate('default')"><img src="images/Globe_48x48.png" border="0" alt="Default site" title="Default site"><br>
		<a href="javascript:selectSiteTemplate('default')">Default</a>
	</div>

	<cfloop query="qrySiteTemplates">
		<cfif qrySiteTemplates.name neq "default">
			<div class="dsb_secBox">
				<a href="javascript:selectSiteTemplate('#qrySiteTemplates.name#')"><img src="images/Globe_48x48.png" border="0" alt="#qrySiteTemplates.name#" title="#qrySiteTemplates.name#"><br>
				<a href="javascript:selectSiteTemplate('#qrySiteTemplates.name#')">#qrySiteTemplates.name#</a>
			</div>
		</cfif>
	</cfloop>
</cfoutput>