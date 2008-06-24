<cfparam name="request.requestState.pageHREF" default="">
<cfparam name="request.requestState.numCopies" default="">
<cfparam name="request.requestState.numTokens" default="3">
<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.qryAccount" default="">

<cfinclude template="../../../includes/udf.cfm">

<cfset pageHREF = request.requestState.pageHREF>
<cfset numCopies = request.requestState.numCopies>
<cfset numTokens = request.requestState.numTokens>
<cfset oPage = request.requestState.oPage>
<cfset qryAccount = request.requestState.qryAccount>

<cfset xmlContent = oPage.getXML()>
<cfset xmlContent = xmlPrettyPrint( xmlContent.xmlRoot )>
<cfset title = oPage.getPageTitle()>

<cfoutput>
	<cfmodule template="../../../includes/menu_site.cfm" title="Accounts > #qryAccount.username# > Tokenize Page">

	<form name="frm" method="post" action="index.cfm">
		<input type="hidden" name="event" value="ehAccounts.doCopyTokenizedPage">
		<input type="hidden" name="pageHREF" value="#getFileFromPath(pageHREF)#">

		<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="8" cellspacing="0">
			<tr>
				<td>
					<strong>Title:</strong> #title#
				</td>
				<td>
					No. of Copies: <input type="text" name="numCopies" size="3" value="#numCopies#" onchange="this.form.event.value='ehAccounts.dspTokenizePage';this.form.submit()">
				</td>
				<td>
					No. of Tokens: 
					<select name="numTokens" onchange="this.form.event.value='ehAccounts.dspTokenizePage';this.form.submit()">
						<cfloop from="1" to="10" index="i">
							<option value="#i#" <cfif numTokens eq i>selected</cfif>>#i#</option>
						</cfloop>
					</select>
				</td>
			</tr>
		</table>
	
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr valign="top">
				<td>	
					<!--- show xml edit area --->
					<textarea name="xmlContent"  
								onkeypress="checkTab(event)" 
								onkeydown="checkTabIE()"				
								class="codeEditor" style="height:300px;"
								wrap="off">#xmlContent#</textarea>
				
					<br><br>
					<!--- show tokens datagrid --->
					<table class="tblGrid" style="width:95%">
						<tr>
							<th>No</th>
							<th>Page Name</th>
							<cfloop from="1" to="#numTokens#" index="i">
								<th align="center">%#i#</th>
							</cfloop>
						</tr>
						<cfloop from="1" to="#numCopies#" index="i">
							<cfset tmpDefaultName = "Copy #i# of " & getFileFromPath(pageHREF)>
							<tr>
								<td style="width:30px;"><strong>#i#.</strong></td>
								<td style="width:150px;"><input type="text" name="name_#i#" value="#tmpDefaultName#" style="width:150px;font-size:10px;"></td>
								<cfloop from="1" to="#numTokens#" index="j">
									<td align="center"><input type="text" name="token_#i#_#j#" value="" style="width:#500/numTokens#px;font-size:10px;"></td>
								</cfloop>
							</tr>
						</cfloop>
					</table>
									
				</td>
				<td width="200">
					<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
						<div style="margin:10px;">
							<h2>Tokenize Page</h2>
							<p>
								Tokenizing a page allows you to define Tokens or keywords on an existing page so that multiple copies of
								that page can be created each one with different values for the defined tokens.
							</p>
							<p>
								To insert a token locate the section of the code you wish to be changed and replace it with <strong>%1 </strong>(for the first
								token, <strong>%2</strong> for the second, and so on). Then, use the table below to assign the value each token should have on
								each of the copies of the page.
							</p>
							<p>
								When all tokens and values have been assigned, click on <b>Create Pages</b> to create the copies.
							</p>
						</div>
					</div>
				</td>
				
			</tr>
		</table>
				

		<p>
			<input type="button" name="btnCancel" value="Return" onClick="document.location='?event=ehAccounts.dspAddPage'">
			&nbsp;&nbsp;
			<input type="submit" name="btnSave" value="Create Pages">
		</p>
	
	</form>

</cfoutput>


