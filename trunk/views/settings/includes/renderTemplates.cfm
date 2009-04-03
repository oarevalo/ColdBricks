<cfparam name="request.requestState.oHomePortalsConfigBean" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	
	try{ rt_page = oHomePortalsConfigBean.getRenderTemplate("page"); } catch(any e) { rt_page = ""; }
	try{ rt_module = oHomePortalsConfigBean.getRenderTemplate("module"); } catch(any e) { rt_module = ""; }
	try{ rt_moduleNC = oHomePortalsConfigBean.getRenderTemplate("moduleNoContainer"); } catch(any e) { rt_moduleNC = ""; }
</cfscript>

<cfoutput>
	<tr><td colspan="2"><h2>Render Templates:</h2></td></tr>
	<tr>
		<td width="150"><strong>Page:</strong></td>
		<td>
			<input type="text" name="rt_page" value="#rt_page#" size="30" class="formField">
			<a href="index.cfm?event=ehSettings.dspEditXML&configFile=#rt_page#">Edit XML</a>
		</td>
	</tr>
	<tr>
		<td width="150"><strong>Module:</strong></td>
		<td>
			<input type="text" name="rt_module" value="#rt_module#" size="30" class="formField">
			<a href="index.cfm?event=ehSettings.dspEditXML&configFile=#rt_module#">Edit XML</a>
		</td>
	</tr>
	<tr>
		<td width="150"><strong>Module (w/o Container):</strong></td>
		<td>
			<input type="text" name="rt_moduleNC" value="#rt_moduleNC#" size="30" class="formField">
			<a href="index.cfm?event=ehSettings.dspEditXML&configFile=#rt_moduleNC#">Edit XML</a>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>