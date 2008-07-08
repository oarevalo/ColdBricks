<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<cfparam name="request.requestState.applicationTitle" default="#application.applicationName#">
<cfparam name="request.requestState.viewTemplatePath" default="">

<cfparam name="request.requestState.cbPageTitle" default="">
<cfparam name="request.requestState.cbPageIcon" default="">
<cfparam name="request.requestState.cbShowSiteMenu" default="">

<cfparam name="request.requestState.oPlugin" default="">

<cfset oPlugin = request.requestState.oPlugin>
<cfset cbPageTitle = request.requestState.cbPageTitle>
<cfset cbPageIcon = request.requestState.cbPageIcon>
<cfset cbShowSiteMenu = request.requestState.cbShowSiteMenu>

<cfif cbPageTitle eq "">
	<cfset cbPageTitle = oPlugin.getName()>
</cfif>

<cfif cbPageIcon eq "" and oPlugin.getIconSrc() neq "">
	<cfset cbPageIcon = oPlugin.getPath() & "/" & oPlugin.getIconSrc()>
<cfelse>
	<cfset cbPageIcon = "images/cb-blocks.png">
</cfif>

<cfoutput>
	<html>
		<head>
			<title>
				#request.requestState.applicationTitle# 
				:: Plugin
				<cfif cbPageTitle neq "">:: #cbPageTitle#</cfif>
			</title>
			<link href="includes/css/style.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="includes/js/main.js"></script>
		</head>
		<body>
			<div id="header">
				<cfinclude template="../includes/header.cfm">
			</div>
			<div id="mainMenu">
				<cfinclude template="../includes/menu-top.cfm">
			</div>
			<div id="mainBody">
				<div id="content">
					<cfinclude template="../includes/message.cfm">
					
					<table style="width:95%;font-size:11px;" align="center">
						<tr valign="top">
							<td>
								<cfif oPlugin.getType() eq "site">
									<cfmodule template="../includes/menu_site.cfm" 
												title="#cbPageTitle#" 
												icon="#cbPageIcon#">
								<cfelse>
									<cfif cbPageTitle neq "">
										<h2>
											<cfif cbPageIcon neq ""><img src="#cbPageIcon#" align="absmiddle"></cfif>
											#cbPageTitle#
										</h2>
									</cfif>
								</cfif>

								<cfif request.requestState.viewTemplatePath neq "">
									<cfinclude template="#request.requestState.viewTemplatePath#">
								</cfif>
							</td>
						</tr>
					</table>
				</div>
				<cfinclude template="../includes/footer.cfm">
			</div>
		</body>
	</html>
</cfoutput>
