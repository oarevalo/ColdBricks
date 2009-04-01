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
		tmpPageURL = "/index.cfm?page=#fileName#";
	else
		tmpPageURL = appRoot & "/index.cfm?page=#fileName#";
		
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
				<option value="_IMPORT">-- Import Skins --</option>
			</select>
			<cfif skinID neq "">
				<a href="index.cfm?event=ehResources.dspMain&resType=skin&id=#skinID#">Edit</a>
			<cfelse>
				<a href="index.cfm?event=ehResources.dspMain&resType=skin&id=NEW">New</a>
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
			
			<table id="tblLayoutPreview" border="1" align="center" style="margin:0px;margin-top:30px;">
				
				<!--- display headers --->
				<cfif structKeyExists(stLocationsByType,"header")>
					<cfset aSections = stLocationsByType["header"]>
					
					<cfloop from="1" to="#arrayLen(aSections)#" index="i">
						<cfset name = aSections[i].name>
						<cfset aModules = stModulesByRegion[ name ]>
						<tr valign="top">
							<td colspan="#numColumns#" style="height:17px;">
								<div class="layoutSectionLabel" style="display:none;" id="#name#_title">
									<table style="width:100%;" border="0">
										<td style="border:0px !important;" align="left">
											<a href="javascript:document.location='?event=ehPage.dspMain&editLayoutSection=#name#'">#name#</a>
										</td>
										<td align="right" style="border:0px !important;">
											<a href="javascript:document.location='?event=ehPage.doDeleteLayoutLocation&locationName=#name#'"><img src="images/cross.png" align="absmiddle" border="0"></a>
										</td>
									</table>
								</div>
								<ul id="pps_#name#" class="layoutPreviewList">
								<cfloop from="1" to="#ArrayLen(aModules)#" index="j">
									<cfset tmpModuleID = aModules[j].id>
									<li id="ppm_#tmpModuleID#" class="layoutListItem"><div>#tmpModuleID#</div></li>
								</cfloop>
								</ul>
							</td>	
						</tr>
					</cfloop>
				</cfif>
				
				<!--- display columns --->
				<cfif structKeyExists(stLocationsByType,"column")>
					<cfset aSections = stLocationsByType["column"]>

					<tr valign="top">
						<cfloop from="1" to="#arrayLen(aSections)#" index="i">
							<cfset name = aSections[i].name>
							<cfset aModules = stModulesByRegion[ name ]>
							<td style="width:#colWidth#px;">
								<div class="layoutSectionLabel" style="display:none;" id="#name#_title">
									<table style="width:100%;" border="0">
										<td style="border:0px !important;" align="left">
											<a href="javascript:document.location='?event=ehPage.dspMain&editLayoutSection=#name#'">#name#</a>
										</td>
										<td align="right" style="border:0px !important;">
											<a href="javascript:document.location='?event=ehPage.doDeleteLayoutLocation&locationName=#name#'"><img src="images/cross.png" align="absmiddle" border="0"></a>
										</td>
									</table>
								</div>
								<ul id="pps_#name#" class="layoutPreviewList">
								<cfloop from="1" to="#ArrayLen(aModules)#" index="j">
									<cfset tmpModuleID = aModules[j].id>
									<li id="ppm_#tmpModuleID#" class="layoutListItem"><div>#tmpModuleID#</div></li>
								</cfloop>
								</ul>
							</td>
						</cfloop>
					</tr>
				</cfif>
				
				<!--- display footers --->
				<cfif structKeyExists(stLocationsByType,"footer")>
					<cfset aSections = stLocationsByType["footer"]>
	
					<cfloop from="1" to="#arrayLen(aSections)#" index="i">
						<cfset name = aSections[i].name>
						<cfset aModules = stModulesByRegion[ name ]>
						<tr valign="top">
							<td colspan="#numColumns#" style="height:17px;">
								<div class="layoutSectionLabel" style="display:none;" id="#name#_title">
									<table style="width:100%;" border="0">
										<td style="border:0px !important;" align="left">
											<a href="javascript:document.location='?event=ehPage.dspMain&editLayoutSection=#name#'">#name#</a>
										</td>
										<td align="right" style="border:0px !important;">
											<a href="javascript:document.location='?event=ehPage.doDeleteLayoutLocation&locationName=#name#'"><img src="images/cross.png" align="absmiddle" border="0"></a>
										</td>
									</table>
								</div>
								<ul id="pps_#name#" class="layoutPreviewList">	
								<cfloop from="1" to="#ArrayLen(aModules)#" index="j">
									<cfset tmpModuleID = aModules[j].id>
									<li id="ppm_#tmpModuleID#" class="layoutListItem"><div>#tmpModuleID#</div></li>
								</cfloop>
								</ul>
							</td>	
						</tr>
					</cfloop>
				</cfif>
			</table>
			<div id="moduleOrderButtons" style="display:none;margin-top:5px;">
				<input type="button" name="btnUpdateModuleOrder"
						onclick="updateModuleOrder()"
						value="Apply Changes">
				<input type="button" name="btnUndoModuleOrder"
						onclick="document.location='index.cfm?event=ehPage.dspMain'"
						value="Undo">
			</div>
			</div>
			
			<p align="center" style="font-size:9px;">Double-click on module to view/edit properties.</p>

			<div class="cp_sectionBox" 
				 style="padding:0px;margin-left:10px;margin-right:10px;margin-top:10px;">
				<div style="margin:4px;text-align:left;">
					
					<div style="float:right;">
						<strong>Apply Template:</strong>
						<select name="pageTemplate" style="width:160px;font-size:10px;" onchange="applyPageTemplate(this.value)">
							<option value="" selected="yes">-- Select layout template --</option>
							<cfloop query="qryPageTemplates">
								<option value="#qryPageTemplates.id#">#qryPageTemplates.id#</option>
							</cfloop>
							<option value="_NEW">-- New Template --</option>
							<option value="_IMPORT">-- Import Templates --</option>
						</select>					
					</div>
					
					<strong>Page Layout:</strong>
					&nbsp;&nbsp;&nbsp;
					<img src="images/layout_header.png" align="Absmiddle">
					<a href="?event=ehPage.doAddLayoutLocation&locationType=header" style="font-weight:normal;">Add Header</a>	
					&nbsp;&nbsp;&nbsp;
					<img src="images/layout_sidebar.png" align="Absmiddle">
					<a href="?event=ehPage.doAddLayoutLocation&locationType=column" style="font-weight:normal;">Add Column</a>			
					&nbsp;&nbsp;&nbsp;
					<img src="images/page.png" align="Absmiddle">
					<a href="?event=ehPage.doAddLayoutLocation&locationType=footer" style="font-weight:normal;">Add Footer</a>			
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
				
				<div style="border-bottom:1px solid black;background-color:##ccc;text-align:left;line-height:22px;font-size:11px;">
					<input type="checkbox" name="chkShowLayoutSectionTitles" 
							onclick="showLayoutSectionTitles(this.checked)" value="1">
					Show Section Titles
				</div>

				<div id="layoutSections" style="margin:5px;margin-top:10px;text-align:left;">
					<cfparam name="editLayoutSection" default="">

					<div style="margin:2px;">
						<strong>Section:</strong> &nbsp;&nbsp;
						<select name="layoutSection" 
								style="width:100px;"
								onchange="document.location='?event=ehPage.dspMain&editLayoutSection='+this.value">
							<option value=""></option>
							<cfloop from="1" to="#arrayLen(aLayoutRegions)#" index="i">
								<option value="#aLayoutRegions[i].name#"
										<cfif aLayoutRegions[i].name eq editLayoutSection>selected</cfif>
										>#aLayoutRegions[i].name#</option>
							</cfloop>
						</select>
					</div>
					
					<cfif editLayoutSection neq "">
						<cfloop from="1" to="#arrayLen(aLayoutRegions)#" index="i">
							<cfif aLayoutRegions[i].name eq editLayoutSection>
								<cfset thisLocation = aLayoutRegions[i]>
							</cfif>
						</cfloop>

						<div style="margin-top:5px;border-top:1px solid silver;">
							<div style="margin:2px;">
								<form name="frmEditLayoutSection" method="post" action="index.cfm">
									<table>
										<tr>
											<td style="font-size:10px;color:##999;text-align:right;width:50px;">Name:</td>
											<td><input type="text" name="locationNewName" value="#thisLocation.name#" style="width:90px;padding:2px;"></td>
										</tr>
										<tr>
											<td style="font-size:10px;color:##999;text-align:right;width:50px;">Type:</td>
											<td>
												<select name="locationType" style="width:90px;padding:2px;">
													<cfloop from="1" to="#arrayLen(aLayoutSectionTypes)#" index="i">
														<option value="#aLayoutSectionTypes[i]#"
																<cfif aLayoutSectionTypes[i] eq thisLocation.type>selected</cfif>
																>#aLayoutSectionTypes[i]#</option>
													</cfloop>
												</select>
										</tr>
										<tr>
											<td style="font-size:10px;color:##999;text-align:right;width:50px;">CSS Class:</td>
											<td><input type="text" name="locationClass" value="#thisLocation.class#" style="width:90px;padding:2px;"></td>
										</tr>
									</table>
									<p align="center">
										<input type="hidden" name="event" value="ehPage.doSaveLayoutLocation">
										<input type="hidden" name="locationOriginalName" value="#thisLocation.name#">
										<input type="submit" name="btnSave" value="Save">
										<input type="button" name="btnDelete" value="Delete" onclick="document.location='?event=ehPage.doDeleteLayoutLocation&locationName=#thisLocation.name#'">
										<input type="button" name="btnCancel" value="Cancel" onclick="document.location='?event=ehPage.dspMain'">
									</p>
								</form>
							</div>
						</div>
					<cfelse>
						<p>Select from the drop-down box a layout section to customize its properties</p>
						<!---
						<p align="center"><br>
							&bull; <a href="##">Save current layout as template</a>
						</p>
						---->
					</cfif>

					<table>
					</table>
				</div>
			</div>
		</td>
	</tr>
</table>
</cfoutput>	
<hr>

<script type="text/javascript">
	doEvent('ehPage.dspContentRenderersTree','resourceTreePanel',{});
</script>

