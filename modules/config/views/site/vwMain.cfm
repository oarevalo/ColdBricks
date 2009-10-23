<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.oAppConfigBean" default="">
<cfparam name="request.requestState.panel" default="general">

<cfset oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean>
<cfset oAppConfigBean = request.requestState.oAppConfigBean>
<cfset panel = request.requestState.panel>

<cfset aPanels = [
				{ id = "general", label = "General Settings" },
				{ id = "baseResources", label = "Base Resources" },
				{ id = "renderTemplates", label = "Render Templates" },
				{ id = "contentRenderers", label = "Content Renderers" },
				{ id = "resLibs", label = "Resource Libraries" },
				{ id = "resourceTypes", label = "Resource Types" },
				{ id = "plugins", label = "Plugins" },
				{ id = "pageProperties", label = "Page Properties" },
				{ id = "resLibTypes", label = "Resource Library Types" }
			]>
			
<script type="text/javascript">
	function submitForm(event) {
		document.frm.event.value = event;
		document.frm.submit();
	}
	
	function toggleField(chk,fld) {
		document.getElementById("fld_"+fld).disabled = !chk;
	}
</script>

<cfoutput>
	<cfinclude template="includes/nav.cfm">
	<br>
	<table style="margin:0px;padding:0px;width:100%;" cellpadding="0" cellspacing="0">
		<tr valign="top">
			<td style="width:120px;">
				<br />
				<cfloop from="1" to="#arrayLen(aPanels)#" index="i">
					<a href="index.cfm?event=config.ehSiteConfig.dspMain&panel=#aPanels[i].id#"
						<cfif panel eq aPanels[i].id>style="font-weight:bold;"</cfif>>#aPanels[i].label#</a><br />
				</cfloop>
			</td>
			<td>
				<form name="frm" method="post" action="index.cfm">
					<input type="hidden" name="event" value="">
				
					<table class="dataFormTable" width="90%">
						<cfswitch expression="#panel#">
							<cfcase value="general">
								<form name="frm" method="post" action="index.cfm">
									<input type="hidden" name="event" value="config.ehSiteConfig.doSaveGeneral">
									<cfinclude template="includes/general.cfm">
									<cfinclude template="includes/caching.cfm">
									<tr>
										<td colspan="2" align="center" style="padding-top:5px;">
											<input type="submit" name="btnSave" value="Apply Changes">
										</td>
									</tr>
								</form>
							</cfcase>
							<cfcase value="resLibs">
								<cfinclude template="includes/resLibs.cfm">
							</cfcase>
							<cfcase value="baseResources">
								<cfinclude template="includes/baseResources.cfm">
							</cfcase>
							<cfcase value="contentRenderers">
								<cfinclude template="includes/contentRenderers.cfm">
							</cfcase>
							<cfcase value="plugins">
								<cfinclude template="includes/plugins.cfm">
							</cfcase>
							<cfcase value="resourceTypes">
								<cfinclude template="includes/resourceTypes.cfm">
							</cfcase>
							<cfcase value="renderTemplates">
								<cfinclude template="includes/renderTemplates.cfm">
							</cfcase>
							<cfcase value="pageProperties">
								<cfinclude template="includes/pageProperties.cfm">
							</cfcase>
							<cfcase value="resLibTypes">
								<cfinclude template="includes/resLibTypes.cfm">
							</cfcase>
						</cfswitch>
					</table>
				</form>
			</td>
			<td width="200">
				<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
					<div style="margin:10px;">
						<h2>Site Settings</h2>
						This screen allows you to manipulate the general settings for this site.
						<br><br>
						The values shown in the disabled fields are the default values set in
						the main server settings screen. To override a default value mark the checkbox
						and enter the new value. New values are only applied to the current site.
					</div>
				</div>
			</td>
		</tr>
	</table>
</cfoutput>

