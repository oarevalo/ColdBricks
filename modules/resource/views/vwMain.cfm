<cfparam name="request.requestState.resLibIndex" default="">
<cfparam name="request.requestState.resourceType" default="">
<cfparam name="request.requestState.package" default="">
<cfparam name="request.requestState.resourceID" default="">
<cfparam name="request.requestState.done" default="false">
<cfparam name="request.requestState.oCatalog" default="">
<cfparam name="request.requestState.qryPackages" default="#queryNew('')#">
<cfparam name="request.requestState.oResourceBean" default="">
<cfparam name="request.requestState.resourceTypeConfig" default="">
<cfparam name="request.requestState.aResLibs" default="">

<cfscript>
	resLibIndex = request.requestState.resLibIndex;
	resourceType = request.requestState.resourceType;
	package = request.requestState.package;
	id = request.requestState.resourceID;
	qryPackages = request.requestState.qryPackages;
	oResourceBean = request.requestState.oResourceBean;
	resourceTypeConfig = request.requestState.resourceTypeConfig;
	oCatalog = request.requestState.oCatalog;
	aResLibs = request.requestState.aResLibs;
	done = request.requestState.done;
	tmpHREF = "";
	
	if(resLibIndex gt 0) {
		propsConfig = resourceTypeConfig.getProperties();
		lstPropsConfig = structKeyList(propsConfig);
		lstPropsConfig = listSort(lstPropsConfig,"textnocase");	
		
		props = oResourceBean.getProperties();
		lstProps = structKeyList(props);
		lstProps = listSort(lstProps,"textnocase");	
		
		tmpHREF = oResourceBean.getHREF();
		tmpFullHREF = oResourceBean.getFullHref();
		tmpDescription = oResourceBean.getDescription();
		tmpFullPath = oResourceBean.getFullPath();
		
	} else {
		lstPropsConfig = "";
		tmpDescription = "";
	}
</cfscript>

<cfsavecontent variable="tmpHTML">
	<script type="text/javascript" src="modules/resource/includes/resourceEditor.js"></script>
	<link type="text/css" rel="stylesheet" href="includes/css/style.css" />
	<link type="text/css" rel="stylesheet" href="includes/floatbox/floatbox.css" />
	<script type="text/javascript" src="includes/floatbox/floatbox.js"></script>
	<script type="text/javascript">
		function hideMessageBox() {
			var d = document.getElementById("app_messagebox");
			d.style.display = "none";
		}		
	</script>
	<style type="text/css">
		#app_messagebox {
			top:5px;
		}
		.formField {
			width:250px !important;
		}
	</style>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">

