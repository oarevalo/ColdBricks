<cfparam name="request.requestState.pageTitle" default="">
<cfparam name="request.requestState.resType" default="module">
<cfparam name="request.requestState.appRoot" default="">
<cfparam name="request.requestState.aLayoutSectionTypes" default="">
<cfparam name="request.requestState.pageHREF" default="">

<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.oCatalog" default="">

<cfparam name="request.requestState.accountName" default="">
<cfparam name="request.requestState.stPageTemplates" default="">

<cfparam name="request.requestState.pageMode" default="">
<cfparam name="request.requestState.treeType" default="resources">

<cfscript>
	pageTitle = request.requestState.pageTitle;
	thisPageHREF = request.requestState.pageHREF;
	resType = request.requestState.resType;
	appRoot = request.requestState.appRoot;
	aLayoutSectionTypes = request.requestState.aLayoutSectionTypes;
	stPageTemplates = request.requestState.stPageTemplates;
	pageMode = request.requestState.pageMode;
	treeType = request.requestState.treeType;
	
	oPage = request.requestState.oPage;
	oCatalog = request.requestState.oCatalog;	
	oContext = request.requestState.oContext;

	accountName = request.requestState.accountName;
	
	title = oPage.getTitle();
	if(oPage.hasProperty("SkinID"))
		skinID = oPage.getProperty("SkinID");
	else
		skinID = "";
	pageTemplateName = oPage.getPageTemplate();
	
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
		if(not structKeyExists(stModulesByRegion, aModules[i].getLocation()))
			stModulesByRegion[ aModules[i].getLocation() ] = arrayNew(1);
		arrayAppend(stModulesByRegion[ aModules[i].getLocation() ] , aModules[i]);
	}
	
	numColumns = arrayLen(aLayoutRegions);
	colWidth = 200;
	if(numColumns gt 0)	colWidth = 200 / numColumns;
	
	fileName = getFilefromPath(thisPageHREF);
	fileName = listDeleteAt(fileName, listlen(fileName,"."), ".");
	
	if(oContext.getHomePortals().getResourceLibraryManager().hasResourceType("skin")) {
		hasSkins = true;
		qrySkins = oCatalog.getIndex("skin");
	} else {
		hasSkins = false;
		qrySkins = queryNew("");
	}
	aStyles = oPage.getStylesheets();
	
	hasModules = (oContext.getHomePortals().getResourceLibraryManager().hasResourceType("module"));
	
	if(appRoot eq "/")
		tmpPageURL = "/index.cfm";
	else
		tmpPageURL = appRoot & "/index.cfm";
		
	if(accountName eq "") {
		tmpPageURL = tmpPageURL & "?page=#thisPageHREF#";
	} else {
		tmpPageAlias = oContext.getHomePortals().getPluginManager().getPlugin("accounts").getPageAlias(accountName,fileName);
		tmpPageURL = tmpPageURL & "?page=" & tmpPageAlias;
	}

	tmpPageURL = reReplace(tmpPageURL,"//*","/","all");	
</cfscript>


<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="modules/resource/includes/resourceEditor.js"></script>
	<script type="text/javascript" src="modules/page/includes/pageEditor.js"></script>
	<script type="text/javascript" src="includes/js/prototype-1.4.0.js"></script>
	<script type="text/javascript" src="modules/page/includes/coordinates.js"></script>
	<script type="text/javascript" src="modules/page/includes/drag.js"></script>
	<script type="text/javascript" src="modules/page/includes/dragdrop.js"></script>
	<link type="text/css" rel="stylesheet" href="includes/floatbox/floatbox.css" />
	<script type="text/javascript" src="includes/floatbox/floatbox.js"></script>
	<script>
		window.onload = initLayoutPreview;
	</script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">


