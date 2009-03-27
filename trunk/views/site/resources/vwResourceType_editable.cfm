<cfparam name="request.requestState.resourceType" default="">
<cfparam name="request.requestState.id" default="">
<cfparam name="request.requestState.qryResources" default="">
<cfparam name="request.requestState.oResourceBean" default="">
<cfparam name="request.requestState.pkg" default="">
<cfparam name="request.requestState.resTypeLabel" default="">
<cfparam name="request.requestState.qryAccounts" default="">
<cfparam name="request.requestState.resourceTypeInfo" default="">
<cfparam name="request.requestState.resourcesRoot" default="">

<cfscript>
	resourceType = request.requestState.resourceType;
	id = request.requestState.id;
	qryResources = request.requestState.qryResources;
	oResourceBean = request.requestState.oResourceBean;
	package = request.requestState.package;
	resTypeLabel = request.requestState.resTypeLabel;
	resourceTypeInfo = request.requestState.resourceTypeInfo;
	resourcesRoot = request.requestState.resourcesRoot;
</cfscript>

<cfquery name="qryPackages" dbtype="query">
	SELECT DISTINCT package
		FROM qryResources
		ORDER BY package
</cfquery>

<cfif package neq "">
	<cfquery name="qryEntries" dbtype="query">
		SELECT *
			FROM qryResources
			WHERE package LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#package#">
			ORDER BY id
	</cfquery>
</cfif>

<!--- <form name="frm_blank" action="index.cfm" method="post" style="margin:0px;padding:0px;">
</form> --->

