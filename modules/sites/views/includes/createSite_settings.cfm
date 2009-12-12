<cfparam name="request.requestState.name" default="">
<cfparam name="request.requestState.appRoot" default="">
<cfparam name="request.requestState.siteTemplate" default="">
<cfparam name="request.requestState.aSites" default="">

<cfset name = request.requestState.name>
<cfset appRoot = request.requestState.appRoot>
<cfset siteTemplate = request.requestState.siteTemplate>
<cfset aSites = request.requestState.aSites>

<cfif siteTemplate neq "">
	<cfloop from="1" to="#arrayLen(aSites)#" index="i">
		<cfif aSites[i].name eq siteTemplate>
			<cfset thisSite = aSites[i]>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfoutput>
	<table cellspacing="5">
		<cfif siteTemplate neq "">
			<tr>
				<td width="60">
					<strong>Site Template:</strong><br>
				</td>
				<td style="color:##999;font-weight:bold;font-size:12px;" id="siteTemplate2">#thisSite.title# (#siteTemplate#)</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>#thisSite.description#</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</cfif>
		<tr>
			<td colspan="2">
				<strong>Site Name:</strong>
				<div style="color:##666;line-height:18px;width:600px;">
					Enter a name to identify the new site. Name must contain only letters, digits, and underscore.
				</div>
			</td>
		</tr>
		<tr valign="top">
			<td width="100">&nbsp;</td>
			<td>
				<input type="text" id="name" name="name" value="#name#" size="50" class="formField" onkeyup="onChangeSiteName(this.value)"> 
				&nbsp; <span style="color:red;font-weight:bold;">required</span>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2">
				<strong>Application Root:</strong>
				<div style="color:##666;line-height:18px;width:600px;">
					Enter the URL path to where the new site will be deployed. Paths are always relative
					to the web root. 
				</div>
			</td>
		</tr>
		<tr valign="top">
			<td>&nbsp;</td>
			<td>
				<input type="text" id="appRoot" name="appRoot" value="#appRoot#" size="50" class="formField" <cfif name eq "">disabled="true"</cfif>> 
				&nbsp; <span style="color:red;font-weight:bold;">required</span><br />
				<input type="checkbox" name="deployToWebRoot" id="deployToWebRoot" value="1"  <cfif name eq "">disabled="true"</cfif> onclick="onChangeDeployToRoot(this.checked)" >
				<span style="color:##666;line-height:18px;">Deploy site to web root?</span>
			</td>
		</tr>
		<cfif siteTemplate eq "">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2">
					<strong>Content Root:</strong>
					<div style="color:##666;line-height:18px;width:600px;">
						Enter the URL path to the location where content pages for the new site will be stored.
						Typically this is a folder located inside the application's directory.
					</div>
				</td>
			</tr>
			<tr valign="top">
				<td>&nbsp;</td>
				<td>
					<input type="text" id="contentRoot" name="contentRoot" value="" size="50" class="formField" <cfif name eq "">disabled="true"</cfif>> 
					&nbsp; <span style="color:red;font-weight:bold;">required</span>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2">
					<strong>Resource Library Root:</strong>
					<div style="color:##666;line-height:18px;width:600px;">
						Resource Library root is the path to the location of the resources library you wish to use for
						this site. A resource library contains all reusable content that is used to create a site, such as
						modules, skins, contents, feeds, etc. 
						Paths are always relative to the web root. 
					</div>
				</td>
			</tr>		
			<tr valign="top">
				<td>&nbsp;</td>
				<td>
					<input type="radio" name="useDefault_rl" value="1" checked="true"> <input type="text" id="resourcesRoot" name="resourcesRoot" value="" size="50" class="formField" disabled="true"><br />
					<input type="radio" name="useDefault_rl" value="0"> <em>None</em> <br />
				</td>
			</tr>
		</cfif>
	</table>				

	<br>
	<p>
		<input type="button" name="btnBack" value="<< Back" onclick="document.location='index.cfm?event=sites.ehSites.dspCreate'">&nbsp;
		<input type="submit" name="btn" value="Create Site" style="font-weight:bold;" id="btnCreate" <cfif name eq "">disabled="true"</cfif>>
	</p>
</cfoutput>
