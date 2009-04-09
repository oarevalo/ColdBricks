<cfparam name="request.requestState.resLibIndex" default="">
<cfparam name="request.requestState.resourceType" default="">
<cfparam name="request.requestState.package" default="">
<cfparam name="request.requestState.qryPackages" default="#queryNew('')#">
<cfparam name="request.requestState.aResLibs" default="">
<cfparam name="request.requestState.done" default="false">

<cfscript>
	resLibIndex = request.requestState.resLibIndex;
	resourceType = request.requestState.resourceType;
	package = request.requestState.package;
	qryPackages = request.requestState.qryPackages;
	aResLibs = request.requestState.aResLibs;
	done = request.requestState.done;
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
	function uploadResource(resType,pkg,resLibIndex) {
		if(pkg==null || pkg==undefined) pkg="";
		if(resLibIndex==null || resLibIndex==undefined) resLibIndex="";
	
		var href = "index.cfm"
					+ "?event=ehResources.dspUploadResource" 
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
		<input type="hidden" name="event" value="ehResources.doUploadResource">

		<div class="cp_sectionTitle" 
				style="padding:0px;margin:0px;font-size:14px; width:99%;margin-bottom:5px;">
			<div style="margin:4px;">
				Select a <u>#resourceType#</u> to upload:
			</div>
		</div>		
		
		<table style="font-family:arial;font-size:12px;margin:5px;">
			<tr>
				<td width="80"><b>ID:</b></td>
				<td><input type="text" name="id" value="" class="formField" disabled="true" style="width:250px;"></td>
			</tr>
			<tr>
				<td width="80">&nbsp;</td>
				<td>
					<input type="checkbox" name="useFilenameAsID" value="true" class="formField" checked="true"
							style="width:auto;"
							onclick="this.form.id.disabled=this.checked">
					Use filename as resource ID
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td><strong>Res Lib:</strong></td>
				<td>
					<select name="resLibIndex" class="formField" onchange="uploadResource('#resourceType#','#package#',this.value)" style="width:250px;">
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
			<tr>
				<td><b>File:</b></td>
				<td><input type="file" name="resFile" class="formField" style="width:250px;" <cfif resLibIndex lte 0>disabled="true"</cfif>></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
		<div style="text-align:center;">
			<input type="submit" name="btnUpload" value="Create Resource" <cfif resLibIndex lte 0>disabled="true"</cfif>>
		</div>
	</form>
</cfoutput>

<cfif isBoolean(done) and done>
	<script type="text/javascript">
		setTimeout("fb.end()",100);
	</script>
</cfif>