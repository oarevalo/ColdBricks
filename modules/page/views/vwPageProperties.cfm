<cfparam name="request.requestState.oPage" default="">

<cfparam name="request.requestState.propName" default="">
<cfparam name="request.requestState.propValue" default="">

<cfscript>
	oPage = request.requestState.oPage;
	
	propName = request.requestState.propName;
	propValue = request.requestState.propValue;

	title = oPage.getTitle();
	stProps = oPage.getProperties();
	
	if(propName neq "" and oPage.hasProperty(propName)) {
		propValue = oPage.getProperty(propName);	
	}
</cfscript>


<script type="text/javascript">
function deletePageProperty(name) {
	if(confirm('Delete property?')) {
		document.location = '?event=page.ehPage.doRemovePageProperty&propName='+name;
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
						<th width="150">Name</th>
						<th>Value</th>
						<th width="30">&nbsp;</th>
					</tr>
					<cfset i = 1>
					<cfloop collection="#stProps#" item="key">
						<tr <cfif i mod 2>style="background-color:##f3f3f3;"</cfif>>
							<td align="right"><b>#i#.</b></td>
							<td>#stProps[key].name#</td>
							<td>#stProps[key].value#</td>
							<td align="right">
								<a href="index.cfm?event=page.ehPage.dspPageProperties&propName=#key#"><img src="images/page_edit.png" align="absmiddle" border="0"></a>
								<a href="javascript:deletePageProperty('#jsStringFormat(key)#')"><img src="images/waste_small.gif" align="absmiddle" border="0"></a>
							</td>
						</tr>
						<cfset i = i + 1>
					</cfloop>
					<cfif structIsEmpty(stProps)>
						<tr><td colspan="4"><em>No custom page properties found.</em></td></tr>
					</cfif>
				</table>
			</div>	

			<form name="frm" method="post" action="index.cfm" style="margin:0px;padding:0px;">
				<fieldset style="margin-top:10px;border:1px solid ##ccc;background-color:##ebebeb;">
					<legend><strong>Add/Edit Property:</strong></legend>
					<input type="hidden" name="event" value="page.ehPage.doSetPageProperty">
					<input type="hidden" name="propName" value="#propName#">
				
					<table cellspacing="0" cellpadding="2" style="margin-bottom:5px;">
						<tr>
							<td>Name:</td>
							<td>Value:</td>
							<td>&nbsp;</td>
						</tr>
						<tr valign="top">
							<td>
								<input type="text" name="newname" value="#propName#">
							</td>	
							<td>
								<input type="text" name="propValue" value="#propValue#" style="width:300px;">
							</td>
							<td>
								<input type="submit" name="btnSave" value="Save">	
								<cfif propName neq "">
									<input type="button" name="btnCancel" value="Cancel" onclick="document.location='?event=page.ehPage.dspPageProperties'">	
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
					<h2>Custom Page Properties</h2>
					<p>
						Page properties are custom values associated with a page. Properties can be used for different
						purposes by the containing website or application.
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