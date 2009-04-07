<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.baseResourceEditIndex" default="">
<cfparam name="request.requestState.baseResourceEditType" default="">
<cfparam name="request.requestState.oAppConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	baseResourceEditIndex = request.requestState.baseResourceEditIndex;
	baseResourceEditType = request.requestState.baseResourceEditType;
	lstBaseResourceTypes = oHomePortalsConfigBean.getBaseResourceTypes();
	oAppConfigBean = request.requestState.oAppConfigBean;
</cfscript>

<script type="text/javascript">
	function confirmDeleteBaseResource(type, index) {
		if(confirm("Delete base resource?")) {
			document.location = "index.cfm?event=ehSiteConfig.doDeleteBaseResource&type=" + type + "&index=" + index;
		}
	}
</script>


<cfoutput>
	<tr><td colspan="2"><h2>Base Resources:</h2></td></tr>
	<tr>
		<td colspan="2">
		
			<table style="width:100%;border:1px solid silver;">
				<tr>
					<th style="background-color:##ccc;width:50px;">No.</th>
					<th style="background-color:##ccc;width:100px;">Type</th>
					<th style="background-color:##ccc;">Value</th>
					<th style="background-color:##ccc;width:100px;">Action</th>
				</tr>
				<cfset index = 1>
				<cfloop list="#lstBaseResourceTypes#" index="resType">
					<cfset aRes = oHomePortalsConfigBean.getBaseResourcesByType(resType)>
					<cfloop from="1" to="#arrayLen(aRes)#" index="i">
						<tr <cfif index mod 2>class="altRow"</cfif>>
							<td style="width:50px;" align="right"><strong>#index#.</strong></td>
							<td style="width:100px;" align="center">#resType#</td>
							<td><a href="#aRes[i]#" target="_blank">#aRes[i]#</a></td>
							<td align="center">
								< base >
							</td>
						</tr>
						<cfset index = index + 1>
					</cfloop>
				</cfloop>

				<cfset index = 1>
				<cfloop list="#lstBaseResourceTypes#" index="resType">
					<cfset aRes = oAppConfigBean.getBaseResourcesByType(resType)>
					<cfloop from="1" to="#arrayLen(aRes)#" index="i">
						<tr <cfif index mod 2>class="altRow"</cfif>>
							<td style="width:50px;" align="right"><strong>#index#.</strong></td>
							<td style="width:100px;" align="center">#resType#</td>
							<td><a href="#aRes[i]#" target="_blank">#aRes[i]#</a></td>
							<td align="center">
								<a href="index.cfm?event=ehSiteConfig.dspMain&baseResourceEditIndex=#i#&baseResourceEditType=#resType#"><img src="images/page_edit.png" border="0" alt="Edit base resource" title="Edit base resource"></a>
								<a href="##" onclick="confirmDeleteBaseResource('#resType#',#i#)"><img src="images/page_delete.png" border="0" alt="Delete base resource" title="Delete base resource"></a>
							</td>
						</tr>
						<cfset index = index + 1>
					</cfloop>
				</cfloop>
			</table>
			<cfif baseResourceEditIndex eq 0>
				<form name="frmAddBaseResource" action="index.cfm" method="post">
					<table style="width:100%;border:1px solid silver;margin-top:5px;">
						<tr>
							<td style="width:50px;" align="center"><strong>New:</strong></td>
							<td style="width:100px;">
								<select name="type" style="width:100px;font-size:11px;">
									<cfloop list="#lstBaseResourceTypes#" index="resType">
										<option value="#resType#">#resType#</option>
									</cfloop>
								</select>
							</td>
							<td>
								<input type="text" name="href" value="" style="width:340px;font-size:11px;">
							</td>
							<td style="width:100px;" align="center">
								<input type="button" name="btnSave" value="Apply" style="font-size:11px;" onclick="submitForm('ehSiteConfig.doAddBaseResource')">
								<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=ehSiteConfig.dspMain'">
							</td>
						</tr>
					</table>
				</form>
			<cfelseif baseResourceEditIndex gt 0>
				<cftry>
					<cfset aRes = oAppConfigBean.getBaseResourcesByType(baseResourceEditType)>
					<cfset baseResourceEditHREF = aRes[baseResourceEditIndex]>
					<cfcatch type="any">
						<cfset baseResourceEditHREF = "">
					</cfcatch>
				</cftry>
				<form name="frmEditBaseResource" action="index.cfm" method="post">
					<input type="hidden" name="index" value="#baseResourceEditIndex#">

					<table style="width:100%;border:1px solid silver;margin-top:5px;">
						<tr>
							<td style="width:50px;" align="center"><strong>Edit:</strong></td>
							<td style="width:100px;">
								<select name="type" style="width:100px;font-size:11px;">
									<cfloop list="#lstBaseResourceTypes#" index="resType">
										<option value="#resType#" <cfif resType eq baseResourceEditType>selected</cfif>>#resType#</option>
									</cfloop>
								</select>
							</td>
							<td>
								<input type="text" name="href" value="#baseResourceEditHREF#" style="width:340px;font-size:11px;">
							</td>
							<td style="width:100px;" align="center">
								<input type="button" name="btnSave" value="Apply" style="font-size:11px;" onclick="submitForm('ehSiteConfig.doSaveBaseResource')">
								<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=ehSiteConfig.dspMain'">
							</td>
						</tr>
					</table>
				</form>
			<cfelse>
				<br>
				<a href="index.cfm?event=ehSiteConfig.dspMain&baseResourceEditIndex=0">Click Here</a> to add a base resources
			</cfif>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>