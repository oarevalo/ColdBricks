<cfparam name="request.requestState.pageTitle" default="">
<cfparam name="request.requestState.resType" default="module">
<cfparam name="request.requestState.appRoot" default="">
<cfparam name="request.requestState.aLayoutSectionTypes" default="">
<cfparam name="request.requestState.pageHREF" default="">

<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.oCatalog" default="">

<cfparam name="request.requestState.accountName" default="">

<cfscript>
	pageTitle = request.requestState.pageTitle;
	thisPageHREF = request.requestState.pageHREF;
	resType = request.requestState.resType;
	appRoot = request.requestState.appRoot;
	aLayoutSectionTypes = request.requestState.aLayoutSectionTypes;
	
	oPage = request.requestState.oPage;
	oCatalog = request.requestState.oCatalog;	

	accountName = request.requestState.accountName;
	
	title = oPage.getTitle();
	skinID = oPage.getSkinID();
	
	stLocationsByType = structNew();
	for(i=1;i lte ArrayLen(aLayoutSectionTypes);i=i+1) {
		if(not structKeyExists(stLocationsByType,aLayoutSectionTypes[i]))
			stLocationsByType[ aLayoutSectionTypes[i] ] = arrayNew(1);
	}

	aLayoutRegions = oPage.getLayoutRegions();
	stModulesByRegion = structNew();
	
	for(i=1;i lte ArrayLen(aLayoutRegions);i=i+1) {
		if(structKeyExists(stLocationsByType,aLayoutRegions[i].type)) {
			arrayAppend( stLocationsByType[aLayoutRegions[i].type] , aLayoutRegions[i] );
		}
		if(not structKeyExists(stModulesByRegion, aLayoutRegions[i].name))
			stModulesByRegion[ aLayoutRegions[i].name ] = arrayNew(1);
	}
	
	aModules = oPage.getModules();
	for(i=1;i lte ArrayLen(aModules);i=i+1) {
		if(not structKeyExists(stModulesByRegion, aModules[i].location))
			stModulesByRegion[ aModules[i].location ] = arrayNew(1);
		arrayAppend(stModulesByRegion[ aModules[i].location ] , aModules[i]);
	}
	
	numColumns = arrayLen(aLayoutRegions);
	colWidth = 200;
	if(numColumns gt 0)	colWidth = 200 / numColumns;
	
	fileName = getFilefromPath(thisPageHREF);
	fileName = listDeleteAt(fileName, listlen(fileName,"."), ".");
	
	qrySkins = oCatalog.getResourcesByType("skin");
	qryPageTemplates = oCatalog.getResourcesByType("pageTemplate");
	aStyles = oPage.getStylesheets();
	
	if(appRoot eq "/")
		tmpPageURL = "/index.cfm?page=#thisPageHREF#";
	else
		tmpPageURL = appRoot & "/index.cfm?page=#thisPageHREF#";
		
	if(accountName neq "") tmpPageURL & "&account=" & accountName;
</cfscript>


<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/pageEditor.js"></script>
	<script type="text/javascript" src="includes/js/prototype-1.4.0.js"></script>
	<script type="text/javascript" src="includes/js/coordinates.js"></script>
	<script type="text/javascript" src="includes/js/drag.js"></script>
	<script type="text/javascript" src="includes/js/dragdrop.js"></script>
	<script>
		window.onload = initLayoutPreview;
	</script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">


<cfoutput>
<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="8" cellspacing="0">
	<tr>
		<td nowrap="yes">
			<form name="frm" method="post" action="index.cfm" style="padding:0px;margin:0px;">
				<strong>Title:</strong> 
				<input type="hidden" name="event" value="ehPage.doSetTitle">
				<input type="text" name="pageTitle" value="#title#" size="50" class="formField" style="width:200px;font-size:12px;" onkeydown="$('btnChangeTitle').disabled=false;">
				<input type="submit" value="Apply" style="width:auto;" disabled id="btnChangeTitle">
			</form>
		</td>

		<td align="center" nowrap="yes">
			<strong>Skin:</strong>
			<select name="skin" style="width:150px;font-size:11px;" class="formField"  onchange="changeSkin(this.value)">
				<option value="0">-- Select Skin --</option>
				<option value="NONE">-- None --</option>
				<cfloop query="qrySkins">
					<option value="#qrySkins.id#" <cfif qrySkins.id eq skinID>selected</cfif>>#qrySkins.id#</option>
				</cfloop>
				<option value="_NEW">-- New Skin --</option>
				<!--- <option value="_IMPORT">-- Import Skins --</option> --->
			</select>
			<cfif skinID neq "">
				<a href="index.cfm?event=ehResources.dspMain&resType=skin&id=#skinID#&libpath=auto">Edit</a>
			<cfelse>
				<a href="index.cfm?event=ehResources.dspMain&resType=skin&id=NEW&pkg=__ALL__">New</a>
			</cfif>
		</td>
		<td align="right" nowrap="yes">
			<cfmodule template="../../../includes/sitePageSelector.cfm">
			<a href="##" onclick="doRenamePage()">Rename</a>
		</td>
	</tr>
</table>

