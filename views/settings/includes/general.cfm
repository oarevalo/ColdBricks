<cfparam name="request.requestState.oHomePortalsConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	
	defaultPage = oHomePortalsConfigBean.getDefaultPage();
	contentRoot = oHomePortalsConfigBean.getContentRoot();
</cfscript>

<cfoutput>
	<tr><td colspan="2"><h2>General Settings:</h2></td></tr>
	<tr valign="top">
		<td style="width:110px;"><strong>Content Root:</strong></td>
		<td>
			<input type="text" name="contentRoot" value="#contentRoot#" id="fld_contentRoot" size="30" class="formField">
			<div class="formFieldTip">
				The Content Root is the location where all site pages will be stored. Normally this is a relative path
				within the application pointing to a directory used exclusively to store content pages.
			</div>
		</td>
	</tr>
	<tr valign="top">
		<td style="width:110px;"><strong>Default Page:</strong></td>
		<td>
			<input type="text" name="defaultPage" value="#defaultPage#" id="fld_defaultPage" size="30" class="formField">
			<div class="formFieldTip">
				This is the name and path to a page that is loaded by default when no page is requested explicitly. 
				The location of the page is always relative to the content root.
			</div>
		</td>
	</tr>
</cfoutput>