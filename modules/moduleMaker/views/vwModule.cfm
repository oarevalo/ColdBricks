<cfparam name="request.requestState.moduleType" default="">
<cfparam name="request.requestState.tagInfo" default="">
<cfparam name="request.requestState.head" default="">
<cfparam name="request.requestState.body" default="">
<cfparam name="request.requestState.editPropIndex" default="-1">

<cfset moduleType = request.requestState.moduleType>
<cfset tagInfo = request.requestState.tagInfo>
<cfset head = request.requestState.head>
<cfset body = request.requestState.body>
<cfset editPropIndex = request.requestState.editPropIndex>


<cfparam name="tagInfo.name" default="">
<cfparam name="tagInfo.properties" default="#arrayNew(1)#">
<cfparam name="tagInfo.path" default="">
<cfparam name="tagInfo.hint" default="">

<cfoutput>
	<form name="frm" action="index.cfm" method="post" style="margin:0px;padding:0px;">
		<input type="hidden" name="event" value="moduleMaker.ehModuleMaker.doSave">
		<input type="hidden" name="moduleType" value="#moduleType#">
		<div>
			<div class="cp_sectionTitle" style="margin:0px;padding:0px;">
				&nbsp; Module Editor
			</div>
			<div style="margin-top:5px;margin-bottom:5px;font-size:11px;text-align:left;background-color:##ccc;border:1px solid ##333;padding:2px;">
				<b>View:</b>
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="viewpanel" value="config" checked="true" onclick="selectPanel('config')"> Config
				<input type="radio" name="viewpanel" value="body" onclick="selectPanel('body')"> Body
				<input type="radio" name="viewpanel" value="head" onclick="selectPanel('head')"> Head
			</div>
			<div id="pnl_editor">
				<textarea name="body" 
							wrap="off" 
							onkeypress="checkTab(event)" 
							onkeydown="checkTabIE()"	
							id="body" 
							style="width:98%;border:1px solid silver;padding:2px;height:385px;display:none;">#htmlEditFormat(body)#</textarea>

				<textarea name="head" 
							wrap="off" 
							onkeypress="checkTab(event)" 
							onkeydown="checkTabIE()"	
							id="head" 
							style="width:98%;border:1px solid silver;padding:2px;height:385px;display:none;">#htmlEditFormat(head)#</textarea>
				
				<div id="config">
					<div style="border:1px solid silver;padding:10px;">
						<table style="width:100%;">
							<tr>
								<td width="80"><b>Name:</b></td>
								<td><input type="text" name="name" value="#moduleType#" class="formField" disabled="true"></td>
							</tr>
							<tr>
								<td width="80"><b>CFC Path:</b></td>
								<td><input type="text" name="cfcpath" value="#tagInfo.name#" class="formField" disabled="true"></td>
							</tr>
							<tr valign="top">
								<td width="80"><b>Description:</b></td>
								<td><textarea name="hint" class="formField" rows="3">#tagInfo.hint#</textarea></td>
							</tr>
						</table>
					</div>
	
					<div style="margin-top:10px;height:265px;">	
						<table border="1" class="browseTable tblGrid" align="center" style="width:100%;">
							<tr>
								<th colspan="5" style="text-align:left;">
									<div style="float:right;font-weight:normal;margin-right:20px;">
										<img src="images/add.png" align="absmiddle" border="0" alt="Add Section" title="Add Section">
										<a href="##">Add Property</a>
									</div>
									Module Properties
								</th>
							</tr>
							<tr>
								<th style="width:20px;">No.</th>
								<th>Name</th>
								<th style="width:150px;">Type</th>
								<th style="width:50px;">Required?</th>
								<th style="width:75px;">Action</th>
							</tr>
							<cfloop from="1" to="#arrayLen(tagInfo.properties)#" index="i">
								<cfset thisProp = tagInfo.properties[i]>
								<cfparam name="thisProp.name" default="">
								<cfparam name="thisProp.type" default="">
								<cfparam name="thisProp.hit" default="">
								<cfparam name="thisProp.required" default="false">
								<cfparam name="thisProp.default" default="">
								<cfset thisProp.required = isBoolean(thisProp.required) and thisProp.required>
								<tr>
									<td style="width:20px;text-align:right;"><strong>#i#.</strong></td>
									<td><a href="##">#thisProp.name#</a></td>
									<td style="width:150px;">#thisProp.type#</td>
									<td style="width:75px;text-align:center;">#yesNoFormat(thisProp.required)#</td>
									<td></td>
								</tr>
							</cfloop>
							<cfif arrayLen(tagInfo.properties) eq 0>
								<tr><td colspan="5"><em>Module has no properties</em></td></tr>
							</cfif>
						</table>
					</div>					
				</div>
			</div>
			
			<div class="pagingControls"style="clear:both;">
				<div style="float:right;font-weight:normal;">
					<b>Path:</b> #tagInfo.path#
				</div>
				<input type="button" name="btnSave" value="Apply Changes" onclick="saveTemplate(this.form)">
				&nbsp;&nbsp;
				<input type="button" name="btnDelete" value="Delete" onclick="deleteTemplate(this.form)">
			</div>
		</div>
	</form>	
</cfoutput>
