<cfparam name="request.requestState.oHomePortalsConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	
	pageCacheSize = oHomePortalsConfigBean.getPageCacheSize();
	pageCacheTTL = oHomePortalsConfigBean.getPageCacheTTL();
	catalogCacheSize = oHomePortalsConfigBean.getCatalogCacheSize();
	catalogCacheTTL = oHomePortalsConfigBean.getCatalogCacheTTL();
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
			<strong>Resources:</strong>
		</td>
		<td>
			<strong>Max Size:</strong>
			<input type="text" name="catalogCacheSize" value="#catalogCacheSize#" id="fld_catalogCacheSize" size="5" style="width:50px;" class="formField">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<strong>TTL (min):</strong>
			<input type="text" name="catalogCacheTTL" value="#catalogCacheTTL#" id="fld_catalogCacheTTL" size="5" style="width:50px;" class="formField">
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>