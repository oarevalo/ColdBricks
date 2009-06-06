<cfparam name="attributes.numColumns" type="numeric">
<cfparam name="attributes.sectionsArray" type="array">
<cfparam name="attributes.modulesByRegionStruct" type="struct">
<cfparam name="caller.editLayoutSection" type="string" default="">

<cfset aSections = attributes.sectionsArray>
<cfset stModulesByRegion = attributes.modulesByRegionStruct>

<cfoutput>
	<cfloop from="1" to="#arrayLen(aSections)#" index="i">
		<cfset name = aSections[i].name>
		<cfset aModules = stModulesByRegion[ name ]>
		<tr valign="top">
			<td colspan="#attributes.numColumns#" style="height:17px;">
				<div class="layoutSectionLabel" <cfif caller.editLayoutSection eq "">style="display:none;"</cfif> id="#name#_title">
					<table style="width:100%;" border="0">
						<td style="border:0px !important;" align="left">
							<a href="javascript:document.location='?event=ehPage.dspMain&editLayoutSection=#name#'">#name#</a>
						</td>
						<td align="right" style="border:0px !important;">
							<a href="javascript:document.location='?event=ehPage.doDeleteLayoutLocation&locationName=#name#'"><img src="images/delete.png" align="absmiddle" border="0" title="delete section" alt="delete section"></a>
						</td>
					</table>
				</div>
				<ul id="pps_#name#" class="layoutPreviewList">
				<cfloop from="1" to="#ArrayLen(aModules)#" index="j">
					<cfset tmpModuleID = aModules[j].getID()>
					<li id="ppm_#tmpModuleID#" class="layoutListItem"><div>#tmpModuleID#</div></li>
				</cfloop>
				</ul>
			</td>	
		</tr>
	</cfloop>
</cfoutput>