<table border="0" cellspacing="0" cellpadding="0" width="100%" style="margin-top:10px;">
	<tr valign="top">
	
		<td width="210">
			<!--- Add Content --->
			<div class="cp_sectionTitle" id="cp_pd_moduleProperties_Title" 
					style="width:210px;padding:0px;margin:0px;">
				<div style="margin:2px;">
					<img src="images/brick_add.png" align="absmiddle"> Add Page Content
				</div>
			</div>
			<!--- select resource type --->
			<div id="resourceTreePanel">Loading resources...</div>
		</td>

		<td style="padding:0px;margin:0px;" align="Center">

			<div class="cp_sectionBox" 
				 style="padding:0px;margin-left:5px;margin-right:5px;border:0px;margin-top:0px;">

				<div style="float:right;margin-right:0px;margin:4px;">
					<div class="buttonImage btnLarge">
						<img src="images/magnifier.png" align="Absmiddle">
						<a href="#tmpPageURL#" target="previewPage"><strong>Preview</strong></a>
					</div>
				</div>

				<div style="margin:4px;text-align:left;padding-top:0px;">
					<div class="buttonImage btnLarge" style="margin:0px;float:left;margin-right:5px;">
						<img src="images/cog.png" align="Absmiddle">
						<a href="?event=ehPage.dspEventHandlers">Event Handlers</a>
					</div>
					<div class="buttonImage btnLarge" style="margin:0px;float:left;margin-right:5px;">
						<img src="images/page_code.png" align="Absmiddle">
						<a href="?event=ehPage.dspMeta">Meta Tags</a>	
					</div>
					<div class="buttonImage btnLarge" style="margin:0px;float:left;margin-right:5px;">
						<img src="images/css.png" align="Absmiddle">
						<a href="?event=ehPage.dspEditCSS">StyleSheet</a>
					</div>
					<div class="buttonImage btnLarge" style="margin:0px;float:left;margin-right:5px;">
						<img src="images/xml.gif" align="Absmiddle">
						<a href="?event=ehPage.dspEditXML">Page Source</a>
					</div>
				</div>
			</div>

			<!--- layout preview --->
			<div style="text-align:left;font-size:11px;margin:5px;margin-left:10px;margin-top:10px;"><b>Layout Preview:</b></div>
			<div style="background-color:##ebebeb;height:320px;border:1px dashed ##000;margin-right:10px;margin-top:5px;margin-left:10px;">
				 <cfinclude template="includes/showPagePreview.cfm"> 
			</div>
			
			<p align="center" style="font-size:9px;">Double-click on module to view/edit properties.</p>

			<div class="cp_sectionBox" 
				 style="padding:0px;margin-left:10px;margin-right:10px;margin-top:10px;">
				<div style="margin:4px;text-align:left;">
					
					<!--- <div style="float:right;">
						<strong>Apply Template:</strong>
						<select name="pageTemplate" style="width:160px;font-size:10px;" onchange="applyPageTemplate(this.value)">
							<option value="" selected="yes">-- Select layout template --</option>
							<cfloop query="qryPageTemplates">
								<option value="#qryPageTemplates.id#">#qryPageTemplates.id#</option>
							</cfloop>
							<option value="_NEW">-- New Template --</option>
							<option value="_IMPORT">-- Import Templates --</option>
						</select>					
					</div> --->

					<strong>Page Layout:</strong>
					&nbsp;&nbsp;&nbsp;
					<cfloop from="1" to="#arrayLen(aLayoutSectionTypes)#" index="i">
						<cfscript>
							switch(aLayoutSectionTypes[i]) {
								case "header": imgSrc = "images/layout_header.png"; break;
								case "column": imgSrc = "images/layout_sidebar.png"; break;
								case "footer": imgSrc = "images/page.png"; break;
								default:
									imgSrc = "images/layout_header.png";
							}
						</cfscript>
						<img src="#imgSrc#" align="Absmiddle">
						<a href="?event=ehPage.doAddLayoutLocation&locationType=#aLayoutSectionTypes[i]#" style="font-weight:normal;">Add #ucase(left(aLayoutSectionTypes[i],1))##right(aLayoutSectionTypes[i],len(aLayoutSectionTypes[i])-1)#</a>	
						&nbsp;&nbsp;&nbsp;
					</cfloop>
				</div>
			</div>

		</td>
		<td align="right" width="190">
			<!--- module properties --->
			<div class="cp_sectionTitle" 
					style="width:190px;padding:0px;margin:0px;">
				<div style="margin:2px;text-align:left;">
					<img src="images/brick_edit.png" align="absmiddle">
					Module Properties
				</div>
			</div>
			<div class="cp_sectionBox" 
				style="margin-top:0px;width:190px;padding:0px;height:220px;margin-top:0px;margin-right:0px;border-top:0px;">
				<div id="moduleProperties" style="margin:0px;text-align:left;">
					<p align="center"><bR>
						Drag boxes to accomodate modules.<br>
						Click box to edit properties.
					</p>
				</div>
			</div>

			
			<!--- Layout Sections --->
			<div class="cp_sectionTitle" 
					style="width:190px;padding:0px;margin:0px;margin-top:5px;">
				<div style="margin:2px;text-align:left;">
					&nbsp;Page Layout
				</div>
			</div>
			<div class="cp_sectionBox" 
					style="margin-top:0px;width:190px;padding:0px;height:200px;margin-top:0px;margin-right:0px;border-top:0px;text-align:left;">
				<cfinclude template="includes/editPageLayout.cfm">
			</div>
		</td>
	</tr>
</table>
</cfoutput>	
<hr>

<script type="text/javascript">
	doEvent('ehPage.dspContentRenderersTree','resourceTreePanel',{});
</script>
