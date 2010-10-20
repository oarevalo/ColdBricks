<cfparam name="request.requestState.resourceType" default="">
<cfparam name="request.requestState.pkg" default="">
<cfparam name="request.requestState.id" default="">
<cfparam name="request.requestState.resLibIndex" default="">
<cfparam name="request.requestState.qryResources" default="">
<cfparam name="request.requestState.stResourceTypes" default="">

<cfset resType = request.requestState.resourceType>
<cfset pkg = request.requestState.pkg>
<cfset id = request.requestState.id>
<cfset resLibIndex = request.requestState.resLibIndex>
<cfset qryResources = request.requestState.qryResources>
<cfset stResourceTypes = request.requestState.stResourceTypes>

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
	<script type="text/javascript" src="modules/resources/includes/resourceEditor.js"></script>
	<script type="text/javascript" src="modules/resource/includes/resourceEditor.js"></script>
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
	<link type="text/css" rel="stylesheet" href="includes/floatbox/floatbox.css" />
	<script type="text/javascript" src="includes/floatbox/floatbox.js"></script>
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
				style="margin:0px;width:150px;padding:0px;height:448px;border-top:0px;">
				<div style="margin:5px;">
				
					<cfset lstResTypes = structKeyList(stResourceTypes)>
					<cfset lstResTypes = listSort(lstResTypes,"textnocase","asc")>
					<cfloop list="#lstResTypes#" index="key">
						<cfscript>
							switch(key) {
								case "module": imgSrc = "images/brick.png"; break;
								case "content": imgSrc = "images/folder_page.png"; break;
								case "feed": imgSrc = "images/feed-icon16x16.gif"; break;
								case "skin": imgSrc = "images/css.png"; break;
								case "page": imgSrc = "images/page.png"; break;
								case "pageTemplate": imgSrc = "images/page_code.png"; break;
								case "html": imgSrc = "images/html.png"; break;
								default:
									imgSrc = "images/folder.png";
							}
						</cfscript>
						<div style="margin-bottom:5px;">
							<img src="#imgSrc#" align="absmiddle"> 
							<a href="##" 
								onclick="selectResourceType('#key#','','','#reslibindex#')"
								class="resTreeItem" 
								id="resTreeItem_#key#">#key#</a> 
							(<cfif structKeyExists(stResCount,key)>#stResCount[key]#<cfelse>0</cfif>)
						</div>
					</cfloop>
					<cfif lstResTypes eq "">
						<em>No resources found!</em>
					</cfif>
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
			--->			
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
			selectResource('#resType#','#id#','#pkg#','#resLibIndex#')
		<cfelse>
			selectResourceType('#resType#','','')
		</cfif>
	</script>	
</cfif>

</cfoutput>
