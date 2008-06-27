<cfparam name="request.requestState.resType" default="module">
<cfparam name="request.requestState.oCatalog" default="">

<cfscript>
	resType = request.requestState.resType;
	oCatalog = request.requestState.oCatalog;	

	qryResources = oCatalog.getResourcesByType(resType);
</cfscript>	
	
<div class="cp_sectionBox"  style="border-bottom:1px solid black;background-color:#ccc;line-height:22px;padding-left:5px;">
	<a href="#" onclick="doEvent('ehPage.dspResourceTree','resourceTreePanel',{resType:'module'})" <cfif resType eq "module">style="font-weight:bold;"</cfif>>Modules</a>&nbsp;|&nbsp;
	<a href="#" onclick="doEvent('ehPage.dspResourceTree','resourceTreePanel',{resType:'feed'})" <cfif resType eq "feed">style="font-weight:bold;"</cfif>>Feeds</a>&nbsp;|&nbsp;
	<a href="#" onclick="doEvent('ehPage.dspResourceTree','resourceTreePanel',{resType:'content'})" <cfif resType eq "content">style="font-weight:bold;"</cfif>>Content</a>&nbsp;|&nbsp;
	<a href="#" onclick="doEvent('ehPage.dspResourceTree','resourceTreePanel',{resType:'html'})" <cfif resType eq "html">style="font-weight:bold;"</cfif>>HTML</a> 
</div>
<div class="cp_sectionBox" 
	style="margin-top:0px;width:210px;padding:0px;height:420px;margin-right:0px;margin-left:0px;border-top:0px;">
	<div style="margin:5px;">

		<cfoutput>
			<div style="background-color:##f5f5f5;margin:-5px;border-bottom:1px dashed silver;padding-left:5px;">
				<div class="buttonImage btnSmall" style="margin:0px;float:left;margin-right:5px;">
					<cfif resType neq "module">
						<a href="index.cfm?event=ehResources.dspMain&resType=#resType#&id=NEW" title="Create a new resource of type #resType#">New</a>
					<cfelse>
						<span style="color:##999;"><strong>New</strong></span>
					</cfif>
				</div>
				<div class="buttonImage btnSmall" style="margin:0px;float:left;margin-right:5px;">
					<a href="index.cfm?event=ehResources.dspImport" title="Import resource packages from another site">Import</a>
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
					<cfif resType eq "module" or qryResources.name eq "">
						<cfset tmpResTitle = qryResources.id>
					<cfelse>
						<cfset tmpResTitle = qryResources.name>
					</cfif>
					<div style="border-bottom:1px solid ##ebebeb;">
						<div style="float:right;">
							<a href="javascript:addResource('#jsstringformat(qryResources.id)#','#resType#');"><img src="images/add.png" align="absmiddle" border="0" alt="Add To Page" title="Add To Page"></a>
							<a href="javascript:viewResourceInfo('#jsstringformat(qryResources.id)#','#resType#')"><img src="images/information.png" align="absmiddle" border="0" alt="Info" title="Info"></a>
							<cfif resType neq "module">
								<a href="index.cfm?event=ehResources.dspMain&resType=#resType#&id=#qryResources.id#&pkg=#qryResources.package#"><img src="images/edit-page-yellow.gif" align="absmiddle" border="0" alt="Edit" title="Edit"></a>
							</cfif>
						</div>
						<div style="width:130px;overflow:hidden;">
							<a href="javascript:viewResourceInfo('#jsstringformat(qryResources.id)#','#resType#')" 
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
			<br><em>There are no resources of this type in the library.</em>
			<br><br>
			<div class="helpBox" style="padding:5px;border:1px solid silver;">
				<img src="images/information.png" align="absmiddle"> <b>Tip:</b>
				Start building your resource library by creating resources or 
				<a href="index.cfm?event=ehResources.dspImport" style="color:green !important;font-weight:bold;">importing resource packages</a> from other sites.
			</div>
		</cfif>
		<br>

	</div>
</div>
