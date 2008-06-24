<cfparam name="request.requestState.siteTemplatesRoot" default="">
<cfparam name="request.requestState.siteTemplate" default="">
<cfparam name="request.requestState.qrySiteTemplates" default="#queryNew('')#">

<cfset siteTemplatesRoot = request.requestState.siteTemplatesRoot>
<cfset qrySiteTemplates = request.requestState.qrySiteTemplates>
<cfset siteTemplate = request.requestState.siteTemplate>

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
		function toggleSiteTemplate(opt) {
			var d = document.getElementById("tblCustom");
			if(opt=="")
				d.style.display = "block";
			else
				d.style.display = "none";
		}
		function selectSiteTemplate(st) {
			document.location = "index.cfm?event=ehSites.dspCreate&siteTemplate="+st;
		}
	</script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">


<cfoutput>
<h2>Create New Site</h2>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>
			<div style="margin-top:10px;">
				<form name="frm" method="post" action="index.cfm" style="margin:15px;" >
					<input type="hidden" name="event" value="ehSites.doCreate">
					<input type="hidden" name="siteTemplate" value="#siteTemplate#" id="siteTemplate">
	
					<cfif siteTemplate eq "">
					<div id="step1Panel">
						<b>Select a site template by clicking on one of the icons below. To create a blank site without using any template, select <u>Default</u>.</b><br><br>
					
						<div class="dsb_secBox">
							<a href="##" onclick="selectSiteTemplate('default')"><img src="images/Globe_48x48.png" border="0" alt="Default site" title="Default site"><br>
							<a href="##" onclick="selectSiteTemplate('default')">Default</a>
						</div>
	
						<cfloop query="qrySiteTemplates">
							<cfif qrySiteTemplates.name neq "default">
								<div class="dsb_secBox">
									<a href="##" onclick="selectSiteTemplate('#qrySiteTemplates.name#')"><img src="images/Globe_48x48.png" border="0" alt="#qrySiteTemplates.name#" title="#qrySiteTemplates.name#"><br>
									<a href="##" onclick="selectSiteTemplate('#qrySiteTemplates.name#')">#qrySiteTemplates.name#</a>
								</div>
							</cfif>
						</cfloop>
					</div>
					<br style="clear:both;" />
					<cfelse>
					<div id="step2Panel">
						<table cellspacing="5">
							<tr>
								<td width="60">
									<strong>Site Template:</strong><br>
								</td>
								<td style="color:##999;font-weight:bold;font-size:12px;" id="siteTemplate2">#siteTemplate#</td>
							</tr>
							<tr>
								<td colspan="2">
									<strong>Site Name:</strong>
									<div style="color:##666;line-height:18px;width:600px;">
										Enter a name to identify the new site. Name must contain only letters, digits, underscore, and spaces.
									</div>
								</td>
							</tr>
							<tr valign="top">
								<td width="100">&nbsp;</td>
								<td>
									<input type="text" name="name" value="" size="50" class="formField" onblur="if(this.form.appRoot.value=='') this.form.appRoot.value='/'+this.value"> 
									&nbsp; <span style="color:red;font-weight:bold;">required</span>
								</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td colspan="2">
									<strong>Application Root:</strong>
									<div style="color:##666;line-height:18px;width:600px;">
										Enter the URL path to where the new site will be deployed. Paths are always relative
										to the web root. To deploy the site to the webroot enter "/".
									</div>
								</td>
							</tr>
							<tr valign="top">
								<td>&nbsp;</td>
								<td>
									<input type="text" name="appRoot" value="" size="50" class="formField"> 
									&nbsp; <span style="color:red;font-weight:bold;">required</span>
								</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<cfif siteTemplate eq "default">
							<tr>
								<td colspan="2">
									<strong>Accounts Root:</strong>
									<div style="color:##666;line-height:18px;width:600px;">
										Accounts root is the path to the directory where all files for accounts will be created. 
										Paths are always relative to the web root. 
									</div>
								</td>
							</tr>		
							<tr valign="top">
								<td>&nbsp;</td>
								<td>
									<input type="radio" name="useDefault_ar" value="1" checked="true"> <strong>Default:</strong> {APPLICATION_ROOT} / accounts<br>
									<input type="radio" name="useDefault_ar" value="0"> <strong>Custom:</strong> <input type="text" name="accountsRoot" value="" size="50" class="formField">
								</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td colspan="2">
									<strong>Resource Library Root:</strong>
									<div style="color:##666;line-height:18px;width:600px;">
										Resource Library root is the path to the location of the resources library you wish to use for
										this site. A resource library contains all reusable content that is used to create a site, such as
										modules, skins, contents, feeds, etc. 
										Paths are always relative to the web root. 
									</div>
								</td>
							</tr>		
							<tr valign="top">
								<td>&nbsp;</td>
								<td>
									<input type="radio" name="useDefault_rl" value="1" checked="true"> <strong>Default:</strong> {APPLICATION_ROOT} / resourceLibrary<br>
									<!--- <input type="radio" name="useDefault_rl" value="2"> <strong>Central Library:</strong> {HOME_ROOT} / resourceLibrary<br> --->
									<input type="radio" name="useDefault_rl" value="0"> <strong>Custom:</strong> <input type="text" name="resourcesRoot" value="" size="50" class="formField">
								</td>
							</tr>
							
							</cfif>
						</table>				
			
						<br>
						<p>
							<input type="button" name="btnBack" value="<< Back" onclick="document.location='index.cfm?event=ehSites.dspCreate'">&nbsp;
							<input type="submit" name="btn" value="Create Site">
						</p>
					</div>
					</cfif>
				</form>			
			</div>	
		</td>
		
		<td width="200">
			<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
				<div style="margin:10px;">
					<h2>Creating a Site</h2>
					<p>
						From this screen you can create a new site that can be managed with ColdBricks. 
					</p>
					<p>
						To jumpstart the process of building complex sites, ColdBricks allows you to create sites based on <b>Site Templates</b>. These are
						pre-packaged solutions for different types of sites.  All site templates are located by default in the /ColdBricks/SiteTemplates directory.
					</p>
					<p>
						Only administrator users can create sites.
					</p>
				</div>
			</div>
		</td>
	</tr>
</table>

</cfoutput>