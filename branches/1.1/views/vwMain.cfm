<cfparam name="request.requestState.qrySites" default="#queryNew("")#">
<cfparam name="request.requestState.qryUserSites" default="#queryNew("")#">
<cfparam name="request.requestState.userInfo" default="#queryNew("")#">
<cfparam name="request.requestState.loadSiteID" default="">

<cfset qrySites = request.requestState.qrySites>
<cfset qryUserSites = request.requestState.qryUserSites>
<cfset userInfo = request.requestState.userInfo>
<cfset loadSiteID = request.requestState.loadSiteID>

<!--- check if there is another site besides the hp engine --->
<cfquery name="qrySitesCheck" dbtype="query">
	SELECT *
		FROM qrySites
		WHERE siteName NOT LIKE 'HomePortalsEngine'
		ORDER BY siteName
</cfquery>

<!--- get info on the HP site --->
<cfquery name="qryHPSite" dbtype="query">
	SELECT *
		FROM qrySites
		WHERE siteName LIKE 'HomePortalsEngine'
</cfquery>



<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<link href="includes/css/dashboard.css" rel="stylesheet" type="text/css">
	<script type="text/javascript">
		function showDBHelp(key) {
			var helpText = "";
			if(key=="sites") helpText = "Access the sites management module, from there you can add, remove, archive and access individual sites";
			if(key=="users") helpText = "This screen allows you to manage all ColdBricks users. From here you can add, delete and edit user information.";
			if(key=="settings") helpText = "For greater control and customization of all HomePortals sites in this server, use the Settings module to manually edit the HomePortals XML configuration files";
			$("helpTextDiv").style.display = "block";
			$("helpTextDiv").innerHTML = "<img src='images/help.png' align='absmiddle'> " + helpText;
		}
		function hideDBHelp() {
			$("helpTextDiv").style.display = "none";
		}
		function loadSite(siteID,firstTime) {
			if(firstTime==null || firstTime==undefined) firstTime = false;
			overlay();
			document.location = 'index.cfm?event=ehSite.doLoadSite&siteID=' + siteID + '&firstTime='+firstTime;
		}
		doEvent("ehGeneral.dspHomePortalsCheck","hpInfoPanel");
	</script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>
	
<h2>Administration Dashboard</h2>	
	
