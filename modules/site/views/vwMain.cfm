<cfparam name="request.requestState.oSiteInfo" default="">
<cfparam name="request.requestState.stResourceTypes" default="">
<cfparam name="request.requestState.qryResources" default="">
<cfparam name="request.requestState.qryAccounts" default="">
<cfparam name="request.requestState.appRoot" default="">
<cfparam name="request.requestState.defaultAccount" default="">
<cfparam name="request.requestState.qlAccount" default="">
<cfparam name="request.requestState.aPages" default="">
<cfparam name="request.requestState.firstTime" default="false">
<cfparam name="request.requestState.oUser" default="">
<cfparam name="request.requestState.hasAccountsPlugin" default="false">
<cfparam name="request.requestState.aModules" default="">
<cfparam name="request.requestState.oContext" default="">
<cfparam name="request.requestState.isHomePortalsEngine" default="false">

<cfset oSiteInfo = request.requestState.oSiteInfo>
<cfset stResourceTypes = request.requestState.stResourceTypes>
<cfset qryResources = request.requestState.qryResources>
<cfset qryAccounts = request.requestState.qryAccounts>
<cfset appRoot = request.requestState.appRoot>
<cfset defaultAccount = request.requestState.defaultAccount>
<cfset qlAccount = request.requestState.qlAccount>
<cfset aPages = request.requestState.aPages>
<cfset firstTime = request.requestState.firstTime>
<cfset oUser = request.requestState.oUser>
<cfset hasAccountsPlugin = request.requestState.hasAccountsPlugin>
<cfset aModules = request.requestState.aModules>
<cfset oContext = request.requestState.oContext>
<cfset isHomePortalsEngine = request.requestState.isHomePortalsEngine>

<cfset siteID = oSiteInfo.getID()>
<cfset stAccessMap = oUser.getAccessMap()>

<!--- fix appRoot for sites at root level --->
<cfif appRoot eq "/">
	<cfset tmpAppRoot = "">
<cfelse>
	<cfset tmpAppRoot = appRoot>
</cfif>
					
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

<cfoutput>
	
<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<link href="includes/css/dashboard.css" rel="stylesheet" type="text/css">
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">
		
<table width="100%" cellpadding="0" cellspacing="0" style="margin-top:10px;">
	<tr valign="top">
		<td width="200">
			<div class="dsb_siteSection" style="width:150px;padding:0px;">
				<div class="buttonImage btnLarge">
					<a href="#appRoot#" target="_blank" title="Open site in a different window"><img src="images/magnifier.png" border="0" align="absmiddle"> Preview Site</a>
				</div>	


				<div class="buttonImage btnLarge">
					<a href="#tmpAppRoot#/index.cfm?resetApp=1" target="_blank" title="Open the site reloading site settings"><img src="images/arrow_refresh.png" border="0" align="absmiddle"> Reset Site</a>
				</div>	
			</div>
			
			<cfif hasAccountsPlugin and stAccessMap.accounts>
				<cfinclude template="includes/accounts.cfm">
			</cfif>
			
			<cfif stAccessMap.resources>
				<cfinclude template="includes/resources.cfm">
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
					<a href="index.cfm?event=site.ehSite.doLoadAccountPage">Edit your HomePage</a>, 
					<cfif hasAccountsPlugin>
						<a href="index.cfm?event=accounts.ehAccounts.dspMain">Manage Accounts</a> or
					</cfif>
					<a href="index.cfm?event=resources.ehResources.dspMain">Add/Import Site Resources</a>
				</div>
			</cfif>
			
			<cfif isHomePortalsEngine>
				<div class="helpBox" style="padding:15px;font-size:11px;line-height:16px;border:1px solid silver;margin-bottom:20px;margin-right:20px;">
					<img src="images/wmsg.gif" align="absmiddle">
					<span style="color:red;font-weight:bold;">This is the runtime engine for the HomePortals framework.</span> 
					Changes made to this site will affect all HomePortals-based sites and applications on this server.
				</div>
			</cfif>
			
			
			<cfset hasModuleAccess = false>
			
			<cf_dashboardMenu title="Site Management:">
				<cfloop from="1" to="#arrayLen(aModules)#" index="i">
					<cfset isAllowed = structKeyExists(stAccessMap, aModules[i].accessMapKey)
										and stAccessMap[aModules[i].accessMapKey]
										and
										(
											aModules[i].bindToPlugin eq ""
											or
											(
												aModules[i].bindToPlugin neq ""
												and
												oContext.getHomePortals().getPluginManager().hasPlugin( aModules[i].bindToPlugin )
											)	
										)>

					<cf_dashboardMenuItem href="#aModules[i].href#" 
											isAllowed="#isAllowed#"
											imgSrc="#aModules[i].imgSrc#"
											alt="#aModules[i].alt#"
											label="#aModules[i].label#"
											help="#aModules[i].description#">
				</cfloop>
			</cf_dashboardMenu>
			
		</td>
		<td width="350">
			<cfif hasAccountsPlugin and stAccessMap.pages>
				<cfinclude template="includes/accountQuickLinks.cfm">
			</cfif>
		
			<cfinclude template="includes/siteInfo.cfm">
		</td>
	</tr>
</table>

</cfoutput>