<cfoutput>
	<div class="cp_sectionTitle" 
			style="padding:0px;margin:0px;font-size:14px; width:99%;margin-bottom:5px;">
		<div style="margin:4px;">
			<cfif id neq "">
				<img src="images/page_edit.png" align="absmiddle">
				Edit '#id#' (#resourceType#)
			<cfelse>
				<img src="images/page_add.png" align="absmiddle">
				Create Resource (#resourceType#)
			</cfif>
		</div>
	</div>
	
	<form name="frm" id="frmResourceEditor" action="index.cfm" method="post" style="margin:0px;padding:0px;" enctype="multipart/form-data">
		<input type="hidden" name="event" value="resource.ehResource.doSave">
		<input type="hidden" name="resourceType" value="#resourceType#">

	<div style="width:99%;">
	
		<div style="width:200px;float:right;margin-left:5px;">

			<div style="border:1px solid silver;" id="pnl_info">
				<div class="cp_sectionTitle" style="margin:0px;padding:0px;">&nbsp; Resource Target</div>
				<div style="margin:5px;">
					<cfif id neq "">
					
						<cfif tmpHREF neq "">
							<cfscript>
								stInfo = structNew();
								stInfo.exists = oResourceBean.targetFileExists();
	
								if(tmpFullPath neq "") {
									try {
										fileObj = createObject("java","java.io.File").init(expandPath(tmpFullHREF));
										stInfo.lastModified = createObject("java","java.util.Date").init(fileObj.lastModified());
										stInfo.size = fileObj.length();
										stInfo.readOnly = fileObj.canRead() and not fileObj.canWrite();
										stInfo.createdOn = stInfo.lastModified;
										stInfo.path = fileObj.getAbsolutePath();
										stInfo.exists = fileObj.exists();
									} catch(any e) {
										// ignore
									}
								}
							</cfscript>
						</cfif>
						
						<div style="text-align:center;margin:10px;">
							<cfif tmpHREF neq "">
								<!--- for known image types, show the image --->
								<cfif tmpFullPath neq "" and fileExists(tmpFullPath) and isImageFile(tmpFullPath)>
									<cfimage action="resize"
											    width="100" height="" 
											    source="#tmpFullPath#"
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
						
						<cfif tmpHREF eq "" or not isImageFile(expandPath(tmpFullHREF))>
							<div class="buttonImage btnLarge" style="margin:0 auto;text-align:left;">
								&nbsp;
								<img src="images/page_edit.png" align="Absmiddle">
								<a href="javascript:resourceEditor.editFileRichText('#jsStringFormat(id)#','#jsstringformat(resourcetype)#','#jsstringformat(package)#')">Open w/ Editor</a>
							</div>
						</cfif>
						
						<div class="buttonImage btnLarge" style="margin:0 auto;text-align:left;">
							&nbsp;<img src="images/add.png" align="Absmiddle">
							<a href="##" onclick="resourceEditor.showUploadFile()">Upload File</a>
						</div>
	
						<div id="uploadDiv" style="margin:5px;border:1px solid silver;background-color:##f5f5f5;display:none;">
							<div style="margin:5px;">
								<input type="file" name="resFile" class="formField" style="width:100px !important;font-size:10px;"><br />
								<input type="button" onclick="resourceEditor.uploadFile(this.form)" name="btnUpload" value="Upload" style="width:auto;font-size:10px;margin-top:4px;">
								<a href="##" onclick="resourceEditor.hideUploadFile()" style="font-size:10px;">Close</a>
							</div>
						</div>
						
						<cfif tmpHREF neq "" and stInfo.exists>
							<div class="buttonImage btnLarge" style="margin:0 auto;text-align:left;">
								&nbsp;<img src="images/delete.png" align="Absmiddle">
								<a href="##" onclick="resourceEditor.deleteFile('#jsStringFormat(id)#','#jsstringformat(resourcetype)#','#jsstringformat(package)#')">Delete File</a>
							</div>
						</cfif>
						
						<cfif tmpHREF neq "" and stInfo.exists>
							<div class="buttonImage btnLarge" style="margin:0 auto;text-align:left;">
								&nbsp;<img src="images/page_lightning.png" align="Absmiddle">
								<a href="#tmpFullHREF#" target="_blank">Open in Browser</a>
							</div>
						</cfif>
					<cfelse>
						<p>You must first create the resource before assigning a target to it.</p>
					</cfif>
				</div>
			</div>
				
			<cfif tmpHREF neq "">
				<div style="border:1px solid silver;margin-top:20px;" id="pnl_info">
					<div class="cp_sectionTitle" style="margin:0px;padding:0px;">&nbsp; File Information</div>
					<div style="margin:5px;">
						<cfif stInfo.exists>
							<cfif structKeyExists(stInfo,"size")>
								<b>Size:</b> #stInfo.size# bytes<br />
							</cfif>
							<cfif structKeyExists(stInfo,"lastModified")>
								<b>Last Modified:</b> #lsDateFormat(stInfo.lastModified)#<br />
							</cfif>
							<cfif not structKeyExists(stInfo,"size") and not structKeyExists(stInfo,"lastModified")>
								<em>No additional information found</em>
							</cfif>
						<cfelse>
							<em>file not found on server</em>
						</cfif>
					</div>
				</div>
			</cfif>
			
			<cfif id neq "" and not oResourceBean.isExternalTarget()>
				<input type="hidden" name="href" value="#tmpHREF#">
			</cfif>
		</div>
		
		
		
		<div style="margin:3px;height:405px;overflow:auto;">

			<table width="100%">
				<cfif id neq "">
					<input type="hidden" name="resourceID" value="#id#">
					<input type="hidden" name="package" value="#package#">
					<tr>
						<td width="80"><b>Resource ID:</b></td>
						<td><strong>#oResourceBean.getID()# (#oResourceBean.getType()#)</strong></td>
					</tr>
					<tr>
						<td width="80"><b>Res. Library:</b></td>
						<td>#oResourceBean.getResourceLibrary().getPath()#</td>
					</tr>
					<tr>
						<td width="80"><b>Package:</b></td>
						<td>#oResourceBean.getPackage()#</td>
					</tr>
					<tr>
						<td width="80"><b>Created On:</b></td>
						<td>#lsDateFormat(oResourceBean.getCreatedOn())# #lsTimeFormat(oResourceBean.getCreatedOn())#</td>
					</tr>
					<cfif oResourceBean.isExternalTarget()>
						<tr>
							<td width="80"><b>HREF:</b></td>
							<td><input type="text" name="href" value="#tmpHREF#" class="formField"></td>
						</tr>
					</cfif>
				<cfelse>		
					<tr>
						<td width="80"><b>Resource ID:</b></td>
						<td><input type="text" name="resourceID" value="" class="formField" <cfif resLibIndex lte 0>disabled="true"</cfif>></td>
					</tr>
					<tr>
						<td>&nbsp</td>
						<td>
							<div class="formFieldTip" style="margin-bottom:0px;">
								Enter an ID to identify this resource.
							</div>
						</td>
					</tr>
					<tr>
						<td><strong>Resource Library:</strong></td>
						<td>
							<select name="resLibIndex" class="formField" onchange="resourceEditor.main('NEW','#resourceType#','#package#',this.value)" style="width:250px;">
								<option value="">-- Select One --</option>
								<cfloop from="1" to="#arrayLen(aResLibs)#" index="i">
									<option value="#i#" <cfif resLibIndex eq i>selected</cfif>>#aResLibs[i].getPath()#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td>&nbsp</td>
						<td>
							<div class="formFieldTip" style="margin-bottom:0px;">
								Select the Resource Library where this resource will be created.
							</div>
						</td>
					</tr>
					<tr>
						<td width="80"><b>Package:</b></td>
						<td>
							<select name="package" class="formField" onchange="resourceEditor.togglePackage(this.value)" <cfif resLibIndex lte 0>disabled="true"</cfif>>
								<option value="">[CREATE NEW]</option>
								<cfloop query="qryPackages">
									<option value="#qryPackages.name#" <cfif qryPackages.name eq package>selected</cfif>>#qryPackages.name#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<cfif resLibIndex gt 0>
						<tr>
							<td>&nbsp;</td>
							<td>
								<div id="newPkgDiv" <cfif package neq "" and package neq "__ALL__">style="display:none;"</cfif>>
									New package name:
									<input type="text" name="package_new" value="" class="formField" style="width:250px;" <cfif resLibIndex lte 0>disabled="true"</cfif>>
								</div>
							</td>
						</tr>
					</cfif>
				</cfif>
				<tr valign="top">
					<td><strong>Description:</strong><br />(optional)</td>
					<td><textarea name="description" class="formField" rows="4" <cfif resLibIndex lte 0>disabled="true"</cfif>>#trim(tmpDescription)#</textarea></td>
				</tr>
				<cfif lstPropsConfig neq "">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td class="cp_sectionTitle" colspan="2">Additional Resource Properties</td></tr>
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
										<cfset qryResources = oCatalog.getIndex(resourceType)>
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
	
	<div class="pagingControls" style="clear:both;height:30px;padding-top:0px;">
		<div class="buttonImage btnLarge" style="margin:0 auto;float:left;margin-left:5px;">
			&nbsp;<img src="images/disk.png" align="Absmiddle">
			<cfif resLibIndex gt 0>
				<a href="javascript:resourceEditor.save(document.getElementById('frmResourceEditor'))">Apply Changes</a>
			<cfelse>
				Apply Changes
			</cfif>
		</div>
		
		<cfif id neq "">
			<div class="buttonImage btnLarge" style="margin:0 auto;float:left;margin-left:15px;">
				&nbsp;<img src="images/delete.png" align="Absmiddle">
				<a href="javascript:resourceEditor.deleteRes('#jsStringFormat(id)#','#jsStringFormat(resourceType)#','#jsStringFormat(package)#')">Delete Resource</a>
			</div>
		</cfif>
	</div>
	</form>	
	
</cfoutput>

<cfif isBoolean(done) and done>
	<script type="text/javascript">
		setTimeout("fb.end()",100);
	</script>
</cfif>