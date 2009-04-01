<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.oCatalog" default="">
<cfparam name="request.requestState.stModule" default="">
<cfparam name="request.requestState.tagInfo" default="">
<cfparam name="request.requestState.pageHREF" default="">

<cfscript>
	oPage = request.requestState.oPage;
	oCatalog = request.requestState.oCatalog;
		
	thisModule = request.requestState.stModule;
	tagInfo = request.requestState.tagInfo;
	thisPageHREF = request.requestState.pageHREF;	

	lstBaseAttribs = "location,id,title,container,style,icon,moduleType,class,output";
	lstAllAttribs = structKeyList(thisModule);
	lstCustomAttribs = "";
	
	title = oPage.getTitle();
</cfscript>

<cfoutput>
	<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="8" cellspacing="0">
		<tr>
			<td nowrap="yes">
				<strong>Title:</strong> #title#
			</td>
			<td align="right">
				<cfmodule template="../../../includes/sitePageSelector.cfm">
			</td>
		</tr>
	</table>


	<form name="frmModule" action="index.cfm?event=ehPage.doSaveModule" method="post" style="margin:0px;padding:0px;">
		<input type="hidden" name="event" value="ehPage.doSaveModule" />

		<input type="hidden" name="location" value="#thisModule.location#" />
		<input type="hidden" name="id" value="#thisModule.ID#">
		<input type="hidden" name="moduleType" value="#thisModule.moduleType#">
		<input type="hidden" name="_baseAttribs" id="_baseAttribs" value="#lstBaseAttribs#">

		<br>

		<table width="100%">
			<tr valign="top">
				<td>
					<div style="font-weight:bold;font-size:16px;border-bottom:1px solid silver;">General Properties</div>

					<table style="margin:5px;">
						<tr>
							<td style="width:100px;font-size:16px;"><strong>ID:</strong></td>
							<td style="font-size:16px;"><b>#thisModule.ID#</b> (#thisModule.moduleType#)</td>
						</tr>
						<tr>
							<td><strong>Title:</strong></td>
							<td>
								<input type="text" name="title" 
										value="#thisModule.Title#" 
										class="formField">
							</td>
						</tr>
						<tr>
							<td><strong>Icon URL:</strong></td>
							<td>
								<input type="text" name="icon" 
										value="#thisModule.icon#" 
										class="formField">
							</td>
						</tr>
						<tr>
							<td><strong>Module Container:</strong></td>
							<td>
								<input type="radio" name="container" 
										style="border:0px;width:15px;"
										value="true" 
										<cfif thisModule.container>checked</cfif>> Yes 
								<input type="radio" name="container" 
										style="border:0px;width:15px;"
										value="false" 
										<cfif not thisModule.container>checked</cfif>> No 
							</td>
						</tr>
					</table>
					<br>
					
					<div style="font-weight:bold;font-size:16px;border-bottom:1px solid silver;">Display Properties</div>

					<table style="margin:5px;">
						<tr>
							<td style="width:100px;"><strong>CSS Class:</strong></td>
							<td>
								<input type="text" name="class" 
										value="#thisModule.class#" 
										class="formField">
							</td>
						</tr>
						<tr>
							<td><strong>CSS Style:</strong></td>
							<td>
								<input type="text" name="style" 
										value="#thisModule.style#" 
										class="formField">
							</td>
						</tr>
						<tr>
							<td><strong>Display output:</strong></td>
							<td>	
								<input type="radio" name="output" 
										style="border:0px;width:15px;"
										value="true" 
										<cfif thisModule.output>checked</cfif>> Yes 
								<input type="radio" name="output" 
										style="border:0px;width:15px;"
										value="false" 
										<cfif not thisModule.output>checked</cfif>> No 
							</td>
						</tr>
					</table>
					<br>

					<div style="font-weight:bold;font-size:16px;border-bottom:1px solid silver;">Module Properties</div>

					<cfif arrayLen(tagInfo.properties) gt 0>
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
								<cfset lstCustomAttribs = listAppend(lstCustomAttribs, prop.name)>
								
								<tr>
									<td style="width:100px;"><strong>#prop.displayName#:</strong></td>
									<td>
										<cfswitch expression="#tmpType#">
											<cfcase value="list">
												<cfif structKeyExist(prop,"values")>
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
												<cfset qryResources = oCatalog.getResourcesByType(resourceType)>
												<cfquery name="qryResources" dbtype="query">
													SELECT *, upper(package) as upackage, upper(id) as uid
														FROM qryResources
														ORDER BY upackage, uid, id
												</cfquery>
												<select name="#thisAttr#" class="formField">
													<cfif not prop.required><option value="_NOVALUE_"></option></cfif>
													<cfloop query="qryResources">
														<option value="#qryResources.id#"
																<cfif tmpAttrValue eq qryResources.id>selected</cfif>	
																	>[#qryResources.package#] #qryResources.id#</option>
													</cfloop>
												</select>
												<cfif prop.required><span style="color:red;">&nbsp; * required</span></cfif>
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
								<cfif prop.hint neq "">
									<tr>
										<td>&nbsp;</td>
										<td><div class="formFieldTip">#prop.hint#</div></td>
									</tr>
								</cfif>
							</cfloop>
						</table>
					</cfif>
									
<!---					
					<cfif thisModule.moduleType eq "content">
						<cfset qryResources_content = oCatalog.getResourcesByType("content")>
						<cfset qryResources_html = oCatalog.getResourcesByType("html")>

						<cfquery name="qryResources_content" dbtype="query">
							SELECT *, upper(package) as upackage, upper(id) as uid FROM qryResources_content ORDER BY upackage, uid, id
						</cfquery>
						<cfquery name="qryResources_html" dbtype="query">
							SELECT *, upper(package) as upackage, upper(id) as uid FROM qryResources_html ORDER BY upackage, uid, id
						</cfquery>

					
						<div style="font-weight:bold;font-size:16px;border-bottom:1px solid silver;">Content Properties</div>
						<table style="margin:5px;">
							<tr>
								<td><strong>Resource Type:</strong></td>
								<td>
									<select name="resourceType" class="formField" onchange="toggleResourceType(this.value)">
										<option value="" <cfif thisModule.resourceType eq "">selected</cfif>>None</option>
										<option value="content" <cfif thisModule.resourceType eq "content">selected</cfif>>Content</option>
										<option value="html" <cfif thisModule.resourceType eq "HTML">selected</cfif>>HTML</option>
									</select>
								</td>
							</tr>
							<tr>
								<td><strong>Resource ID:</strong></td>
								<td>
									<select name="resourceID_content" class="formField" id="resourceID_content" <cfif thisModule.resourceType neq "content">style="display:none;"</cfif>>
										<cfloop query="qryResources_content">
											<cfset tmpName = qryResources_content.id>
											<option value="#qryResources_content.id#"
													<cfif thisModule.resourceID eq qryResources_content.id>selected</cfif>	
														>[#qryResources_content.package#] #tmpName#</option>
										</cfloop>
									</select>

									<select name="resourceID_html" class="formField" id="resourceID_html" <cfif thisModule.resourceType neq "html">style="display:none;"</cfif>>
										<cfloop query="qryResources_html">
											<cfset tmpName = qryResources_html.name>
											<option value="#qryResources_html.id#"
													<cfif thisModule.resourceID eq qryResources_html.id>selected</cfif>	
														>[#qryResources_html.package#] #tmpName#</option>
										</cfloop>
									</select>
									
									<div id="resourceID_none" <cfif thisModule.resourceType neq "">style="display:none;"</cfif>><em>Not using a resource</em></div>
								</td>
							</tr>
							<tr>
								<td><strong>HREF:</strong></td>
								<td>
									<input type="text" name="href" 
											value="#thisModule.href#" 
											class="formField">
								</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td><strong>Use Cache?:</strong></td>
								<td>
									<input type="checkbox" name="cache" 
											style="border:0px;width:auto;"
											value="true" 
											<cfif thisModule.cache>checked</cfif> style="width:15px;"> 
									&nbsp;&nbsp;&nbsp;&nbsp;
									<strong>Cache TTL:</strong>
									<input type="text" name="cacheTTL" 
											value="#thisModule.cacheTTL#" 
											style="width:50px;"
											class="formField"> &nbsp;
									<span class="formFieldTip">Time To Live for cached content in minutes</span>
								</td>
							</tr>
						</table>
					<cfelse>

						<div style="font-weight:bold;font-size:16px;border-bottom:1px solid silver;">Other Properties</div>
	
						<table style="margin:5px;">
							<cfset bHasOtherProps = false>
							<cfloop collection="#thisModule#" item="thisAttr">
								<cfif Not ListFindNoCase(lstAttribs,thisAttr) and not ListFindNoCase(lstIgnoreAttribs,thisAttr) and not ListFindNoCase(lstContentAttribs,thisAttr)>
									<cfset tmpAttrValue = thisModule[thisAttr]>
									<cfset tmpNodeInfo = structNew()>
									<cfset bNodeInfoFound = false>
									<cfset bHasOtherProps = true>
									
									<cfloop from="1" to="#arrayLen(aAttrInfo)#" index="i">
										<cfset tmpNode = aAttrInfo[i]>
										<cfif tmpNode.name eq thisAttr>
											<cfset tmpNodeInfo = tmpNode>
											<cfset bNodeInfoFound = true>
											<cfbreak>
										</cfif>
									</cfloop>
	
									<cfif bNodeInfoFound>
										<cfif tmpNodeInfo.label neq "">
											<cfset thisAttrLabel = tmpNodeInfo.label>
										<cfelse>
											<cfset thisAttrLabel = thisAttr>
										</cfif>
										
										<cfif tmpNodeInfo.type eq "resource" or tmpNodeInfo.type eq "resourceOnly">
											<cfif tmpNodeInfo.resourceType neq "">
												<cfset qryResources = oCatalog.getResourcesByType(tmpNodeInfo.resourceType)>
												<cfquery name="qryResources" dbtype="query">
													SELECT *, upper(package) as upackage, upper(id) as uid
														FROM qryResources
														ORDER BY upackage, uid, id
												</cfquery>
											<cfelse>
												<cfset tmpNodeInfo.type = "text">
											</cfif>
										</cfif>
										
										<tr valign="top">
											<td width="50"><strong>#thisAttrLabel#:</strong></td>
											<td>
												<cfswitch expression="#tmpNodeInfo.type#">
													<cfcase value="list">
														<select name="#thisAttr#" class="formField" style="width:150px;">
															<cfloop list="#tmpNodeInfo.values#" index="item">
																<option value="#item#" <cfif tmpAttrValue eq item>selected</cfif>>#item#</option>
															</cfloop>
														</select>
													</cfcase>
													<cfcase value="resourceOnly">
														<select name="#thisAttr#" class="formField">
															<cfloop query="qryResources">
																<cfif qryResources.name eq "">
																	<cfset tmpName = qryResources.id>
																<cfelse>
																	<cfset tmpName = qryResources.name>
																</cfif>
																<cfset tmpVal = evaluate("qryResources." & tmpNodeInfo.resourceField)>
																<option value="#tmpVal#"
																		<cfif tmpAttrValue eq tmpVal>selected</cfif>	
																			>[#qryResources.package#] #tmpName#</option>
															</cfloop>
														</select>
													</cfcase>
													<cfcase value="resource">
														<input type="text" 
																name="#thisAttr#" 
																id="fld_#thisAttr#"
																value="#tmpAttrValue#" 
																class="formField">
														[ <a href="##" onclick="document.getElementById('fld_#thisAttr#_alt').style.display='block'"><strong>Pick #tmpNodeInfo.resourceType# from list</strong></a> ]<br>
														<select name="#thisAttr#_alt" class="formField" id="fld_#thisAttr#_alt" 
																style="display:none;margin-top:10px;"
																onchange="document.getElementById('fld_#thisAttr#').value=this.value;this.style.display='none'">
															<cfloop query="qryResources">
																<cfif qryResources.name eq "">
																	<cfset tmpName = qryResources.id>
																<cfelse>
																	<cfset tmpName = qryResources.name>
																</cfif>
																<cfset tmpVal = evaluate("qryResources." & tmpNodeInfo.resourceField)>
																<option value="#tmpVal#"
																		<cfif tmpAttrValue eq tmpVal>selected</cfif>	
																			>[#qryResources.package#] #tmpName#</option>
															</cfloop>
														</select>
													</cfcase>
													<cfdefaultcase>
														<input type="text" 
																name="#thisAttr#" 
																value="#tmpAttrValue#" 
																class="formField">
													</cfdefaultcase>
												</cfswitch>
	
												<div class="formFieldTip">#tmpNodeInfo.description#</div>
											</td>
										</tr>
									<cfelse>
										<tr valign="top">
											<td width="50"><strong>#thisAttr#:</strong></td>
											<td>
												<input type="text" 
														name="#thisAttr#" 
														value="#tmpAttrValue#" 
														class="formField">
												<br><br>
											</td>
										</tr>
									</cfif>
								</cfif>
							</cfloop>
						</table>
						<cfif not bHasOtherProps>
							<em>This module does not have any additional properties</em>
						</cfif>
					</cfif>

---->
				</td>
				<td style="width:10px;">&nbsp;</td>
				
					<td style="border:1px solid ##ccc;background-color:##ebebeb;width:250px;font-size:14px;line-height:18px;">
						<cfinclude template="vwContentTagInfo.cfm">
					</td>
				
			</tr>
		</table>
		<p>
			<input type="hidden" name="_customAttribs" id="_customAttribs" value="#lstCustomAttribs#">	
			<input type="button" 
					name="btnCancel" 
					value="Return To Page Editor" 
					onClick="document.location='?event=ehPage.dspMain'">
			&nbsp;&nbsp;
			<input type="submit" name="btnSave" value="Apply Changes">
		</p>
	</form>
</cfoutput>

