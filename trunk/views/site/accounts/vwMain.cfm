<cfparam name="request.requestState.qryAccounts" default="">
<cfparam name="request.requestState.accountsRoot" default="">
<cfparam name="request.requestState.showAccount" default="false">
<cfparam name="request.requestState.accountID" default="">

<cfscript>
	qryAccounts = request.requestState.qryAccounts;
	accountsRoot = request.requestState.accountsRoot;
	showAccount = request.requestState.showAccount;
	accountID = request.requestState.accountID;
</cfscript>

<cfquery name="qryAccounts" dbtype="query">
	SELECT *
		FROM qryAccounts
		ORDER BY username
</cfquery>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<script type="text/javascript" src="includes/js/accountEditor.js"></script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">


<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td width="200">
			<div class="cp_sectionTitle" id="cp_pd_moduleProperties_Title" 
					style="width:200px;padding:0px;margin:0px;">
				<div style="margin:2px;">
					<img src="images/folder_brick.png" align="absmiddle"> Accounts (#qryAccounts.recordCount#)
				</div>
			</div>
			<div style="border-bottom:1px solid black;background-color:##ccc;text-align:left;line-height:22px;font-size:11px;">
				<img src="images/add.png" align="absmiddle" style="margin-left:5px;"> 
				<a href="index.cfm?event=ehAccounts.dspCreate" style="font-weight:bold;">Create Account</a>
			</div>
			<div class="cp_sectionBox" 
				style="margin-top:0px;width:200px;padding:0px;height:430px;margin-right:0px;margin-left:0px;border-top:0px;">
				<div id="accountsTree" style="margin:5px;">
					<cfloop query="qryAccounts">
						<cfset tmpHREF = "javascript:loadAccount('#qryAccounts.userID#','#qryAccounts.username#')">
						<div>
							<img src="images/folder.png" align="absmiddle" class="accountTreeItemImage" id="accountTreeItemImage_#qryAccounts.userID#"> 
							<a href="#tmpHREF#" class="accountTreeItem" 
								style="font-weight:normal;"
								alt="Click to view account's pages"
								title="Click to view account's pages"
								id="accountTreeItem_#qryAccounts.userID#">#username#</a>
						</div>
					</cfloop>
				</div>
			</div>			
		</td>
		<td>
			<div style="margin-left:10px;margin-right:10px;" id="accountMainPanel">
				<div style="background-color:##fff;height:470px;border:1px dashed ##ccc;margin-top:5px;overflow:auto;">
					<div style="line-height:24px;margin:30px;font-size:14px;">
					
						<img src="images/quick_start.gif"><br><br>
					
						&bull; All pages in a site are grouped in Accounts. Each account can group multiple pages and be managed
							independently from the others.<br><br>
	
						&bull; Select from the list on the left the account you wish to manage. When you click on the account name
							all pages within the account will be displayed.<br><br>
							
						&bull; Click on <a href="index.cfm?event=ehAccounts.dspCreate">Create Account</a> to add a new account to the site.<br><br>
						
						&bull; <b>Did you know?</b> Each account has a username and password so that you can create personalized mini-sites
							for multiple users within the same site.
							
					</div>
				</div>
			</div>
		</td>
		<td width="200">
			<!--- Account Info --->
			<div class="cp_sectionTitle" 
					style="width:190px;padding:0px;margin:0px;">
				<div style="margin:2px;text-align:left;">
					<img src="images/house.png" align="absmiddle">
					Account Information
				</div>
			</div>
			<div class="cp_sectionBox" 
				style="margin-top:0px;width:190px;padding:0px;height:205px;margin-top:0px;margin-right:0px;border-top:0px;">
				<div id="accountInfoPanel" style="margin:0px;text-align:left;">
					<p align="center"><bR>
						Select an account from the accounts tree to view more information
					</p>
				</div>
			</div>

			<!--- Page Info --->
			<div class="cp_sectionTitle" 
					style="width:190px;padding:0px;margin:0px;margin-top:10px;">
				<div style="margin:2px;text-align:left;">
					<img src="images/page.png" align="absmiddle">
					Page Information
				</div>
			</div>
			<div class="cp_sectionBox" 
				style="margin-top:0px;width:190px;padding:0px;height:205px;margin-top:0px;margin-right:0px;border-top:0px;">
				<div id="pageInfoPanel" style="margin:0px;text-align:left;">
					<p align="center"><bR>
						Select a page from the pages view to view information
					</p>
				</div>
			</div>

		</td>
	</tr>
</table>

<!--- load selected account (if any) --->
<cfif showAccount>
	<script type="text/javascript">
		loadAccount("#accountID#","");
	</script>
</cfif>

</cfoutput>
