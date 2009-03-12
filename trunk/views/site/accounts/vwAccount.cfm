<cfparam name="request.requestState.aPages" default="">
<cfparam name="request.requestState.siteTitle" default="">
<cfparam name="request.requestState.accountName" default="">
<cfparam name="request.requestState.startRow" default="1">
<cfparam name="request.requestState.accountsRoot" default="">
<cfparam name="request.requestState.appRoot" default="">
<cfparam name="request.requestState.viewType" default="">
<cfparam name="request.requestState.searchTerm" default="">

<cfset aPages = request.requestState.aPages>
<cfset siteTitle = request.requestState.siteTitle>
<cfset accountName = request.requestState.accountName>
<cfset startRow = request.requestState.startRow>
<cfset accountsRoot = request.requestState.accountsRoot>
<cfset appRoot = request.requestState.appRoot>
<cfset viewType = request.requestState.viewType>
<cfset searchTerm = request.requestState.searchTerm>

<cfscript>
	// put pages into a query
	qryPages = queryNew("href,isDefault,title");
	for(i=1;i lte arrayLen(aPages);i=i+1) {
		QueryAddRow(qryPages);
		QuerySetCell(qryPages, "href", aPages[i].href);
		QuerySetCell(qryPages, "title", aPages[i].title);
		tmpVal = isBoolean(aPages[i]["default"]) and aPages[i]["default"];
		QuerySetCell(qryPages, "isDefault", tmpVal);
	}
</cfscript>	

<!--- sort pages query  --->
<cfquery name="qryPages" dbtype="query">
	SELECT *
		FROM qryPages
		<cfif searchTerm neq "">
			WHERE upper(href) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(searchTerm)#%">
				OR upper(title) LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(searchTerm)#%">
		</cfif>
		ORDER BY title
</cfquery>

<cfscript>
	// page for when viewing in details mode
	rowsPerPage = 15;
	if(startRow lt 0) startRow = 1;
	endRow = startRow + rowsPerPage - 1;
	numPages = ceiling(qryPages.recordCount / rowsPerPage);
	pageNum = int(startRow/rowsPerPage)+1;
	prevPageStartRow = (pageNum-2)*rowsPerPage + 1;
	nextPageStartRow = (pageNum)*rowsPerPage + 1;
	lastPageStartRow = (numPages-1)*rowsPerPage;
</cfscript>



