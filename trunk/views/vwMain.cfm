<cfparam name="request.requestState.qrySites" default="#queryNew("")#">
<cfparam name="request.requestState.qryUserSites" default="#queryNew("")#">
<cfparam name="request.requestState.loadSiteID" default="">
<cfparam name="request.requestState.aModules" default="">
<cfparam name="request.requestState.oUser" default="">
<cfparam name="request.requestState.showHomePortalsAsSite" default="false">

<cfset qrySites = request.requestState.qrySites>
<cfset qryUserSites = request.requestState.qryUserSites>
<cfset loadSiteID = request.requestState.loadSiteID>
<cfset aModules = request.requestState.aModules>
<cfset oUser = request.requestState.oUser>
<cfset showHomePortalsAsSite = request.requestState.showHomePortalsAsSite>

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

<cfset stAccessMap = oUser.getAccessMap()>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<link href="includes/css/dashboard.css" rel="stylesheet" type="text/css">
	<script type="text/javascript">
		doEvent("ehGeneral.dspHomePortalsCheck","hpInfoPanel");
	</script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>
	
<table width="100%" cellpadding="0" cellspacing="0" style="margin-top:10px;">
	<tr valign="top">
		<td width="200">
			<cfif stAccessMap.sites>
				<div class="dsb_siteSection" style="width:150px;padding:0px;">
					<div class="buttonImage btnLarge">
						<a href="index.cfm?event=sites.ehSites.dspCreate" title="Click here to create a new portal or site"><img src="images/folder_add.png" border="0" align="absmiddle">&nbsp; Create New Site</a>
					</div>	
	
	
					<div class="buttonImage btnLarge">
						<a href="index.cfm?event=sites.ehSites.dspRegister" title="Click here to register an existing portal or site in ColdBricks"><img src="images/folder_page.png" border="0" align="absmiddle">&nbsp; Register Site</a>
					</div>	
				</div>
				<br><br>
			</cfif>

			<div class="dsb_siteSection" style="width:150px;padding:0px;">
				<div style="margin:10px;" id="hpInfoPanel">
					Checking <a href="/homePortals">HomePortals</a> Framework...
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

			<cf_dashboardMenu title="Server Management:" id="dsb_serverManagement">
				
				<cfloop from="1" to="#arrayLen(aModules)#" index="i">
					<cfif aModules[i].imgSrc neq "">
						<cfset tmpImgSrc = aModules[i].imgSrc>
					<cfelse>
						<cfset tmpImgSrc = "images/Globe_48x48.png">
					</cfif>
					
					<cf_dashboardMenuItem href="#aModules[i].href#" 
											isAllowed="#stAccessMap[aModules[i].accessMapKey]#"
											imgSrc="#tmpImgSrc#"
											alt="#aModules[i].alt#"
											label="#aModules[i].label#"
											help="#aModules[i].description#">
				</cfloop>
				
			</cf_dashboardMenu>


			<cf_dashboardMenu title="Site Shortcuts:" id="dsb_sites">
				<cfif showHomePortalsAsSite and qryHPSite.recordCount eq 1>
					<cf_dashboardMenuItem href="javascript:loadSite('#qryHPSite.siteID#')" 
											imgSrc="images/Globe_48x48.png"
											alt="HomePortals Framework runtime engine"
											label="HomePortals"
											help="HomePortals Framework runtime engine"
											labelStyle="color:red;">
				</cfif>
				
				<cfloop query="qrySites">
					<cfif qrySites.siteID neq qryHPSite.SiteID>
						<cf_dashboardMenuItem href="javascript:loadSite('#qrySites.siteID#')" 
												imgSrc="images/Globe_48x48.png"
												alt="#qrySites.siteName#"
												label="#qrySites.siteName#"
												help="Load site '#qrySites.siteName#' for management">
					</cfif>
				</cfloop>
				
			</cf_dashboardMenu>

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
