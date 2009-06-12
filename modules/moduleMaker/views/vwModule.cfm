<cfparam name="request.requestState.moduleType" default="">
<cfparam name="request.requestState.tagInfo" default="">
<cfparam name="request.requestState.head" default="">
<cfparam name="request.requestState.body" default="">

<cfset moduleType = request.requestState.moduleType>
<cfset tagInfo = request.requestState.tagInfo>
<cfset head = request.requestState.head>
<cfset body = request.requestState.body>

<cfset isNew = (moduleType eq "__NEW__")>
<cfif isNew>
	<cfset moduleType = "">
</cfif>

<cfparam name="tagInfo.name" default="">
<cfparam name="tagInfo.properties" default="#arrayNew(1)#">
<cfparam name="tagInfo.path" default="">
<cfparam name="tagInfo.hint" default="">

<cfoutput>
	<form name="frm" action="index.cfm" method="post" style="margin:0px;padding:0px;">
		<input type="hidden" name="event" value="ehModuleMaker.doSave">
		<input type="hidden" name="moduleType" value="#moduleType#">
		<div>
			<div class="cp_sectionTitle" style="margin:0px;padding:0px;">
				&nbsp; Module Editor
			</div>
			<div style="margin-top:5px;margin-bottom:5px;font-size:11px;text-align:left;background-color:##ccc;border:1px solid ##333;padding:2px;">
				<b>Name:</b> <input type="text" name="tagname" value="#moduleType#" class="formField" style="width:150px;font-size:10px;">
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="viewpanel" value="body" onclick="selectPanel('body')"> Body
				<input type="radio" name="viewpanel" value="head" checked="true" onclick="selectPanel('head')"> Head
				<input type="radio" name="viewpanel" value="config" onclick="selectPanel('config')"> Config
			</div>
			<div id="pnl_editor">
				<textarea name="body" 
							wrap="off" 
							onkeypress="checkTab(event)" 
							onkeydown="checkTabIE()"	
							id="body" 
							style="width:98%;border:1px solid silver;padding:2px;height:385px;">#htmlEditFormat(body)#</textarea>

				<textarea name="head" 
							wrap="off" 
							onkeypress="checkTab(event)" 
							onkeydown="checkTabIE()"	
							id="head" 
							style="width:98%;border:1px solid silver;padding:2px;height:385px;display:none;">#htmlEditFormat(head)#</textarea>
				
				<div id="config" style="display:none;">
					<table>
						<tr>
							<th>Name:</th>
							<td><input type="text" name="name" value="#tagInfo.name#"></td>
						</tr>
						<tr>
							<th>Description:</th>
							<td><textarea name="hint">#tagInfo.hint#</textarea></td>
						</tr>
					</table>
					<cfdump var="#tagInfo.properties#">
				</div>
			</div>
			
			<div class="pagingControls"style="clear:both;">
				<cfif not isNew>
					<div style="float:right;font-weight:normal;">
						<b>Path:</b> #tagInfo.path#
					</div>
				</cfif>
				<input type="button" name="btnSave" value="Apply Changes" onclick="saveTemplate(this.form)">
				<cfif not isNew>
					&nbsp;&nbsp;
					<input type="button" name="btnDelete" value="Delete" onclick="deleteTemplate(this.form)">
				</cfif>
			</div>
		</div>
	</form>	
</cfoutput>
