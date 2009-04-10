<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.resLibPathEditIndex" default="">

<cfset oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean>
<cfset resLibPathEditIndex = request.requestState.resLibPathEditIndex>

<script type="text/javascript">
	function confirmDeleteResLibPath(index) {
		if(confirm("Delete resource library path?")) {
			document.location = "index.cfm?event=ehSettings.doDeleteResLibPath&index=" + index;
		}
	}
</script>

<cfoutput>
	<tr><td colspan="2"><h2>Resource Libraries:</h2></td></tr>
	<tr>
		<td colspan="2">
		
			<table style="width:100%;border:1px solid silver;">
				<tr>
					<th style="background-color:##ccc;width:50px;">No.</th>
					<th style="background-color:##ccc;">Path</th>
					<th style="background-color:##ccc;width:100px;">Action</th>
				</tr>
				<cfset aResLibs = oHomePortalsConfigBean.getResourceLibraryPaths()>
				<cfloop from="1" to="#arrayLen(aResLibs)#" index="i">
					<tr <cfif i mod 2>class="altRow"</cfif> <cfif resLibPathEditIndex eq i>style="font-weight:bold;"</cfif>>
						<td style="width:50px;" align="right"><strong>#i#.</strong></td>
						<td><a href="index.cfm?event=ehSettings.dspMain&resLibPathEditIndex=#i#">#aResLibs[i]#</a></td>
						<td align="center">
							<a href="index.cfm?event=ehSettings.dspMain&resLibPathEditIndex=#i#"><img src="images/page_edit.png" border="0" alt="Edit resource library path" title="Edit resource library path"></a>
							<a href="##" onclick="confirmDeleteResLibPath(#i#)"><img src="images/page_delete.png" border="0" alt="Delete resource library path" title="Delete resource library path"></a>
						</td>
					</tr>
				</cfloop>
			</table>
			<cfif resLibPathEditIndex eq 0>
				<form name="frmAddResLibPath" action="index.cfm" method="post">
					<input type="hidden" name="event" value="ehSettings.doAddResLibPath">
					<table style="width:100%;border:1px solid silver;margin-top:5px;">
						<tr>
							<td style="width:50px;" align="center"><strong>New:</strong></td>
							<td>
								<input type="text" name="path" value="" style="width:340px;" class="formField">
							</td>
							<td style="width:100px;" align="center">
								<input type="submit" name="btnSave" value="Apply" style="font-size:11px;">
								<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=ehSettings.dspMain'">
							</td>
						</tr>
					</table>
				</form>
			<cfelseif resLibPathEditIndex gt 0>
				<cftry>
					<cfset aResLibs = oHomePortalsConfigBean.getResourceLibraryPaths()>
					<cfset resLibPath = aResLibs[resLibPathEditIndex]>
					<cfcatch type="any">
						<cfset resLibPath = "">
					</cfcatch>
				</cftry>
				<form name="frmEditResLibPath" action="index.cfm" method="post">
					<input type="hidden" name="event" value="ehSettings.doSaveResLibPath">
					<input type="hidden" name="index" value="#resLibPathEditIndex#">

					<table style="width:100%;border:1px solid silver;margin-top:5px;">
						<tr>
							<td style="width:50px;" align="center"><strong>Edit:</strong></td>
							<td>
								<input type="text" name="path" value="#resLibPath#" style="width:340px;" class="formField">
							</td>
							<td style="width:100px;" align="center">
								<input type="submit" name="btnSave" value="Apply" style="font-size:11px;">
								<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=ehSettings.dspMain'">
							</td>
						</tr>
					</table>
				</form>
			<cfelse>
				<br>
				<a href="index.cfm?event=ehSettings.dspMain&resLibPathEditIndex=0">Click Here</a> to add a resource library path
			</cfif>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>