<cfparam name="request.requestState.resourceType" default="">
<cfparam name="request.requestState.qryResources" default="">
<cfparam name="request.requestState.resourcesRoot" default="">
<cfparam name="request.requestState.resTypeLabel" default="">
<cfparam name="request.requestState.resTypeIcon" default="">
<cfparam name="request.requestState.resourceTypeInfo" default="">
<cfparam name="request.requestState.startRow" default="1">
<cfparam name="request.requestState.searchTerm" default="">
<cfparam name="request.requestState.resViewType" default="resources">
<cfparam name="request.requestState.aResLibs">
<cfparam name="request.requestState.resLibIndex">
<cfparam name="request.requestState.package" default="">
<cfparam name="request.requestState.id" default="">
<cfparam name="request.requestState.qryPackages" default="">

<cfset resourceType = request.requestState.resourceType>
<cfset qryResources = request.requestState.qryResources>
<cfset resourcesRoot = request.requestState.resourcesRoot>
<cfset resTypeLabel = request.requestState.resTypeLabel>
<cfset resTypeIcon = request.requestState.resTypeIcon>
<cfset resourceTypeInfo = request.requestState.resourceTypeInfo>
<cfset startRow = request.requestState.startRow>
<cfset searchTerm = request.requestState.searchTerm>
<cfset resViewType = request.requestState.resViewType>
<cfset aResLibs = request.requestState.aResLibs>
<cfset resLibIndex = request.requestState.resLibIndex>
<cfset package = request.requestState.package>
<cfset id = request.requestState.id>
<cfset qryPackages = request.requestState.qryPackages>

<cfif resLibIndex gt 0>
	<cfset thisLibPath = aResLibs[resLibIndex].getPath()>
<cfelse>
	<cfset thisLibPath = "">
</cfif>



<!--- sort/filter resources  --->
<cfquery name="qryResources" dbtype="query">
	SELECT *
		FROM qryResources
		<cfif searchTerm neq "">
			WHERE upper(package) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(searchTerm)#%">
				OR upper(id) LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(searchTerm)#%">
		</cfif>
		ORDER BY package,id
</cfquery>

<!--- filter by package --->
<cfquery name="qryResources" dbtype="query">
	SELECT *
		FROM qryResources
		<cfif package neq "">
			WHERE upper(package) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(package)#">
		</cfif>
		ORDER BY libpath,package,id
</cfquery>

<cfscript>
	// page for when viewing in details mode
	rowsPerPage = 15;
	if(startRow lt 0) startRow = 1;
	endRow = startRow + rowsPerPage - 1;
	numPages = ceiling(qryResources.recordCount / rowsPerPage);
	pageNum = int(startRow/rowsPerPage)+1;
	prevPageStartRow = (pageNum-2)*rowsPerPage + 1;
	nextPageStartRow = (pageNum)*rowsPerPage + 1;
	lastPageStartRow = (numPages-1)*rowsPerPage;
</cfscript>


