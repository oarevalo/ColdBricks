<cfparam name="request.requestState.oSiteInfo" default="">
<cfparam name="request.requestState.aResourceTypes" default="">
<cfparam name="request.requestState.qryResources" default="">
<cfparam name="request.requestState.qryAccounts" default="">
<cfparam name="request.requestState.appRoot" default="">
<cfparam name="request.requestState.defaultAccount" default="">
<cfparam name="request.requestState.qlAccount" default="">
<cfparam name="request.requestState.aPages" default="">
<cfparam name="request.requestState.firstTime" default="false">
<cfparam name="request.requestState.aPlugins" default="">
<cfparam name="request.requestState.oUser" default="">

<cfset oSiteInfo = request.requestState.oSiteInfo>
<cfset aResourceTypes = request.requestState.aResourceTypes>
<cfset qryResources = request.requestState.qryResources>
<cfset qryAccounts = request.requestState.qryAccounts>
<cfset appRoot = request.requestState.appRoot>
<cfset defaultAccount = request.requestState.defaultAccount>
<cfset qlAccount = request.requestState.qlAccount>
<cfset aPages = request.requestState.aPages>
<cfset firstTime = request.requestState.firstTime>
<cfset aPlugins = request.requestState.aPlugins>
<cfset oUser = request.requestState.oUser>

<cfset siteID = oSiteInfo.getID()>
<cfset stAccessMap = oUser.getAccessMap()>

<!--- sort accounts --->
<cfquery name="qryAccounts" dbtype="query">
	SELECT *, upper(username) as u_username
		FROM qryAccounts
		ORDER BY u_username
</cfquery>

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


<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<link href="includes/css/dashboard.css" rel="stylesheet" type="text/css">
	<script type="text/javascript">
		function showDBHelp(key) {
			var helpText = "";
			if(key=="homepage") helpText = "This shortcut allows you to quickly access and edit the initial page (or 'Home Page') of your site.";
			if(key=="accounts") helpText = "All pages in a site are grouped into accounts. Use the Accounts module to add, modify or delete pages from a site.";
			if(key=="resources") helpText = "The Resource Library module contains all reusable elements that can be used in sites and pages. Available resource types include modules, feeds, skins, page templates, content articles and HTML blocks.";
			if(key=="siteMap") helpText = "The SiteMap Tool allows you to create friendlier URLs to the pages on the site. It works by creating directories and files that act as placeholders that can be linked to existing pages on the site.";
			if(key=="settings") helpText = "For greater control and customization of your site, use the Settings module to manually edit the HomePortals XML configuration files";
			if(key=="download") helpText = "Download a zipped version of this site for backup or migration";
		
			<cfoutput>
			<cfloop from="1" to="#arrayLen(aPlugins)#" index="i">
				<cfset oPlugin = aPlugins[i]>
				<cfset tmpID = oPlugin.getID()>
				<cfset tmpDesc = oPlugin.getDescription()>
				if(key=="mod_#tmpID#") helpText = "#jsstringFormat(tmpDesc)#";
			</cfloop>
			</cfoutput>		
		
			$("helpTextDiv").style.display = "block";
			$("helpTextDiv").innerHTML = "<img src='images/help.png' align='absmiddle'> " + helpText;
		}
		function hideDBHelp() {
			$("helpTextDiv").style.display = "none";
		}
	</script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>
	
