<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.oAppConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	oAppConfigBean = request.requestState.oAppConfigBean;
	
	hasRTPage = true;
	hasRTModule = true;
	hasRTModuleNC = true;
	
	try{ rt_page = oAppConfigBean.getRenderTemplate("page"); } catch(any e) { rt_page = ""; }
	try{ rt_module = oAppConfigBean.getRenderTemplate("module"); } catch(any e) { rt_module = ""; }
	try{ rt_moduleNC = oAppConfigBean.getRenderTemplate("moduleNoContainer"); } catch(any e) { rt_moduleNC = ""; }

	if(rt_page eq "") {try{ rt_page = oHomePortalsConfigBean.getRenderTemplate("page"); hasRTPage = false; } catch(any e) { rt_page = ""; }}
	if(rt_module eq "") {try{ rt_module = oHomePortalsConfigBean.getRenderTemplate("module"); hasRTModule = false; } catch(any e) { rtmodule = ""; }}
	if(rt_moduleNC eq "") {try{ rt_moduleNC = oHomePortalsConfigBean.getRenderTemplate("moduleNoContainer"); hasRTModuleNC = false; } catch(any e) { rt_moduleNC = ""; }}
</cfscript>

<cfoutput>
	<tr><td colspan="2"><h2>Render Templates:</h2></td></tr>
	<tr>
		<td width="170">
			<input type="checkbox" name="appSettings" value="rt_page" <cfif hasRTPage>checked</cfif> onclick="toggleField(this.checked,'rt_page')">
			<strong>Page:</strong>
		</td>
		<td>
			<input type="text" name="rt_page" value="#rt_page#" id="fld_rt_page" size="30" class="formField" <cfif not hasRTPage>disabled</cfif>>
			<cfif hasRTPage>
				<a href="index.cfm?event=ehSiteConfig.dspEditXML&configFile=#rt_page#">Edit XML</a>
			</cfif>
		</td>
	</tr>
	<tr>
		<td width="170">
			<input type="checkbox" name="appSettings" value="rt_module" <cfif hasRTModule>checked</cfif> onclick="toggleField(this.checked,'rt_module')">
			<strong>Module:</strong>
		</td>
		<td>
			<input type="text" name="rt_module" value="#rt_module#" id="fld_rt_module" size="30" class="formField" <cfif not hasRTModule>disabled</cfif>>
			<cfif hasRTModule>
				<a href="index.cfm?event=ehSiteConfig.dspEditXML&configFile=#rt_module#">Edit XML</a>
			</cfif>
		</td>
	</tr>
	<tr>
		<td width="170">
			<input type="checkbox" name="appSettings" value="rt_moduleNC" <cfif hasRTModuleNC>checked</cfif> onclick="toggleField(this.checked,'rt_moduleNC')">
			<strong>Module (w/o Container):</strong>
		</td>
		<td>
			<input type="text" name="rt_moduleNC" value="#rt_moduleNC#" id="fld_rt_moduleNC" size="30" class="formField" <cfif not hasRTModuleNC>disabled</cfif>>
			<cfif hasRTModuleNC>
				<a href="index.cfm?event=ehSiteConfig.dspEditXML&configFile=#rt_moduleNC#">Edit XML</a>
			</cfif>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>