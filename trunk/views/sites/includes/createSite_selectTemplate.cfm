<cfoutput>
	<b>Select a site template by clicking on one of the icons below.</b><br><br>

	<cfloop query="qrySiteTemplates">
		<div class="dsb_secBox">
			<a href="javascript:selectSiteTemplate('#qrySiteTemplates.name#')"><img src="images/Globe_48x48.png" border="0" alt="#qrySiteTemplates.name#" title="#qrySiteTemplates.name#"><br>
			<a href="javascript:selectSiteTemplate('#qrySiteTemplates.name#')">#qrySiteTemplates.name#</a>
		</div>
	</cfloop>
</cfoutput>