<cfparam name="request.requestState.accountName" default="">
<cfparam name="request.requestState.accountID" default="">
<cfparam name="request.requestState.accountsRoot" default="">
<cfparam name="request.requestState.numPages" default="">
<cfparam name="request.requestState.appRoot" default="">

<cfscript>
	accountName = request.requestState.accountName;
	accountID = request.requestState.accountID;
	accountsRoot = request.requestState.accountsRoot;
	numPages = request.requestState.numPages;
	appRoot = request.requestState.appRoot;
	
	if(appRoot eq "/")
		tmpAppURL = "/index.cfm?account=#accountName#";
	else
		tmpAppURL = appRoot & "/index.cfm?account=#accountName#";
	
</cfscript>

<!--- calculate account size --->
<cfset tmpPath = accountsRoot & "/" & accountName>
<cfdirectory action="list" name="qry" directory="#ExpandPath(tmpPath)#" recurse="true">
<cfset accountSize = arraySum(listToArray(valueList(qry.size)))>
<cfset accountSizeKB = accountSize/1024>

<cfoutput>
	<div style="margin:10px;">
		<strong>Username:</strong> 	#accountName#
	
		<div style="margin-top:10px;">
			<strong>Account Directory:</strong><br>
			#accountsRoot#/#accountName#/
			<!--- <a href="?event=ehAccounts.dspFileManager&accountID=#accountID#" style="color:blue !important;">[View Files]</a> --->
		</div>
		
		<div style="margin-top:10px;">
			<strong>Pages:</strong> #numPages# <br>
			<strong>Space Used:</strong> #decimalformat(accountSizeKB)# KB<br>
		</div>
		
		<div style="line-height:24px;margin-top:10px;">
			<img src="images/user_edit.png" align="absmiddle">&nbsp; <a href="?event=ehAccounts.dspEdit&accountID=#accountID#" style="color:blue !important;">Edit Profile</a><br>
			<img src="images/waste_small.gif" align="absmiddle">&nbsp; <a href="##" onclick="deleteAccount('#accountID#')" style="color:blue !important;">Delete Account</a><br>
			<img src="images/page_link.png" align="absmiddle">&nbsp; <a href="#tmpAppURL#" style="color:blue !important;" target="_blank">Go to Account Site</a><br>
		</div>		
	</div>
</cfoutput>