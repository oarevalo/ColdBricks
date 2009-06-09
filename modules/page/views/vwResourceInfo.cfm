<cfparam name="request.requestState.oResourceBean" default="">
<cfparam name="request.requestState.resourceID" default="">
<cfparam name="request.requestState.resType" default="">

<cfset oResourceBean = request.requestState.oResourceBean>
<cfset resourceID = request.requestState.resourceID>
<cfset resType = request.requestState.resType>
<cfset tmpResTitle = resourceID>
<cfset tmpHREF = oResourceBean.getFullHREF()>

<cfoutput>
	<div style="border-bottom:1px solid black;background-color:##ccc;text-align:left;line-height:22px;">
		<a href="javascript:addResource('#jsstringformat(resourceID)#','#resType#');"><img src="images/add.png" align="absmiddle" border="0" alt="Add To Page" title="Add To Page"> Add To Page</a>
	</div>
	
	<div style="width:160px;">
		<table style="margin:5px;">
			<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;width:30px;">Type:</td><td>#resType#</td></tr>
			<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;width:30px;">ID:</td><td>#tmpResTitle#</td></tr>
			<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;width:30px;">Package:</td><td>#oResourceBean.getPackage()#</td></tr>
			<tr valign="top"><td style="font-size:10px;color:##999;text-align:left;width:30px;">HREF:</td><td><a href="#tmpHREF#" onclick="fb.loadAnchor('#jsStringFormat(tmpHREF)#');return false;"><span style="color:green;">#tmpHREF#</span></a></td></tr>
		</table>
	
		<div style="margin:5px;">
			<div style="font-size:10px;color:##999;text-align:right;width:30px;">Description:</div>
			<cfif oResourceBean.getDescription() neq "">
				#oResourceBean.getDescription()#
			<cfelse>
				N/A
			</cfif>
		</div>
	</div>
</cfoutput>