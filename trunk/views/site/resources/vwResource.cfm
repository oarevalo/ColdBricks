<cfparam name="request.requestState.resLibIndex" default="">
<cfparam name="request.requestState.resourceType" default="">
<cfparam name="request.requestState.package" default="">
<cfparam name="request.requestState.id" default="">

<cfparam name="request.requestState.oCatalog" default="">
<cfparam name="request.requestState.qryPackages" default="">
<cfparam name="request.requestState.oResourceBean" default="">
<cfparam name="request.requestState.resourceTypeConfig" default="">

<cfscript>
	resLibIndex = request.requestState.resLibIndex;
	resourceType = request.requestState.resourceType;
	package = request.requestState.package;
	id = request.requestState.id;
	qryPackages = request.requestState.qryPackages;
	oResourceBean = request.requestState.oResourceBean;
	resourceTypeConfig = request.requestState.resourceTypeConfig;
	oCatalog = request.requestState.oCatalog;
	
	propsConfig = resourceTypeConfig.getProperties();
	lstPropsConfig = structKeyList(propsConfig);
	lstPropsConfig = listSort(lstPropsConfig,"textnocase");	
	
	props = oResourceBean.getProperties();
	lstProps = structKeyList(props);
	lstProps = listSort(lstProps,"textnocase");	
	
	tmpHREF = oResourceBean.getHREF();
	tmpFullHREF = oResourceBean.getFullHref();
	tmpDescription = oResourceBean.getDescription();
</cfscript>

