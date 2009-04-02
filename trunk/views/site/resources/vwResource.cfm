<cfparam name="request.requestState.resLibIndex" default="">
<cfparam name="request.requestState.resourceType" default="">
<cfparam name="request.requestState.package" default="">
<cfparam name="request.requestState.id" default="">

<cfparam name="request.requestState.qryPackages" default="">
<cfparam name="request.requestState.oResourceBean" default="">
<cfparam name="request.requestState.resourceTypeConfig" default="">

<cfscript>
	resLibIndex = request.requestState.resLibIndex;
	resourceType = request.requestState.resourceType;
	package = request.requestState.package;
	id = request.requestState.id;
	qryPackages = request.requestState.qryPackages;
	oResourceBean = request.requestState.oResourceBean;
	resourceTypeConfig = request.requestState.resourceTypeConfig;
	
	props = oResourceBean.getProperties();
	lstProps = structKeyList(props);
	lstProps = listSort(lstProps,"textnocase");	
</cfscript>

<cfoutput>
	<div style="border:1px solid silver;background-color:##fff;margin-bottom:5px;height:470px;" id="pnl_info">
		<form name="frm" action="index.cfm" method="post" style="margin:0px;padding:0px;">
			<input type="hidden" name="event" value="ehResources.doSaveResource">

			<table style="margin:10px;">
				<tr>
					<td width="80"><b>Res Lib:</b></td>
					<td>#oResourceBean.getResLibPath()#</td>
				</tr>
				<cfif id neq "">
					<input type="hidden" name="id" value="#id#">
					<input type="hidden" name="package" value="#package#">
					<tr>
						<td width="80"><b>ID:</b></td>
						<td>#oResourceBean.getID()#</td>
					</tr>
					<tr>
						<td width="80"><b>Package:</b></td>
						<td>#oResourceBean.getPackage()#</td>
					</tr>
				<cfelse>		
					<tr>
						<td width="80"><b>ID:</b></td>
						<td><input type="text" name="id" value="" class="formField"></td>
					</tr>
					<tr>
						<td width="80"><b>Package:</b></td>
						<td>
							<select name="package" class="formField" onchange="togglePackage(this.value)">
								<option value="">[CREATE NEW]</option>
								<cfloop query="qryPackages">
									<option value="#qryPackages.name#" <cfif qryPackages.name eq package>selected</cfif>>#qryPackages.name#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<div id="newPkgDiv" style="display:none;">
								New package name:
								<input type="text" name="package_new" value="" class="formField" style="width:250px;">
							</div>
						</td>
					</tr>
				</cfif>
				
				<tr>
					<td width="80"><b>HREF:</b></td>
					<td><input type="text" name="href" value="#oResourceBean.getHREF()#" class="formField"></td>
				</tr>
				<tr valign="top">
					<td><strong>Description:</strong></td>
					<td><textarea name="description" class="formField" rows="4">#oResourceBean.getDescription()#</textarea></td>
				</tr>
				<cfif lstProps neq "">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td><strong><u>Custom Properties</u></strong></td></tr>
					<cfloop list="#lstProps#" index="key">
						<cfset tmpValue = trim(props[key])>
						<tr>
							<td width="80"><b>#key#:</b></td>
							<td><input type="text" name="cp_#key#" value="#tmpValue#" class="formField"></td>
						</tr>
					</cfloop>
				</cfif>
			</table>
			<br /><br />
			<div style="margin:10px;">
				<input type="button" name="btnSave" value="Apply Changes" onclick="saveResource(this.form)">
				<cfif id neq "">
					&nbsp;&nbsp;&nbsp;
					<input type="button" name="btnDelete" value="Delete Resource" onclick="if(confirm('Delete resource?')){document.location='index.cfm?event=ehResources.doDeleteResource&id=#id#&resourceType=#resourceType#&pkg=#pkg#'}">
				</cfif>
				&nbsp;&nbsp;&nbsp;
				<input type="button" name="btnCancel" value="Cancel" onclick="selectResourceType('#resourceType#')">
			</div>
		</form>		
	</div>

</cfoutput>

