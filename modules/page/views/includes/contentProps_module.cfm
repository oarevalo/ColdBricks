<cfparam name="forceResourceType" default="">
<cfparam name="forceResourceID" default="">
<cfparam name="useResourceEditor" default="false">

<cfoutput>
	<div style="font-weight:bold;font-size:16px;border-bottom:1px solid silver;">Module Properties</div>
	
	<cfif structKeyExists(tagInfo,"properties") and arrayLen(tagInfo.properties) gt 0>
		<table style="margin:5px;">
			<cfloop from="1" to="#arrayLen(tagInfo.properties)#" index="i">
				<cfset prop = duplicate(tagInfo.properties[i])>
				<cfparam name="prop.name" default="property">
				<cfparam name="prop.hint" default="">
				<cfparam name="prop.default" default="">
				<cfparam name="prop.type" default="">
				<cfparam name="prop.required" default="false">
				<cfparam name="prop.displayName" default="#prop.name#">
				
				<cfparam name="thisModule[prop.name]" default="#prop.default#">
				
				<cfset tmpAttrValue = thisModule[prop.name]>
				<cfset thisAttr = prop.name>
				<cfif listLen(prop.type,":") eq 2 and listfirst(prop.type,":") eq "resource">
					<cfset tmpType = listfirst(prop.type,":")>
					<cfset resourceType = listlast(prop.type,":")>
				<cfelse>
					<cfset tmpType = prop.type>
				</cfif>
				<cfset lstModuleAttribs = listAppend(lstModuleAttribs, prop.name)>
				
				<cfif tmpType eq "resource" and forceResourceType neq "" and forceResourceID neq "" and resourceType eq forceResourceType>
					<cfset tmpAttrValue = forceResourceID>
				</cfif>
				
				<tr>
					<td style="width:100px;"><strong>#prop.displayName#:</strong></td>
					<td>
						<cfswitch expression="#tmpType#">
							<cfcase value="list">
								<cfif structKeyExists(prop,"values")>
									<cfset lstValues = prop.values>
								<cfelse>
									<cfset lstValues = "">
								</cfif>
								<cfparam name="prop.values" default="string">
								<select name="#thisAttr#" class="formField" style="width:150px;">
									<cfif not prop.required><option value="_NOVALUE_"></option></cfif>
									<cfloop list="#lstValues#" index="item">
										<option value="#item#" <cfif tmpAttrValue eq item>selected</cfif>>#item#</option>
									</cfloop>
								</select>
								<cfif prop.required><span style="color:red;">&nbsp; * required</span></cfif>
							</cfcase>
							
							<cfcase value="resource">
								<cfset qryResources = oCatalog.getIndex(resourceType)>
								<cfquery name="qryResources" dbtype="query">
									SELECT *, upper(package) as upackage, upper(id) as uid
										FROM qryResources
										ORDER BY upackage, uid, id
								</cfquery>
								<select name="#thisAttr#" class="formField" style="width:350px;">
									<cfif not prop.required><option value="_NOVALUE_"></option></cfif>
									<cfloop query="qryResources">
										<cfif qryResources.package neq "">
											<cfset tmpResID = qryResources.package & "/" & qryResources.id>
										<cfelse>
											<cfset tmpResID = qryResources.id>
										</cfif>
										<option value="#tmpResID#"
												<cfif tmpAttrValue eq tmpResID>selected</cfif>	
													>#tmpResID#</option>
									</cfloop>
								</select>
								<cfif prop.required><span style="color:red;">&nbsp; * required</span></cfif>
								
								<span style="white-space:nowrap;">
									&nbsp;&nbsp;
									<cfif useResourceEditor>
										<img src="images/page_edit.png" align="absmiddle">
										<a href="javascript:resourceEditor.open('#jsStringFormat(tmpAttrValue)#','#jsStringFormat(resourceType)#','',0);">Edit</a>
										&nbsp;
										<img src="images/page_add.png" align="absmiddle">
										<a href="javascript:resourceEditor.open('NEW','#jsStringFormat(resourceType)#','',0);">Create</a>
									<cfelse>
										<a href="index.cfm?event=resources.ehResources.dspMain&resourceType=#resourceType#&id=#tmpAttrValue#">[Add/Edit]</a>
									</cfif>
								</span>
							</cfcase>
							
							<cfcase value="boolean">
								<cfif prop.required>
									<cfset isTrueChecked = (isBoolean(tmpAttrValue) and tmpAttrValue)>
									<cfset isFalseChecked = (isBoolean(tmpAttrValue) and not tmpAttrValue) or (tmpAttrValue eq "")>
								<cfelse>
									<cfset isTrueChecked = (isBoolean(tmpAttrValue) and tmpAttrValue)>
									<cfset isFalseChecked = (isBoolean(tmpAttrValue) and not tmpAttrValue)>
								</cfif>
								
								<input type="radio" name="#thisAttr#" 
										style="border:0px;width:15px;"
										value="true" 
										<cfif isTrueChecked>checked</cfif>> True 
								<input type="radio" name="#thisAttr#" 
										style="border:0px;width:15px;"
										value="false" 
										<cfif isFalseChecked>checked</cfif>> False 
								<cfif prop.required><span style="color:red;">&nbsp; * required</span></cfif>
							</cfcase>
							
							<cfdefaultcase>
								<input type="text" 
										name="#thisAttr#" 
										value="#tmpAttrValue#" 
										class="formField">
								<cfif prop.required><span style="color:red;">&nbsp; * required</span></cfif>
							</cfdefaultcase>
						</cfswitch>
						<input type="hidden" name="#thisAttr#_default" value="#prop.default#">
					</td>
				</tr>
				<cfif prop.hint neq "" and prop.hint neq "N/A">
					<tr>
						<td>&nbsp;</td>
						<td><div class="formFieldTip">#prop.hint#</div></td>
					</tr>
				</cfif>
			</cfloop>
		</table>
	<cfelse>
		<table style="margin:5px;">
			<tr>
				<td colspan="2"><em>This content tag does not have any defined properties</em></td>
			</tr>
		</table>
	</cfif>
	<cfset lstIgnoreAttribs = listAppend(lstIgnoreAttribs, lstModuleAttribs)>
</cfoutput>