<cfparam name="request.requestState.contentRoot" default="">
<cfset contentRoot = request.requestState.contentRoot>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<script type="text/javascript">
		function selectTreeNode(path) {
			doEvent("pages.ehPages.dspNode","nodePanel",{path: path});
		}
				
		function reloadNode(path) {
			doEvent("pages.ehPages.dspNode","nodePanel",{path: path});
		}
		
		function loadTreeNode(id,path) {
			doEvent('pages.ehPages.dspTreeNode',id,{path:path});
		}
		
		function loadNodeInfo(path,index) {
			doEvent("pages.ehPages.dspNodeInfo","nodeInfoPanel",{path: path}, doEventComplete);
		
			var d1 = $$(".pagesViewItem");
			for(var i=0;i < d1.length;i++) {
				d1[i].style.fontWeight="normal";
			}	
			
			// highlight selected account
			var d2 = $("pagesViewItem_"+index);
			if(d2) d2.style.fontWeight="bold";
		}
		
		function openPage(path) {
			document.location = 'index.cfm?event=page.ehPage.dspMain&page='+escape(path);
		}
		
		function deletePage(path,pathToDelete) {
			if(confirm('Delete page?')) {
				doEvent("pages.ehPages.doDeleteNodes","nodePanel",{path: path, pathsToDelete: 'page;'+pathToDelete});
			}
		}		

		function deleteFolder(path,pathToDelete) {
			if(confirm('Delete folder and all of its contents?')) {
				doEvent("pages.ehPages.doDeleteNodes","nodePanel",{path: path, pathsToDelete: 'folder;'+pathToDelete});
			}
		}		
		
		function addFolder(path) {
			var name = prompt("Enter the name of the new folder:");
			if(name!="" && name!=null) {
				doEvent("pages.ehPages.doCreateFolder","nodePanel",{path: path, name: name});
			}
		}
		
		function addPage(path) {
			var name = prompt("Enter the name of the new page:");
			if(name!="" && name!=null) {
				doEvent("pages.ehPages.doCreatePage","nodePanel",{path: path, name: name});
			}
		}

		function renamePage(parentPath, pagePath) {
			var name = prompt("Enter the name of the new page:");
			if(name!="" && name!=null) {
				doEvent("pages.ehPages.doRenamePage","nodePanel",{parentPath: parentPath, pagePath: pagePath, newName: name});
			}
		}

		function copyPage(parentPath, pagePath) {
			doEvent("pages.ehPages.doCopyPage","nodePanel",{parentPath: parentPath, pagePath: pagePath});
		}
		
		
	</script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td width="200">
			<div class="cp_sectionTitle" id="cp_pd_moduleProperties_Title" 
					style="width:200px;padding:0px;margin:0px;">
				<div style="margin:2px;">
					&nbsp; Site Pages
				</div>
			</div>
			<div class="cp_sectionBox" 
				style="margin:0px;width:200px;padding:0px;height:450px;border-top:0px;">
				<div id="pagesTree" style="margin:5px;">
				</div>
			</div>			
		</td>
		<td>
			<div style="margin-left:10px;margin-right:10px;">
				<div style="background-color:##fff;height:470px;border:1px dashed ##ccc;overflow:auto;" id="nodePanel">
					<div style="line-height:24px;margin:30px;font-size:14px;">
					
						<img src="images/quick_start.gif"><br><br>
						
						&bull; Select a folder to view or manipulate its contents.<br><br>

						&bull; Clicking on a folder node (<img src="images/folder.png" border="0" align="absmiddle">) will 
							display the folder contents.<br><br>

					</div>

				</div>
			</div>
		</td>
		<td width="200">
			<!--- Page Info --->
			<div class="cp_sectionTitle" 
					style="width:190px;padding:0px;margin:0px;">
				<div style="margin:2px;text-align:left;">
					<img src="images/page.png" align="absmiddle">
					Page Information
				</div>
			</div>
			<div class="cp_sectionBox" 
				style="margin-top:0px;width:190px;padding:0px;height:450px;margin-top:0px;margin-right:0px;border-top:0px;">
				<div id="nodeInfoPanel" style="margin:0px;text-align:left;">
					<p align="center"><bR>
						Select a page from the pages view to view information
					</p>
				</div>
			</div>
	
		</td>
	</tr>
</table>

<script>
loadTreeNode("pagesTree","")
</script>
</cfoutput>
