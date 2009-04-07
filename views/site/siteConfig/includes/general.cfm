<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.oAppConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	oAppConfigBean = request.requestState.oAppConfigBean;
	
	hasDefaultPage = true;
	hasContentRoot = true;
	
	defaultPage = oAppConfigBean.getDefaultPage();
	contentRoot = oAppConfigBean.getContentRoot();

	if(defaultPage eq "") {
		defaultPage = oHomePortalsConfigBean.getDefaultPage();
		hasDefaultPage = false;
	}
	if(contentRoot eq "") {
		contentRoot = oHomePortalsConfigBean.getContentRoot();
		hasContentRoot = false;
	}
	
</cfscript>

<cfoutput>
	<tr><td colspan="2"><h2>General Settings:</h2></td></tr>
	<tr>
		<td width="170">
			<input type="checkbox" name="appSettings" value="contentRoot" <cfif hasContentRoot>checked</cfif> onclick="toggleField(this.checked,'contentRoot')">
			<strong>Content Root:</strong>
		</td>
		<td><input type="text" name="contentRoot" value="#contentRoot#" id="fld_contentRoot" size="30" class="formField" <cfif not hasContentRoot>disabled</cfif>></td>
	</tr>
	<tr>
		<td width="170">
			<input type="checkbox" name="appSettings" value="defaultPage" <cfif hasDefaultPage>checked</cfif> onclick="toggleField(this.checked,'defaultPage')">
			<strong>Default Page:</strong>
		</td>
		<td><input type="text" name="defaultPage" value="#defaultPage#" id="fld_defaultPage" size="30" class="formField" <cfif not hasDefaultPage>disabled</cfif>></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>