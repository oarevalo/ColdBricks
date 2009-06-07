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
	function uploadResource(resType,pkg,resLibIndex) {
		if(pkg==null || pkg==undefined) pkg="";
		if(resLibIndex==null || resLibIndex==undefined) resLibIndex="";
	
		var href = "index.cfm"
					+ "?event=resources.ehResources.dspUploadResource" 
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
		<input type="hidden" name="event" value="resources.ehResources.doSelectResourceLibrary">

		<div class="cp_sectionTitle" 
				style="padding:0px;margin:0px;font-size:14px; width:99%;margin-bottom:5px;">
			<div style="margin:4px;">
				Select a Resource Library:
			</div>
		</div>		
		
		<table style="font-family:arial;font-size:12px;margin:5px;">
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
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
		<div style="text-align:center;">
			<input type="submit" name="btnUpload" value="Continue">
		</div>
	</form>
</cfoutput>

<cfif isBoolean(done) and done>
	<script type="text/javascript">
		setTimeout("fb.end()",100);
	</script>
</cfif>