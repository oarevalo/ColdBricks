<cfparam name="request.requestState.oSiteInfo" default="">
<cfparam name="request.requestState.stResourceTypes" default="">
<cfparam name="request.requestState.qryResources" default="">
<cfparam name="request.requestState.qryAccounts" default="">
<cfparam name="request.requestState.appRoot" default="">
<cfparam name="request.requestState.defaultAccount" default="">
<cfparam name="request.requestState.qlAccount" default="">
<cfparam name="request.requestState.aPages" default="">
<cfparam name="request.requestState.firstTime" default="false">
<cfparam name="request.requestState.aPlugins" default="">
<cfparam name="request.requestState.oUser" default="">
<cfparam name="request.requestState.qryUserPlugins" default="">
<cfparam name="request.requestState.hasAccountsPlugin" default="false">


<cfset oSiteInfo = request.requestState.oSiteInfo>
<cfset stResourceTypes = request.requestState.stResourceTypes>
<cfset qryResources = request.requestState.qryResources>
<cfset qryAccounts = request.requestState.qryAccounts>
<cfset appRoot = request.requestState.appRoot>
<cfset defaultAccount = request.requestState.defaultAccount>
<cfset qlAccount = request.requestState.qlAccount>
<cfset aPages = request.requestState.aPages>
<cfset firstTime = request.requestState.firstTime>
<cfset aPlugins = request.requestState.aPlugins>
<cfset oUser = request.requestState.oUser>
<cfset qryUserPlugins = request.requestState.qryUserPlugins>
<cfset hasAccountsPlugin = request.requestState.hasAccountsPlugin>

<cfset siteID = oSiteInfo.getID()>
<cfset stAccessMap = oUser.getAccessMap()>

<cfset lstUserPlugins = valueList(qryUserPlugins.pluginID)>

<cfset showAllModules = (oUser.getRole() eq "admin" or oUser.getRole() eq "mngr")>

<!--- sort accounts --->
<cfif hasAccountsPlugin>
	<cfquery name="qryAccounts" dbtype="query">
		SELECT *, upper(accountName) as u_username
			FROM qryAccounts
			ORDER BY u_username
	</cfquery>
</cfif>

<!--- get resource count by type --->
<cfquery name="qryResCount" dbtype="query">
	SELECT type, count(*) as resCount
		FROM qryResources
		GROUP BY type
		ORDER BY type
</cfquery>

<!--- index results into a struct --->
<cfset stResCount = structNew()>
<cfloop query="qryResCount">
	<cfset stResCount[qryResCount.type] = qryResCount.resCount>
</cfloop>

