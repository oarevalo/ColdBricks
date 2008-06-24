<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<cfparam name="request.requestState.applicationTitle" default="#application.applicationName#">
<cfoutput>
	<html>
		<head>
			<title>#request.requestState.applicationTitle#</title>
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
						<tr>	
							<td>
								<cfif request.requestState.view neq "">
									<cfinclude template="../views/#request.requestState.view#.cfm">
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

