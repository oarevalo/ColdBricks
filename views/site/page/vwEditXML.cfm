<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.xmlContent" default="">
<cfparam name="request.requestState.pageHREF" default="">

<cfinclude template="../../../includes/udf.cfm">

<cfscript>
	oPage = request.requestState.oPage;
	xmlContent = request.requestState.xmlContent;
	thisPageHREF = request.requestState.pageHREF;	
	
	title = oPage.getTitle();
	
	xmlDoc = oPage.toXML();
	if(xmlContent eq "")
		xmlContent = xmlPrettyPrint(xmlDoc.xmlRoot);
</cfscript>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/pageEditor.js"></script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>
<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="8" cellspacing="0">
	<tr>
		<td nowrap="yes">
			<strong>Title:</strong> #title#
		</td>
		<td align="right">
			<cfmodule template="../../includes/sitePageSelector.cfm">
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

