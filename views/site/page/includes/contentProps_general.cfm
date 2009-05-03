<cfoutput>
	<div style="font-weight:bold;font-size:16px;border-bottom:1px solid silver;">General Properties</div>

	<table style="margin:5px;">
		<tr>
			<td style="width:100px;font-size:16px;"><strong>ID:</strong></td>
			<td style="font-size:16px;"><b>#thisModule.ID#</b> (#thisModule.moduleType#)</td>
		</tr>
		<tr>
			<td><strong>Title:</strong></td>
			<td>
				<input type="text" name="title" 
						value="#thisModule.Title#" 
						class="formField">
			</td>
		</tr>
		<tr>
			<td><strong>Icon URL:</strong></td>
			<td>
				<input type="text" name="icon" 
						value="#thisModule.icon#" 
						class="formField">
			</td>
		</tr>
		<tr>
			<td><strong>Template:</strong></td>
			<td>
				<select name="moduleTemplate" style="width:130px;font-size:11px;" class="formField">
					<option value="0">-- Select Template --</option>
					<option value="" <cfif thisModule.moduleTemplate eq "">selected</cfif>>(default)</option>
					<cfloop collection="#stModuleTemplates#" item="key">
						<option value="#stModuleTemplates[key].name#" 
								<cfif stModuleTemplates[key].name eq thisModule.moduleTemplate>selected</cfif>>#stModuleTemplates[key].name#</option>
					</cfloop>
				</select>

				<!--- <input type="radio" name="container" 
						style="border:0px;width:15px;"
						value="true" 
						<cfif thisModule.container>checked</cfif>> Yes 
				<input type="radio" name="container" 
						style="border:0px;width:15px;"
						value="false" 
						<cfif not thisModule.container>checked</cfif>> No  --->
			</td>
		</tr>
	</table>
	<cfset lstIgnoreAttribs = listAppend(lstIgnoreAttribs, "title,icon,container")>
</cfoutput>
