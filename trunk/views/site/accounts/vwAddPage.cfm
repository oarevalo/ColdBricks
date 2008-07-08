<cfparam name="request.requestState.qryAccount" default="">
<cfparam name="request.requestState.aPages" default="">
<cfparam name="request.requestState.aCatalogPages" default="">

<cfscript>
	qryAccount = request.requestState.qryAccount;
	aPages = request.requestState.aPages;
	qryCatalogPages = request.requestState.aCatalogPages;

	// sort account pages
	qryPages = queryNew("href,title");
	for(i=1;i lte arrayLen(aPages);i=i+1) {
		queryAddRow(qryPages);
		querySetCell(qryPages,"href",aPages[i].href);
		querySetCell(qryPages,"title",aPages[i].title);
	}
</cfscript>

<cfquery name="qryPages" dbtype="query">
	SELECT *, UPPER(title) AS title_upper
		FROM qryPages
		ORDER BY title_upper
</cfquery>

<cfoutput>
	<p>
	<fieldset class="formEdit">
		<legend><img src="images/page.png" align="absmiddle"> <b>Add a Blank Page</b></legend>
		<p>
			This option allows you to add an empty blank page. Enter
			the name for the new page and click GO.
		</p>
		<form name="frmAdd" action="index.cfm" method="post" style="margin-left:20px;">
			<input type="hidden" name="event" value="ehAccounts.doAddPage">
			Name: 
			<input type="text" name="pageName" value="" style="width:150px;">
			<input type="submit" value="Go">
		</form>
		<em><b>Note:</b> Page names can only contain letters, digits and the underscore ( _ ) symbol</em>
	</fieldset>
	</p>
	<br>
	<p>
	<fieldset class="formEdit">
		<legend><img src="images/page_copy.png" align="absmiddle"> <b>Copy Existing Page</b></legend>
		<p>
			This option creates a duplicate of an existing page on your site. 
			Select from the dropdown menu the page you wish to copy and 
			then click GO.
		</p>
		<form name="frmCopy" action="index.cfm" method="post" style="margin-left:20px;">
			<input type="hidden" name="event" value="ehAccounts.doCopyPage">

			<div style="border:1px solid silver;margin-top:10px;margin-bottom:10px;padding:5px;width:500px;" class="helpBox">
				<input type="checkbox" name="tokenize" value="1"> <strong>Tokenize page.</strong> &nbsp;&nbsp;
				Tokenizing a page allows you to define Tokens or keywords on an existing page so that multiple copies of
				that page can be created each one with different values for the defined tokens.
			</div>

			Select page to copy:
			<select name="pageHREF">
				<cfloop query="qryPages">
					<option value="#qryPages.href#">#qryPages.title#</option>
				</cfloop>
			</select>
			&nbsp;&nbsp;&nbsp;
			No. of Copies:
			<input type="text" name="numCopies" value="1" style="width:30px;">
			<input type="submit" value="Go"><br>
		</form>
	</fieldset>
	</p>
	<br>

	<p>
	<fieldset class="formEdit">
		<legend><img src="images/folder_page.png" align="absmiddle"> <b>Add Page From Resource Library</b></legend>
		<p>
			This option adds a new page to a site from a page stored in the resource library. 
			Select from the dropdown menu the page you wish to add and 
			then click GO.
		</p>
		<cfif qryCatalogPages.recordCount gt 0>
			<form name="frmCatalog" action="index.cfm" method="post" style="margin-left:20px;">
				<input type="hidden" name="event" value="ehAccounts.doAddPageResource">
				Select page to add:
				<select name="resourceID">
					<cfloop query="qryCatalogPages">
						<option value="#qryCatalogPages.id#">#qryCatalogPages.id#</option>
					</cfloop>
				</select>
				<input type="submit" value="Go">
			</form>
		<cfelse>
			<em>There are no pages on the resource library. <a href="index.cfm?event=ehResources.dspMain&resType=page&id=NEW">Click Here</a> to create a new page resource.</em>
		</cfif>
	</fieldset>
	</p>
	
	<p>
		<input type="button" name="btnCancel" value="Return To Accounts Manager" onClick="document.location='?event=ehAccounts.dspMain'">
	</p>
</cfoutput>