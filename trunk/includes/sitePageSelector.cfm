<!--- this displays a selector control to change pages within a site --->
<cfparam name="request.requestState.oContext" default="">
<cfset oContext = request.requestState.oContext>

<cfif oContext.hasAccountSite()>

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
		<select name="page" id="page" style="width:150px;font-size:11px;" class="formField"  onchange="changePage(this.value)">
			<cfloop from="1" to="#arrayLen(aPagesSorted)#" index="i">
				<option value="#aPagesSorted[i]#"
						<cfif aPagesSorted[i] eq getFileFromPath(oContext.getPageHREF())>selected</cfif>>#aPagesSorted[i]#</option>
			</cfloop>
		</select>
	</cfoutput>

<cfelse>
	<cfoutput>
		<cfset _href = oContext.getPageHREF()>
		<cfset _path = "">
		<cfif listLen(_href,"/") gt 1>
			<cfset _path = listDeleteat(_href,listLen(_href,"/"),"/")>
		</cfif>
		<cfset _qryPages = oContext.getHomePortals().getPageProvider().listFolder(_path)> 

		<strong>Page:</strong>
		<select name="page" id="page" style="width:150px;font-size:11px;" class="formField"  onchange="changePage(this.value)">
			<cfloop query="_qryPages">
				<cfif _qryPages.type eq "page">
					<option value="#_path#/#_qryPages.name#"
							<cfif _qryPages.name eq getFileFromPath(_href)>selected</cfif>>#_qryPages.name#</option>
				</cfif>
			</cfloop>
		</select>
	</cfoutput>
</cfif>

