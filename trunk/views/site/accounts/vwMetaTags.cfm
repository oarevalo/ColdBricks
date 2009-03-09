<cfparam name="request.requestState.oSite" default="">
<cfparam name="request.requestState.oPage" default="">

<cfparam name="request.requestState.name" default="">
<cfparam name="request.requestState.content" default="">
<cfparam name="request.requestState.index" default="0">

<cfscript>
	oSite = request.requestState.oSite;
	oPage = request.requestState.oPage;
	
	name = request.requestState.name;
	content = request.requestState.content;
	index = request.requestState.index;
	
	aPages = oSite.getPages();
	owner = oSite.getOwner();
	title = oPage.getTitle();
	
	thisPageHREF = oPage.getHREF();	

	qryMetaTags = oPage.getMetaTags();
	
	if(index gt 0 and index lte qryMetaTags.recordCount) {
		name = qryMetaTags.name[index];	
		content = qryMetaTags.content[index];	
	}
	
	lstMetaTags = "description,keywords,robots,author,copyright,refresh";

	// sort account pages
	aPagesSorted = arrayNew(1);
	for(i=1;i lte arrayLen(aPages);i=i+1) {
		arrayAppend(aPagesSorted, aPages[i].href);
	}
	arraySort(aPagesSorted,"textnocase","asc");

</cfscript>


<script type="text/javascript">
function deleteMetaTag(index) {
	if(confirm('Delete meta tag?')) {
		document.location = '?event=ehPage.doDeleteMetaTag&index='+index;
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
			<strong>Page:</strong>
			<select name="page" style="width:180px;font-size:11px;" class="formField"  onchange="document.location='?event=ehPage.dspMain&page='+this.value">
				<cfloop from="1" to="#arrayLen(aPagesSorted)#" index="i">
					<option value="#aPagesSorted[i]#"
							<cfif aPagesSorted[i] eq getFileFromPath(thisPageHREF)>selected</cfif>>#aPagesSorted[i]#</option>
				</cfloop>
			</select>
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
						<th>Content</th>
						<th width="30">&nbsp;</th>
					</tr>
					<cfloop query="qryMetaTags">
						<tr <cfif qryMetaTags.currentRow mod 2>style="background-color:##f3f3f3;"</cfif>>
							<td align="right"><b>#qryMetaTags.currentRow#.</b></td>
							<td>#qryMetaTags.name#</td>
							<td>#qryMetaTags.content#</td>
							<td align="right">
								<a href="index.cfm?event=ehPage.dspMeta&index=#qryMetaTags.currentRow#"><img src="images/page_edit.png" align="absmiddle" border="0"></a>
								<a href="javascript:deleteMetaTag(#qryMetaTags.currentRow#)"><img src="images/waste_small.gif" align="absmiddle" border="0"></a>
							</td>
						</tr>
					</cfloop>
					<cfif qryMetaTags.recordCount eq 0>
						<tr><td colspan="4"><em>No user-defined meta tags found.</em></td></tr>
					</cfif>
				</table>
			</div>	

			<form name="frm" method="post" action="index.cfm" style="margin:0px;padding:0px;">
				<fieldset style="margin-top:10px;border:1px solid ##ccc;background-color:##ebebeb;">
					<legend><strong>Add Meta Tag:</strong></legend>
					<input type="hidden" name="event" value="ehPage.doAddMetaTag">
					<input type="hidden" name="index" value="#index#">
				
					<table cellspacing="0" cellpadding="2" style="width:440px;margin-bottom:5px;">
						<tr>
							<td>Name:</td>
							<td>Content:</td>
							<td>&nbsp;</td>
						</tr>
						<tr valign="top">
							<td>
								<select name="name" style="width:200px;font-size:10px;">
									<cfloop list="#lstMetaTags#" index="tag">
										<option value="#tag#" <cfif name eq tag>selected</cfif>>#tag#</option>
									</cfloop>
								</select>
							</td>	
							<td>
								<textarea name="content" rows="3" style="width:400px;">#content#</textarea>
							</td>
							<td>
								<cfif index gt 0>
									<input type="submit" name="btnSave" value="Save Meta Tag">	
								<cfelse>
									<input type="submit" name="btnSave" value="Add Meta Tag">	
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
					<h2>Meta Tags</h2>
					<p>
						Meta tags are a way to provide additional information about a web page. They are especially
						useful for search engine spiders and other automatic processing of web content.
					</p>
					<p>
						All meta tags have a name and an associated content. Common meta tags are <b>description</b>,
						<b>keywords</b> and <b>robots</b>
					</p>
					<p>
						<div style="font-weight:bold;font-size:12px;border-bottom:2px solid black;margin-top:10px;">Other Resources:</div>
						<a href="http://en.wikipedia.org/wiki/Meta_tag" target="_blank" style="font-weight:normal;border-bottom:1px dashed silver;">Meta Element Wikipedia Entry</a><br />
						<a href="http://www.w3.org/TR/html401/struct/global.html##h-7.4.4" target="_blank" style="font-weight:normal;border-bottom:1px dashed silver;">W3C Meta Data Spec</a><br />
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
			onClick="document.location='?event=ehPage.dspMain'">
</p>
</cfoutput>