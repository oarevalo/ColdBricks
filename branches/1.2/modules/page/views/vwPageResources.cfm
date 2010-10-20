<cfparam name="request.requestState.oPage" default="">

<cfparam name="request.requestState.type" default="">
<cfparam name="request.requestState.href" default="">
<cfparam name="request.requestState.index" default="">

<cfscript>
	oPage = request.requestState.oPage;
	
	type = request.requestState.type;
	href = request.requestState.href;
	index= request.requestState.index;
	
	title = oPage.getTitle();
	aStyles = oPage.getStylesheets();
	aScripts = oPage.getScripts();
	
	if(type neq "" and index gt 0) {
		if(type eq "JavaScript")
			href = aScripts[index];
		else if(type eq "Stylesheet")
			href = aStyles[index];
	}
	
	lstTypes = "Stylesheet,JavaScript";
</cfscript>


<script type="text/javascript">
function deletePageResource(type,index) {
	if(confirm('Delete this resource?')) {
		document.location = '?event=page.ehPage.doDeletePageResource&index='+index+'&type='+type;
	}
}
</script>

<cfoutput>
<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="8" cellspacing="0">
	<tr>
		<td nowrap="yes">
			<strong>Title:</strong> #title#
		</td>
		<td align="right">
			<cfmodule template="../../../includes/sitePageSelector.cfm">
		</td>
	</tr>
</table>


<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>
			<div style="margin-top:10px;border:1px solid ##ccc;height:230px;overflow:auto;">	
				<table class="cp_dataTable">
					<tr>
						<th width="10">&nbsp;</th>
						<th width="150">Type</th>
						<th>Src</th>
						<th width="30">&nbsp;</th>
					</tr>
					<cfloop from="1" to="#arrayLen(aStyles)#" index="i">
						<tr <cfif i mod 2>style="background-color:##f3f3f3;"</cfif>>
							<td align="right"><b>#i#.</b></td>
							<td>Stylesheet</td>
							<td>#aStyles[i]#</td>
							<td align="right">
								<a href="index.cfm?event=page.ehPage.dspPageResources&index=#i#&type=Stylesheet"><img src="images/page_edit.png" align="absmiddle" border="0"></a>
								<a href="javascript:deletePageResource('Stylesheet',#i#)"><img src="images/waste_small.gif" align="absmiddle" border="0"></a>
							</td>
						</tr>
					</cfloop>
					<cfloop from="1" to="#arrayLen(aScripts)#" index="i">
						<tr <cfif i mod 2>style="background-color:##f3f3f3;"</cfif>>
							<td align="right"><b>#i#.</b></td>
							<td>Script</td>
							<td>#aScripts[i]#</td>
							<td align="right">
								<a href="index.cfm?event=page.ehPage.dspPageResources&index=#i#&type=JavaScript"><img src="images/page_edit.png" align="absmiddle" border="0"></a>
								<a href="javascript:deletePageResource('JavaScript',#i#)"><img src="images/waste_small.gif" align="absmiddle" border="0"></a>
							</td>
						</tr>
					</cfloop>
					<cfif arrayLen(aScripts) + arrayLen(aStyles) eq 0>
						<tr><td colspan="4"><em>No resources found.</em></td></tr>
					</cfif>
				</table>
			</div>	

			<form name="frm" method="post" action="index.cfm" style="margin:0px;padding:0px;">
				<fieldset style="margin-top:10px;border:1px solid ##ccc;background-color:##ebebeb;">
					<legend><strong>Add/Edit Page Resource:</strong></legend>
					<input type="hidden" name="event" value="page.ehPage.doSavePageResource">
					<input type="hidden" name="index" value="#index#">
				
					<table cellspacing="0" cellpadding="2" style="margin-bottom:5px;">
						<tr>
							<td>Type:</td>
							<td>Src:</td>
							<td>&nbsp;</td>
						</tr>
						<tr valign="top">
							<td>
								<select name="type" style="width:100px;">
									<cfloop list="#lstTypes#" index="tag">
										<option value="#tag#" <cfif type eq tag>selected</cfif>>#tag#</option>
									</cfloop>
								</select>
							</td>	
							<td>
								<input type="text" name="href"  style="width:300px;" value="#href#">
							</td>
							<td>
								<input type="submit" name="btnSave" value="Save">	
								<cfif index gt 0>
									<input type="button" name="btnCancel" value="Cancel" onclick="document.location='?event=page.ehPage.dspPageResources'">	
								</cfif>
							</td>
						</tr>
					</table>
				</fieldset>
			</form>
		</td>
		
		<td width="200">
			<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:350px;line-height:18px;">
				<div style="margin:10px;">
					<h2>Styles & Scripts</h2>
					<p>
						You can add custom CSS Stylesheets and Javascript files to your pages. These page resources will
						be linked to every time the page is rendered.
					</p>
					<p>
						To add an external resource, just select the resource type (stylesheet or javascript) and enter the
						location where the resource resides.
					</p>
				</div>
			</div>
		</td>
		
	</tr>
</table>

<p>
	<input type="button" 
			name="btnCancel" 
			value="Return To Page Editor" 
			onClick="document.location='?event=page.ehPage.dspMain'">
</p>
</cfoutput>