<cfoutput>
	<!--- <table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="5" cellspacing="0">
		<tr>
			<td width="90" style="font-weight:bold;font-size:12px;">#resTypeLabel#</td>
			<td nowrap="yes">
				Package:
				<cfset tmp = package>
				<select name="package" onchange="selectResourceType('#resourceType#','',this.value)" style="font-size:11px;width:130px;">
					<option value="">--- Select One ---</option>
					<cfloop query="qryPackages">
						<option value="#qryPackages.package#" <cfif tmp eq qryPackages.package>selected</cfif>>#qryPackages.package#</option>
					</cfloop>
				</select>
			</td>
			<td nowrap="yes">
				Item:
				<select name="id" onchange="selectResourceType('#resourceType#',this.value,'#package#')" style="font-size:11px;width:130px;">
					<option value="">--- Select One ---</option>
					<cfset tmpID = id>
					<cfif package neq "">
						<cfloop query="qryEntries">
							<cfif qryEntries.name eq "">
								<cfset tmp = qryEntries.id>
							<cfelse>
								<cfset tmp = qryEntries.name>
							</cfif>
							<option value="#qryEntries.id#" <cfif tmpID eq qryEntries.id>selected</cfif>>#tmp#</option>
						</cfloop>
					</cfif>
				</select>
			</td>
			<td align="right">
				<img src="images/add.png" align="absmiddle"> <a href="javascript:selectResourceType('#resourceType#','NEW','#package#')">Create Resource</a>
			</td>
		</tr>
	</table>
 --->
	<cfif id neq "">

	<cfscript>
		beanPackage = oResourceBean.getPackage();
		description = oResourceBean.getDescription();
		content = "";
		contentLocation = oResourceBean.getHref();
		tmpTitle = "Edit Content";
		tmpErrMessage = "";
		
		isExternalContent = left(contentLocation,4) eq "http";
		if(id eq "NEW") id = "";
	</cfscript>

	<cfif contentLocation neq "" and not isExternalContent>
		<cftry>
			<cfset filePath = expandPath(resourcesRoot & "/" & contentLocation)>
			<cffile action="read" file="#filePath#" variable="content">
			<cfcatch type="any">
				<cfset tmpErrMessage = cfcatch.message & "[#contentLocation#]">
			</cfcatch>
		</cftry>
	</cfif>

	<div style="margin-top:5px;">
		<div style="padding:0px;">
			<form name="frm" action="index.cfm" method="post" style="margin:0px;padding:0px;">
				<input type="hidden" name="event" value="ehResources.doSaveResource">
				<input type="hidden" name="id" value="#id#">
				<input type="hidden" name="resourceType" value="#resourceType#">
				
				<div style="margin-top:5px;margin-bottom:5px;font-size:12px;text-align:left;background-color:##ccc;border:1px solid ##333;padding:2px;">
					<div style="float:right;margin-right:10px;">
						<b>ID:</b> 
						<cfif id eq "">
							< New >
						<cfelse>
							#id#
						</cfif>
					</div>
					<cfif resourceType eq "content">
						[ 
							<img src="images/magnifier.png" align="absmiddle">
							<a href="javascript:selectPanel('preview',false)" id="panelSelector_preview" class="panelSelector">Preview</a> 
						] &nbsp;
						<cfset defaultPanel = "preview">
					<cfelseif resourceType eq "feed">
						<cfset defaultPanel = "info">
					<cfelse>
						[ 
							<img src="images/page_white_code.png" align="absmiddle">
							<a href="javascript:selectPanel('code')" id="panelSelector_code" class="panelSelector">HTML</a> 
						] &nbsp;
						<cfset defaultPanel = "code">
					</cfif>
						[ 
							<img src="images/information.png" align="absmiddle">
							<a href="javascript:selectPanel('info')" id="panelSelector_info" class="panelSelector">More Info</a> 
						]
				</div>

				<div style="border:1px solid silver;background-color:##50628b;margin-bottom:5px;color:##fff;">
					<table width="100%">
						<tr>
							<td>
								<b>ID:</b> <input type="text" name="new_id" value="#id#" style="width:300px;">
							</td>
							<td align="right">
								<b>Package:</b> <input type="text" name="pkg" value="#beanPackage#" style="width:100px;font-size:11px;">
							</td>
						</tr>
					</table>
				</div>
				
				
				<div style="border:1px solid silver;background-color:##fff;margin-bottom:5px;display:none;height:371px;" id="pnl_info">
					<table style="margin:10px;">
						<tr valign="top">
							<td><strong>ID:</strong></td>
							<td><cfif id eq "">< New ><cfelse>#id#</cfif></td>
						</tr>
						<cfif resourceType eq "feed">
							<tr>
								<td width="80"><b>URL:</b></td>
								<td><input type="text" name="href" value="#contentLocation#" class="formField"></td>
							</tr>
						</cfif>
						<tr valign="top">
							<td><strong>Description:</strong></td>
							<td><textarea name="description" class="formField" rows="4">#description#</textarea></td>
						</tr>
					</table>
				</div>
				
				<cfif resourceType neq "feed">
					<div id="pnl_editor" style="display:none;">
						<cfif tmpErrMessage eq "">
							<textarea name="body" 
										wrap="off" 
										onkeypress="checkTab(event)" 
										onkeydown="checkTabIE()"	
										id="body" 
										style="width:98%;border:1px solid silver;padding:2px;height:365px;">#HTMLEditFormat(content)#</textarea>
						<cfelse>
							<b>Content file could not be read.</b><br> Error: #tmpErrMessage#
						</cfif>
					</div>
				</cfif>
				
				<div style="margin-top:8px;">
					<input type="button" name="btnSave" value="Apply Changes" onclick="saveResource(this.form)">
					<!---
					<cfif resourceType eq "content">
						<input type="button" name="btnSave" value="Apply Changes" onclick="saveContent(this.form)">&nbsp;&nbsp;&nbsp;
					<cfelse>
						<input type="submit" name="btnSave" value="Apply Changes">&nbsp;&nbsp;&nbsp;
					</cfif>
					---->
					<cfif id neq "">
						&nbsp;&nbsp;&nbsp;
						<input type="button" name="btnDelete" value="Delete Resource" onclick="if(confirm('Delete resource?')){document.location='index.cfm?event=ehResources.doDeleteResource&id=#id#&resourceType=#resourceType#&pkg=#pkg#'}">
					</cfif>
					&nbsp;&nbsp;&nbsp;
					<input type="button" name="btnCancel" value="Cancel" onclick="selectResourceType('#resourceType#')">
				</div>
			</form>

		</div>
	</div>

	<script type="text/javascript">
		try {selectPanel('#defaultPanel#',true); } catch(e) {alert(e);}
	</script>


	<cfelse>
	
		<div style="line-height:24px;margin:30px;font-size:14px;">
		
			&bull; Select from the list on the left a type of resource to browse available resource or create new ones<br>
			
			&bull; Use the <strong>Package</strong> and <strong>Item</strong> drop-downs above to browse through the available resources.<br>

			&bull; Click on <a href="javascript:selectResourceType('#resourceType#','NEW','')">Create Resource</a> to create a new
				resource of the selected type.<br>
				
		</div>

	</cfif>

	<script type="text/javascript">
		try { setResourceTypeInfo('#jsstringformat(resTypeLabel)#','#jsstringformat(resourceTypeInfo)#') } catch(e) {alert(e);}
	</script>

</cfoutput>