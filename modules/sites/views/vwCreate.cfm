<cfparam name="request.requestState.siteTemplatesRoot" default="">
<cfparam name="request.requestState.siteTemplate" default="">

<cfset siteTemplatesRoot = request.requestState.siteTemplatesRoot>
<cfset siteTemplate = request.requestState.siteTemplate>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<link href="includes/css/dashboard.css" rel="stylesheet" type="text/css">
	<script type="text/javascript">
		function toggleSiteTemplate(opt) {
			var d = document.getElementById("tblCustom");
			if(opt=="")
				d.style.display = "block";
			else
				d.style.display = "none";
		}
		function selectSiteTemplate(st) {
			document.location = "index.cfm?event=sites.ehSites.dspCreate&siteTemplate="+st;
		}
		function onChangeSiteName(newName) {
			f1 = $("appRoot");
			b1 = $("btnCreate");
			c1 = $("deployToWebRoot");

			if(newName != '') {
				f1.disabled = false;
				b1.disabled = false;
				c1.disabled = false;
				if(f1) f1.value = '/' + newName;
				onChangeDeployToRoot(c1.checked);
			} else {
				f1.value = '';
				f1.disabled = true;
				b1.disabled = true;
				c1.disabled = true;
			}
		}
		
		function onChangeDeployToRoot(checked) {
			f0 = $("name");
			f1 = $("appRoot");

			if(checked) {
				if(f1) f1.value = '/';
				f1.disabled = true;

			} else {
				if(f1) f1.value = '/' + f0.value;
				f1.disabled = false;
			}
		}		
	</script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">


<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>
			<div style="margin-top:10px;">
				<form name="frm" method="post" action="index.cfm" style="margin:15px;" >
					<input type="hidden" name="event" value="sites.ehSites.doCreate">
					<input type="hidden" name="siteTemplate" value="#siteTemplate#" id="siteTemplate">
	
					<cfif siteTemplate eq "">
						<div id="step1Panel">
							<cfinclude template="includes/createSite_selectTemplate.cfm">
						</div>
						<br style="clear:both;" />
					<cfelse>
						<div id="step2Panel">
							<cfinclude template="includes/createSite_settings.cfm">
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
						pre-packaged solutions for different types of sites.  All site templates are located by default in the #siteTemplatesRoot# directory.
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