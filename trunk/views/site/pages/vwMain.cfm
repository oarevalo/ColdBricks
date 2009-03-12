<cfparam name="request.requestState.contentRoot" default="">
<cfset contentRoot = request.requestState.contentRoot>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<script type="text/javascript">
		function selectTreeNode(path) {
			doEvent("ehPages.dspNode","nodePanel",{path: path});
		}
		
		function deleteNode(path) {
			if(confirm("Delete node?")) {
				var loc = "index.cfm?event=ehPages.doDeleteNode&path=" + path;
				document.location = loc;
			}
		}
		
		function reloadNode(path) {
			doEvent("ehPages.dspNode","nodePanel",{path: path});
		}
		
		function loadTreeNode(id,path) {
			doEvent('ehPages.dspTreeNode',id,{path:path});
		}
		
		function loadNodeInfo(path,index) {
			doEvent("ehPages.dspNodeInfo","nodeInfoPanel",{path: path}, doEventComplete);
		
			d = $$(".pagesViewItem");
			for(var i=0;i < d.length;i++) {
				d[i].style.fontWeight="normal";
			}	
			
			// highlight selected account
			d = $("pagesViewItem_"+index);
			if(d) d.style.fontWeight="bold";
		}
		
		function openPage(path) {
			document.location = 'index.cfm?event=ehPage.dspMain&page='+escape(path);
		}
		
		function deletePage(path) {
			if(confirm('Delete page?')) {
				document.location = '?event=ehPages.doDeletePage&path='+escape(path);
			}
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
					style="width:190px;padding:0px;margin:0px;margin-top:10px;">
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
