<cfparam name="request.requestState.aStatus" default="">
<cfparam name="request.requestState.pageHREF" default="">
<cfparam name="request.requestState.numCopies" default="">
<cfparam name="request.requestState.numTokens" default="3">
<cfparam name="request.requestState.qryAccount" default="">
<cfparam name="request.requestState.appRoot" default="">

<cfset aStatus = request.requestState.aStatus>
<cfset pageHREF = request.requestState.pageHREF>
<cfset numCopies = request.requestState.numCopies>
<cfset numTokens = request.requestState.numTokens>
<cfset qryAccount = request.requestState.qryAccount>
<cfset appRoot = request.requestState.appRoot>

<cfoutput>
	<cfmodule template="../../../includes/menu_site.cfm" title="Accounts > #qryAccount.username# > Tokenize Page Results">

	<b>Source Page:</b> #pageHREF#<br>
	<b>Number of Copies:</b> #numCopies#<Br>
	<b>Number of Tokens:</b> #numTokens#<Br><br>

	<table style="width:600px;;border:1px solid silver;" class="dataFormTable">
		<tr>
			<th style="background-color:##ccc;width:30px;">No.</th>
			<th style="background-color:##ccc;">Page Name</th>
			<th style="background-color:##ccc;width:75px;">Status</th>
			<th style="background-color:##ccc;">Error Message</th>
			<th style="background-color:##ccc;">Page URL</th>
		</tr>
		<cfloop from="1" to="#arrayLen(aStatus)#" index="i">
			<tr <cfif i mod 2>class="altRow"</cfif>>
				<td style="width:30px;" align="right"><strong>#i#.</strong></td>
				<td>#aStatus[i].pageName#</td>
				<td align="center">
					<cfif aStatus[i].error>
						<span style="color:red;font-weight:bold;">Error</span>
					<cfelse>
						<span style="color:green;font-weight:bold;">OK</span>
					</cfif>
				</td>
				<td>#aStatus[i].errorMessage#</td>
				<td align="center">
					<cfif not aStatus[i].error>
						<cfset href = getFileFromPath(aStatus[i].url)>
						<cfset fileName = listDeleteAt(href, listlen(href,"."), ".")>
						<cfif appRoot eq "/">
							<cfset tmpPageURL = "/index.cfm?account=#qryAccount.username#&page=#fileName#">
						<cfelse>
							<cfset tmpPageURL = appRoot & "/index.cfm?account=#qryAccount.username#&page=#fileName#">
						</cfif>	
						<a href="index.cfm?event=ehPage.dspMain&page=#href#"><img src="images/page_edit.png" align="absmiddle" alt="Edit page" title="Edit page" border="0"></a>
						<a href="#tmpPageURL#" target="_blank"><img src="images/page_link.png" align="absmiddle" alt="Open page in browser" title="Open page in browser" border="0"></a>
						<a href="#aStatus[i].url#" target="_blank"><img src="images/page_code.png" align="absmiddle" alt="View page XML" title="View page XML" border="0"></a>
					<cfelse>
						N/A
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
	<br>
	<p>
		<input type="button" name="btnCancel" value="Return To Account Manager" onClick="document.location='?event=ehAccounts.dspMain'"> &nbsp;&nbsp;
		<input type="button" name="btnCancel" value="Return To Tokenize Page" onClick="document.location='?event=ehAccounts.dspTokenizePage&pageHREF=#urlEncodedFormat(pageHREF)#&numCopies=#numCopies#&numTokens=#numTokens#'">
	</p>

</cfoutput>
