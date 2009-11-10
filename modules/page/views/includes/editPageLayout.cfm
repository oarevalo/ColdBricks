<cfparam name="editLayoutSection" default="">
<cfparam name="pageMode" default="">

<cfoutput>
	<cfif pageMode eq "preview">
		<div style="border-bottom:1px solid black;background-color:##ccc;text-align:left;line-height:22px;font-size:11px;">
			<input type="checkbox" name="chkShowLayoutSectionTitles" 
					onclick="showLayoutSectionTitles(this.checked)" value="1"
					<cfif editLayoutSection neq "">checked</cfif>>
			Show Section Titles
		</div>
	</cfif>

	<div id="layoutSections" style="margin:5px;margin-top:10px;text-align:left;">

		<div style="margin:2px;">
			<strong>Section:</strong> &nbsp;&nbsp;
			<select name="layoutSection" 
					style="width:100px;"
					onchange="document.location='?event=page.ehPage.dspMain&editLayoutSection='+this.value">
				<option value=""></option>
				<cfloop from="1" to="#arrayLen(aLayoutRegions)#" index="i">
					<option value="#aLayoutRegions[i].name#"
							<cfif aLayoutRegions[i].name eq editLayoutSection>selected</cfif>
							>#aLayoutRegions[i].name#</option>
				</cfloop>
			</select>
		</div>
		
		<cfif editLayoutSection neq "">
			<cfloop from="1" to="#arrayLen(aLayoutRegions)#" index="i">
				<cfif aLayoutRegions[i].name eq editLayoutSection>
					<cfset thisLocation = aLayoutRegions[i]>
				</cfif>
			</cfloop>

			<div style="margin-top:5px;border-top:1px solid silver;">
				<div style="margin:2px;">
					<form name="frmEditLayoutSection" method="post" action="index.cfm">
						<table>
							<tr>
								<td style="font-size:10px;color:##999;text-align:right;width:50px;">Name:</td>
								<td><input type="text" name="locationNewName" value="#thisLocation.name#" style="width:90px;padding:2px;"></td>
							</tr>
							<tr>
								<td style="font-size:10px;color:##999;text-align:right;width:50px;">Type:</td>
								<td>
									<select name="locationType" style="width:90px;padding:2px;">
										<cfloop from="1" to="#arrayLen(aLayoutSectionTypes)#" index="i">
											<option value="#aLayoutSectionTypes[i]#"
													<cfif aLayoutSectionTypes[i] eq thisLocation.type>selected</cfif>
													>#aLayoutSectionTypes[i]#</option>
										</cfloop>
									</select>
							</tr>
							<tr>
								<td style="font-size:10px;color:##999;text-align:right;width:50px;">CSS Class:</td>
								<td><input type="text" name="locationClass" value="#thisLocation.class#" style="width:90px;padding:2px;"></td>
							</tr>
						</table>
						<p align="center">
							<input type="hidden" name="event" value="page.ehPage.doSaveLayoutLocation">
							<input type="hidden" name="locationOriginalName" value="#thisLocation.name#">
							<input type="submit" name="btnSave" value="Save">
							<input type="button" name="btnDelete" value="Delete" onclick="document.location='?event=page.ehPage.doDeleteLayoutLocation&locationName=#thisLocation.name#'">
							<input type="button" name="btnCancel" value="Cancel" onclick="document.location='?event=page.ehPage.dspMain'">
						</p>
					</form>
				</div>
			</div>
		<cfelse>
			<p>Select from the drop-down box a layout section to customize its properties</p>
		</cfif>
	</div>
</cfoutput>