<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.templateEditKey" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	templateEditKey = request.requestState.templateEditKey;
	
	stTemplates = oHomePortalsConfigBean.getRenderTemplates();
	
	dspEvent = "ehSettings.dspMain";
</cfscript>


<script type="text/javascript">
	function confirmDeleteTemplate(name) {
		if(confirm("Delete template?")) {
			document.location = "index.cfm?event=ehSettings.doDeleteRenderTemplate&name=" + name;
		}
	}
</script>

<cfoutput>
	<tr><td colspan="2"><h2>Render Templates:</h2></td></tr>
	<tr>
		<td colspan="2">
		
			<table style="width:100%;border:1px solid silver;">
				<tr>
					<th style="background-color:##ccc;width:50px;">No.</th>
					<th style="background-color:##ccc;width:100px;">Name</th>
					<th style="background-color:##ccc;width:100px;">Type</th>
					<th style="background-color:##ccc;">Path</th>
					<th style="background-color:##ccc;width:100px;">Default?</th>
					<th style="background-color:##ccc;width:100px;">Action</th>
				</tr>
				<cfset index = 1>
				<cfloop collection="#stTemplates#" item="key">
					<tr <cfif index mod 2>class="altRow"</cfif> <cfif templateEditKey eq key>style="font-weight:bold;"</cfif>>
						<td style="width:50px;" align="right"><strong>#index#.</strong></td>
						<td style="width:100px;" align="center"><a href="index.cfm?event=#dspEvent#&templateEditKey=#key#">#key#</a></td>
						<td style="width:100px;" align="center"><a href="index.cfm?event=#dspEvent#&templateEditKey=#key#">#stTemplates[key].type#</a></td>
						<td>#stTemplates[key].href#</td>
						<td align="center"><cfif isBoolean(stTemplates[key].isDefault) and stTemplates[key].isDefault>Yes</cfif></td>
						<td align="center">
							<a href="index.cfm?event=#dspEvent#&templateEditKey=#key#"><img src="images/page_edit.png" border="0" alt="Edit render template" title="Edit render template"></a>
							<a href="##" onclick="confirmDeleteTemplate('#key#')"><img src="images/page_delete.png" border="0" alt="Delete render template" title="Delete render template"></a>
						</td>
					</tr>
					<cfset index++>
				</cfloop>
			</table>
			<cfif templateEditKey neq "">
				<cfif templateEditKey neq "__NEW__">
					<cfset isNew = false>
					<cfset stTemplate = oHomePortalsConfigBean.getRenderTemplate(templateEditKey)>
				<cfelse>
					<cfset isNew = true>
					<cfset stTemplate = structNew()>	
					<cfset templateEditKey = "">
				</cfif>
				<cfparam name="stTemplate.name" default="">
				<cfparam name="stTemplate.type" default="">
				<cfparam name="stTemplate.href" default="">
				<cfparam name="stTemplate.description" default="">
				<cfparam name="stTemplate.isDefault" default="false">
				<br />
				<cfif isNew>
					<p><b>Create New Render Template</b></p>
				<cfelse>
					<p><b>Edit Render Template</b></p>
				</cfif>

				<table style="width:100%;border:1px solid silver;margin-top:5px;">
					<tr valign="top">
						<td style="width:430px;">
							<form name="frmEditTemplate" action="index.cfm" method="post">
								<input type="hidden" name="event" value="ehSettings.doSaveRenderTemplate">
								<cfif not isNew>
									<input type="hidden" name="name" value="#templateEditKey#">
								</cfif>
								<table>
									<tr>
										<td><b>Name:</b></td>
										<td><input type="text" name="name" value="#stTemplate.name#"  class="formField" <cfif not isNew>disabled</cfif>></td>
									</tr>
									<tr>
										<td><b>Type:</b></td>
										<td>
											<input type="radio" name="type" value="page" <cfif stTemplate.type eq "page">checked</cfif>> Page &nbsp;&nbsp;
											<input type="radio" name="type" value="module" <cfif stTemplate.type eq "module">checked</cfif>> Module &nbsp;&nbsp;
										</td>
									</tr>
									<tr>
										<td><b>HREF:</b></td>
										<td><input type="text" name="href" value="#stTemplate.href#" class="formField"></td>
									</tr>
									<tr>
										<td><b>Default?:</b></td>
										<td>
											<input type="radio" name="isDefault" value="true" <cfif stTemplate.isDefault>checked</cfif>> Yes &nbsp;&nbsp;
											<input type="radio" name="isDefault" value="false" <cfif not stTemplate.isDefault>checked</cfif>> No &nbsp;&nbsp;
										</td>
									</tr>
									<tr valign="top">
										<td><b>Description:</b></td>
										<td><textarea name="description" class="formField" rows="3">#stTemplate.description#</textarea></td>
									</tr>
								</table>
								<br />
								<input type="submit" name="btnSave" value="Apply" style="font-size:11px;">
								<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=#dspEvent#'">
							</form>
						</td>
					</tr>
				</table>
			<cfelse>
				<br>
				<a href="index.cfm?event=#dspEvent#&templateEditKey=__NEW__">Click Here</a> to register a render template
			</cfif>	
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>

