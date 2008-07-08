<cfparam name="request.requestState.resType" default="">
<cfparam name="request.requestState.pkg" default="">
<cfparam name="request.requestState.id" default="">
<cfparam name="request.requestState.qryResources" default="">

<cfset resType = request.requestState.resType>
<cfset pkg = request.requestState.pkg>
<cfset id = request.requestState.id>
<cfset qryResources = request.requestState.qryResources>

<!--- get resource count by type --->
<cfquery name="qryResCount" dbtype="query">
	SELECT type, count(*) as resCount
		FROM qryResources
		GROUP BY type
		ORDER BY type
</cfquery>

<!--- index results into a struct --->
<cfset stResCount = structNew()>
<cfloop query="qryResCount">
	<cfset stResCount[qryResCount.type] = qryResCount.resCount>
</cfloop>


<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<script language="javascript" type="text/javascript" src="/ColdBricks/includes/tiny_mce/tiny_mce.js"></script>
	<script type="text/javascript" src="includes/js/resourceEditor.js"></script>
	<style type="text/css">
		.buttonImage {
			white-space:nowrap;
			height:1%;
			height:25px;
			padding-top:10px;
			text-align:center;
		}
		.buttonImage a {
			text-decoration:none !important;
			font-weight:bold;
			color:#333;
		}
		.buttonImage a:hover {
			color:green !important;
		}	
		#btnImport {
			background:transparent url(images/btn_120x24.gif) no-repeat scroll 0%;
			width:120px;
			margin:0 auto;
		}
	</style>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">
<cfoutput>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td width="150">
			<div class="cp_sectionTitle" id="cp_pd_moduleProperties_Title" 
					style="width:150px;padding:0px;margin:0px;">
				<div style="margin:2px;">
					&nbsp; Resource Types
				</div>
			</div>
			<div class="cp_sectionBox" 
				style="margin:0px;width:150px;padding:0px;height:320px;border-top:0px;">
				<div style="margin:5px;">
					<div style="margin-bottom:5px;">
						<img src="images/brick.png" align="absmiddle"> <a href="##" onclick="selectResourceType('module')" class="resTreeItem" id="resTreeItem_module">Modules</a> (<cfif structKeyExists(stResCount,"module")>#stResCount.module#<cfelse>0</cfif>)
					</div>
					<div style="margin-bottom:5px;">
						<img src="images/folder_page.png" align="absmiddle"> <a href="##" onclick="selectResourceType('content')" class="resTreeItem" id="resTreeItem_content">Content</a> (<cfif structKeyExists(stResCount,"content")>#stResCount.content#<cfelse>0</cfif>)
					</div>
					<div style="margin-bottom:5px;">
						<img src="images/feed-icon16x16.gif" align="absmiddle"> <a href="##" onclick="selectResourceType('feed')" class="resTreeItem" id="resTreeItem_feed">Feeds</a> (<cfif structKeyExists(stResCount,"feed")>#stResCount.feed#<cfelse>0</cfif>)
					</div>
					<div style="margin-bottom:5px;">
						<img src="images/css.png" align="absmiddle"> <a href="##" onclick="selectResourceType('skin')" class="resTreeItem" id="resTreeItem_skin">Skins</a> (<cfif structKeyExists(stResCount,"skin")>#stResCount.skin#<cfelse>0</cfif>)
					</div>
					<div style="margin-bottom:5px;">
						<img src="images/page.png" align="absmiddle"> <a href="##" onclick="selectResourceType('page')" class="resTreeItem" id="resTreeItem_page">Pages</a> (<cfif structKeyExists(stResCount,"page")>#stResCount.page#<cfelse>0</cfif>)
					</div>
					<div style="margin-bottom:5px;">
						<img src="images/page_code.png" align="absmiddle"> <a href="##" onclick="selectResourceType('pageTemplate')" class="resTreeItem" id="resTreeItem_pageTemplate"> Page Templates</a> (<cfif structKeyExists(stResCount,"pageTemplate")>#stResCount.pageTemplate#<cfelse>0</cfif>)
					</div>
					<div style="margin-bottom:5px;">
						<img src="images/html.png" align="absmiddle"> <a href="##" onclick="selectResourceType('html')" class="resTreeItem" id="resTreeItem_html">HTML</a> (<cfif structKeyExists(stResCount,"html")>#stResCount.html#<cfelse>0</cfif>)
					</div>
				</div>
			</div>			
			<!---
			<div class="cp_sectionTitle" id="cp_pd_moduleProperties_Title" 
					style="width:150px;padding:0px;margin:0px;margin-top:10px;">
				<div style="margin:2px;">
					&nbsp; Rebuild Library
				</div>
			</div>
			<div class="cp_sectionBox" 
				style="margin:0px;width:150px;padding:0px;height:125px;border-top:0px;">
				<div style="margin:10px;">
					Rebuilding the resource library will auto-discover any 
					new resources and update changes to existing ones.	
					<div style="text-align:center;margin-top:5px;">
						<input type="button" name="btnRebuild" 
								value="Rebuild Library" 
								onClick="document.location='?event=ehResources.dspMain&rebuildCatalog=true'">					
					</div>
				</div>
			</div>		
			--->			
			<div class="cp_sectionTitle" id="cp_pd_moduleProperties_Title" 
					style="width:150px;padding:0px;margin:0px;margin-top:10px;">
				<div style="margin:2px;">
					&nbsp; Import Resources
				</div>
			</div>
			<div class="cp_sectionBox" 
				style="margin:0px;width:150px;padding:0px;height:95px;border-top:0px;">
				<div style="margin:5px;">
					Import packages from other sites.
					<div class="buttonImage" id="btnImport" style="margin-top:10px;">
						<a href="##" onClick="document.location='?event=ehResources.dspImport'">Import Packages</a>
					</div>	
				</div>
			</div>			
		</td>
		<td>
			<div style="margin-left:5px;margin-right:5px;">
				<div style="background-color:##fff;" id="nodePanel">

					<div style="line-height:24px;margin:30px;font-size:14px;">
					
						<img src="images/quick_start.gif"><br><br>
						
						&bull; The list on the left shows the different types of resources available. 
							Resources are reusable elements that can be used on pages.<br><br>
						
						&bull; Select a resource type from the list on the left to browse available resources or create new ones<br><br>
						
						&bull; You can import resources from other sites on the same server by clicking on the <b>Import Packages</b> button<br><br>
						
						&bull; <b>Did you know?</b> You can create your own resources to extend the customization options of your pages.
							Just click on the resource type you wish to create, and then click on the <em>Create Resource</em> link
							that appears.
							
					</div>

				</div>
			</div>
		</td>
		<td width="180">
			<div class="cp_sectionBox helpBox"  style="margin:0px;height:470px;line-height:18px;">
				<div style="margin:10px;">
					<h2>Site Resources</h2>
					<p>
						This screen displays all resources that are currently registered and available 
						to use on this site. All resources are grouped by packages. To view information about a 
						particular resource, click on the resource ID.
					</p>
					<p>Use the tree view on the left to select the type of resource to manage.</p>
					
					<div id="resInfo" style="margin-top:20px;">
					</div>
				</div>
			</div>		
		</td>
	</tr>
</table>

<cfif resType neq "">
	<script>
		<cfif id neq "">
			selectResource('#resType#','#id#','#pkg#')
		<cfelse>
			selectResourceType('#resType#','','')
		</cfif>
	</script>	
</cfif>

</cfoutput>
