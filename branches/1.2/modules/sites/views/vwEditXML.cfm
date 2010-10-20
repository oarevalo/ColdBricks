<cfparam name="request.requestState.configFile" default="">
<cfparam name="request.requestState.xmlContent" default="">
<cfparam name="request.requestState.siteID" default="">
<cfparam name="request.requestState.errorMessage" default="">

<cfscript>
	configFile = request.requestState.configFile;
	siteID = request.requestState.siteID;
	xmlContent = request.requestState.xmlContent;
	errorMessage = request.requestState.errorMessage;
</cfscript>

<cfoutput>

<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="8" cellspacing="0">
	<tr>
		<td nowrap="yes">
			<strong>Config File: </strong> #configFile#<br /><br />
			<cfif errorMessage eq "">
				<div style="font-weight:bold;color:green;">
					<img src="images/cmsg.gif" align="absmiddle"> Site config is OK
				</div>
			<cfelse>
				<div style="font-weight:bold;color:##F70000;">
					<img src="images/wmsg.gif" align="absmiddle"> #errorMessage#
				</div>
			</cfif>
		</td>
	</tr>
</table>

<form name="frm" method="post" action="index.cfm" style="margin:0px;padding:0px;">
	<input type="hidden" name="event" value="sites.ehSites.doSaveConfigFile">
	<input type="hidden" name="configFile" value="#configFile#">
	<input type="hidden" name="siteID" value="#siteID#">

	<table style="margin:0px;padding:0px;width:100%;" cellpadding="0" cellspacing="0">
		<tr valign="top">
			<td>
	
				<div style="font-size:12px;font-weight:bold;margin:10px;margin-bottom:0px;">
					<span style="color:red;">CAUTION!</span> Please make sure you know what you are doing. 
					Incorrect syntax or tags could make the site unable to be displayed. 
				</div>
				
				<textarea name="xmlContent"  
							onkeypress="checkTab(event)" 
							onkeydown="checkTabIE()"				
							class="codeEditor" 
							wrap="off">#xmlContent#</textarea>

			</td>
			<td width="200">
				<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
					<div style="margin:10px;">
						<h2>Repair Config</h2>
						Use this screen to manually edit a site's XML configuration file. <br /><br />
						It is recommended to always use the Settings screens to manage a site
						configuration, however sometimes manual edit may be required to repair 
						incorrect or malformed settings.
					</div>
				</div>
			</td>
		</tr>
	</table>

	<p>
		<input type="submit" name="btnSave" value="Apply Changes">
		<input type="button" name="btnCancel" value="Cancel" onclick="document.location='index.cfm?event=sites.ehSites.dspMain'">
	</p>
</form>

</cfoutput>

