<cfparam name="request.requestState.oContext">
<cfset oContext = request.requestState.oContext>
<cfset oSite = oContext.getSiteInfo()>
<cfset path = oSite.getPath()>

<cfset probeWS = request.requestState.probeWS>
<cfset aCaches = probeWS.getCacheNames()>

<cfscript>
	// get amount of free memory
	freeMem = probeWS.getJVMFreeMemoryPercent();
	if(freeMem gt 50)
		freeMemLabelColor = "green";
	else if(freemem gt 15)
		freeMemLabelColor = "orange";
	else
		freeMemLabelColor = "red";
</cfscript>
<cfset aCaches = probeWS.getCacheNames()>

<cfsavecontent variable="tmpHTML">
	<link type="text/css" rel="stylesheet" href="includes/floatbox/floatbox.css" />
	<script type="text/javascript" src="includes/floatbox/floatbox.js"></script>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>
	<table border="0" class="browseTable">
		<tr>
			<th colspan="2">
				<div style="float:right;">
					<a href="index.cfm?event=ehSiteMonitor.doResetSite">Reset App</a>
				</div>
				Application:
			</th>
		</tr>
		<tr>
			<td width="130"><b>Status:</b></td>
			<td><cfif probeWS.isLoaded()>Loaded<cfelse>Not Loaded</cfif></td>
		</tr>
		<tr>
			<td width="130"><b>App Root:</b></td>
			<td>#path#</td>
		</tr>
		<tr>
			<td width="130"><b>Free JVM Memory:</b></td>
			<td><span style="color:#freeMemLabelColor#;font-weight:bold;">#decimalFormat(freeMem)#%</span></td>
		</tr>
	</table>
			
	<br><br>
	<table border="1" class="browseTable tblGrid">
		<tr><th colspan="7">Cache Registry:</th></tr>
		<tr>
			<th width="10">No.</th>
			<th>Cache Name</th>
			<th>Current<br>Size</th>
			<th>Max<br>Size</th>
			<th>Hit/Miss</th>
			<th>Last Reap</th>
			<th>Actions</th>
		</tr>
		<cfset index = 1>
		<cfloop array="#aCaches#" index="cacheName">
			<cfset stStats = probeWS.getCacheInfo(cacheName)>
			<cfif stStats.maxSize gt 0>
				<cfset cacheWarning = (stStats.currentSize gt stStats.maxSize or
										(stStats.maxSize gte stStats.currentSize 
										and stStats.currentSize/stStats.maxSize gt 0.9))>
			<cfelse>
				<cfset cacheWarning = false>
			</cfif>
			<tr <cfif cacheWarning>style="background-color:pink;"</cfif>>
				<td>#index#.</td>
				<td>#cacheName#</td>
				<td align="right">#stStats.currentSize#</td>
				<td align="right">#stStats.maxSize#</td>
				<td align="right">#stStats.hitCount# / #stStats.missCount#</td>
				<td align="center">
					<cfif stStats.lastReap neq "" and dateFormat(stStats.lastReap,"mm/dd/yyyy") neq "12/30/1899">
						#lsDateFormat(stStats.lastReap)#<br>#lsTimeFormat(stStats.lastReap)#
					<cfelse>
						-
					</cfif>
				</td>
				<td align="center">
					[<a href="index.cfm?event=ehSiteMonitor.dspCacheList&cacheName=#cacheName#" rel="floatbox" rev="width:450 height:350 loadPageOnClose:self">list</a>]
					[<a href="index.cfm?event=ehSiteMonitor.doCacheReap&cacheName=#cacheName#">reap</a>]
				</td>
			</tr>
			<cfset index=index+1>
		</cfloop>
	</table>

</cfoutput>

