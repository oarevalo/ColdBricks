<cfparam name="request.requestState.templateName" default="">
<cfparam name="request.requestState.templateType" default="">
<cfparam name="request.requestState.templateView" default="">
<cfparam name="request.requestState.templateStruct" default="#structNew()#">
<cfparam name="request.requestState.templateSource" default="">
<cfparam name="request.requestState.defaultHREF" default="">

<cfset templateName = request.requestState.templateName>
<cfset templateType = request.requestState.templateType>
<cfset templateView = request.requestState.templateView>
<cfset templateStruct = request.requestState.templateStruct>
<cfset templateSource = request.requestState.templateSource>
<cfset defaultHREF = request.requestState.defaultHREF>

<cfset isNew = (templateName eq "__NEW__")>
<cfif isNew>
	<cfset templateName = "">
</cfif>

<cfparam name="templateStruct.description" default="">
<cfparam name="templateStruct.href" default="">

<cfset aTokens = {
					page = [
								{name = "Page Title", token = "$PAGE_TITLE$"},
								{name = "HTML Head Section", token = "$PAGE_HTMLHEAD$"},
								{name = "BODY OnLoad", token = "$PAGE_ONLOAD$"},
								{name = "Custom Section", token = "$PAGE_CUSTOMSECTION[""sec_name""]$"},
								{name = "Layout Section", token = "$PAGE_LAYOUTSECTION[""sec_type""][""tag_name""]$"},
								{name = "Page Property", token = "$PAGE_PROPERTY[""prop_name""]$"}
							],
					module = [
								{name = "Module ID", token = "$MODULE_ID$"},
								{name = "Module Title", token = "$MODULE_TITLE$"},
								{name = "Module Content", token = "$MODULE_CONTENT$"},
								{name = "Module Icon", token = "$MODULE_ICON$"},
								{name = "Module Property", token = "$MODULE_propname$"}
							]
				}>

<cfoutput>
	<script type="text/javascript">
		<cfset index = 1>
		<cfloop from="1" to="#arrayLen(aTokens.page)#" index="i">
			aTokens[#index#] = "#jsStringFormat(aTokens.page[i].token)#";
			<cfset index++>
		</cfloop>
		<cfloop from="1" to="#arrayLen(aTokens.module)#" index="i">
			aTokens[#index#] = "#jsStringFormat(aTokens.module[i].token)#";
			<cfset index++>
		</cfloop>
	</script>

	<form name="frm" action="index.cfm" method="post" style="margin:0px;padding:0px;">
		<input type="hidden" name="event" value="">
		<input type="hidden" name="templateView" value="#templateView#">
		<input type="hidden" name="templateHREF" value="#templateStruct.href#">
		<input type="hidden" name="defaultHREF" value="#defaultHREF#">
		<input type="hidden" name="description" value="#templateStruct.description#">

		<div>
			<div class="cp_sectionTitle" style="margin:0px;padding:0px;">
				&nbsp; Template Editor
			</div>
				
			<div style="margin-top:5px;margin-bottom:5px;font-size:11px;text-align:left;background-color:##ccc;border:1px solid ##333;padding:2px;">
				<div style="width:230px;float:right;font-size:11px;margin-top:2px;">
					<strong>Insert Token:</strong>
					<cfset index = 1>
					<select name="selInsertToken" onchange="insertToken(this.value)" style="width:150px;font-size:10px;">
						<option value="0">--- Select Token ---</option>
						<option value="0">------ Page Tokens ------</option>
						<cfloop from="1" to="#arrayLen(aTokens.page)#" index="i">
							<option value="#index#">#aTokens.page[i].name#</option>
							<cfset index++>
						</cfloop>
						<option value="0"></option>
						<option value="0">------ Module Tokens ------</option>
						<cfloop from="1" to="#arrayLen(aTokens.module)#" index="i">
							<option value="#index#">#aTokens.module[i].name#</option>
							<cfset index++>
						</cfloop>
					</select>
				</div>
				<b>Name:</b> <input type="text" name="templateName" value="#templateName#" class="formField" style="width:150px;font-size:10px;">
				
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				
				<strong>Template Type:</strong>
				<input type="radio" name="templateType" value="page" <cfif templateType eq "page">checked</cfif>> Page
				<input type="radio" name="templateType" value="module" <cfif templateType eq "module">checked</cfif>> Module
			</div>
		
			<div id="pnl_editor">
				<textarea name="body" 
							wrap="off" 
							onkeypress="checkTab(event)" 
							onkeydown="checkTabIE()"	
							id="body" 
							style="width:98%;border:1px solid silver;padding:2px;height:385px;">#HTMLEditFormat(templateSource)#</textarea>
			</div>
			
			<div class="pagingControls"style="clear:both;">
				<cfif not isNew>
					<div style="float:right;font-weight:normal;">
						<b>Path:</b> #templateStruct.href#
					</div>
				</cfif>
				<input type="button" name="btnSave" value="Apply Changes" onclick="saveTemplate(this.form)">
				<cfif not isNew>
					&nbsp;&nbsp;
					<input type="button" name="btnDelete" value="Delete Template" onclick="deleteTemplate(this.form)">
				</cfif>
			</div>

		</div>
	</form>

	<cfif templateView eq "richtext">
		<script type="text/javascript">
			tinyMCE.idCounter=0;
			tinyMCE.execCommand('mceAddControl', false, "body");
		</script>
	</cfif>		

</cfoutput>