<cfoutput>
<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="8" cellspacing="0" border="0">
	<tr>
		<td nowrap="yes" style="width:320px;">
			<form name="frm" method="post" action="index.cfm" style="padding:0px;margin:0px;">
				<strong>Title:</strong> 
				<input type="hidden" name="event" value="page.ehPage.doSetTitle">
				<input type="text" name="pageTitle" value="#title#" size="50" class="formField" style="width:200px;font-size:12px;" onkeydown="$('btnChangeTitle').disabled=false;">
				<input type="submit" value="Apply" style="width:auto;" disabled id="btnChangeTitle">
			</form>
		</td>

		<td align="left" nowrap="yes" style="width:180px;">
			<cfif hasSkins>
				<strong>Skin:</strong>
				<select name="skin" style="width:110px;font-size:11px;" class="formField"  onchange="changeSkin(this.value)">
					<option value="0">-- Select Skin --</option>
					<option value="NONE">-- None --</option>
					<cfloop query="qrySkins">
						<option value="#qrySkins.id#" <cfif qrySkins.id eq skinID>selected</cfif>>#qrySkins.id#</option>
					</cfloop>
					<option value="_NEW">-- New Skin --</option>
				</select>
				<cfif skinID neq "">
					<a href="##" onclick="resourceEditor.open('#jsStringFormat(skinID)#','skin','',0);">Edit</a>
				<cfelse>
					<a href="##" onclick="resourceEditor.open('NEW','skin','',0);">New</a>
				</cfif>
			</cfif>
		</td>

		<td align="left" nowrap="yes" style="width:210px;">
			<strong>Template:</strong>
			<select name="pageTemplate" style="width:130px;font-size:11px;" class="formField"  onchange="changePageTemplate(this.value)">
				<option value="0">-- Select Template --</option>
				<option value="" <cfif pageTemplateName eq "">selected</cfif>>(default)</option>
				<cfloop collection="#stPageTemplates#" item="key">
					<option value="#stPageTemplates[key].name#" 
							<cfif stPageTemplates[key].name eq pageTemplateName>selected</cfif>>#stPageTemplates[key].name#</option>
				</cfloop>
			</select>
		</td>

		<td align="left" nowrap="yes">
			<cfmodule template="../../../includes/sitePageSelector.cfm">
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
			<div style="text-align:left;background-color:##999;">
				<div style="margin:2px;">
					<input type="radio" name="treeType" value="resources" 
							<cfif treeType eq "resources">checked</cfif>
							onclick="doEvent('page.ehPage.dspResourceTree','resourceTreePanel',{});"> Resources
					<input type="radio" name="treeType" value="tags" 
							<cfif treeType eq "tags">checked</cfif>
							onclick="doEvent('page.ehPage.dspContentRenderersTree','resourceTreePanel',{});"> Module Types
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
					<cfif hasModules>
						<div class="buttonImage btnLarge" style="margin:0px;float:left;margin-right:5px;">
							<img src="images/cog.png" align="Absmiddle">
							<a href="?event=page.ehPage.dspEventHandlers">Event Handlers</a>
						</div>
					</cfif>
					<div class="buttonImage btnLarge" style="margin:0px;float:left;margin-right:5px;">
						<img src="images/page_code.png" align="Absmiddle">
						<a href="?event=page.ehPage.dspMeta">Meta Tags</a>	
					</div>
					<div class="buttonImage btnLarge" style="margin:0px;float:left;margin-right:5px;">
						<img src="images/folder_brick.png" align="Absmiddle">
						<a href="?event=page.ehPage.dspPageProperties">Page Properties</a>
					</div>
					<div class="buttonImage btnLarge" style="margin:0px;float:left;margin-right:5px;">
						<img src="images/page_lightning.png" align="Absmiddle">
						<a href="?event=page.ehPage.dspPageResources">Styles & Scripts</a>
					</div>
				</div>
			</div>

			<!--- layout preview --->
			<div style="text-align:left;font-size:11px;margin:5px;margin-left:10px;margin-top:10px;height:20px;">
				
				<div id="moduleOrderButtons" style="float:right;display:none;margin-right:10px;">
					<input type="button" name="btnUpdateModuleOrder"
							style="font-size:10px;"
							onclick="updateModuleOrder()"
							value="Apply Changes">
					<input type="button" name="btnUndoModuleOrder"
							style="font-size:10px;"
							onclick="document.location='index.cfm?event=page.ehPage.dspMain'"
							value="Undo">
				</div>
				
				<b>View Mode:</b>
				&nbsp;&nbsp;
				<cfif pageMode eq "details"><b>&raquo;</b></cfif>
				<a href="index.cfm?event=page.ehPage.dspMain&pageMode=details" <cfif pageMode eq "details">style="font-weight:bold;"</cfif>>Modules List</a>
				&nbsp;&nbsp;
				<cfif pageMode eq "contents"><b>&raquo;</b></cfif>
				<a href="index.cfm?event=page.ehPage.dspMain&pageMode=contents" <cfif pageMode eq "contents">style="font-weight:bold;"</cfif>>Modules By Section</a>
				&nbsp;&nbsp;
				<cfif pageMode eq "preview"><b>&raquo;</b></cfif>
				<a href="index.cfm?event=page.ehPage.dspMain&pageMode=preview" <cfif pageMode eq "preview">style="font-weight:bold;"</cfif>>Layout Preview</a>
			</div>
			<div style="background-color:##ebebeb;border:1px dashed ##000;margin-right:10px;margin-top:5px;margin-left:10px;">
				<cfswitch expression="#pageMode#">
					<cfcase value="preview">
						<cfinclude template="includes/showPagePreview.cfm"> 
					</cfcase>
					<cfcase value="contents">
						<cfinclude template="includes/showPageContents.cfm"> 
					</cfcase>
					<cfcase value="details">
						<cfinclude template="includes/showPageDetails.cfm"> 
					</cfcase>
				</cfswitch>
			</div>
			
			<cfif pageMode neq "details">
				<p align="center" style="font-size:9px;">Double-click on module to view/edit properties.</p>
			</cfif>

			<div class="cp_sectionBox" 
				 style="padding:0px;margin-left:10px;margin-right:10px;margin-top:10px;">
				<div style="margin:4px;text-align:left;">
					
					<div style="float:right;">
						<img src="images/css.png" align="Absmiddle">
						<a href="?event=page.ehPage.dspEditCSS"><b>View CSS</b></a>
						&nbsp;&nbsp;
						<img src="images/xml.gif" align="Absmiddle">
						<a href="?event=page.ehPage.dspEditXML"><b>View Source</b></a>
					</div>

					<cfif pageMode eq "preview">
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
							<span style="white-space:nowrap;">
								<img src="#imgSrc#" align="Absmiddle">
								<a href="?event=page.ehPage.doAddLayoutLocation&locationType=#aLayoutSectionTypes[i]#&pageMode=preview" style="font-weight:normal;">Add #ucase(left(aLayoutSectionTypes[i],1))##lcase(right(aLayoutSectionTypes[i],len(aLayoutSectionTypes[i])-1))#</a>	
							</span>
							&nbsp;&nbsp;&nbsp;
						</cfloop>
					<cfelseif pageMode eq "details">
						<strong>TIP:</strong>
						To view or modify page layout sections, switch to 
						<a href="index.cfm?event=page.ehPage.dspMain&pageMode=preview"><u>Preview Mode</u></a>
					</cfif>
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
						<cfif pageMode neq "details">
							Drag boxes to accomodate modules.<br>
							Click box to edit properties.
						<cfelse>
							Click on Module ID to edit module properties.<br />
							Click on Info icon to view module details.
						</cfif>
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
	<cfif treeType eq "resources">
		doEvent('page.ehPage.dspResourceTree','resourceTreePanel',{});
	<cfelse>
		doEvent('page.ehPage.dspContentRenderersTree','renderersTreePanel',{});
	</cfif>
</script>

