<cfset lstCustomProps = "">

<cfoutput>
	<div style="font-weight:bold;font-size:16px;border-bottom:1px solid silver;">Custom Properties</div>
	
	<table style="margin:5px;">
		<cfset bHasOtherProps = false>
		<cfloop collection="#thisModule#" item="thisAttr">
			<cfif not ListFindNoCase(lstIgnoreAttribs,thisAttr)>
				<cfset tmpAttrValue = thisModule[thisAttr]>
				<cfset lstCustomAttribs = listAppend(lstCustomAttribs, thisAttr)>
				<tr valign="top">
					<td width="50"><strong>#thisAttr#:</strong></td>
					<td>
						<input type="text" 
								name="#thisAttr#" 
								id="#thisAttr#_fld"
								value="#tmpAttrValue#" 
								class="formField">
						
						<input type="checkbox" name="#thisAttr#_delete" value="true" onclick="this.form.#thisAttr#_fld.disabled=this.checked"> Delete?	
					</td>
				</tr>
			</cfif>
		</cfloop>
		<tr>
			<td width="50"><input type="text" name="newCustomProp_name" value="" class="formField" style="width:100px;"></td>
			<td><input type="text" name="newCustomProp_value" value="" class="formField"></td>
		</tr>
	</table>	
</cfoutput>