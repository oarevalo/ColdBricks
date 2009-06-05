
<cfoutput>
	<table border="1" class="browseTable tblGrid" style="width:100%;">
		<cfloop collection="#stLocationsByType#" item="regionName">
			<cfset aSections = stLocationsByType[regionName]>
			<tr>
				<th align="left">
					<div style="float:right;font-weight:normal;margin-right:20px;">
						<img src="images/add.png" align="absmiddle" border="0" alt="Add Section" title="Add Section">
						<a href="?event=ehPage.doAddLayoutLocation&locationType=#regionName#">Add Section</a>
					</div>
					#regionName#
				</th>
			</tr>	
		
			<cfloop from="1" to="#arrayLen(aSections)#" index="i">
				<cfset name = aSections[i].name>
				<cfset aModules = stModulesByRegion[ name ]>
				<tr>
					<td>
						<div style="float:right;font-weight:normal;margin-right:20px;">
							<img src="images/delete.png" align="absmiddle" border="0" alt="Delete Section" title="Delete Section">
							<a href="?event=ehPage.doDeleteLayoutLocation&locationName=#name#" onclick="return confirm('Are you sure?')">Delete Section</a>
						</div>
						&nbsp; <strong>#name#</strong>
					</td>
				</tr>
				<tr>
					<td style="background-color:##f5f5f5;">
						<ul id="pps_#name#" class="layoutPreviewList" style="width:100%;">
							<cfloop from="1" to="#ArrayLen(aModules)#" index="j">
								<cfset tmpModuleID = aModules[j].getID()>
								<li id="ppm_#tmpModuleID#" class="layoutListItem" style="border:0px;background-color:##f5f5f5;"><div>#tmpModuleID#</div></li>
							</cfloop>
						</ul>	
					</td>
				</tr>
			</cfloop>
		</cfloop>
	</table>
</cfoutput>
