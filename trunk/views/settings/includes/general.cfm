<cfparam name="request.requestState.oHomePortalsConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	
	defaultPage = oHomePortalsConfigBean.getDefaultPage();
	contentRoot = oHomePortalsConfigBean.getContentRoot();
</cfscript>

<cfoutput>
	<tr><td colspan="2"><h2>General Settings:</h2></td></tr>
	<tr>
		<td width="150"><strong>Content Root:</strong></td>
		<td><input type="text" name="contentRoot" value="#contentRoot#" id="fld_contentRoot" size="30" class="formField"></td>
	</tr>
	<tr>
		<td width="150"><strong>Default Page:</strong></td>
		<td><input type="text" name="defaultPage" value="#defaultPage#" id="fld_defaultPage" size="30" class="formField"></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>