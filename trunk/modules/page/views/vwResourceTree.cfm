<cfparam name="request.requestState.resType" default="module">
<cfparam name="request.requestState.oCatalog" default="">
<cfparam name="request.requestState.aResTypes" default="">

<cfscript>
	resType = request.requestState.resType;
	oCatalog = request.requestState.oCatalog;	
	aResTypes = request.requestState.aResTypes;	

	qryResources = oCatalog.getResourcesByType(resType);
</cfscript>	

<cfoutput>
	<div class="cp_sectionBox"  style="border-bottom:1px solid black;background-color:##ccc;line-height:22px;padding-left:5px;">
		Resource Type: 
		<select name="resType" onchange="doEvent('page.ehPage.dspResourceTree','resourceTreePanel',{resType:this.value})"
				style="width:120px;">
			<cfloop from="1" to="#arrayLen(aResTypes)#" index="i">
				<option value="#aResTypes[i]#"
						<cfif aResTypes[i] eq resType>selected</cfif>
						>#aResTypes[i]#</option>
			</cfloop>
		</select>
	</div>
</cfoutput>	
<div class="cp_sectionBox" 
	style="margin-top:0px;width:210px;padding:0px;height:420px;margin-right:0px;margin-left:0px;border-top:0px;">
	<div style="margin:5px;">
		<cfif arrayLen(aResTypes) eq 0>
			There are no resource types bound to any module types that can be added directly as page content.
		<cfelse>
			<cfoutput>
				<div style="background-color:##f5f5f5;margin:-5px;border-bottom:1px dashed silver;padding-left:5px;">
					<div class="buttonImage btnSmall" style="margin:0px;float:left;margin-right:5px;">
						<cfif resType neq "module">
							<a href="javascript:editResource('NEW','#resType#','')" title="Create a new resource of type #resType#">New</a>
						<cfelse>
							<span style="color:##999;"><strong>New</strong></span>
						</cfif>
					</div>
					<br style="clear:both;" />
				</div>
			</cfoutput>
	
			<!--- put modules into a query and sort them --->
			<cfquery name="qryResources" dbtype="query">
				SELECT *
					FROM qryResources
					ORDER BY package, id
			</cfquery>
			
			<cfoutput query="qryResources" group="package">
				<div style="margin-top:5px;">
					<b>#qryResources.package#</b><br>
					<cfoutput>
						<cfset tmpResTitle = qryResources.id>
						<div style="border-bottom:1px solid ##ebebeb;">
							<div style="float:right;">
								<a href="javascript:addResource('#jsstringformat(qryResources.id)#','#resType#');"><img src="images/add.png" align="absmiddle" border="0" alt="Add To Page" title="Add To Page"></a>
								<a href="javascript:viewResourceInfo('#jsstringformat(qryResources.id)#','#resType#')"><img src="images/information.png" align="absmiddle" border="0" alt="Info" title="Info"></a>
								<cfif resType neq "module">
									<a href="javascript:editResource('#jsstringformat(qryResources.id)#','#resType#','#jsStringFormat(qryResources.package)#')"><img src="images/edit-page-yellow.gif" align="absmiddle" border="0" alt="Edit" title="Edit"></a>
								</cfif>
							</div>
							<div style="width:130px;overflow:hidden;">
								<a href="javascript:addResource('#jsstringformat(qryResources.id)#','#resType#')" 
									class="cpListLink" 
									style="font-weight:normal;" 
									>#tmpResTitle#</a>
							</div>
						</div>
						<div style="clear:both;">
					</cfoutput>
				</div>
			</cfoutput>
			<cfif qryResources.recordCount eq 0>
				<cfoutput><br><em>There are no resources of type '#resType#' in the library.</em></cfoutput>
			</cfif>
		</cfif>
		<br>
	</div>
</div>
