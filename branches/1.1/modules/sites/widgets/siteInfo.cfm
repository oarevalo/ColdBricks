<cfset oContext = getService("sessionContext").getContext()>
<cfset oSiteInfo = oContext.getSiteInfo()>
<cfset stAccessMap = getValue("oUser").getAccessMap()>

<cfoutput>
	<form name="frmNotes" method="post" action="index.cfm" style="margin:0px;padding:0px;">
		<input type="hidden" name="event" value="sites.ehSite.doSaveNotes">
		<table width="100%">
			<tr>
				<td width="100"><strong>Site Name:</strong></td>
				<td>#oSiteInfo.getsitename()#</td>
			</tr>	
			<tr>
				<td width="100"><strong>Site URL:</strong></td>
				<td>#oSiteInfo.getpath()#</td>
			</tr>
			<tr>
				<td width="100"><strong>Create Date:</strong></td>
				<td>#oSiteInfo.getcreatedDate()#</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2"><strong>Notes:</strong></td>
			</tr>

			<cfset tmp = oSiteInfo.getnotes()>
			<cfif stAccessMap.saveNotes>
				<tr>
					<td colspan="2">
						<textarea name="notes" id="notesField">#tmp#</textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="buttonImage btnSmall">
							<a href="##" onclick="frmNotes.submit()">Apply</a>
						</div>	
					</td>
				</tr>
			<cfelse>
				<cfif tmp eq ""><cfset tmp = "<em>None</em>"></cfif>
				<tr>
					<td colspan="2">
						<div id="notesField" style="overflow:auto;background-color:##fff;">#tmp#</div>
					</td>
				</tr>
			</cfif>
		</table>
	</form>
</cfoutput>