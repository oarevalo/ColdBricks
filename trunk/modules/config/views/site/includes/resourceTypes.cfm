<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.resTypeEditKey" default="">
<cfparam name="request.requestState.resTypePropEditKey" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	oAppConfigBean = request.requestState.oAppConfigBean;
	resTypeEditKey = request.requestState.resTypeEditKey;
	resTypePropEditKey = request.requestState.resTypePropEditKey;
		
	dspEvent = "config.ehSiteConfig.dspMain";
	
	aPropTypes = ["text","list","resource","boolean"];
</cfscript>

<script type="text/javascript">
	function confirmDeleteResType(name) {
		if(confirm("Delete resource type?")) {
			document.location = "index.cfm?event=config.ehSiteConfig.doDeleteResourceType&name=" + name;
		}
	}
	function confirmDeleteResTypeProp(type,name) {
		if(confirm("Delete resource type property?")) {
			document.location = "index.cfm?event=config.ehSiteConfig.doDeleteResourceTypeProperty&resTypeEditKey=" + type + "&name="+name;
		}
	}
	function togglePropType(type) {
		var s1 = document.getElementById("rowValues");
		var s2 = document.getElementById("rowResourceTypes");

		if(type=="list") {
			s1.style.display = "table-row";
			s2.style.display = "none";
		} else if(type=="resource") {
			s2.style.display = "table-row";
			s1.style.display = "none";
		} else {
			s1.style.display = "none";
			s2.style.display = "none";
		}
	}
</script>

