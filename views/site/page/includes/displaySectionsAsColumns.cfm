<cfparam name="attributes.columnWidth" type="numeric">
<cfparam name="attributes.sectionsArray" type="array">
<cfparam name="attributes.modulesByRegionStruct" type="struct">

<cfset aSections = attributes.sectionsArray>
<cfset stModulesByRegion = attributes.modulesByRegionStruct>

<cfoutput>
	<tr valign="top">
		<cfloop from="1" to="#arrayLen(aSections)#" index="i">
			<cfset name = aSections[i].name>
			<cfset aModules = stModulesByRegion[ name ]>
			<td style="width:#attributes.columnWidth#px;">
				<div class="layoutSectionLabel" style="display:none;" id="#name#_title">
					<table style="width:100%;" border="0">
						<td style="border:0px !important;" align="left">
							<a href="javascript:document.location='?event=ehPage.dspMain&editLayoutSection=#name#'">#name#</a>
						</td>
						<td align="right" style="border:0px !important;">
							<a href="javascript:document.location='?event=ehPage.doDeleteLayoutLocation&locationName=#name#'"><img src="images/cross.png" align="absmiddle" border="0"></a>
						</td>
					</table>
				</div>
				<ul id="pps_#name#" class="layoutPreviewList">
				<cfloop from="1" to="#ArrayLen(aModules)#" index="j">
					<cfset tmpModuleID = aModules[j].id>
					<li id="ppm_#tmpModuleID#" class="layoutListItem"><div>#tmpModuleID#</div></li>
				</cfloop>
				</ul>
			</td>
		</cfloop>
	</tr>
</cfoutput>
