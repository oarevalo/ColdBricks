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
			<td><strong>Module Container:</strong></td>
			<td>
				<input type="radio" name="container" 
						style="border:0px;width:15px;"
						value="true" 
						<cfif thisModule.container>checked</cfif>> Yes 
				<input type="radio" name="container" 
						style="border:0px;width:15px;"
						value="false" 
						<cfif not thisModule.container>checked</cfif>> No 
			</td>
		</tr>
	</table>
	<cfset lstIgnoreAttribs = listAppend(lstIgnoreAttribs, "title,icon,container")>
</cfoutput>
