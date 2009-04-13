<cfparam name="request.requestState.siteTemplatesRoot" default="">
<cfparam name="request.requestState.siteTemplate" default="">

<cfset siteTemplatesRoot = request.requestState.siteTemplatesRoot>
<cfset siteTemplate = request.requestState.siteTemplate>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="includes/js/prototype-1.6.0.js"></script>
	<link href="includes/css/dashboard.css" rel="stylesheet" type="text/css">
	<script type="text/javascript">
		function onChangeSiteName(newName) {
			f1 = $("appRoot");
			f2 = $("contentRoot");
			f3 = $("resourcesRoot");
			
			if(f1 && f1.value=='') f1.value = '/' + newName;
			if(f2 && f2.value=='') f2.value = '/' + newName + '/content';
			if(f3 && f3.value=='') f3.value = '/' + newName + '/resourceLibrary';
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
					<input type="hidden" name="event" value="ehSites.doCreateCustom">
					<cfinclude template="includes/createSite_settings.cfm">
				</form>			
			</div>	
		</td>
		
		<td width="200">
			<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:400px;line-height:18px;">
				<div style="margin:10px;">
					<h2>Creating a Custom Site</h2>
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