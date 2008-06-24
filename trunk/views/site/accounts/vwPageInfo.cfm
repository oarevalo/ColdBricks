<cfparam name="request.requestState.stPage" default="">
<cfparam name="request.requestState.appRoot" default="">
<cfparam name="request.requestState.accountName" default="">
<cfparam name="request.requestState.pageExists" default="">

<cfset stPage = request.requestState.stPage>
<cfset appRoot = request.requestState.appRoot>
<cfset accountName = request.requestState.accountName>
<cfset pageExists = request.requestState.pageExists>

<cfscript>
	if(isStruct(stPage)) {
		thisPageHREF = stPage.href;
		fileName = getFilefromPath(thisPageHREF);
		fileName = listDeleteAt(fileName, listlen(fileName,"."), ".");
	
		if(appRoot eq "/")
			tmpPageURL = "/index.cfm?account=#accountName#&page=#fileName#";
		else
			tmpPageURL = appRoot & "/index.cfm?account=#accountName#&page=#fileName#";
	}
</cfscript>

<cfoutput>

<div style="margin:10px;">
	<cfif isStruct(stPage)>
		<div style="margin-top:5px;">
			<div style="font-size:10px;color:##999;">Title:</div>
			#stPage.title#
		</div>
		
		<div style="margin-top:5px;">
			<div style="font-size:10px;color:##999;">Filename:</div>
			#stPage.href#
		</div>
		
		<div style="margin-top:5px;">
			<span style="font-size:10px;color:##999;">Is Default Page?:</span> #yesNoFormat(stPage.default)#
		</div>
	
		<br>
		<cfif pageExists>
			<div style="line-height:20px;">
				<img src="images/page_edit.png" align="absmiddle">&nbsp; <a href="index.cfm?event=ehPage.dspMain&page=#stPage.href#" style="color:blue !important;font-weight:bold;">Open page editor</a><br>
				<img src="images/page_link.png" align="absmiddle">&nbsp; <a href="#tmpPageURL#" style="color:blue !important;" target="_blank">View Page in Browser</a><br>
				<img src="images/page_lightning.png" align="absmiddle">&nbsp; <a href="index.cfm?event=ehAccounts.doSetDefaultPage&page=#stPage.href#" style="color:blue !important;">Set as default page</a><br>
				<img src="images/waste_small.gif" align="absmiddle">&nbsp; <a href="##" onclick="deletePage('#jsstringformat(stPage.href)#')" style="color:blue !important;">Delete Page</a><br>
			</div>
		<cfelse>
			<div style="color:red">
				The requested page cannot be found. The page may have been deleted from outside ColdBricks.
				Use the link below to remove the page from the directory.<br><br>
			</div>
			<img src="images/waste_small.gif" align="absmiddle">&nbsp; <a href="##" onclick="deletePage('#jsstringformat(stPage.href)#')" style="color:blue !important;">Delete Page</a><br>
		</cfif>
	<cfelse>
		<p align="center"><bR>
			Select a page from the pages view to view information
		</p>		
	</cfif>
</div>

</cfoutput>