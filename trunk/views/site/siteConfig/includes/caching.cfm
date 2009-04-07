<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.oAppConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	oAppConfigBean = request.requestState.oAppConfigBean;
	
	pageCacheSize = oAppConfigBean.getPageCacheSize();
	pageCacheTTL = oAppConfigBean.getPageCacheTTL();
	contentCacheSize = oAppConfigBean.getContentCacheSize();
	contentCacheTTL = oAppConfigBean.getContentCacheTTL();
	rssCacheSize = oAppConfigBean.getRSSCacheSize();
	rssCacheTTL = oAppConfigBean.getRSSCacheTTL();

	hasPageCacheSize = true;
	hasPageCacheTTL = true;
	hasContentCacheSize = true;
	hasContentCacheTTL = true;
	hasRSSCacheSize = true;
	hasRSSCacheTTL = true;
	
	if(val(pageCacheSize) eq 0) {pageCacheSize = oHomePortalsConfigBean.getPageCacheSize(); hasPageCacheSize = false;}
	if(val(pageCacheTTL) eq 0) {pageCacheTTL = oHomePortalsConfigBean.getPageCacheTTL(); hasPageCacheTTL = false;}
	if(val(contentCacheSize) eq 0) {contentCacheSize = oHomePortalsConfigBean.getContentCacheSize(); hasContentCacheSize = false;}
	if(val(contentCacheTTL) eq 0) {contentCacheTTL = oHomePortalsConfigBean.getContentCacheTTL(); hasContentCacheTTL = false;}
	if(val(rssCacheSize) eq 0) {rssCacheSize = oHomePortalsConfigBean.getRSSCacheSize(); hasRSSCacheSize = false;}
	if(val(rssCacheTTL) eq 0) {rssCacheTTL = oHomePortalsConfigBean.getRSSCacheTTL(); hasRSSCacheTTL = false;}
</cfscript>

<cfoutput>
	<tr><td colspan="2"><h2>Caching:</h2></td></tr>
	<tr>
		<td width="170">
			<strong>Pages:</strong>
		</td>
		<td>
			<input type="checkbox" name="appSettings" value="pageCacheSize" <cfif hasPageCacheSize>checked</cfif> onclick="toggleField(this.checked,'pageCacheSize')">
			<strong>Max Size:</strong>
			<input type="text" name="pageCacheSize" value="#pageCacheSize#" id="fld_pageCacheSize" size="5" style="width:50px;" class="formField" <cfif not hasPageCacheSize>disabled</cfif>>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="appSettings" value="pageCacheTTL" <cfif hasPageCacheTTL>checked</cfif> onclick="toggleField(this.checked,'pageCacheTTL')">
			<strong>TTL (min):</strong>
			<input type="text" name="pageCacheTTL" value="#pageCacheTTL#" id="fld_pageCacheTTL" size="5" style="width:50px;" class="formField" <cfif not hasPageCacheTTL>disabled</cfif>>	
		</td>
	</tr>
	<tr>
		<td width="170">
			<strong>Content:</strong>
		</td>
		<td>
			<input type="checkbox" name="appSettings" value="contentCacheSize" <cfif hasContentCacheSize>checked</cfif> onclick="toggleField(this.checked,'contentCacheSize')">
			<strong>Max Size:</strong>
			<input type="text" name="contentCacheSize" value="#contentCacheSize#" id="fld_contentCacheSize" size="5" style="width:50px;" class="formField" <cfif not hasContentCacheSize>disabled</cfif>>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="appSettings" value="contentCacheTTL" <cfif hasContentCacheTTL>checked</cfif> onclick="toggleField(this.checked,'contentCacheTTL')">
			<strong>TTL (min):</strong>
			<input type="text" name="contentCacheTTL" value="#contentCacheTTL#" id="fld_contentCacheTTL" size="5" style="width:50px;" class="formField" <cfif not hasContentCacheTTL>disabled</cfif>>
		</td>
	</tr>
	<tr>
		<td width="170">
			<strong>RSS Feeds:</strong>
		</td>
		<td>
			<input type="checkbox" name="appSettings" value="rssCacheSize" <cfif hasRSSCacheSize>checked</cfif> onclick="toggleField(this.checked,'rssCacheSize')">
			<strong>Max Size:</strong>
			<input type="text" name="rssCacheSize" value="#rssCacheSize#" id="fld_rssCacheSize" size="5" style="width:50px;" class="formField" <cfif not hasRSSCacheSize>disabled</cfif>>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="appSettings" value="rssCacheTTL" <cfif hasRSSCacheTTL>checked</cfif> onclick="toggleField(this.checked,'rssCacheTTL')">
			<strong>TTL (min):</strong>
			<input type="text" name="rssCacheTTL" value="#rssCacheTTL#" id="fld_rssCacheTTL" size="5" style="width:50px;" class="formField" <cfif not hasRSSCacheTTL>disabled</cfif>>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>