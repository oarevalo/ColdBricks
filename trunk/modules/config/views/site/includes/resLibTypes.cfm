<cfparam name="request.requestState.oHomePortalsConfigBean" default="">
<cfparam name="request.requestState.resLibTypeEditKey" default="">
<cfparam name="request.requestState.resLibTypePropEditKey" default="">

<cfscript>
	oHomePortalsConfigBean = request.requestState.oHomePortalsConfigBean;
	oAppConfigBean = request.requestState.oAppConfigBean;
	resLibTypeEditKey = request.requestState.resLibTypeEditKey;
	resLibTypePropEditKey = request.requestState.resLibTypePropEditKey;
	
	dspEvent = "config.ehSiteConfig.dspMain";
</cfscript>

<script type="text/javascript">
	function confirmDeleteResType(name) {
		if(confirm("Delete resource library type ?")) {
			document.location = "index.cfm?event=config.ehSiteConfig.doDeleteResourceLibraryType&prefix=" + name;
		}
	}
	function confirmDeleteResTypeProp(type,name) {
		if(confirm("Delete resource library type  property?")) {
			document.location = "index.cfm?event=config.ehSiteConfig.doDeleteResourceLibraryTypeProperty&resLibTypeEditKey=" + type + "&name="+name;
		}
	}
</script>

