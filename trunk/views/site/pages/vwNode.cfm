<cfparam name="request.requestState.contentRoot" default="">
<cfparam name="request.requestState.pageName" default="">
<cfparam name="request.requestState.path" default="">
<cfparam name="request.requestState.oUser" default="">

<cfset contentRoot = request.requestState.contentRoot>
<cfset pageName = request.requestState.pageName>
<cfset path = request.requestState.path>
<cfset oUser = request.requestState.oUser>

<cfscript>
	isFile = true;
	
	// correct paths
	if(not isFile and right(path,1) neq "/") path = path & "/";
	if(right(contentRoot,1) neq "/") contentRoot = contentRoot & "/";

	path = replace(path,"//","/","all");
	
	// check if the user is allowed to edit pages
	stAccessMap = oUser.getAccessMap();
	allowedToEditPages = stAccessMap.pages;
</cfscript>

<cfoutput>

	<div style="font-size:16px;margin:10px;">
		<b>Path:</b>
		#path#
		<cfif path neq appRoot>
			(<img src="images/waste_small.gif" align="absmiddle"> <a href="##" onclick="deleteNode('#jsstringformat(path)#')" style="font-size:11px;"><strong>Delete</strong></a>)
		</cfif>
	</div>

	<form name="frmCreateDir1" method="post" action="index1.cfm" style="margin-left:20px;">
	</form>


	<cfif not isFile>
		<div style="margin:10px;margin-top:20px;">
		<fieldset class="formEdit" style="width:480px;">
			<legend><img src="images/folder.png" align="absmiddle"> <b>Create Folder</b></legend>

			<form name="frmCreateDir" method="post" action="index.cfm" style="margin-left:20px;">
				<input type="hidden" name="event" value="ehPages.doCreateDirectory">
				<input type="hidden" name="path" value="#path#">
				<table align="center">
					<tr>
						<td><b>Name:</b></td>
						<td>
							<input type="text" name="name" value="" size="50" class="formField" style="width:310px;">
							<input type="submit" name="btnSave" value="Apply">
						</td>
					</tr>
				</table>
			</form>
		</fieldset>
		</div>

		<div style="margin:10px;margin-top:20px;">
		<fieldset class="formEdit" style="width:480px;">
			<legend><img src="images/page_add.png" align="absmiddle"> <b>Create Page</b></legend>
			<form name="frmCreateFile" method="post" action="index.cfm">
				<input type="hidden" name="path" value="#path#">
					
				<table align="center">
					<tr>
						<td><b>Name:</b></td>
						<td>
							<input type="text" name="page" value="" size="50" class="formField">
						</td>
					</tr>
				</table>
				<br>
				&nbsp;&nbsp;<input type="button" name="btnSave" value="Create Page" 
									onclick="doFormEvent('ehPages.doCreatePage','nodePanel',this.form)">
			</form>
		</fieldset>
		</div>
	<cfelseif isFile and pageName neq "">
		<!--- this is a file that was successfully parsed --->

		<div style="margin:10px;margin-top:20px;">
			this is a page
		</div>
	<cfelse>
		<div style="margin:10px;">
			Select a directory node to either create subdirectories or new file mappings.
		</div>
	</cfif>

</cfoutput>