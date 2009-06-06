<cfset aModules = oPage.getModules()>

<cfset aOptions = arrayNew(1)>
<cfloop from="1" to="#arrayLen(aLayoutSectionTypes)#" index="regionIndex">
	<cfset regionName = aLayoutSectionTypes[regionIndex]>
	<cfset aSections = stLocationsByType[regionName]>
	<cfloop from="1" to="#arrayLen(aSections)#" index="i">
		<cfset name = aSections[i].name>
		<cfset st = structNew()>
		<cfset st.value = name>
		<cfset st.label = "#name# (#regionName#)">
		<cfset arrayAppend(aOptions,st)>
	</cfloop>
</cfloop>

<cfoutput>
	<table border="1" class="browseTable tblGrid" style="width:100%;">
		<tr>
			<th style="width:15px;">No.</th>
			<th style="width:150px;">Module ID</th>
			<th>Module Type</th>
			<th>Location</th>
			<th style="width:100px;">Action</th>
		</tr>
		<cfloop from="1" to="#arrayLen(aModules)#" index="i">
			<cfset tmpID = aModules[i].getID()>
			<tr <cfif i mod 2>style="background-color:##f5f5f5;"</cfif>>
				<td align="right"><b>#i#.</b></td>
				<td><a href="javascript:void;" onclick="editModuleProperties('#tmpID#')">#aModules[i].getID()#</a></td>
				<td align="center">#aModules[i].getModuleType()#</td>
				<td align="center" style="width:150px;">
					<select name="location" style="font-size:10px;width:150px;" onchange="doSetModuleLocation('#tmpID#',this.value)">
						<cfloop from="1" to="#arrayLen(aOptions)#" index="j">
							<option value="#aOptions[j].value#"
									<cfif aModules[i].getLocation() eq aOptions[j].value>selected</cfif>
									>#aOptions[j].label#</option>
						</cfloop>
					</select>
				</td>
				<td align="center">
					<a href="##" onclick="getModuleProperties('#tmpID#')"><img src="images/information.png" align="absmiddle" border="0" alt="Info" title="Info"></a>
					<a href="##" onclick="editModuleProperties('#tmpID#')"><img src="images/brick_edit.png" align="absmiddle" border="0" alt="Edit" title="Info"></a>
					<a href="##" onclick="doDeleteModule('#tmpID#');"><img src="images/brick_delete.png" align="absmiddle" border="0" alt="Delete" title="Info"></a>
					<cfif i gt 1>
						<a href="##" onclick="doMoveModule('up','#tmpID#')"><img src="images/arrow_up.png" align="absmiddle" border="0" alt="Move Up" title="Move Up"></a>
					<cfelse>
						&nbsp;&nbsp;&nbsp;
					</cfif>
					<cfif i lt arrayLen(aModules)>
						<a href="##" onclick="doMoveModule('down','#tmpID#')"><img src="images/arrow_down.png" align="absmiddle" border="0" alt="Move Down" title="Move Down"></a>
					<cfelse>
						&nbsp;&nbsp;&nbsp;
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