<table width="100%" cellpadding="0" cellspacing="0" style="margin-top:10px;">
	<tr valign="top">
		<td width="200">
			<div class="dsb_siteSection" style="width:150px;padding:0px;">
				<div class="buttonImage btnLarge">
					<a href="index.cfm?event=ehSites.dspCreate" title="Click here to create a new portal or site"><img src="images/folder_add.png" border="0" align="absmiddle">&nbsp; Create New Site</a>
				</div>	


				<div class="buttonImage btnLarge">
					<a href="index.cfm?event=ehSites.dspRegister" title="Click here to register an existing portal or site in ColdBricks"><img src="images/folder_page.png" border="0" align="absmiddle">&nbsp; Register Site</a>
				</div>	
			</div>

			<br><br>

			<div class="dsb_siteSection" style="width:150px;padding:0px;">
				<div style="margin:10px;" id="hpInfoPanel">
					Checking HomePortals Framework...
				</div>
			</div>

		</td>
		<td>
			<cfif qrySitesCheck.recordCount eq 0>
				<div class="helpBox" style="padding:10px;border:1px solid silver;margin-right:10px;">
					<img src="images/quick_start.gif" style="margin-bottom:5px;"><br>
					It seems that you have no sites configured to manage with ColdBricks.
					<cfif qrySites.recordCount eq 1>
						The site you see here, <b>HomePortalsEngine</b>, is the runtime engine for
						the HomePortals framework. <em>It is highly recommended to not modify this site adding 
						your own content.</em><br>
					</cfif>
					<b>To get started with your first site,</b> either <a href="index.cfm?event=ehSites.dspCreate" title="Click here to go to the create site screen">Create a Site</a> 
					or <a href="index.cfm?event=ehSites.dspRegister" title="Click here to register an existing HomePortals-based site on this server">Register an Existing Site</a>
				</div>
				<br>
			</cfif>


			<div id="dsb_serverManagement">
				<div class="dsb_secTitle">Server Management:</div>

				<div class="dsb_secBox">
					<a href="index.cfm?event=ehSites.dspMain" onmouseover="showDBHelp('sites')" onmouseout="hideDBHelp()" onfocus="showDBHelp('sites')" onblur="hideDBHelp()"><img src="images/folder_desktop_48x48.png" border="0" alt="Resource Management" title="Resource Management"><br>
					<a href="index.cfm?event=ehSites.dspMain" onmouseover="showDBHelp('sites')" onmouseout="hideDBHelp()" onfocus="showDBHelp('sites')" onblur="hideDBHelp()">Sites</a>
				</div>

				<div class="dsb_secBox">
					<a href="index.cfm?event=ehUsers.dspMain" onmouseover="showDBHelp('users')" onmouseout="hideDBHelp()" onfocus="showDBHelp('users')" onblur="hideDBHelp()"><img src="images/users_48x48.png" border="0" alt="Accounts Management" title="Accounts Management"><br>
					<a href="index.cfm?event=ehUsers.dspMain" onmouseover="showDBHelp('users')" onmouseout="hideDBHelp()" onfocus="showDBHelp('users')" onblur="hideDBHelp()">Users</a>
				</div>
		
				<div class="dsb_secBox">
					<a href="index.cfm?event=ehSettings.dspMain" onmouseover="showDBHelp('settings')" onmouseout="hideDBHelp()" onfocus="showDBHelp('settings')" onblur="hideDBHelp()"><img src="images/configure_48x48.png" border="0" alt="Site Settings" title="Site Settings"><br>
					<a href="index.cfm?event=ehSettings.dspMain" onmouseover="showDBHelp('settings')" onmouseout="hideDBHelp()" onfocus="showDBHelp('settings')" onblur="hideDBHelp()">Settings</a>
				</div>

				<br style="clear:both;" />
				
				<div style="height:60px;">
					<div id="helpTextDiv" style="display:none;"></div>
				</div>
			</div>
			
			<div id="dsb_sites">
				<div class="dsb_secTitle">Sites Shortcuts:</div>

				<cfif qryHPSite.recordCount eq 1>
					<div class="dsb_secBox">
						<a href="##" onclick="loadSite('#qryHPSite.siteID#')"><img src="images/Globe_48x48.png" border="0" alt="HomePortals Framework runtime engine" title="HomePortals Framework runtime engine"><br>
						<a href="##" onclick="loadSite('#qryHPSite.siteID#')" style="color:red;" title="HomePortals Framework runtime engine">HomePortals</a>
					</div>
				</cfif>

				<cfloop query="qrySites">
					<cfif qrySites.siteID neq qryHPSite.SiteID>
						<div class="dsb_secBox">
							<a href="##" onclick="loadSite('#qrySites.siteID#')"><img src="images/Globe_48x48.png" border="0" alt="#qrySites.siteName#" title="#qrySites.siteName#"><br>
							<a href="##" onclick="loadSite('#qrySites.siteID#')">#qrySites.siteName#</a>
						</div>
					</cfif>
				</cfloop>
		
				<br style="clear:both;" />
			</div>

		</td>
		
		<td width="200">
			<div class="cp_sectionBox helpBox" style="font-family:arial;height:350px;">
				<div style="margin:10px;">
					<h2>Welcome To ColdBricks!</h2>
					You are currently on the ColdBricks server dashboard, from this screen you can have quick access
					to the different managment modules as well as to the sites created on this server.<br><br>
					
					The icons on the top part of the screen are the management modules. Just click on one of them to access
					the particular module or mouseover to view a short description.<br><br>
					
					The icons on the lower part are the sites on this server that are currently being managed with ColdBricks,
					click on the icon to quickly access each site.
				</div>
			</div>
		
		</td>
	</tr>
</table>

<div id="overlay">
     <div>
        <p>Loading site. Please wait...</p>
		<img src="images/animLoading.gif" align="Absmiddle">
     </div>
</div>

<!--- handle automatic loading of a site --->
<cfif loadSiteID neq "">
	<cfoutput>
		<script type="text/javascript">
			loadSite('#jsStringFormat(loadSiteID)#',true);
		</script>
	</cfoutput>
</cfif>

</cfoutput>