<cfoutput>
	<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="5" cellspacing="0">
		<tr>
			<td nowrap="yes">
				<form name="frmTitle" method="post" action="index.cfm" style="padding:0px;margin:0px;">
					<strong>Site Title:</strong> 
					<input type="hidden" name="event" value="ehAccounts.doSetSiteTitle">
					<input type="text" name="title" value="#siteTitle#" class="formField" style="width:130px;font-size:11px;">
					<input type="submit" value="Change" style="width:auto;">
				</form>
			</td>
			<td align="center" nowrap="yes">
				<form name="frmSearch" method="post" action="index.cfm" style="padding:0px;margin:0px;">
					<input type="text" name="searchTerm" value="#searchTerm#" class="formField" style="width:130px;font-size:11px;">
					<input type="button" value="Search" style="width:auto;" onclick="doFormEvent('ehAccounts.dspAccount','accountMainPanel',this.form)">
				</form>
			</td>
			<td align="right">
				<img src="images/add.png" align="absmiddle"> <a href="index.cfm?event=ehAccounts.dspAddPage"><strong>Add Page</strong></a>
			</td>
		</tr>
	</table>
	
	<div style="background-color:##fff;height:399px;border:1px dashed ##ccc;margin-top:3px;overflow:auto;margin-bottom:3px;">
		<form name="frmDelete" method="post" action="index.cfm" style="padding:0px;margin:0px;">
			<input type="hidden" name="event" value="ehAccounts.doDeletePage">
			<table cellpadding="1" cellspacing="0" style="width:100%;border-bottom:0px;" class="browseTable">
				<tr>
					<th width="40">No</th>
					<th style="text-align:left;">Page Title</th>
					<th style="text-align:left;">HREF</th>
					<th width="50">Default</th>
					<th width="70">Action</th>
				</tr>
				<cfloop query="qryPages" startrow="#startRow#" endrow="#endRow#">
					<cfset index = qryPages.currentRow>
					<tr <cfif index mod 2>class="altRow"</cfif>>
						<td width="40" align="right">
							#index#.
							<input type="checkbox" name="page" value="#qryPages.href#">
						</td>
						<td>
							<cfif qryPages.isDefault>
								<img src="images/page_lightning.png" align="absmiddle"> 
							<cfelse>
								<img src="images/page.png" align="absmiddle"> 
							</cfif>
							<a onclick="loadPageInfo('#qryPages.href#',#index#)"
								ondblclick="openPage('#accountName#','#qryPages.href#')"  
								class="pagesViewItem" id="pagesViewItem_#index#"	
								alt="Double-click to open in page editor"
								title="Double-click to open in page editor"
								href="##">#qryPages.title#</a><br>
						</td>
						<td>#qryPages.href#</td>
						<td align="center" width="50">
							<cfif qryPages.isDefault>Yes<cfelse>-</cfif>
						</td>
						<td align="center">
							<a href="##" onclick="openPage('#accountName#','#qryPages.href#')"><img src="images/page_edit.png" align="absmiddle" alt="Edit page" title="Edit page" border="0"></a>
							<a href="##" onclick="deletePage('#jsstringformat(qryPages.href)#')"><img src="images/waste_small.gif" align="absmiddle" alt="Delete page" title="Delete page" border="0"></a>
						</td>
					</tr>
				</cfloop>
				<cfif searchTerm neq "" and qryPages.recordCount eq 0>
					<tr><td colspan="5"><em>No pages found!</em></td></tr>
				</cfif>
			</table>
		</form>
	</div>

	<div class="pagingControls">
		<div style="width:170px;float:right;text-align:right;">
			<img src="images/waste_small.gif" align="absmiddle" alt="Delete page" title="Delete page" border="0">
			<a href="##" onclick="document.frmDelete.submit()">Delete selected pages</a>
		</div>
		Page 
			<select name="pageJump" style="font-size:10px;" onchange="doEvent('ehAccounts.dspAccount','accountMainPanel',{viewType:'details',startRow:(this.value-1)*#rowsPerPage#+1,searchTerm:'#jsstringformat(searchTerm)#'})">
				<cfloop from="1" to="#numPages#" index="i">
					<option value="#i#" <cfif i eq pageNum>selected</cfif>>#i#</option>
				</cfloop>
			</select>
		of #numPages# &nbsp;&middot;&nbsp;
		<cfif startRow gt 1>
			<a href="##" onclick="doEvent('ehAccounts.dspAccount','accountMainPanel',{viewType:'details',startRow:1,searchTerm:'#jsstringformat(searchTerm)#'})">First</a> &nbsp;&middot;&nbsp;
			<a href="##" onclick="doEvent('ehAccounts.dspAccount','accountMainPanel',{viewType:'details',startRow:#prevPageStartRow#,searchTerm:'#jsstringformat(searchTerm)#'})">Previous</a>
		<cfelse>
			<span style="color:##999;">First &nbsp;&middot;&nbsp; Previous</span>
		</cfif>
		&nbsp;&middot;&nbsp;
		<cfif endRow lte qryPages.recordCount>
			<a href="##" onclick="doEvent('ehAccounts.dspAccount','accountMainPanel',{viewType:'details',startRow:#nextPageStartRow#,searchTerm:'#jsstringformat(searchTerm)#'})">Next</a> &nbsp;&middot;&nbsp;
			<a href="##" onclick="doEvent('ehAccounts.dspAccount','accountMainPanel',{viewType:'details',startRow:#lastPageStartRow#,searchTerm:'#jsstringformat(searchTerm)#'})">Last</a> 
		<cfelse>
			<span style="color:##999;">Next &nbsp;&middot;&nbsp; Last</span>
		</cfif>
	</div>


</cfoutput>