<cfoutput>
	<tr><td colspan="2"><h2>Custom Resource library Types:</h2></td></tr>
	<tr>
		<td colspan="2">
			<div class="formFieldTip">
				Resource library types are the different types of resources libraries that that can be used on a site. 
				Library types are defined by the mechanism used to store and retrieve the library. By default, resources
				libraries are based on the file system; however it is possible to have different implementations that use
				other media such as Databases or Amazon S3.<br />
				<br />
				This screen allows you to define additional resource library types.
			</div>
		
			<table style="width:100%;border:1px solid silver;">
				<tr>
					<th style="background-color:##ccc;width:50px;">No.</th>
					<th style="background-color:##ccc;width:100px;">Type</th>
					<th style="background-color:##ccc;">Impl Path</th>
					<th style="background-color:##ccc;width:100px;">Action</th>
				</tr>
				<cfset stResTypes = oHomePortalsConfigBean.getResourceLibraryTypes()>
				<cfset index = 1>
				<cfloop collection="#stResTypes#" item="key">
					<tr <cfif index mod 2>class="altRow"</cfif> <cfif resLibTypeEditKey eq key>style="font-weight:bold;"</cfif>>
						<td style="width:50px;" align="right"><strong>#index#.</strong></td>
						<td style="width:100px;" align="center">#stResTypes[key].prefix#</td>
						<td>#stResTypes[key].path#</td>
						<td align="center">< base ></td>
					</tr>
					<cfset index++>
				</cfloop>

				<cfset stResTypes = oAppConfigBean.getResourceLibraryTypes()>
				<cfloop collection="#stResTypes#" item="key">
					<tr <cfif index mod 2>class="altRow"</cfif> <cfif resLibTypeEditKey eq key>style="font-weight:bold;"</cfif>>
						<td style="width:50px;" align="right"><strong>#index#.</strong></td>
						<td style="width:100px;" align="center"><a href="index.cfm?event=#dspEvent#&resLibTypeEditKey=#key#">#stResTypes[key].prefix#</a></td>
						<td>#stResTypes[key].path#</td>
						<td align="center">
							<a href="index.cfm?event=#dspEvent#&resLibTypeEditKey=#key#"><img src="images/page_edit.png" border="0" alt="Edit resource library type " title="Edit resource library type "></a>
							<a href="##" onclick="confirmDeleteResType('#key#')"><img src="images/page_delete.png" border="0" alt="Delete resource library type " title="Delete resource library type "></a>
						</td>
					</tr>
					<cfset index++>
				</cfloop>
			</table>
			<cfif resLibTypeEditKey neq "">
				<cfif resLibTypeEditKey neq "__NEW__">
					<cfset isNew = false>
					<cfset stResType = stResTypes[resLibTypeEditKey]>
				<cfelse>
					<cfset isNew = true>
					<cfset stResType = structNew()>	
					<cfset resLibTypeEditKey = "">
				</cfif>
				<cfparam name="stResType.prefix" default="">
				<cfparam name="stResType.path" default="">
				<cfparam name="stResType.properties" default="#structNew()#">
				<br />
				<cfif isNew>
					<p><b>Register New Resource Library Type </b></p>
				<cfelse>
					<p><b>Edit Resource Library Type </b></p>
				</cfif>
				
				<table style="width:100%;border:1px solid silver;margin-top:5px;">
					<tr valign="top">
						<td style="width:430px;">
							<form name="frmEditResType" action="index.cfm" method="post">
								<input type="hidden" name="event" value="config.ehSiteConfig.doSaveResourceLibraryType">
								<cfif not isNew>
									<input type="hidden" name="prefix" value="#resLibTypeEditKey#">
								</cfif>
								<table>
									<tr>
										<td><b>Prefix:</b></td>
										<td><input type="text" name="prefix" value="#stResType.prefix#" style="width:300px;" class="formField" <cfif not isNew>disabled</cfif>></td>
									</tr>
									<tr>
										<td><b>Path:</b></td>
										<td><input type="text" name="path" value="#stResType.path#" style="width:300px;" class="formField"></td>
									</tr>
								</table>
								<br />
								<input type="submit" name="btnSave" value="Apply" style="font-size:11px;">
								<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=#dspEvent#'">
							</form>
						</td>
						<cfif not isNew>
							<td>
								<cfset stProps = stResType.properties>
								<b>Resource Library Type Properties:</b><br />
								<table style="width:100%;border:1px solid silver;margin-top:5px;">
									<tr>
										<th style="background-color:##ccc;width:100px;">Name</th>
										<th style="background-color:##ccc;">Value</th>
										<th style="background-color:##ccc;width:100px;">Action</th>
									</tr>
									<cfset i = 1>
									<cfloop collection="#stProps#" item="key">
										<cfparam name="stProps[key].name" default="">
										<cfparam name="stProps[key].value" default="">
										
										<tr <cfif i mod 2>class="altRow"</cfif> <cfif resLibTypePropEditKey eq key>style="font-weight:bold;"</cfif>>
											<td style="width:100px;" align="center"><a href="index.cfm?event=#dspEvent#&resLibTypeEditKey=#resLibTypeEditKey#&resLibTypePropEditKey=#key#">#stProps[key].name#</a></td>
											<td>#stProps[key].value#</td>
											<td align="center">
												<a href="index.cfm?event=#dspEvent#&resLibTypeEditKey=#resLibTypeEditKey#&resLibTypePropEditKey=#key#"><img src="images/page_edit.png" border="0" alt="Edit resource library type  property" title="Edit resource library type  property"></a>
												<a href="##" onclick="confirmDeleteResTypeProp('#resLibTypeEditKey#','#key#')"><img src="images/page_delete.png" border="0" alt="Delete resource library type  property" title="Delete resource library type  property"></a>
											</td>
										</tr>
										<cfset i = i + 1>
									</cfloop>
								</table>
	
								<cfif resLibTypePropEditKey gte 0>
									<cfif resLibTypePropEditKey gt 0>
										<cfset isNewProp = false>
										<cfset stResTypeProp = stProps[resLibTypePropEditKey]>
									<cfelse>
										<cfset isNewProp = true>
										<cfset stResTypeProp = structNew()>	
										<cfset resLibTypePropEditKey = "">
									</cfif>
									
									<cfparam name="stResTypeProp.name" default="">
									<cfparam name="stResTypeProp.value" default="">
									<br />
									<cfif isNewProp>
										<p><b>Create New Resource Library Type Property</b></p>
									<cfelse>
										<p><b>Edit Resource Library Type Property</b></p>
									</cfif>

									<form name="frmEditResTypeProp" action="index.cfm" method="post">
										<input type="hidden" name="event" value="config.ehSiteConfig.doSaveResourceLibraryTypeProperty">
										<input type="hidden" name="resLibTypePropEditKey" value="#resLibTypePropEditKey#">
										<input type="hidden" name="resLibTypeEditKey" value="#resLibTypeEditKey#">
										<cfif not isNewProp>
											<input type="hidden" name="name" value="#stResTypeProp.name#">
										</cfif>
										<table>
											<tr>
												<td><b>Name:</b></td>
												<td><input type="text" name="name" value="#stResTypeProp.name#" style="width:200px;" class="formField" <cfif not isNewProp>disabled</cfif>></td>
											</tr>
											<tr>
												<td><b>Value:</b></td>
												<td><input type="text" name="value" value="#stResTypeProp.value#" style="width:200px;" class="formField"></td>
											</tr>
										</table>
										<br />
										<input type="submit" name="btnSave" value="Apply" style="font-size:11px;">
										<input type="button" name="btnCancel" value="Cancel" style="font-size:11px;" onclick="document.location='index.cfm?event=#dspEvent#&resLibTypeEditKey=#resLibTypeEditKey#'">
									</form>
							<cfelse>
								<br>
								<a href="index.cfm?event=#dspEvent#&resLibTypeEditKey=#resLibTypeEditKey#&resLibTypePropEditKey=0">Click Here</a> to add a new property
							</cfif>
							</td>
						</cfif>
					</tr>
				</table>
				
			<cfelse>
				<br>
				<a href="index.cfm?event=#dspEvent#&resLibTypeEditKey=__NEW__">Click Here</a> to register a resource library type 
			</cfif>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>
			