<cfscript>
	aOptions = [
		{
			href = "index.cfm?event=ehSite.doLoadHomePage",
			help = "This shortcut allows you to quickly access and edit the initial page (or 'Home Page') of your site.",
			imgSrc = "images/homepage_48x48.png",
			alt = "Edit Site's Home Page",
			label = "Home Page",
			isAllowed = stAccessMap.pages
		},
		{
			href = "index.cfm?event=ehPages.dspMain",
			help = "The pages module lets you manage all pages in a site.",
			imgSrc = "images/documents_48x48.png",
			alt = "Manage site pages",
			label = "Pages",
			isAllowed = stAccessMap.pages
		},
		{
			href = "index.cfm?event=ehAccounts.dspMain",
			help = "Pages can also be grouped into accounts. Use the Accounts module to add, modify or delete pages from a site.",
			imgSrc = "images/users_48x48.png",
			alt = "Manage accounts",
			label = "Accounts",
			isAllowed = hasAccountsPlugin and stAccessMap.accounts
		},
		{
			href = "index.cfm?event=ehResources.dspMain",
			help = "The Resource Library module contains all reusable elements that can be used in sites and pages. Available resource types include modules, feeds, skins, page templates, content articles and HTML blocks.",
			imgSrc = "images/folder2_yellow_48x48.png",
			alt = "Resource Management",
			label = "Resources",
			isAllowed = stAccessMap.resources
		},
		{
			href = "index.cfm?event=ehSiteMap.dspMain",
			help = "The SiteMap Tool allows you to create friendlier URLs to the pages on the site. It works by creating directories and files that act as placeholders that can be linked to existing pages on the site.",
			imgSrc = "images/Globe_48x48.png",
			alt = "Site Map Tool",
			label = "Site Map",
			isAllowed = stAccessMap.siteMap
		},
		{
			href = "index.cfm?event=ehSiteConfig.dspMain",
			help = "For greater control and customization of your site, use the Settings module to manually edit the HomePortals XML configuration files",
			imgSrc = "images/configure_48x48.png",
			alt = "Site Settings",
			label = "Settings",
			isAllowed = stAccessMap.siteSettings
		},
		{
			href = "index.cfm?event=ehSites.doArchiveSite&siteID=#siteID#",
			help = "Download a zipped version of this site for backup or migration",
			imgSrc = "images/download_manager_48x48.png",
			alt = "Download Site",
			label = "Download",
			isAllowed = stAccessMap.downloadSite
		}	
	];
	
	for(i=1;i lte arrayLen(aPlugins);i=i+1) {
		oPlugin = aPlugins[i];
		tmpID = oPlugin.getID();
		
		if(showAllModules or listFind(lstUserPlugins,tmpID)) {
			tmpEvent = oPlugin.getModuleName() & "." & oPlugin.getDefaultEvent();
			tmpName = oPlugin.getName();
			tmpImage = oPlugin.getPath() & "/" & oPlugin.getIconSrc();
			tmpDesc = oPlugin.getDescription();

			if(oPlugin.getIconSrc() eq "") tmpImage = "images/cb-blocks.png";
			if(tmpDesc eq "") tmpDesc = "<em>No description available</em>";

			st = {
				href = "index.cfm?event=#tmpEvent#",
				help = tmpDesc,
				imgSrc = tmpImage,
				alt = "Plugin: #tmpName#",
				label = tmpName
			};
			
			arrayAppend(aOptions, duplicate(st));
		}
	}
</cfscript>


<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<link href="includes/css/dashboard.css" rel="stylesheet" type="text/css">
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>
		
