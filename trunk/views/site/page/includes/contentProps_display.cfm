<cfoutput>
	<div style="font-weight:bold;font-size:16px;border-bottom:1px solid silver;">Display Properties</div>

	<table style="margin:5px;">
		<tr>
			<td style="width:100px;"><strong>CSS Class:</strong></td>
			<td>
				<input type="text" name="class" 
						value="#thisModule.class#" 
						class="formField">
			</td>
		</tr>
		<tr>
			<td><strong>CSS Style:</strong></td>
			<td>
				<input type="text" name="style" 
						value="#thisModule.style#" 
						class="formField">
			</td>
		</tr>
		<tr>
			<td><strong>Display output:</strong></td>
			<td>	
				<input type="radio" name="output" 
						style="border:0px;width:15px;"
						value="true" 
						<cfif thisModule.output>checked</cfif>> Yes 
				<input type="radio" name="output" 
						style="border:0px;width:15px;"
						value="false" 
						<cfif not thisModule.output>checked</cfif>> No 
			</td>
		</tr>
	</table>
	<cfset lstIgnoreAttribs = listAppend(lstIgnoreAttribs, "class,style,output")>
</cfoutput>