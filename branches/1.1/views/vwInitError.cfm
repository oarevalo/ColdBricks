<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>ColdBricks</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<style type="text/css">
		body,td,th {
			font-family: Arial, Helvetica, sans-serif;
			font-size: 12px;
			color: ##333;
			background-image:none;
		}
		p {
			margin-bottom:10px;
			line-height:20px;
		}
		.tblDump {
			width:600px;
			border-collapse:collapse;
			border:1px solid silver;
		}
		.tblDump td, .tblDump th {
			padding:4px;
			line-height:18px;
		}
		.tblDump th {
			background-color:##ccc;
			text-align:left;
		}
	</style>
</head>
		   
<body leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
	<table align="center" style="width:500px;margin-top:50px;">
		<tr>
			<td style="font-size:12px;line-height:120%;padding:10px;">
				<img src="images/error_sm.gif" align="left">	
				<cfif request.fatal>
					<div style="margin:5px;font-size:13px;font-weight:bold;">
						An error ocurred while initializing ColdBricks
					</div>
					<p>
						There is a fatal problem that is preventing the application from being
						intialized. Please correct the problem and reload this page.
					</p><br>
					<br />
					<div style="border:1px solid silver;background-color:##ffffe1;padding:10px;">
						<strong>The following is the information returned:</strong><br><br />
						<b>Initialization Step:</b> #request.errorStep#<br />
						<b>Error Message:</b> #request.error.message#<br />
						<b>Error Detail:</b> #request.error.detail#<br />
					</div>
				</cfif>

				<cfif structKeyExists(request,"moduleInitErrors") and arrayLen(request.moduleInitErrors) gt 0>
					<p><b>The following problems were detected while initializing modules:</b></p>
					<br /><br />
					<div style="clear:both;"></div>
					<cfloop from="1" to="#arrayLen(request.moduleInitErrors)#" index="i">
						&bull; <b><u>#request.moduleInitErrors[i].name#:</u></b> #request.moduleInitErrors[i].message#<br />
					</cfloop>
					<br /><br />
					<a href="index.cfm"><b>Click Here</b></a> to continue to the application
				</cfif>

	           <div style="border-top:3px solid ##ccc;margin-top:20px;">
			</td>
		</tr>
	</table>

	<cfif structKeyExists(application,"_appSettings") 
			and structKeyExists(application["_appSettings"],"debugMode")
			and application["_appSettings"].debugMode
			and structKeyExists(request,"error")>
		<br><br>
		<table align="center" class="tblDump" border="1">
			<tr>
				<td colspan="2" style="line-height:24px;">
					<b><u>Diagnostic Information:</u></b>
				</td>
			</tr>
			<tr>
				<th>Type:</th>
				<td>#request.error.type#</td>
			</tr>
			<cfif isDefined("request.error.tagContext")>
				<tr valign="top">
					<th>Tag Context:</th>
					<td>
						<cfloop from="1" to="#arrayLen(request.error.tagContext)#" index="i">
							&bull; #request.error.tagContext[i].template# (line #request.error.tagContext[i].line#)<br>
						</cfloop>
					</td>
				</tr>
			</cfif>
		</table>
	</cfif>
</body>
</html>
</cfoutput>
