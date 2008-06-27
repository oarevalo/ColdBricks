<cfparam name="request.requestState.hostName" default="">
<cfparam name="request.requestState.applicationTitle" default="#application.applicationName#">
<cfparam name="request.requestState.userInfo" default="">

<cfset userInfo = request.requestState.userInfo>
<cfset hostName = request.requestState.hostName>
<cfset appTitle = request.requestState.applicationTitle>

<cfoutput>
	<table width="100%">
		<tr>
			<td>
				<div style="line-height:20px;font-weight:bold;">
					<a href="index.cfm" style="color:##ff9900;text-decoration:none;font-size:20px;"><img src="images/coldbricks_logo.gif" border="0"></a>
				</div>
			</td> 
			<td align="right" style="padding-right:10px;">
				<span style="font-size:10px;font-weight:bold;border-bottom:1px dotted ##333;padding-bottom:8px;">
					<cfif userInfo.administrator>
						<span style="color:red;">Administrator</span>
					<cfelse>
						<span style="color:green;">#userInfo.username#</span>
					</cfif>
					&nbsp;&bull;&nbsp;
					#lsDateFormat(now())#
					&nbsp;&nbsp;|&nbsp;&nbsp;
					#hostName#
					&nbsp;&nbsp;|&nbsp;&nbsp;
					<a href="?event=ehGeneral.doLogoff">Log off</a>
				</span>
			</td>
		</tr>
	</table>
</cfoutput>
	