<table width="100%" cellpadding="0" cellspacing="0" style="margin-top:10px;">
	<tr valign="top">
		<td width="200">
			<div class="dsb_siteSection" style="width:150px;padding:0px;">
				<div class="buttonImage btnLarge">
					<a href="#appRoot#" target="_blank" title="Open site in a different window"><img src="images/magnifier.png" border="0" align="absmiddle"> Preview Site</a>
				</div>	


				<div class="buttonImage btnLarge">
					<!--- fix appRoot for sites at root level --->
					<cfif appRoot eq "/">
						<cfset tmpAppRoot = "">
					<cfelse>
						<cfset tmpAppRoot = appRoot>
					</cfif>
					<a href="#tmpAppRoot#/index.cfm?refreshApp=1" target="_blank" title="Open the site reloading site settings"><img src="images/arrow_refresh.png" border="0" align="absmiddle"> Reset Site</a>
				</div>	
			</div>
			
			<cfif hasAccountsPlugin and stAccessMap.accounts>
				<div id="dsb_siteAccounts" style="margin-top:25px;">
					<div class="dsb_secTitle">Accounts Summary:</div>
					<div class="dsb_siteSection">
						<strong>No of Accounts:</strong> #qryAccounts.recordCount#<br><br>
						<strong>Default Account:</strong> #defaultAccount#<br><br>
						<img src="images/add.png" align="absmiddle"> <a href="index.cfm?event=ehAccounts.dspCreate"> Create Account</a>
					</div>
				</div>
			</cfif>
			
			<cfif stAccessMap.resources>
				<div id="dsb_siteResources" style="margin-top:35px;">
					<div class="dsb_secTitle">Resources Summary:</div>
					<div class="dsb_siteSection">
						<cfset lstResTypes = structKeyList(stResourceTypes)>
						<cfset lstResTypes = listSort(lstResTypes,"textnocase","asc")>
						<cfloop list="#lstResTypes#" index="key">
							<cfscript>
								switch(key) {
									case "module": imgSrc = "images/brick.png"; break;
									case "content": imgSrc = "images/folder_page.png"; break;
									case "feed": imgSrc = "images/feed-icon16x16.gif"; break;
									case "skin": imgSrc = "images/css.png"; break;
									case "page": imgSrc = "images/page.png"; break;
									case "pageTemplate": imgSrc = "images/page_code.png"; break;
									case "html": imgSrc = "images/html.png"; break;
									default:
										imgSrc = "images/folder.png";
								}
							</cfscript>
							<div style="margin-bottom:5px;">
								<img src="#imgSrc#" align="absmiddle"> 
								<a href="index.cfm?event=ehResources.dspMain&resType=#key#" 
									class="resTreeItem" 
									id="resTreeItem_#key#">#stResourceTypes[key].folderName#</a> 
								(<cfif structKeyExists(stResCount,key)>#stResCount[key]#<cfelse>0</cfif>)
							</div>
						</cfloop>
						<cfif lstResTypes eq "">
							<em>No resources found!</em>
						</cfif>
					</div>
				</div>
			</cfif>

		</td>
		<td>
			<cfif isBoolean(firstTime) and firstTime>
				<div class="helpBox" style="padding:15px;font-size:11px;line-height:16px;border:1px solid silver;margin-bottom:20px;margin-right:20px;">
					<div style="font-weight:bold;color:green;font-size:14px;margin-bottom:8px;">Congratulations!</div> 
					You just created a new ColdBricks Site. This screen is called the
					<b>Site Dashboard</b>. From here you have a general overview of your site and 
					have quick access to many features. You can return to this screen at any time by 
					clicking on the <img src="images/house.png" align="absmiddle"> <b><u>dashboard</u></b> link.<br><br>
					To get started, you may want to 
					<a href="index.cfm?event=ehSite.doLoadAccountPage">Edit your HomePage</a>, 
					<cfif hasAccountsPlugin>
						<a href="index.cfm?event=ehAccounts.dspMain">Manage Accounts</a> or
					</cfif>
					<a href="index.cfm?event=ehResources.dspMain">Add/Import Site Resources</a>
				</div>
			</cfif>
			
			<cfset hasModuleAccess = false>
			
			<cf_dashboardMenu title="Site Management:">
				<cfloop from="1" to="#arrayLen(aOptions)#" index="i">
					<cf_dashboardMenuItem attributeCollection="#aOptions[i]#">
				</cfloop>
			</cf_dashboardMenu>
			
		</td>
		<td width="350">
			<cfif hasAccountsPlugin and stAccessMap.pages>
				<div id="dsb_quickLink" style="width:300px;margin-bottom:30px;">
					<div class="dsb_secTitle">Quick Links:</div>
					<div class="dsb_siteSection">
						Use the following dropdowns to quckly access any
						page on this site.<br><br>
						<select name="account" style="width:130px;font-size:10px;border:1px solid silver;" 
								onchange="document.location='index.cfm?event=ehSite.dspMain&qlAccount='+this.value">
							<option value="">-- Select Account --</option>
							<cfloop query="qryAccounts">
								<option value="#qryAccounts.accountname#" <cfif qlAccount eq qryAccounts.accountname>selected</cfif>>#qryAccounts.accountname#</option>
							</cfloop>
						</select>
	
						<cfif qlAccount neq "">
							<select name="page" style="width:130px;font-size:10px;border:1px solid silver;"
									onchange="document.location='index.cfm?event=ehSite.doLoadAccountPage&account=#qlAccount#&page='+this.value">
									<option value="">-- Select Page --</option>
								<cfloop from="1" to="#arrayLen(aPages)#" index="i">
									<option value="#aPages[i]#">#aPages[i]#</option>
								</cfloop>
							</select>
						</cfif>
					</div>
				</div>	
			</cfif>
		
			<div id="dsb_siteInfo">
				<div class="dsb_secTitle">Site Information:</div>
				<form name="frmNotes" method="post" action="index.cfm" style="margin:0px;padding:0px;">
					<input type="hidden" name="event" value="ehSite.doSaveNotes">
					<table class="dsb_siteSection" width="100%">
						<tr>
							<td width="70"><strong>Site Name:</strong></td>
							<td>#oSiteInfo.getsitename()#</td>
						</tr>	
						<tr>
							<td width="70"><strong>Site URL:</strong></td>
							<td>#oSiteInfo.getpath()#</td>
						</tr>
						<tr>
							<td width="70"><strong>Create Date:</strong></td>
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
			</div>	
		</td>
	</tr>
</table>

</cfoutput>