<cfoutput>
	<tr><td colspan="2"><h2>Resource Types:</h2></td></tr>
	<tr>
		<td colspan="2">
			<div class="formFieldTip">
				Resource Types are different types of resources that can be used on a page. Resources are individual content
				elements stored on Resource Libraries. Each resource type has its own set of properties and can be customized
				to represent things that are meaningful to the application.
			</div>
				
			<table style="width:100%;border:1px solid silver;">
				<tr>
					<th style="background-color:##ccc;width:50px;">No.</th>
					<th style="background-color:##ccc;width:100px;">Resource Type</th>
					<th style="background-color:##ccc;">Res Bean Path</th>
					<th style="background-color:##ccc;width:100px;">Action</th>
				</tr>
				<cfset stResTypes = oHomePortalsConfigBean.getResourceTypes()>
				<cfset index = 1>
				<cfloop collection="#stResTypes#" item="key">
					<tr <cfif index mod 2>class="altRow"</cfif>>
						<td style="width:50px;" align="right"><strong>#index#.</strong></td>
						<td style="width:100px;" align="center">#key#</td>
						<td>
							<cfif structKeyExists(stResTypes[key],"resBeanPath") and stResTypes[key].resBeanPath neq "">
								#stResTypes[key].resBeanPath#
							<cfelse>
								default
							</cfif>
						</td>
						<td align="center">
							< base >
						</td>
					</tr>
					<cfset index++>
				</cfloop>
				
				<cfset stResTypes = oAppConfigBean.getResourceTypes()>
				<cfloop collection="#stResTypes#" item="key">
					<tr <cfif index mod 2>class="altRow"</cfif> <cfif resTypeEditKey eq key>style="font-weight:bold;"</cfif>>
						<td style="width:50px;" align="right"><strong>#index#.</strong></td>
						<td style="width:100px;" align="center"><a href="index.cfm?event=#dspEvent#&resTypeEditKey=#key#">#key#</a></td>
						<td>
							<cfif structKeyExists(stResTypes[key],"resBeanPath") and stResTypes[key].resBeanPath neq "">
								#stResTypes[key].resBeanPath#
							<cfelse>
								default
							</cfif>
						</td>
						<td align="center">
							<a href="index.cfm?event=#dspEvent#&resTypeEditKey=#key#"><img src="images/page_edit.png" border="0" alt="Edit resource type" title="Edit resource type"></a>
							<a href="##" onclick="confirmDeleteResType('#key#')"><img src="images/page_delete.png" border="0" alt="Delete resource type" title="Delete resource type"></a>
						</td>
					</tr>
					<cfset index++>
				</cfloop>
			</table>
			<cfif resTypeEditKey neq "">
				<cfif resTypeEditKey neq "__NEW__">
					<cfset isNew = false>
					<cfset stResType = oAppConfigBean.getResourceType(resTypeEditKey)>
				<cfelse>
					<cfset isNew = true>
					<cfset stResType = structNew()>	
					<cfset resTypeEditKey = "">
				</cfif>
				<cfparam name="stResType.name" default="">
				<cfparam name="stResType.folderName" default="">
				<cfparam name="stResType.fileTypes" default="">
				<cfparam name="stResType.resBeanPath" default="">
				<cfparam name="stResType.description" default="">
				<cfparam name="stResType.properties" default="#arrayNew(1)#">
				<br />
				<cfif isNew>
					<p><b>Create New Resource Type</b></p>
				<cfelse>
					<p><b>Edit Resource Type</b></p>
				</cfif>
				
				<table style="width:100%;border:1px solid silver;margin-top:5px;">
					<tr valign="top">
						<td style="width:430px;">
							<form name="frmEditResType" action="index.cfm" method="post">
								<input type="hidden" name="event" value="config.ehSiteConfig.doSaveResourceType">
								<cfif not isNew>
									<input type="hidden" name="name" value="#resTypeEditKey#">
								</cfif>
								<table>
									<tr>
										<td><b>Name:</b></td>
										<td><input type="text" name="name" value="#stResType.name#" style="width:300px;" class="formField" <cfif not isNew>disabled</cfif>></td>
									</tr>
									<tr>
										<td><b>Folder Name:</b></td>
										<td><input type="text" name="folderName" value="#stResType.folderName#" style="width:300px;" class="formField"></td>
									</tr>
									<tr>
										<td><b>File Types:</b></td>
										<td><input type="text" name="fileTypes" value="#stResType.fileTypes#" style="width:300px;" class="formField"></td>
									</tr>
									<tr>
										<td><b>Res Bean Path:</b></td>
										<td><input type="text" name="resBeanPath" value="#stResType.resBeanPath#" style="width:300px;" class="formField"></td>
									</tr>
									<tr valign="top">
										<td><b>Description:</b></td>
										<td><textarea name="description" style="width:300px;" class="formField" rows="3">#stResType.description#</textarea></td>
									</tr>
								</table>
								<br />
								<input type="submit" name="btnSave" value="Apply" style="font-size:11px;">
								<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=#dspEvent#'">
							</form>
						</td>
						<cfif not isNew>
							<td>
								<cfset aProps = stResType.properties>
								<b>Resource Type Properties:</b><br />
								<table style="width:100%;border:1px solid silver;margin-top:5px;">
									<tr>
										<th style="background-color:##ccc;width:50px;">No.</th>
										<th style="background-color:##ccc;width:100px;">Name</th>
										<th style="background-color:##ccc;">Type</th>
										<th style="background-color:##ccc;width:100px;">Action</th>
									</tr>
									<cfif isArray(aProps)>
										<cfloop from="1" to="#arrayLen(aProps)#" index="i">
											<cfparam name="aProps[i].name" default="">
											<cfparam name="aProps[i].type" default="">
											
											<tr <cfif i mod 2>class="altRow"</cfif> <cfif resTypePropEditKey eq i>style="font-weight:bold;"</cfif>>
												<td style="width:50px;" align="right"><strong>#i#.</strong></td>
												<td style="width:100px;" align="center"><a href="index.cfm?event=#dspEvent#&resTypeEditKey=#resTypeEditKey#&resTypePropEditKey=#i#">#aProps[i].name#</a></td>
												<td>#aProps[i].type#</td>
												<td align="center">
													<a href="index.cfm?event=#dspEvent#&resTypeEditKey=#resTypeEditKey#&resTypePropEditKey=#i#"><img src="images/page_edit.png" border="0" alt="Edit resource type property" title="Edit resource type property"></a>
													<a href="##" onclick="confirmDeleteResTypeProp('#resTypeEditKey#','#aProps[i].name#')"><img src="images/page_delete.png" border="0" alt="Delete resource type property" title="Delete resource type property"></a>
												</td>
											</tr>
										</cfloop>
									</cfif>
								</table>
	
								<cfif resTypePropEditKey gte 0>
									<cfif resTypePropEditKey gt 0>
										<cfset isNewProp = false>
										<cfset stResTypeProp = aProps[resTypePropEditKey]>
									<cfelse>
										<cfset isNewProp = true>
										<cfset stResTypeProp = structNew()>	
										<cfset resTypePropEditKey = "">
									</cfif>
									
									<cfparam name="stResTypeProp.name" default="">
									<cfparam name="stResTypeProp.description" default="">
									<cfparam name="stResTypeProp.type" default="">
									<cfparam name="stResTypeProp.values" default="">
									<cfparam name="stResTypeProp.required" default="">
									<cfparam name="stResTypeProp.default" default="">
									<cfparam name="stResTypeProp.label" default="">
									<br />
									<cfif isNewProp>
										<p><b>Create New Resource Type Property</b></p>
									<cfelse>
										<p><b>Edit Resource Type Property</b></p>
									</cfif>

									<cfif listLen(stResTypeProp.type,":") eq 2 and listfirst(stResTypeProp.type,":") eq "resource">
										<cfset tmpType = listfirst(stResTypeProp.type,":")>
										<cfset tmpResourceType = listlast(stResTypeProp.type,":")>
									<cfelse>
										<cfset tmpType = stResTypeProp.type>
										<cfset tmpResourceType = "">
									</cfif>

									<form name="frmEditResTypeProp" action="index.cfm" method="post">
										<input type="hidden" name="event" value="config.ehSiteConfig.doSaveResourceTypeProperty">
										<input type="hidden" name="resTypePropEditKey" value="#resTypePropEditKey#">
										<input type="hidden" name="resTypeEditKey" value="#resTypeEditKey#">
										<cfif not isNewProp>
											<input type="hidden" name="name" value="#stResTypeProp.name#">
										</cfif>
										<table>
											<tr>
												<td><b>Name:</b></td>
												<td><input type="text" name="name" value="#stResTypeProp.name#" style="width:200px;" class="formField" <cfif not isNewProp>disabled</cfif>></td>
											</tr>
											<tr>
												<td><b>Type:</b></td>
												<td>
													<select name="type" style="width:200px;" class="formField" onchange="togglePropType(this.value)">
														<cfloop from="1" to="#arrayLen(aPropTypes)#" index="j">
															<option value="#aPropTypes[j]#" <cfif tmpType eq aPropTypes[j]>selected</cfif>>#aPropTypes[j]#</option>
														</cfloop>
													</select>
												</td>
											</tr>
											<tr id="rowValues" <cfif tmpType neq "list">style="display:none;"</cfif>>
												<td><b>Values:</b></td>
												<td><input type="text" name="values" value="#stResTypeProp.values#" style="width:200px;" class="formField"></td>
											</tr>
											<tr id="rowResourceTypes" <cfif tmpType neq "resource">style="display:none;"</cfif>>
												<td><b>Resource Type:</b></td>
												<td>
													<select name="resourceType" style="width:200px;" class="formField">
														<cfloop collection="#stResTypes#" item="key">
															<option value="#key#" <cfif tmpResourceType eq key>selected</cfif>>#key#</option>
														</cfloop>
													</select>
												</td>
											</tr>
											<tr>
												<td><b>Default:</b></td>
												<td><input type="text" name="default" value="#stResTypeProp.default#" style="width:200px;" class="formField"></td>
											</tr>
											<tr>
												<td><b>Label:</b></td>
												<td><input type="text" name="label" value="#stResTypeProp.label#" style="width:200px;" class="formField"></td>
											</tr>
											<tr>
												<td><b>Required:</b></td>
												<td>
													<input type="radio" name="required" value="true" 
															style="width:auto;" class="formField" 
															<cfif isBoolean(stResTypeProp.required) and stResTypeProp.required>checked</cfif>> Yes
													&nbsp;&nbsp;
													<input type="radio" name="required" value="false" 
															style="width:auto;" class="formField" 
															<cfif isBoolean(stResTypeProp.required) and not stResTypeProp.required>checked</cfif>> No
												</td>
											</tr>
											<tr valign="top">
												<td><b>Description:</b></td>
												<td><textarea name="description" style="width:200px;" class="formField" rows="3">#stResTypeProp.description#</textarea></td>
											</tr>
										</table>
										<br />
										<input type="submit" name="btnSave" value="Apply" style="font-size:11px;">
										<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=#dspEvent#&resTypeEditKey=#resTypeEditKey#'">
									</form>
							<cfelse>
								<br>
								<a href="index.cfm?event=#dspEvent#&resTypeEditKey=#resTypeEditKey#&resTypePropEditKey=0">Click Here</a> to add a new property
							</cfif>
							</td>
						</cfif>
					</tr>
				</table>
				
			<cfelse>
				<br>
				<a href="index.cfm?event=#dspEvent#&resTypeEditKey=__NEW__">Click Here</a> to register a resource type
			</cfif>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>
			