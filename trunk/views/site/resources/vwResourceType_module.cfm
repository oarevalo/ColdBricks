<cfparam name="request.requestState.resourceType" default="">
<cfparam name="request.requestState.id" default="">
<cfparam name="request.requestState.qryResources" default="">
<cfparam name="request.requestState.oResourceBean" default="">
<cfparam name="request.requestState.resourceTypeInfo" default="">

<cfscript>
	resourceType = request.requestState.resourceType;
	id = request.requestState.id;
	qryResources = request.requestState.qryResources;
	oResourceBean = request.requestState.oResourceBean;
	resourceTypeInfo = request.requestState.resourceTypeInfo;
</cfscript>

<cfquery name="qryResources" dbtype="query">
	SELECT *
		FROM qryResources
		ORDER BY package, id
</cfquery>

<cfif id eq "">
	<div style="border:1px solid #ccc;height:440px;overflow:auto;">	
		<cfset j = 1>
		<table class="tblGrid" width="98%">
			<tr>
				<th width="10">&nbsp;</th>
				<th width="150">Module ID</th>
				<th>Description</th>
			</tr>
			
			<cfoutput query="qryResources" group="package">		
				<tr><td colspan="3" style="font-weight:bold;background-color:##ccc;border-bottom:1px solid ##333;border-top:1px solid white;">#package#</td></tr>
				<cfoutput>
					<cfset urlEdit = "javascript:selectResourceType('#resourceType#','#qryResources.id#')">
					<tr <cfif qryResources.currentRow mod 2>style="background-color:##ebebeb;"</cfif>>
						<td width="10"><strong>#qryResources.currentRow#.</strong></td>
						<td width="150">
							<a href="#urlEdit#">#qryResources.id#</a>	
						</td>
						<td>#qryResources.description#</td>
					</tr>
				</cfoutput>
				<tr><td colspan="3">&nbsp;</td></tr>
			</cfoutput>
			<cfif qryResources.recordCount eq 0>
				<cfoutput><tr><td colspan="3"><em>No #resourceType#s found!</em></td></tr></cfoutput>
			</cfif>
		</table>
	</div>
	<div style="margin-top:5px;color:#333;">	
		Click on moduleID to view module description.
	</div>

	<cfoutput>
		<script type="text/javascript">
			setResourceTypeInfo('Modules','#jsstringformat(resourceTypeInfo)#')
		</script>
	</cfoutput>
<cfelse>
	<cfinclude template="vwViewModuleInfo.cfm">
</cfif>
