<cfparam name="request.requestState.qrySites" default="">
<cfparam name="request.requestState.qryResources" default="">
<cfparam name="request.requestState.sourceSiteID" default="">
<cfparam name="request.requestState.oContext" default="">

<cfset qrySites = request.requestState.qrySites>
<cfset qryResources = request.requestState.qryResources>
<cfset sourceSiteID = request.requestState.sourceSiteID>
<cfset oContext = request.requestState.oContext>

<cfset oSiteInfo = oContext.getSiteInfo()>

<!--- filter out any svn specific directories --->
<cfif isquery(qryResources)>
	<cfquery name="qryResources" dbtype="query">
		SELECT *
			FROM qryResources
			WHERE name NOT LIKE '.svn'
			ORDER BY resType, name
	</cfquery>
</cfif>

<!--- filter out current site --->
<cfquery name="qrySites" dbtype="query">
	SELECT *
		FROM qrySites
		WHERE siteID <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#oSiteInfo.getID()#">
		ORDER BY siteName
</cfquery>

<form name="frmImport" method="post" action="index.cfm">
	<input type="hidden" name="event" value="ehResources.doImport">
	<cfoutput><input type="hidden" name="sourceSiteID" value="#sourceSiteID#"></cfoutput>

	<table width="100%" cellpadding="0" cellspacing="0">
		<tr valign="top">
			<td width="150">
				<div class="cp_sectionTitle" id="cp_pd_moduleProperties_Title" 
						style="width:150px;padding:0px;margin:0px;margin-top:10px;">
					<div style="margin:2px;">
						&nbsp; Sites
					</div>
				</div>
				<div class="cp_sectionBox" 
					style="margin:0px;width:150px;padding:0px;height:375px;border-top:0px;">
					<div style="margin:5px;">
						<cfoutput query="qrySites">
							&bull; <a href="index.cfm?event=ehResources.dspImport&sourceSiteID=#qrySites.siteid#" 
									<cfif qrySites.siteID eq sourceSiteID>style="font-weight:bold;"</cfif>>#qrySites.siteName#</a><br>
						</cfoutput>
						<cfif qrySites.recordCount lt 1>
							<em>There are no other sites defined.</em>
						</cfif>
					</div>
				</div>
			</td>
			<td>
				<div style="margin-top:10px;border:1px solid #ccc;height:400px;overflow:auto;margin-left:10px;">	
					<table class="browseTable" style="width:100%">	
						<tr>
							<th width="30">&nbsp;</th>
							<th>Package Name</th>
						</tr>
						<cfif isquery(qryResources)>
							<cfoutput query="qryResources" group="resType">
								<cfset resTypeDir = getResourceTypeDirName(resType)>
								<tr><td colspan="2" style="background-color:##ebebeb;"><b>#resTypeDir#</b></td></tr>
								<cfoutput>
									<tr <cfif qryResources.currentRow mod 2>class="altRow"</cfif>>
										<td align="center"><input type="checkbox" value="#resTypeDir#/#qryResources.name#" name="lstPackages"></td>
										<td>#qryResources.name#</td>
									</tr>
								</cfoutput>
							</cfoutput> 
							<cfif qryResources.recordCount eq 0>
								<tr><td colspan="2"><em>No records found!</em></td></tr>
							</cfif>
						<cfelse>
							<tr><td colspan="2"><em>No site selected</em></td></tr>
						</cfif>
					</table>
				</div>	
			</td>
			
			<td width="200">
				<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
					<div style="margin:10px;">
						<h2>Import Packages</h2>
						<p>
							This screen allows you to copy resource packages from other sites into the current working site.
						</p>
						<p>
							To import packages, click on the site from which you wish to import the package and then select all packages
							you wish to import by clicking the checkboxes next to their names, then click on the "<strong>Import Selected Packages</strong>" button.
						</p>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<p>
		<input type="submit" name="btnImport" value="Import Selected Packages">
		&nbsp;&nbsp;&nbsp;
		<input type="button" 
				name="btnCancel" 
				value="Return To Resources Manager" 
				onClick="document.location='?event=ehResources.dspMain'">
	</p>
</form>	


<!---------------------------------------->
<!--- getResourceTypeDirName		   --->
<!---------------------------------------->
<cffunction name="getResourceTypeDirName" access="public" output="false" returntype="string" hint="Returns the name of the directory on the resource library for the given resource type">
	<cfargument name="resourceType" type="string" required="true">
	<cfreturn ucase(left(arguments.resourceType,1)) & lcase(mid(arguments.resourceType,2,len(arguments.resourceType)-1)) & "s">
</cffunction>