<cfoutput>
	<form name="frm" action="index.cfm" method="post" style="margin:0px;padding:0px;" enctype="multipart/form-data">
		<input type="hidden" name="event" value="ehResources.doSaveResource">
	<div>
		<div style="border:1px solid silver;width:200px;float:right;margin-left:5px;" id="pnl_info">
			<div class="cp_sectionTitle" style="margin:0px;padding:0px;">&nbsp; Resource Target</div>
			<div style="margin:5px;">
				<cfif id neq "">
					<cfif tmpHREF neq "">
						<cfscript>
							fileObj = createObject("java","java.io.File").init(expandPath(tmpFullHREF));
							stInfo = structNew();
							stInfo.lastModified = createObject("java","java.util.Date").init(fileObj.lastModified());
							stInfo.size = fileObj.length();
							stInfo.readOnly = fileObj.canRead() and not fileObj.canWrite();
							stInfo.createdOn = stInfo.lastModified;
							stInfo.path = fileObj.getAbsolutePath();
							stInfo.exists = fileObj.exists();
						</cfscript>
					</cfif>
					
					<div style="text-align:center;margin:10px;">
						<cfif tmpHREF neq "">
							<!--- for known image types, show the image --->
							<cfif fileExists(expandPath(tmpFullHREF)) and isImageFile(expandPath(tmpFullHREF))>
								<cfimage action="resize"
										    width="100" height="" 
										    source="#expandPath(tmpFullHREF)#"
										    name="resImage">
								<a href="##" onclick="fb.loadAnchor('#tmpFullHREF#')"><cfimage action="writeToBrowser" source="#resImage#"></a>
							<cfelse>
								<img src="images/documents_48x48.png" alt="#tmpFullHREF#" title="#tmpFullHREF#"><br />
							</cfif>
							<br />#getFileFromPath(tmpHREF)#
							<cfif not stInfo.exists><br />(not found)</cfif>
						<cfelse>
							<em>No target assigned</em>
						</cfif>
					</div>
					
					&bull; <a href="##" onclick="showUploadFile()">Upload File</a><br />
					<div id="uploadDiv" style="margin:5px;border:1px solid silver;background-color:##f5f5f5;display:none;">
						<div style="margin:5px;">
							<input type="file" name="resFile" class="formField" style="width:170px;font-size:10px;">
							<input type="button" onclick="uploadFile(this.form)" name="btnUpload" value="Upload" style="width:auto;font-size:10px;margin-top:4px;">
							<a href="##" onclick="hideUploadFile()" style="font-size:10px;">Close</a>
						</div>
					</div>
					
					<cfif tmpHREF neq "" and stInfo.exists>
						&bull; <a href="##" onclick="confirmDeleteFile('#jsStringFormat(id)#')">Delete File</a><br />
					</cfif>
					
					<cfif not isImageFile(expandPath(tmpFullHREF))>
						<cfif tmpHREF neq "" and stInfo.exists>
							&bull; <a href="##" onclick="loadResourceEditor('#jsStringFormat(id)#','richtext')">Open w/ Rich Text Editor</a><br />
							&bull; <a href="##" onclick="loadResourceEditor('#jsStringFormat(id)#','plain')">Open w/ Plain Text Editor</a><br />
						<cfelse>
							&bull; <a href="##" onclick="loadResourceEditor('#jsStringFormat(id)#','richtext')">Create using Rich Text Editor</a><br />
							&bull; <a href="##" onclick="loadResourceEditor('#jsStringFormat(id)#','plain')">Create using Plain Text Editor</a><br />
						</cfif>
					</cfif>

					<cfif tmpHREF neq "">
						<br />
						<b><u>File Info:</u></b><br />
						<cfif stInfo.exists>
							<b>Size:</b> #stInfo.size# bytes<br />
							<b>Last Modified:</b> #lsDateFormat(stInfo.lastModified)#<br />
						<cfelse>
							<em>file not found on server</em>
						</cfif>
					</cfif>
				<cfelse>
					<p>You must first create the resource before assigning a target to it.</p>
				</cfif>
			</div>
			<input type="hidden" name="href" value="#tmpHREF#">
		</div>
		<div style="border:1px solid silver;height:440px;overflow:auto;">

			<table width="100%">
				<tr><td class="cp_sectionTitle" colspan="2">General Properties</td></tr>
				<cfif id neq "">
					<input type="hidden" name="id" value="#id#">
					<input type="hidden" name="package" value="#package#">
					<tr>
						<td width="80"><b>Resource ID:</b></td>
						<td><strong>#oResourceBean.getID()# (#oResourceBean.getType()#)</strong></td>
					</tr>
					<tr>
						<td width="80"><b>Package:</b></td>
						<td>#oResourceBean.getPackage()#</td>
					</tr>
				<cfelse>		
					<tr>
						<td width="80"><b>ID:</b></td>
						<td><input type="text" name="id" value="" class="formField"></td>
					</tr>
					<tr>
						<td width="80"><b>Package:</b></td>
						<td>
							<select name="package" class="formField" onchange="togglePackage(this.value)">
								<option value="">[CREATE NEW]</option>
								<cfloop query="qryPackages">
									<option value="#qryPackages.name#" <cfif qryPackages.name eq package>selected</cfif>>#qryPackages.name#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<div id="newPkgDiv" <cfif package neq "" and package neq "__ALL__">style="display:none;"</cfif>>
								New package name:
								<input type="text" name="package_new" value="" class="formField" style="width:250px;">
							</div>
						</td>
					</tr>
				</cfif>
				<tr>
					<td width="80"><b>Res Lib:</b></td>
					<td>#oResourceBean.getResourceLibrary().getPath()#</td>
				</tr>
				<tr valign="top">
					<td><strong>Description:</strong></td>
					<td><textarea name="description" class="formField" rows="4">#trim(tmpDescription)#</textarea></td>
				</tr>
				<cfif lstPropsConfig neq "">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td class="cp_sectionTitle" colspan="2">Resource Properties</td></tr>
					<cfloop list="#lstPropsConfig#" index="key">
						<cfset tmpValue = "">
						<cfset tmpLabel = key>
						<cfset lstValues = "">
						<cfset tmpType = propsConfig[key].type>
						
						<cfif structKeyExists(props,key)>
							<cfset tmpValue = trim(props[key])>
						<cfelseif propsConfig[key].default neq "">
							<cfset tmpValue = propsConfig[key].default>
						</cfif>
						<cfif propsConfig[key].label neq "">
							<cfset tmpLabel = propsConfig[key].label>
						</cfif>
						<cfif listLen(propsConfig[key].type,":") eq 2 and listfirst(propsConfig[key].type,":") eq "resource">
							<cfset tmpType = listfirst(propsConfig[key].type,":")>
							<cfset resourceType = listlast(propsConfig[key].type,":")>
						</cfif>

						<tr>
							<td width="80"><b>#tmpLabel#:</b></td>
							<td>
								<cfswitch expression="#tmpType#">
									<cfcase value="list">
										<cfset lstValues = propsConfig[key].values>
										<select name="cp_#key#" class="formField" style="width:150px;">
											<cfif not propsConfig[key].required><option value="_NOVALUE_"></option></cfif>
											<cfloop list="#lstValues#" index="item">
												<option value="#item#" <cfif tmpValue eq item>selected</cfif>>#item#</option>
											</cfloop>
										</select>
										<cfif propsConfig[key].required><span style="color:red;">&nbsp; * required</span></cfif>
									</cfcase>
									
									<cfcase value="resource">
										<cfset qryResources = oCatalog.getResourcesByType(resourceType)>
										<cfquery name="qryResources" dbtype="query">
											SELECT *, upper(package) as upackage, upper(id) as uid
												FROM qryResources
												ORDER BY upackage, uid, id
										</cfquery>
										<select name="cp_#key#" class="formField">
											<cfif not propsConfig[key].required><option value="_NOVALUE_"></option></cfif>
											<cfloop query="qryResources">
												<option value="#qryResources.id#"
														<cfif tmpValue eq qryResources.id>selected</cfif>	
															>[#qryResources.package#] #qryResources.id#</option>
											</cfloop>
										</select>
										<cfif propsConfig[key].required><span style="color:red;">&nbsp; * required</span></cfif>
									</cfcase>
									
									<cfcase value="boolean">
										<cfif propsConfig[key].required>
											<cfset isTrueChecked = (isBoolean(tmpValue) and tmpValue)>
											<cfset isFalseChecked = (isBoolean(tmpValue) and not tmpValue) or (tmpValue eq "")>
										<cfelse>
											<cfset isTrueChecked = (isBoolean(tmpValue) and tmpValue)>
											<cfset isFalseChecked = (isBoolean(tmpValue) and not tmpValue)>
										</cfif>
										
										<input type="radio" name="cp_#key#" 
												style="border:0px;width:15px;"
												value="true" 
												<cfif isTrueChecked>checked</cfif>> True 
										<input type="radio" name="cp_#key#" 
												style="border:0px;width:15px;"
												value="false" 
												<cfif isFalseChecked>checked</cfif>> False 
										<cfif propsConfig[key].required><span style="color:red;">&nbsp; * required</span></cfif>
									</cfcase>
									
									<cfdefaultcase>
										<input type="text" 
												name="cp_#key#" 
												value="#tmpValue#" 
												class="formField">
										<cfif propsConfig[key].required><span style="color:red;">&nbsp; * required</span></cfif>
									</cfdefaultcase>
								</cfswitch>
								<input type="hidden" name="#key#_default" value="#propsConfig[key].default#">
							
							</td>
						</tr>
					</cfloop>
				</cfif>
			</table>

		</div>
	</div>
	
	<div class="pagingControls"style="clear:both;">
		<input type="button" name="btnSave" value="Apply Changes" onclick="saveResource(this.form)">
		<cfif id neq "">
			&nbsp;&nbsp;&nbsp;
			<input type="button" name="btnDelete" value="Delete Resource" onclick="if(confirm('Delete resource?')){document.location='index.cfm?event=ehResources.doDeleteResource&id=#id#&resourceType=#resourceType#&pkg=#pkg#'}">
		</cfif>
		&nbsp;&nbsp;&nbsp;
		<input type="button" name="btnCancel" value="Cancel" onclick="selectResourceType('#resourceType#')">
	</div>
	</form>	
	
</cfoutput>

