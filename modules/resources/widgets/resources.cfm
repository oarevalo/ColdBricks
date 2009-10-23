<cfset oContext = getService("sessionContext").getContext()>
<cfset hp = oContext.getHomePortals()>
<cfset stAccessMap = getValue("oUser").getAccessMap()>
<cfset hasResourcesModule = getService("UIManager").hasModule("resources","site")>

<cfif not(hasResourcesModule and stAccessMap.resources)>
	<cfexit method="exittemplate">
</cfif>

<cfscript>
	oCatalog = hp.getCatalog();
	
	// get resource types
	stResourceTypes = hp.getResourceLibraryManager().getResourceTypesInfo();

	// get resources
	qryResources = oCatalog.getResources();
</cfscript>

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

<cfset lstResTypes = structKeyList(stResourceTypes)>
<cfset lstResTypes = listSort(lstResTypes,"textnocase","asc")>

<cfoutput>
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
</cfoutput>