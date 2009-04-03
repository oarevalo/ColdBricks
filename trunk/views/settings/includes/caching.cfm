<cfparam name="request.requestState.oHomePortalsConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	
	pageCacheSize = oHomePortalsConfigBean.getPageCacheSize();
	pageCacheTTL = oHomePortalsConfigBean.getPageCacheTTL();
	contentCacheSize = oHomePortalsConfigBean.getContentCacheSize();
	contentCacheTTL = oHomePortalsConfigBean.getContentCacheTTL();
	rssCacheSize = oHomePortalsConfigBean.getRSSCacheSize();
	rssCacheTTL = oHomePortalsConfigBean.getRSSCacheTTL();
</cfscript>

<cfoutput>
	<tr><td colspan="2"><h2>Caching:</h2></td></tr>
	<tr>
		<td width="150">
			<strong>Pages:</strong>
		</td>
		<td>
			<strong>Max Size:</strong>
			<input type="text" name="pageCacheSize" value="#pageCacheSize#" id="fld_pageCacheSize" size="5" style="width:50px;" class="formField">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<strong>TTL (min):</strong>
			<input type="text" name="pageCacheTTL" value="#pageCacheTTL#" id="fld_pageCacheTTL" size="5" style="width:50px;" class="formField">	
		</td>
	</tr>
	<tr>
		<td width="150">
			<strong>Content:</strong>
		</td>
		<td>
			<strong>Max Size:</strong>
			<input type="text" name="contentCacheSize" value="#contentCacheSize#" id="fld_contentCacheSize" size="5" style="width:50px;" class="formField">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<strong>TTL (min):</strong>
			<input type="text" name="contentCacheTTL" value="#contentCacheTTL#" id="fld_contentCacheTTL" size="5" style="width:50px;" class="formField">
		</td>
	</tr>
	<tr>
		<td width="150">
			<strong>RSS Feeds:</strong>
		</td>
		<td>
			<strong>Max Size:</strong>
			<input type="text" name="rssCacheSize" value="#rssCacheSize#" id="fld_rssCacheSize" size="5" style="width:50px;" class="formField">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<strong>TTL (min):</strong>
			<input type="text" name="rssCacheTTL" value="#rssCacheTTL#" id="fld_rssCacheTTL" size="5" style="width:50px;" class="formField">
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>