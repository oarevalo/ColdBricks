<cfoutput>
	<div id="dsb_siteResources" style="margin-top:35px;">
		<div class="dsb_secTitle">Resources Summary:</div>
		<div class="dsb_siteSection">
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
					<a href="index.cfm?event=resources.ehResources.dspMain&resourceType=#key#" 
						class="resTreeItem" 
						id="resTreeItem_#key#">#stResourceTypes[key].getFolderName()#</a> 
					(<cfif structKeyExists(stResCount,key)>#stResCount[key]#<cfelse>0</cfif>)
				</div>
			</cfloop>
			<cfif lstResTypes eq "">
				<em>No resources found!</em>
			</cfif>
		</div>
	</div>
</cfoutput>