<h2>Site Dashboard</h2>	
	
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
			
			<cfif stAccessMap.accounts>
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
						<div style="margin-bottom:5px;">
							<img src="images/brick.png" align="absmiddle"> <a href="index.cfm?event=ehResources.dspMain&resType=module" class="resTreeItem" id="resTreeItem_module">Modules</a> (<cfif structKeyExists(stResCount,"module")>#stResCount.module#<cfelse>0</cfif>)
						</div>
						<div style="margin-bottom:5px;">
							<img src="images/folder_page.png" align="absmiddle"> <a href="index.cfm?event=ehResources.dspMain&resType=content" class="resTreeItem" id="resTreeItem_content">Content</a> (<cfif structKeyExists(stResCount,"content")>#stResCount.content#<cfelse>0</cfif>)
						</div>
						<div style="margin-bottom:5px;">
							<img src="images/feed-icon16x16.gif" align="absmiddle"> <a href="index.cfm?event=ehResources.dspMain&resType=feed" class="resTreeItem" id="resTreeItem_feed">Feeds</a> (<cfif structKeyExists(stResCount,"feed")>#stResCount.feed#<cfelse>0</cfif>)
						</div>
						<div style="margin-bottom:5px;">
							<img src="images/css.png" align="absmiddle"> <a href="index.cfm?event=ehResources.dspMain&resType=skin" class="resTreeItem" id="resTreeItem_skin">Skins</a> (<cfif structKeyExists(stResCount,"skin")>#stResCount.skin#<cfelse>0</cfif>)
						</div>
						<div style="margin-bottom:5px;">
							<img src="images/page.png" align="absmiddle"> <a href="index.cfm?event=ehResources.dspMain&resType=page" class="resTreeItem" id="resTreeItem_page">Pages</a> (<cfif structKeyExists(stResCount,"page")>#stResCount.page#<cfelse>0</cfif>)
						</div>
						<div style="margin-bottom:5px;">
							<img src="images/page_code.png" align="absmiddle"> <a href="index.cfm?event=ehResources.dspMain&resType=pageTemplate" class="resTreeItem" id="resTreeItem_pageTemplate"> Page Templates</a> (<cfif structKeyExists(stResCount,"pageTemplate")>#stResCount.pageTemplate#<cfelse>0</cfif>)
						</div>
						<div style="margin-bottom:5px;">
							<img src="images/html.png" align="absmiddle"> <a href="index.cfm?event=ehResources.dspMain&resType=html" class="resTreeItem" id="resTreeItem_html">HTML</a> (<cfif structKeyExists(stResCount,"html")>#stResCount.html#<cfelse>0</cfif>)
						</div>
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
					<a href="index.cfm?event=ehAccounts.dspMain">Manage Accounts</a> or
					<a href="index.cfm?event=ehResources.dspMain">Add/Import Site Resources</a>
				</div>
			</cfif>
			
			<div id="dsb_siteManagement">
				<div class="dsb_secTitle">Site Management:</div>

				<cfif stAccessMap.pages>
					<div class="dsb_secBox">
						<a href="index.cfm?event=ehSite.doLoadAccountPage" onmouseover="showDBHelp('homepage')" onmouseout="hideDBHelp()" onfocus="showDBHelp('homepage')" onblur="hideDBHelp()"><img src="images/homepage_48x48.png" border="0" alt="Edit Site's Home Page" title="Edit Site's Home Page"><br>
						<a href="index.cfm?event=ehSite.doLoadAccountPage" onmouseover="showDBHelp('homepage')" onmouseout="hideDBHelp()" onfocus="showDBHelp('homepage')" onblur="hideDBHelp()">Home Page</a>
					</div>
				</cfif>

				<cfif stAccessMap.accounts>
					<div class="dsb_secBox">
						<a href="index.cfm?event=ehAccounts.dspMain" onmouseover="showDBHelp('accounts')" onmouseout="hideDBHelp()" onfocus="showDBHelp('accounts')" onblur="hideDBHelp()"><img src="images/users_48x48.png" border="0" alt="Accounts Management" title="Accounts Management"><br>
						<a href="index.cfm?event=ehAccounts.dspMain" onmouseover="showDBHelp('accounts')" onmouseout="hideDBHelp()" onfocus="showDBHelp('accounts')" onblur="hideDBHelp()">Accounts</a>
					</div>
				</cfif>
		
				<cfif stAccessMap.resources>
					<div class="dsb_secBox">
						<a href="index.cfm?event=ehResources.dspMain" onmouseover="showDBHelp('resources')" onmouseout="hideDBHelp()" onfocus="showDBHelp('resources')" onblur="hideDBHelp()"><img src="images/folder2_yellow_48x48.png" border="0" alt="Resource Management" title="Resource Management"><br>
						<a href="index.cfm?event=ehResources.dspMain" onmouseover="showDBHelp('resources')" onmouseout="hideDBHelp()" onfocus="showDBHelp('resources')" onblur="hideDBHelp()">Resources</a>
					</div>
				</cfif>
		
				<cfif stAccessMap.siteMap>
					<div class="dsb_secBox">
						<a href="index.cfm?event=ehSiteMap.dspMain" onmouseover="showDBHelp('siteMap')" onmouseout="hideDBHelp()" onfocus="showDBHelp('siteMap')" onblur="hideDBHelp()"><img src="images/Globe_48x48.png" border="0" alt="Site Map" title="Site Map"><br>
						<a href="index.cfm?event=ehSiteMap.dspMain" onmouseover="showDBHelp('siteMap')" onmouseout="hideDBHelp()" onfocus="showDBHelp('siteMap')" onblur="hideDBHelp()">Site Map</a>
					</div>
				</cfif>

				<cfif stAccessMap.siteSettings>
					<div class="dsb_secBox">
						<a href="index.cfm?event=ehSiteConfig.dspMain" onmouseover="showDBHelp('settings')" onmouseout="hideDBHelp()" onfocus="showDBHelp('settings')" onblur="hideDBHelp()"><img src="images/configure_48x48.png" border="0" alt="Site Settings" title="Site Settings"><br>
						<a href="index.cfm?event=ehSiteConfig.dspMain" onmouseover="showDBHelp('settings')" onmouseout="hideDBHelp()" onfocus="showDBHelp('settings')" onblur="hideDBHelp()">Settings</a>
					</div>
				</cfif>

				<cfif stAccessMap.downloadSite>
					<div class="dsb_secBox">
						<a href="index.cfm?event=ehSites.doArchiveSite&siteID=#siteID#" onmouseover="showDBHelp('download')" onmouseout="hideDBHelp()" onfocus="showDBHelp('download')" onblur="hideDBHelp()"><img src="images/download_manager_48x48.png" border="0" alt="Download Site" title="Download Site"><br>
						<a href="index.cfm?event=ehSites.doArchiveSite&siteID=#siteID#" onmouseover="showDBHelp('download')" onmouseout="hideDBHelp()" onfocus="showDBHelp('download')" onblur="hideDBHelp()">Download</a>
					</div>
				</cfif>

				<cfloop from="1" to="#arrayLen(aPlugins)#" index="i">
					<cfset oPlugin = aPlugins[i]>
					<cfset module = oPlugin.getModuleName()>
					<cfset tmpEvent = module & "." & oPlugin.getDefaultEvent()>
					<cfset tmpID = oPlugin.getID()>
					<cfset tmpName = oPlugin.getName()>
					<cfif oPlugin.getIconSrc() neq "">
						<cfset tmpImage = oPlugin.getPath() & "/" & oPlugin.getIconSrc()>
					<cfelse>
						<cfset tmpImage = "images/cb-blocks.png">
					</cfif>
						<cfset tmpImage = "images/cb-blocks.png">
					<div class="dsb_secBox">
						<a href="index.cfm?event=#tmpEvent#" onmouseover="showDBHelp('mod_#tmpID#')" onmouseout="hideDBHelp()" onfocus="showDBHelp('settings')" onblur="hideDBHelp()"><img src="#tmpImage#" border="0" alt="Plugin: #tmpName#" title="Plugin: #tmpName#"><br>
						<a href="index.cfm?event=#tmpEvent#" onmouseover="showDBHelp('mod_#tmpID#')" onmouseout="hideDBHelp()" onfocus="showDBHelp('settings')" onblur="hideDBHelp()">#tmpName#</a>
					</div>
				</cfloop>
				
				<br style="clear:both;" />
				
				<div id="helpTextDiv" style="display:none;"></div>
			</div>
		</td>
		<td width="350">
			<cfif stAccessMap.pages>
				<div id="dsb_quickLink" style="width:300px;margin-bottom:30px;">
					<div class="dsb_secTitle">Quick Links:</div>
					<div class="dsb_siteSection">
						Use the following dropdowns to quckly access any
						page on this site.<br><br>
						<select name="account" style="width:130px;font-size:10px;border:1px solid silver;" 
								onchange="document.location='index.cfm?event=ehSite.dspMain&qlAccount='+this.value">
							<option value="">-- Select Account --</option>
							<cfloop query="qryAccounts">
								<option value="#username#" <cfif qlAccount eq username>selected</cfif>>#username#</option>
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