<cfoutput>
	<!--- [resLibIndex:#resLibIndex#][id:#id#][resourceType:#resourceType#][pkg:#package#]  --->
	<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="0" cellspacing="0">
		<tr>
			<td nowrap="yes" style="width:200px;">
				<div style="margin:10px;">
					<cfif resTypeIcon neq "">
						<img src="images/#resTypeIcon#" align="absmiddle">
					</cfif>
					<b>#resTypeLabel# (#qryResources.recordCount#)</b> 
				</div>
			</td>
			<td align="center" nowrap="yes">
				<form name="frmSearch" method="post" action="index.cfm" style="padding:0px;margin:0px;">
					<input type="hidden" name="resourceType" value="#resourceType#">
					<input type="text" name="searchTerm" value="#searchTerm#" class="formField" style="width:130px;font-size:11px;">
					<input type="button" value="Search" style="width:auto;" onclick="doFormEvent('resources.ehResources.dspResourceTypeList','nodePanel',this.form)">
				</form>
			</td>
			<td align="right" style="padding-right:10px;width:120px;">
				<cfif resourceType neq "module">
					<div class="buttonImage btnLarge" style="margin:0px;">
						<a href="##" onclick="createResource('#resourceType#','NEW','','#reslibIndex#')"><img src="images/add.png" align="absmiddle" border="0"> Create #resourceType#</a>
					</div>	
				</cfif>
			</td>
			<td align="right" style="padding-right:10px;width:120px;">
				<div class="buttonImage btnLarge" style="margin:0px;">
					<a href="##" onclick="uploadResource('#resourceType#','#package#','#resLibIndex#')"><img src="images/add.png" align="absmiddle" border="0"> Upload #resourceType#</a>
				</div>	
			</td>
		</tr>
	</table>

	<table style="width:100%;border:1px solid silver;background-color:##ccc;margin-top:3px;" cellpadding="0" cellspacing="0">
		<tr>
			<!--- <td nowrap="yes" style="width:200px;">
				<div style="margin:3px;">
					<a href="##" <cfif resViewType eq "resources">style="font-weight:bold;"</cfif>>Resources View</a> |
					<a href="##" <cfif resViewType eq "files">style="font-weight:bold;"</cfif>>Files View</a>
				</div>
			</td> --->
			<td align="right" style="padding-right:10px;width:350px;">
				Resource Library:
				<select name="resLibIndex" onchange="selectResourceType('#resourceType#','','',this.value)" style="font-size:11px;width:190px;">
					<option value="-1">-- All --</option>
					<cfloop from="1" to="#arrayLen(aResLibs)#" index="i">
						<option value="#i#" <cfif resLibIndex eq i>selected</cfif>>#aResLibs[i].getPath()#</option>
					</cfloop>
				</select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				
				Package:
				<select name="package" onchange="selectResourceType('#resourceType#','',this.value,#resLibIndex#)" style="font-size:11px;width:100px;">
					<cfset tmpPKG = package>
					<option value="__ALL__">-- All --</option>
					<cfloop query="qryPackages">
						<option value="#qryPackages.name#" <cfif qryPackages.name eq tmpPKG>selected</cfif>>#qryPackages.name#</option>
					</cfloop>
				</select>
			</td>
		</tr>
	</table>
	
	<div style="background-color:##fff;height:375px;border:1px dashed ##ccc;margin-top:5px;overflow:auto;margin-bottom:5px;">
		<table cellpadding="1" cellspacing="0" style="width:100%;border-bottom:0px;" class="browseTable">
			<tr>
				<th width="20">No</th>
				<th style="text-align:left;width:240px;">ID</th>
				<th style="text-align:left;">Package</th>
				<th width="70">Action</th>
			</tr>
			<cfset currentLibPath = "">
			<cfloop query="qryResources" startrow="#startRow#" endrow="#endRow#">
				<cfset index = qryResources.currentRow>
				<cfif qryResources.libPath neq currentLibPath>
					<tr><td colspan="4" style="font-weight:bold;font-family:verdana;background-color:##ebebeb;"><em>#qryResources.libPath#</em></td></tr>
					<cfset currentLibPath = qryResources.libPath>
				</cfif>
				<tr <cfif index mod 2>class="altRow"</cfif>>
					<td width="20" align="right">#index#.</td>
					<td>
						<a onclick="selectResource('#resourceType#','#jsstringFormat(qryResources.id)#','#jsStringFormat(qryResources.package)#','#reslibIndex#')"
							class="pagesViewItem" id="pagesViewItem_#index#"	
							alt="Click to open in page editor"
							title="Click to open in page editor"
							href="##">#qryResources.id#</a><br>
					</td>
					<td>#qryResources.package#</td>
					<td align="center">
						<cfif resourceType neq "module">
							<a href="##" onclick="selectResource('#resourceType#','#jsstringFormat(qryResources.id)#','#jsStringFormat(qryResources.package)#','#reslibIndex#')"><img src="images/page_edit.png" align="absmiddle" alt="Edit resource" title="Edit resource" border="0"></a>
							<a href="##" onclick="if(confirm('Delete resource?')){document.location='index.cfm?event=resources.ehResources.doDeleteResource&id=#qryResources.id#&resourceType=#resourceType#&pkg=#qryResources.package#'}"><img src="images/waste_small.gif" align="absmiddle" alt="Delete resource" title="Delete resource" border="0"></a>
						<cfelse>
							<a href="##" onclick="selectResource('#resourceType#','#jsstringFormat(qryResources.id)#','#jsStringFormat(qryResources.package)#','#reslibIndex#')"><img src="images/magnifier.png" align="absmiddle" alt="View module information" title="View module information" border="0"></a>
						</cfif>
					</td>
				</tr>
			</cfloop>
			<cfif qryResources.recordCount eq 0>
				<tr><td colspan="6"><em>No resources found for this resource type</em></td></tr>
			</cfif>
		</table>
	</div>

	<div class="pagingControls">
		Page 
			<select name="pageJump" style="font-size:10px;" onchange="doEvent('resources.ehResources.dspResourceTypeList','nodePanel',{resourceType:'#resourceType#',startRow:(this.value-1)*#rowsPerPage#+1,searchTerm:'#jsstringformat(searchTerm)#'})">
				<cfloop from="1" to="#numPages#" index="i">
					<option value="#i#" <cfif i eq pageNum>selected</cfif>>#i#</option>
				</cfloop>
			</select>
		of #numPages# &nbsp;&middot;&nbsp;
		<cfif startRow gt 1>
			<a href="##" onclick="doEvent('resources.ehResources.dspResourceTypeList','nodePanel',{resourceType:'#resourceType#',startRow:1,searchTerm:'#jsstringformat(searchTerm)#'})">First</a> &nbsp;&middot;&nbsp;
			<a href="##" onclick="doEvent('resources.ehResources.dspResourceTypeList','nodePanel',{resourceType:'#resourceType#',startRow:#prevPageStartRow#,searchTerm:'#jsstringformat(searchTerm)#'})">Previous</a>
		<cfelse>
			<span style="color:##999;">First &nbsp;&middot;&nbsp; Previous</span>
		</cfif>
		&nbsp;&middot;&nbsp;
		<cfif endRow lte qryResources.recordCount>
			<a href="##" onclick="doEvent('resources.ehResources.dspResourceTypeList','nodePanel',{resourceType:'#resourceType#',startRow:#nextPageStartRow#,searchTerm:'#jsstringformat(searchTerm)#'})">Next</a> &nbsp;&middot;&nbsp;
			<a href="##" onclick="doEvent('resources.ehResources.dspResourceTypeList','nodePanel',{resourceType:'#resourceType#',startRow:#lastPageStartRow#,searchTerm:'#jsstringformat(searchTerm)#'})">Last</a> 
		<cfelse>
			<span style="color:##999;">Next &nbsp;&middot;&nbsp; Last</span>
		</cfif>
	</div>
	
	<script type="text/javascript">
		try { setResourceTypeInfo('#jsstringformat(resTypeLabel)#','#jsstringformat(resourceTypeInfo)#') } catch(e) {alert(e);}
	</script>
</cfoutput>