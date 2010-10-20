<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.cssContent" default="">
<cfparam name="request.requestState.pageHREF" default="">
<cfparam name="request.requestState.pageCSSContent" default="">

<cfscript>
	oPage = request.requestState.oPage;
	cssContent = request.requestState.cssContent;
	thisPageHREF = request.requestState.pageHREF;	
	pageCSSContent = request.requestState.pageCSSContent;	
	
	title = oPage.getTitle();
	
	if(cssContent eq "") 
		cssContent = pageCSSContent;
</cfscript>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="modules/page/includes/pageEditor.js"></script>
	<script type="text/javascript">
		<cfoutput>
			function saveAsSkin() {
				var n = prompt("Enter a name for the new skin:","#listFirst(getFileFromPath(thisPageHREF),'.')#");
				if(n != null && n != '')
					document.location='?event=page.ehPage.doCreateSkinFromPageCSS&name=' + escape(n);
			}
		</cfoutput>
	</script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">


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


<form name="frm" method="post" action="index.cfm" style="margin:0px;padding:0px;">
	<input type="hidden" name="event" value="page.ehPage.doSaveCSS">
	<table style="margin:0px;padding:0px;width:100%;" cellpadding="0" cellspacing="0">
		<tr valign="top">
			<td>
				<textarea name="cssContent" 
							onkeypress="checkTab(event)" 
							onkeydown="checkTabIE()"				
							class="codeEditor">#cssContent#</textarea>
			</td>
			<td width="300" rowspan="2">
				<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:420px;line-height:18px;">
					<div style="margin:10px;">
						<h2>Stylesheet</h2>
						Use this space to enter CSS declarations and rules
						that will be applied <b>ONLY</b> to the current page. This stylesheet
						is always applied after any other css pages on the page.
						
						<p>
							<div style="font-weight:bold;font-size:12px;border-bottom:2px solid black;">Special Classes / IDs</div>
							&bull; <strong style="color:##50628b;">.Section:</strong> Class applied to all modules that have a container.<br />
							&bull; <strong style="color:##50628b;">.SectionTitle:</strong> Class applied to the module title bar (only when the module container is displayed)<br />
							&bull; <strong style="color:##50628b;">.SectionBody:</strong> Class applied to the module contents (only when the module container is displayed)<br />
						</p>

						<p>
							<span style="color:green;font-weight:bold;">TIP:</span>
							All modules are always contained within a div element with the same ID as the module ID.
						</p>
						
						<p>
							<div style="font-weight:bold;font-size:12px;border-bottom:2px solid black;margin-top:10px;">Other CSS Resources:</div>
							<a href="http://en.wikipedia.org/wiki/Cascading_Style_Sheets" target="_blank" style="font-weight:normal;border-bottom:1px dashed silver;">CSS Wikipedia Entry</a><br />
							<a href="http://www.w3.org/Style/CSS/" target="_blank" style="font-weight:normal;border-bottom:1px dashed silver;">W3C CSS Spec</a><br />
						</p>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<input type="button" 
						name="btnCancel" 
						value="Return To Page Editor" 
						onClick="document.location='?event=page.ehPage.dspMain'">
				&nbsp;&nbsp;
				<input type="submit" name="btnSave" value="Apply Changes" style="font-weight:bold;">
				<!---
				&nbsp;&nbsp;|&nbsp;&nbsp;
				<input type="button" 
						name="btnSkin" 
						value="Convert To Skin" 
						onClick="saveAsSkin()">
				--->
			</td>
		</tr>
	</table>
	
</form>
</cfoutput>
