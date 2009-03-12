<cfparam name="request.requestState.path" default="">
<cfparam name="request.requestState.qryDir" default="">
<cfparam name="request.requestState.startRow" default="1">
<cfparam name="request.requestState.searchTerm" default="">

<cfset path = request.requestState.path>
<cfset qryDir = request.requestState.qryDir>
<cfset startRow = request.requestState.startRow>
<cfset searchTerm = request.requestState.searchTerm>

<!--- sort pages query  --->
<cfquery name="qryPages" dbtype="query">
	SELECT *
		FROM qryDir
		<cfif searchTerm neq "">
			 AND upper(name) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(searchTerm)#%">
		</cfif>
		ORDER BY name
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
				<b>Current Path:</b>
				#path#
				<cfif path neq "/">
					(<img src="images/waste_small.gif" align="absmiddle"> <a href="##" onclick="deleteNode('#jsstringformat(path)#')" style="font-size:11px;"><strong>Delete</strong></a>)
				</cfif>
			</td>
			<td align="right" nowrap="yes">
				<form name="frmSearch" method="post" action="index.cfm" style="padding:0px;margin:0px;">
					<input type="hidden" name="path" value="#path#">
					<input type="text" name="searchTerm" value="#searchTerm#" class="formField" style="width:130px;font-size:11px;">
					<input type="button" value="Search" style="width:auto;" onclick="doFormEvent('ehPages.dspNode','nodePanel',this.form)">
				</form>
			</td>
			<td align="right">
				<img src="images/add.png" align="absmiddle"> <a href="index.cfm?event=ehPages.dspAddPage"><strong>Add Page</strong></a>
				&nbsp;&nbsp;
				<img src="images/add.png" align="absmiddle"> <a href="index.cfm?event=ehPages.dspAddFolder"><strong>Add Folder</strong></a>
			</td>
		</tr>
	</table>
	
	<div style="background-color:##fff;height:399px;border:1px dashed ##ccc;margin-top:3px;overflow:auto;margin-bottom:3px;">
		<form name="frmDelete" method="post" action="index.cfm" style="padding:0px;margin:0px;">
			<input type="hidden" name="event" value="ehPages.doDeletePage">
			<table cellpadding="1" cellspacing="0" style="width:100%;border-bottom:0px;" class="browseTable">
				<tr>
					<th width="40">No</th>
					<th style="text-align:left;">Name</th>
					<th width="70">Action</th>
				</tr>
				<cfloop query="qryPages" startrow="#startRow#" endrow="#endRow#">
					<cfset index = qryPages.currentRow>
					<cfset pagePath = path & "/" & qryPages.name>
					<tr <cfif index mod 2>class="altRow"</cfif>>
						<td width="40" align="right">
							#index#.
							<input type="checkbox" name="page" value="#pagePath#">
						</td>
						<td>
							<cfif qryDir.type eq "folder">
								<img src="images/folder.png" align="absmiddle">
								<a onclick="selectTreeNode('#pagePath#')"
									class="pagesViewItem" id="pagesViewItem_#index#"
									href="##">#qryPages.name#</a>
							<cfelse>
								<img src="images/page.png" align="absmiddle"> 
								<a onclick="loadNodeInfo('#pagePath#',#index#)"
									ondblclick="openPage('#pagePath#')"  
									class="pagesViewItem" id="pagesViewItem_#index#"	
									alt="Double-click to open in page editor"
									title="Double-click to open in page editor"
									href="##">#qryPages.name#</a>
							</cfif>
						</td>
						<td align="center">
							<cfif qryDir.type eq "page">
								<a href="##" onclick="openPage('#pagePath#')"><img src="images/page_edit.png" align="absmiddle" alt="Edit page" title="Edit page" border="0"></a>
							</cfif>
							<a href="##" onclick="deletePage('#jsstringformat(pagePath)#')"><img src="images/waste_small.gif" align="absmiddle" alt="Delete page" title="Delete page" border="0"></a>
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
			<select name="pageJump" style="font-size:10px;" onchange="doEvent('ehPages.dspNode','nodePanel',{startRow:(this.value-1)*#rowsPerPage#+1,searchTerm:'#jsstringformat(searchTerm)#,path:'#path#'})">
				<cfloop from="1" to="#numPages#" index="i">
					<option value="#i#" <cfif i eq pageNum>selected</cfif>>#i#</option>
				</cfloop>
			</select>
		of #numPages# &nbsp;&middot;&nbsp;
		<cfif startRow gt 1>
			<a href="##" onclick="doEvent('ehPages.dspNode','nodePanel',{startRow:1,searchTerm:'#jsstringformat(searchTerm)#',path:'#path#'})">First</a> &nbsp;&middot;&nbsp;
			<a href="##" onclick="doEvent('ehPages.dspNode','nodePanel',{startRow:#prevPageStartRow#,searchTerm:'#jsstringformat(searchTerm)#',path:'#path#'})">Previous</a>
		<cfelse>
			<span style="color:##999;">First &nbsp;&middot;&nbsp; Previous</span>
		</cfif>
		&nbsp;&middot;&nbsp;
		<cfif endRow lte qryPages.recordCount>
			<a href="##" onclick="doEvent('ehPages.dspNode','nodePanel',{startRow:#nextPageStartRow#,searchTerm:'#jsstringformat(searchTerm)#',path:'#path#})">Next</a> &nbsp;&middot;&nbsp;
			<a href="##" onclick="doEvent('ehPages.dspNode','nodePanel',{startRow:#lastPageStartRow#,searchTerm:'#jsstringformat(searchTerm)#',path:'#path#})">Last</a> 
		<cfelse>
			<span style="color:##999;">Next &nbsp;&middot;&nbsp; Last</span>
		</cfif>
	</div>


</cfoutput>
