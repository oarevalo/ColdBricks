<!--- this displays a selector control to change pages within a site --->
<cfparam name="request.requestState.oContext" default="">
<cfset oContext = request.requestState.oContext>

<cfif not oContext.hasAccountSite()>
	<cfexit method="exittemplate">
</cfif>

<cfscript>
	aPages = oContext.getAccountSite().getPages();
	
	// sort account pages
	aPagesSorted = arrayNew(1);
	for(i=1;i lte arrayLen(aPages);i=i+1) {
		arrayAppend(aPagesSorted, aPages[i].href);
	}
	arraySort(aPagesSorted,"textnocase","asc");
</cfscript>

<cfoutput>
	<strong>Page:</strong>
	<select name="page" style="width:180px;font-size:11px;" class="formField"  onchange="changePage(this.value)">
		<cfloop from="1" to="#arrayLen(aPagesSorted)#" index="i">
			<option value="#aPagesSorted[i]#"
					<cfif aPagesSorted[i] eq getFileFromPath(oContext.getPageHREF())>selected</cfif>>#aPagesSorted[i]#</option>
		</cfloop>
		<option value="--NEW--"> -- New Page -- </option>
	</select>
</cfoutput>
