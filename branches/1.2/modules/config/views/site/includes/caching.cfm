<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.oAppConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	oAppConfigBean = request.requestState.oAppConfigBean;
	
	pageCacheSize = oAppConfigBean.getPageCacheSize();
	pageCacheTTL = oAppConfigBean.getPageCacheTTL();
	catalogCacheSize = oAppConfigBean.getCatalogCacheSize();
	catalogCacheTTL = oAppConfigBean.getCatalogCacheTTL();

	hasPageCacheSize = true;
	hasPageCacheTTL = true;
	hasCatalogCacheSize = true;
	hasCatalogCacheTTL = true;
	
	if(val(pageCacheSize) eq 0) {pageCacheSize = oHomePortalsConfigBean.getPageCacheSize(); hasPageCacheSize = false;}
	if(val(pageCacheTTL) eq 0) {pageCacheTTL = oHomePortalsConfigBean.getPageCacheTTL(); hasPageCacheTTL = false;}
	if(val(catalogCacheSize) eq 0) {catalogCacheSize = oHomePortalsConfigBean.getCatalogCacheSize(); hasCatalogCacheSize = false;}
	if(val(catalogCacheTTL) eq 0) {catalogCacheTTL = oHomePortalsConfigBean.getCatalogCacheTTL(); hasCatalogCacheTTL = false;}
</cfscript>

<cfoutput>
	<tr><td colspan="2"><h2>Caching:</h2></td></tr>
	<tr>
		<td colspan="2">
			<div class="formFieldTip">
				Caching is a mechanism used to improve performance by reducing the number of times the engine
				has to access the file system to lookup resources. The <b>Pages</b> cache refers to the caching of 
				content pages. The <b>Resources</b> cache deals with elements obtained from the Resource Library.<br /><br />
				<b>Max Size:</b> Maximum number of items that will be stored in memory at any given time. After the maximum 
				size is reached, the caching engine will start dropping older elements from the cache to make space for new
				ones.<br /><br />
				<b>TTL (min):</b> This is the number of minutes a cached entry will be considered valid for retrieval. After
				its time-to-live expires it will become invalid and will be retrieved again from the file system if requested.
			</div>
		</td>
	</tr>
	<tr>
		<td style="width:110px;">
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
		<td style="width:110px;">
			<strong>Resources:</strong>
		</td>
		<td>
			<input type="checkbox" name="appSettings" value="catalogCacheSize" <cfif hasCatalogCacheSize>checked</cfif> onclick="toggleField(this.checked,'catalogCacheSize')">
			<strong>Max Size:</strong>
			<input type="text" name="catalogCacheSize" value="#catalogCacheSize#" id="fld_catalogCacheSize" size="5" style="width:50px;" class="formField" <cfif not hasCatalogCacheSize>disabled</cfif>>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" name="appSettings" value="catalogCacheTTL" <cfif hasCatalogCacheTTL>checked</cfif> onclick="toggleField(this.checked,'catalogCacheTTL')">
			<strong>TTL (min):</strong>
			<input type="text" name="catalogCacheTTL" value="#catalogCacheTTL#" id="fld_catalogCacheTTL" size="5" style="width:50px;" class="formField" <cfif not hasCatalogCacheTTL>disabled</cfif>>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>