<cfparam name="request.requestState.resourceType" default="">
<cfparam name="request.requestState.id" default="">
<cfparam name="request.requestState.oResourceBean" default="">
<cfparam name="request.requestState.package" default="">
<cfparam name="request.requestState.fileContent" default="">
<cfparam name="request.requestState.type" default="">
<cfparam name="request.requestState.fullhref" default="">
<cfparam name="request.requestState.resLibIndex" default="">

<cfscript>
	resourceType = request.requestState.resourceType;
	id = request.requestState.id;
	oResourceBean = request.requestState.oResourceBean;
	package = request.requestState.package;
	fileContent = request.requestState.fileContent;
	type = request.requestState.type;
	fullhref = request.requestState.fullhref;
	resLibIndex = request.requestState.resLibIndex;
	fileName = "";

	if(fullhref neq "") {
		fileName = getFileFromPath( fullhref );
	}
</cfscript>

<cfoutput>
	<form name="frm" action="index.cfm" method="post" style="margin:0px;padding:0px;">
		<input type="hidden" name="event" value="ehResources.doSaveResourceFile">
		<input type="hidden" name="id" value="#id#">
		<input type="hidden" name="fileName" value="#fileName#">
		<input type="hidden" name="type" value="#type#">
		<div>
			<div class="cp_sectionTitle" style="margin:0px;padding:0px;">&nbsp; Resource Target Editor</div>
				
			<div style="margin-top:5px;margin-bottom:5px;font-size:12px;text-align:left;background-color:##ccc;border:1px solid ##333;padding:2px;">
				<b>ID:</b> #id# (#resourceType#)
			</div>

			<div id="pnl_editor">
				<textarea name="body" 
							wrap="off" 
							onkeypress="checkTab(event)" 
							onkeydown="checkTabIE()"	
							id="body" 
							style="width:98%;border:1px solid silver;padding:2px;height:385px;">#HTMLEditFormat(fileContent)#</textarea>
			</div>
			
			<div class="pagingControls"style="clear:both;">
				<div style="float:right;font-weight:normal;">
					<b>Path:</b> #fullhref#
				</div>
				<input type="button" name="btnSave" value="Apply Changes" onclick="saveResourceFile(this.form)">
				&nbsp;&nbsp;&nbsp;
				<input type="button" name="btnCancel" value="Cancel" onclick="selectResource('#jsStringFormat(resourceType)#','#jsStringFormat(id)#','#jsStringFormat(package)#','#resLibIndex#')">
			</div>

		</div>
	</form>
	<cfif type eq "richtext">
		<script type="text/javascript">
			tinyMCE.idCounter=0;
			tinyMCE.execCommand('mceAddControl', false, "body");
		</script>
	</cfif>
</cfoutput>