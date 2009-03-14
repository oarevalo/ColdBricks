<cfparam name="request.requestState.versionTag" default="">
<cfparam name="usr" default="">

<cfset versionTag = request.requestState.versionTag>

<cfsavecontent variable="txtHTML">
	<link href="includes/css/login.css" rel="stylesheet" type="text/css">
	<script type="text/javascript">
	  function hideMessageBox() {
	  	var d = document.getElementById("app_messagebox");
	  	if(d) d.style.display = "none";
	  }	
	  
	  // this is to check if it is being rendered inside a different layout than the clearn layout
	  if (document.getElementById("header")) {
	  	top.location.href = "index.cfm";
	  }
	</script>
</cfsavecontent>
<cfhtmlhead text="#txtHTML#">
<br>

<cfoutput>
	<form name="frmLogin" action="index.cfm" method="post">
		<input type="hidden" name="event" value="ehGeneral.doLogin">
		
		<table align="center" border="0" cellpadding="2" cellspacing="0" class="tblLogin">
			<tr>
				<td rowspan="5" style="border-right:1px solid ##ccc;width:250px;" valign="middle" align="center">
					<img src="images/coldbricks_logo_white.gif" alt="ColdBricks" title="ColdBricks"><br>
					<div id="versionTag">
						Version: <strong>#versionTag#</strong>
					</div>
					<div id="resetApp">
						<a href="index.cfm?resetApp=1" style="color:##333;" 
							alt="Resetting the application will force a reload of any configuration settings"
							title="Resetting the application will force a reload of any configuration settings">Reset ColdBricks</a>
					</div>
				</td>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="100" valign="middle" style="font-size:11px;" align="right"><b>Username:</b></td>
				<td valign="middle" align="right">
					<input style="font-size:11px;width:120px" 
							type="text" name="usr" 
							required="yes" message="Your email address is required">
				</td>
			</tr>
			<tr>
				<td valign="middle" style="font-size:11px;" align="right"><b>Password:</b></td>
				<td valign="middle" align="right">
					<input style="font-size:11px;width:120px"
							type="password" name="pwd" 
							required="yes" message="Your password is required">
				</td>
			</tr>
			<tr valign="middle">
				<td colspan="2">
					<div class="buttonImage" style="float:right;">
						<a href="##" onclick="frmLogin.submit()">Login</a>
					</div>
				</td>
			</tr>
			<tr><td colspan="3">&nbsp;</td></tr>
		</table>
	</form>
</cfoutput>

