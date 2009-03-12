<cfparam name="request.requestState.oModulePropertiesConfigBean" default="">
<cfparam name="request.requestState.oModulePropertiesConfigBeanBase" default="">
<cfparam name="request.requestState.index" default="">
<cfscript>
	oModulePropertiesConfigBean = request.requestState.oModulePropertiesConfigBean;
	oModulePropertiesConfigBeanBase = request.requestState.oModulePropertiesConfigBeanBase;
	index = request.requestState.index;
	
	qryData = oModulePropertiesConfigBean.getPropertiesAsQuery();
	qryDataBase = oModulePropertiesConfigBeanBase.getPropertiesAsQuery();
</cfscript>

<cfquery name="qryData" dbtype="query">
	SELECT *
		FROM qryData
		ORDER BY moduleName
</cfquery>

<script type="text/javascript">
	function confirmDelete(moduleName, propertyName) {
		if(confirm("Delete module property?")) {
			document.location = "index.cfm?event=ehSiteConfig.doDeleteModuleProperty&moduleName=" + moduleName + "&propertyName=" + propertyName;
		}
	}
</script>

<cfoutput>

<div>
	[ <a href="index.cfm?event=ehSiteConfig.dspMain">General</a> ] &nbsp;&nbsp;
	[ <a href="index.cfm?event=ehSiteConfig.dspAccounts">Accounts</a> ] &nbsp;&nbsp;
	[ <a href="index.cfm?event=ehSiteConfig.dspModuleProperties"><strong>Module Properties</strong></a> ] &nbsp;&nbsp;
	[ <a href="index.cfm?event=ehSiteConfig.dspEditXML">Edit Config Files</a> ] &nbsp;&nbsp;
</div>

<br>

