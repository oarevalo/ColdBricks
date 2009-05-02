<cfparam name="request.requestState.xmlDoc" default="">
<cfparam name="request.requestState.aConfigFiles" default="">
<cfparam name="request.requestState.configFile" default="">
<cfparam name="request.requestState.xmlContent" default="">
<cfparam name="request.requestState.qryHelp" default="">

<cfscript>
	aConfigFiles = request.requestState.aConfigFiles;
	configFile = request.requestState.configFile;
	xmlDoc = request.requestState.xmlDoc;
	xmlContent = request.requestState.xmlContent;
	qryHelp = request.requestState.qryHelp;
	
	if(configFile neq "") { 
		if(xmlContent eq "") xmlContent = xmlDoc;
	}
</cfscript>

<cfoutput>
<cfinclude template="includes/nav.cfm">

<br><br>

<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="8" cellspacing="0">
	<tr>
		<td nowrap="yes">
			<strong>Config File: </strong>
			<cfif configFile neq "">
				#configFile#
			<cfelse>
				None Selected
			</cfif>
		</td>
		<td align="right">
			<strong>Page:</strong>
			<select name="configFile" style="width:300px;font-size:11px;padding:2px;" onchange="document.location='?event=ehSettings.dspEditXML&configFile='+this.value">
				<option value="">----  Select Config File  ----</option>
				<cfloop from="1" to="#arrayLen(aConfigFiles)#" index="i">
					<option value="#aConfigFiles[i]#"
							<cfif aConfigFiles[i] eq configFile>selected</cfif>>#aConfigFiles[i]#</option>
				</cfloop>
			</select>
		</td>
	</tr>
</table>

<cfif configFile neq "">
<form name="frm" method="post" action="index.cfm" style="margin:0px;padding:0px;">
	<input type="hidden" name="event" value="ehSettings.doSaveConfigFile">
	<input type="hidden" name="configFile" value="#configFile#">

	<table style="margin:0px;padding:0px;width:100%;" cellpadding="0" cellspacing="0">
		<tr valign="top">
			<td>
	
				<div style="font-size:12px;font-weight:bold;margin:10px;margin-bottom:0px;">
					<span style="color:red;">CAUTION!</span> Please make sure you know what you are doing. 
					Incorrect syntax or tags could make all sites unable to be displayed. 
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
						<h2>About This File...</h2>
						#qryHelp.description#
					</div>
				</div>
			</td>
		</tr>
	</table>

	<p>
		<input type="submit" name="btnSave" value="Apply Changes">
	</p>
</form>
<cfelse>
	<table style="margin:0px;padding:0px;width:100%;" cellpadding="0" cellspacing="0">
		<tr valign="top">
			<td>
	
				<div style="font-size:12px;font-weight:bold;margin:10px;margin-bottom:0px;">
					<span style="color:red;">CAUTION!</span> Please make sure you know what you are doing. 
					Incorrect syntax or tags could make all sites unable to be displayed. 
				</div>
				
				<textarea name="xmlContent"  
							class="codeEditor" 
							wrap="off">No file selected.</textarea>

			</td>
			<td width="200">
				<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
					<div style="margin:10px;">
						<h2>Server Config</h2>
						This screen allows you to manipulate all HomePortals configuration files. This files
						provide the default settings for all aspects of the HomePortals server.<br><br>
						Use the dropdown on top to select which file to edit. 
					</div>
				</div>
			</td>
		</tr>
	</table>
</cfif>
</cfoutput>

