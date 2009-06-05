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
			<th>Title</th>
			<th>Location</th>
			<th style="width:100px;">Action</th>
		</tr>
		<cfloop from="1" to="#arrayLen(aModules)#" index="i">
			<tr <cfif i mod 2>style="background-color:##f5f5f5;"</cfif>>
				<td align="right"><b>#i#.</b></td>
				<td>#aModules[i].getID()#</td>
				<td>#aModules[i].getTitle()#</td>
				<td align="center" style="width:150px;">
					<select name="location" style="font-size:10px;width:150px;">
						<cfloop from="1" to="#arrayLen(aOptions)#" index="j">
							<option value="#aOptions[j].value#"
									<cfif aModules[i].getLocation() eq aOptions[j].value>selected</cfif>
									>#aOptions[j].label#</option>
						</cfloop>
					</select>
				</td>
				<td align="center">
					<a href="##"><img src="images/information.png" align="absmiddle" border="0" alt="Info" title="Info"></a>
					<a href="##"><img src="images/brick_edit.png" align="absmiddle" border="0" alt="Edit" title="Info"></a>
					<a href="##"><img src="images/brick_delete.png" align="absmiddle" border="0" alt="Delete" title="Info"></a>
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
