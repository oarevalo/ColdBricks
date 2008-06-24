<cfparam name="request.requestState.oSite" default="">
<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.xmlContent" default="">

<cfinclude template="../../../includes/udf.cfm">

<cfscript>
	oSite = request.requestState.oSite;
	oPage = request.requestState.oPage;
	xmlContent = request.requestState.xmlContent;
	
	aPages = oSite.getPages();
	owner = oSite.getOwner();
	title = oPage.getPageTitle();
	
	thisPageHREF = oPage.getHREF();	

	xmlDoc = oPage.getXML();
	if(xmlContent eq "")
		xmlContent = xmlPrettyPrint(xmlDoc.xmlRoot);
		
	// sort account pages
	aPagesSorted = arrayNew(1);
	for(i=1;i lte arrayLen(aPages);i=i+1) {
		arrayAppend(aPagesSorted, aPages[i].href);
	}
	arraySort(aPagesSorted,"textnocase","asc");
		
</cfscript>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/pageEditor.js"></script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>
<cfmodule template="../../../includes/menu_site.cfm" title="Accounts > #owner# > #title# > Page XML">

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


<form name="frm" method="post" action="index.cfm" style="margin:0px;padding:0px;">
	<input type="hidden" name="event" value="ehPage.doSaveXML">
	
	<div style="font-size:12px;font-weight:bold;margin:10px;margin-bottom:0px;">
		<span style="color:red;">CAUTION!</span> Please make sure you know what you are doing. 
		Incorrect syntax or tags could make the page unable to be displayed. It is 
		<span style="text-decoration:underline">HIGHLY RECOMMENDED</span> to use only 
		the page editor to modify a page.
	</div>
	
	<textarea name="xmlContent"  
				onkeypress="checkTab(event)" 
				onkeydown="checkTabIE()"				
				class="codeEditor" 
				wrap="off">#xmlContent#</textarea>
	
	<p>
		<input type="button" 
				name="btnCancel" 
				value="Return To Page Editor" 
				onClick="document.location='?event=ehPage.dspMain'">
		&nbsp;&nbsp;
		<input type="submit" name="btnSave" value="Apply Changes">
	</p>
</form>
</cfoutput>

