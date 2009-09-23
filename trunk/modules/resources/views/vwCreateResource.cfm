<cfparam name="request.requestState.resLibIndex" default="">
<cfparam name="request.requestState.resourceType" default="">
<cfparam name="request.requestState.package" default="">
<cfparam name="request.requestState.qryPackages" default="#queryNew('')#">
<cfparam name="request.requestState.aResLibs" default="">
<cfparam name="request.requestState.done" default="false">
<cfparam name="request.requestState.resourceTypeConfig" default="">
<cfparam name="request.requestState.oResourceBean" default="">

<cfscript>
	resLibIndex = request.requestState.resLibIndex;
	resourceType = request.requestState.resourceType;
	package = request.requestState.package;
	qryPackages = request.requestState.qryPackages;
	aResLibs = request.requestState.aResLibs;
	done = request.requestState.done;
	resourceTypeConfig = request.requestState.resourceTypeConfig;
	oResourceBean = request.requestState.oResourceBean;

	if(resLibIndex gt 0) {
		propsConfig = resourceTypeConfig.getProperties();
		lstPropsConfig = structKeyList(propsConfig);
		lstPropsConfig = listSort(lstPropsConfig,"textnocase");	
		
		props = oResourceBean.getProperties();
		lstProps = structKeyList(props);
		lstProps = listSort(lstProps,"textnocase");	
	} else {
		lstPropsConfig = "";
	}
</cfscript>

<cfsavecontent variable="tmpHTML">
<link type="text/css" rel="stylesheet" href="includes/css/style.css" />
<link type="text/css" rel="stylesheet" href="includes/floatbox/floatbox.css" />
<script type="text/javascript" src="includes/floatbox/floatbox.js"></script>
<script type="text/javascript">
	function togglePackage(selVal) {
		if(selVal=='') 
			document.getElementById('newPkgDiv').style.display='block' 
		else 
			document.getElementById('newPkgDiv').style.display='none'
	}
	function createResource(resType,pkg,resLibIndex) {
		if(pkg==null || pkg==undefined) pkg="";
		if(resLibIndex==null || resLibIndex==undefined) resLibIndex="";
	
		var href = "index.cfm"
					+ "?event=resources.ehResources.dspCreateResource" 
					+ "&resourceType=" + resType
					+ "&pkg=" + pkg
					+ "&resLibIndex=" + resLibIndex
		fb.loadAnchor(href,"width:440 height:300 sameBox:true");
	}
	function hideMessageBox() {
		var d = document.getElementById("app_messagebox");
		d.style.display = "none";
	}		

</script>
<style type="text/css">
	#app_messagebox {
		top:5px;
	}
</style>
</cfsavecontent>
<cfhtmlhead text="#tmpHTML#">


<cfoutput>
	<form name="frm" action="index.cfm" method="post" style="margin:0px;padding:0px;" enctype="multipart/form-data">
		<input type="hidden" name="event" value="resources.ehResources.doCreateResource">

		<div class="cp_sectionTitle" 
				style="padding:0px;margin:0px;font-size:14px; width:99%;margin-bottom:5px;">
			<div style="margin:4px;">
				Create new resource of type <u>#resourceType#</u>:
			</div>
		</div>		
		
		<table style="font-family:arial;font-size:12px;margin:5px;">
			<tr>
				<td width="80"><b>ID:</b></td>
				<td><input type="text" name="id" value="" class="formField" style="width:250px;"></td>
			</tr>
			<tr>
				<td><strong>Res Lib:</strong></td>
				<td>
					<select name="resLibIndex" class="formField" onchange="createResource('#resourceType#','#package#',this.value)" style="width:250px;">
						<option value="">-- Select One --</option>
						<cfloop from="1" to="#arrayLen(aResLibs)#" index="i">
							<option value="#i#" <cfif resLibIndex eq i>selected</cfif>>#aResLibs[i].getPath()#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<cfif qryPackages.recordCount gt 0>
				<tr>
					<td width="80"><b>Package:</b></td>
					<td>
						<select name="package" class="formField" onchange="togglePackage(this.value)" style="width:250px;" <cfif resLibIndex lte 0>disabled="true"</cfif>>
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
							<input type="text" name="package_new" value="" class="formField" style="width:250px;" <cfif resLibIndex lte 0>disabled="true"</cfif>>
						</div>
					</td>
				</tr>
			<cfelse>
				<tr>
					<td><b>Package:</b></td>
					<td>
						<input type="text" name="package_new" value="" class="formField" style="width:250px;" <cfif resLibIndex lte 0>disabled="true"</cfif>>
					</td>
				</tr>
			</cfif>
			<tr valign="top">
				<td><strong>Description:</strong></td>
				<td><textarea name="description" class="formField" rows="3" style="width:250px;" <cfif resLibIndex lte 0>disabled="true"</cfif>></textarea></td>
			</tr>
			<cfif lstPropsConfig neq "">
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
									<select name="cp_#key#" class="formField" style="width:250px;">
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
									<select name="cp_#key#" class="formField" style="width:250px;" >
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
									<input type="text" style="width:250px;" 
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

			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
		<div style="text-align:center;">
			<input type="submit" name="btnCreate" value="Create Resource" <cfif resLibIndex lte 0>disabled="true"</cfif>>
		</div>
	</form>
</cfoutput>

<cfif isBoolean(done) and done>
	<script type="text/javascript">
		setTimeout("fb.end()",100);
	</script>
</cfif>