<cfparam name="request.requestState.stPage" default="">
<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.path" default="">
<cfparam name="request.requestState.pageExists" default="">
<cfparam name="request.requestState.appRoot" default="">

<cfset stPage = request.requestState.stPage>
<cfset oPage = request.requestState.oPage>
<cfset path = request.requestState.path>
<cfset pageExists = request.requestState.pageExists>
<cfset appRoot = request.requestState.appRoot>

<cfscript>
	if(isStruct(stPage)) {

		if(appRoot eq "/")
			tmpPageURL = "/index.cfm?page=#path#";
		else
			tmpPageURL = appRoot & "/index.cfm?page=#path#";
	}
</cfscript>

<cfoutput>

<div style="margin:10px;">
	<cfif pageExists>
		<div style="margin-top:5px;">
			<div style="font-size:10px;color:##999;">Title:</div>
			#oPage.getTitle()#
		</div>
		
		<div style="margin-top:5px;">
			<div style="font-size:10px;color:##999;">Path:</div>
			#path#
		</div>
		
		<br>
		<cfif pageExists>
			<div style="line-height:20px;">
				<img src="images/page_edit.png" align="absmiddle">&nbsp; <a href="index.cfm?event=ehPage.dspMain&page=#path#" style="color:blue !important;font-weight:bold;">Open page editor</a><br>
				<img src="images/page_link.png" align="absmiddle">&nbsp; <a href="#tmpPageURL#" style="color:blue !important;" target="_blank">View Page in Browser</a><br>
				<img src="images/waste_small.gif" align="absmiddle">&nbsp; <a href="##" onclick="deletePage('#jsstringformat(path)#')" style="color:blue !important;">Delete Page</a><br>
			</div>
		<cfelse>
			<div style="color:red">
				The requested page cannot be found. The page may have been deleted from outside ColdBricks.
				Use the link below to remove the page from the directory.<br><br>
			</div>
			<img src="images/waste_small.gif" align="absmiddle">&nbsp; <a href="##" onclick="deletePage('#jsstringformat(path)#')" style="color:blue !important;">Delete Page</a><br>
		</cfif>
	<cfelse>
		<p align="center"><bR>
			Select a page from the pages view to view information
		</p>		
	</cfif>
</div>

</cfoutput>