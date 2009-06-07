<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<cfparam name="request.requestState.applicationTitle" default="#application.applicationName#">
<cfparam name="request.requestState.viewTemplatePath" default="">
<cfparam name="request.requestState.cbPageTitle" default="">
<cfparam name="request.requestState.cbPageIcon" default="">
<cfparam name="request.requestState.cbShowSiteMenu" default="">

<cfoutput>
	<html>
		<head>
			<title>
				#request.requestState.applicationTitle# 
				<cfif request.requestState.cbPageTitle neq "">:: #request.requestState.cbPageTitle#</cfif>
			</title>
			<link href="includes/css/style.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="includes/js/main.js"></script>
			<script type="text/javascript">
				if(top.location != location) {
					top.location.href = document.location.href;
				}
			</script>
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
						<tr>	
							<td>
								<cfif isBoolean(request.requestState.cbShowSiteMenu) and request.requestState.cbShowSiteMenu>
									<cfmodule template="../includes/menu_site.cfm" 
												title="#request.requestState.cbPageTitle#" 
												icon="#request.requestState.cbPageIcon#">
								<cfelse>
									<cfif request.requestState.cbPageTitle neq "">
										<h2>
											<cfif request.requestState.cbPageIcon neq ""><img src="#request.requestState.cbPageIcon#" align="absmiddle"></cfif>
											#request.requestState.cbPageTitle#
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