<table style="margin:0px;padding:0px;width:100%;" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>

			<b>Module Properties Inherited From Base Configuration:</b>
			<table style="width:100%;border:1px solid silver;" class="dataFormTable">
				<tr>
					<th style="background-color:##ccc;width:50px;">No.</th>
					<th style="background-color:##ccc;width:150px;">Module</th>
					<th style="background-color:##ccc;width:150px;">Property</th>
					<th style="background-color:##ccc;">Property</th>
					<th style="background-color:##ccc;width:100px;">Action</th>
				</tr>
				<cfloop query="qryDataBase">
					<tr <cfif qryDataBase.currentRow mod 2>class="altRow"</cfif>>
						<td style="width:50px;" align="right"><strong>#qryDataBase.currentRow#.</strong></td>
						<td style="width:150px;">#qryDataBase.moduleName#</td>
						<td>#qryDataBase.propertyName#</td>
						<td>#qryDataBase.propertyValue#</td>
						<td align="center">
							< base >
						</td>
					</tr>
				</cfloop>
				<cfif qryDataBase.recordCount eq 0>
					<tr><td colspan="5"><em>No properties found</em></td></tr>
				</cfif>
			</table>
			<br><br>
			
			<b>Module Properties Defined For This Site:</b>
			<table style="width:100%;border:1px solid silver;" class="dataFormTable">
				<tr>
					<th style="background-color:##ccc;width:50px;">No.</th>
					<th style="background-color:##ccc;width:150px;">Module</th>
					<th style="background-color:##ccc;width:150px;">Property</th>
					<th style="background-color:##ccc;">Property</th>
					<th style="background-color:##ccc;width:100px;">Action</th>
				</tr>
				<cfloop query="qryData">
					<tr <cfif qryData.currentRow mod 2>class="altRow"</cfif>>
						<td style="width:50px;" align="right"><strong>#qryData.currentRow#.</strong></td>
						<td style="width:150px;">#qryData.moduleName#</td>
						<td style="width:150px;">#qryData.propertyName#</td>
						<td>#qryData.propertyValue#</td>
						<td align="center">
							<a href="index.cfm?event=ehSiteConfig.dspModuleProperties&index=#qryData.currentRow#"><img src="images/page_edit.png" border="0" alt="Edit module property" title="Edit module property"></a>
							<a href="##" onclick="confirmDelete('#qryData.moduleName#','#qryData.propertyName#')"><img src="images/page_delete.png" border="0" alt="Delete module property" title="Delete module property"></a>
						</td>
					</tr>
				</cfloop>
				<cfif qryData.recordCount eq 0>
					<tr><td colspan="5"><em>No properties found</em></td></tr>
				</cfif>
			</table>
			<br><br>
			
			<cfif index eq 0>
				<form name="frm" method="post" action="index.cfm">
					<input type="hidden" name="event" value="ehSiteConfig.doAddModuleProperty">
					<table class="dataFormTable">
						<tr>
							<td width="100"><strong>Module Name:</strong></td>
							<td><input type="text" name="moduleName" value="" size="30" class="formField"></td>
						</tr>
						<tr>
							<td width="100"><strong>Property Name:</strong></td>
							<td><input type="text" name="propertyName" value="" size="30" class="formField"></td>
						</tr>
						<tr>
							<td width="100"><strong>Property Value:</strong></td>
							<td><input type="text" name="propertyValue" value="" size="30" class="formField"></td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							<td colspan="2" align="left" style="padding-top:5px;">
								<input type="submit" name="btnSave" value="Save">
								<input type="button" name="btnCancel" value="Cancel" onclick="document.location='index.cfm?event=ehSiteConfig.dspModuleProperties'">
							</td>
						</tr>
					</table>
				</form>
			<cfelseif index gt 0>
				<form name="frm" method="post" action="index.cfm">
					<input type="hidden" name="event" value="ehSiteConfig.doSaveModuleProperty">
					<input type="hidden" name="index" value="#index#">
					<input type="hidden" name="old_moduleName" value="#qryData.moduleName[index]#">
					<input type="hidden" name="old_propertyName" value="#qryData.propertyName[index]#">
					<table class="dataFormTable">
						<tr>
							<td width="100"><strong>Module Name:</strong></td>
							<td><input type="text" name="moduleName" value="#qryData.moduleName[index]#" size="30" class="formField"></td>
						</tr>
						<tr>
							<td width="100"><strong>Property Name:</strong></td>
							<td><input type="text" name="propertyName" value="#qryData.propertyName[index]#" size="30" class="formField"></td>
						</tr>
						<tr>
							<td width="100"><strong>Property Value:</strong></td>
							<td><input type="text" name="propertyValue" value="#qryData.propertyValue[index]#" size="30" class="formField"></td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							<td colspan="2" align="left" style="padding-top:5px;">
								<input type="submit" name="btnSave" value="Save">
								<input type="button" name="btnCancel" value="Cancel" onclick="document.location='index.cfm?event=ehSiteConfig.dspModuleProperties'">
							</td>
						</tr>
					</table>
				</form>
			<cfelse>
				<input type="button" 
						name="btnCreate" 
						value="Add Module Property" 
						onClick="document.location='?event=ehSiteConfig.dspModuleProperties&index=0'">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<b>Legend:</b> &nbsp;&nbsp;
				<img src="images/page_edit.png" align="absmiddle" border="0" alt="Edit Module Property" title="Edit Module Property"> Edit Module Property &nbsp;&nbsp;
				<img src="images/page_delete.png" align="absmiddle" border="0" alt="Delete Module Property" title="Delete Module Property"> Delete Module Property&nbsp;&nbsp;
			</cfif>
	


		</td>
		<td width="200">
			<div class="cp_sectionBox helpBox"  style="margin:10px;margin-top:0px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
				<div style="margin:10px;">
					<h2>Module Properties</h2>
					These are properties used to configure module behaviour. Each module may use different properties. 
					<br><br>
				</div>
			</div>
		</td>
	</tr>
</table>
</cfoutput>

