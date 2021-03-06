<cfparam name="request.requestState.firstTime" default="false">
<cfparam name="request.requestState.aModules" default="">
<cfparam name="request.requestState.isHomePortalsEngine" default="false">
<cfparam name="request.requestState.aLeftWidgets" default="#arrayNew(1)#">
<cfparam name="request.requestState.aRightWidgets" default="#arrayNew(1)#">

<cfset firstTime = request.requestState.firstTime>
<cfset aModules = request.requestState.aModules>
<cfset isHomePortalsEngine = request.requestState.isHomePortalsEngine>
<cfset aLeftWidgets = request.requestState.aLeftWidgets>
<cfset aRightWidgets = request.requestState.aRightWidgets>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<link href="includes/css/dashboard.css" rel="stylesheet" type="text/css">
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0" style="margin-top:10px;">
	<tr valign="top">
		<td width="200">
			<cfloop from="1" to="#arrayLen(aLeftWidgets)#" index="i">
				<div id="dsb_lwidget#i#" style="width:150px;margin-bottom:25px;">
					<cfif aLeftWidgets[i].title neq "">
						<div class="dsb_secTitle">#aLeftWidgets[i].title#</div>
					</cfif>
					<div class="dsb_siteSection">
						#aLeftWidgets[i].body#
					</div>
				</div>
			</cfloop>
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
					<a href="index.cfm?event=sites.ehSite.doLoadHomePage">Edit your HomePage</a>
				</div>
			</cfif>
			
			<cfif isHomePortalsEngine>
				<div class="helpBox" style="padding:15px;font-size:11px;line-height:16px;border:1px solid silver;margin-bottom:20px;margin-right:20px;">
					<img src="images/wmsg.gif" align="absmiddle">
					<span style="color:red;font-weight:bold;">This is the runtime engine for the HomePortals framework.</span> 
					Changes made to this site will affect all HomePortals-based sites and applications on this server.
				</div>
			</cfif>
			
			<cf_dashboardMenu title="Site Management:" defaultImgSrc="images/Globe_48x48.png">
				<cfloop from="1" to="#arrayLen(aModules)#" index="i">
					<cf_dashboardMenuItem href="#aModules[i].href#" 
											imgSrc="#aModules[i].imgSrc#"
											alt="#aModules[i].alt#"
											label="#aModules[i].label#"
											help="#aModules[i].description#">
				</cfloop>
			</cf_dashboardMenu>
		</td>
		<td width="350">
			<cfloop from="1" to="#arrayLen(aRightWidgets)#" index="i">
				<div id="dsb_rwidget#i#" style="width:350px;margin-bottom:25px;">
					<cfif aRightWidgets[i].title neq "">
						<div class="dsb_secTitle">#aRightWidgets[i].title#</div>
					</cfif>
					<div class="dsb_siteSection">
						#aRightWidgets[i].body#
					</div>
				</div>
			</cfloop>
		</td>
	</tr>
</table>

</cfoutput>
