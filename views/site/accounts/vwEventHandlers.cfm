<cfparam name="request.requestState.oSite" default="">
<cfparam name="request.requestState.oPage" default="">
<cfparam name="request.requestState.oCatalog" default="">

<cfparam name="request.requestState.eventName" default="">
<cfparam name="request.requestState.eventHandler" default="">

<cfscript>
	oSite = request.requestState.oSite;
	oPage = request.requestState.oPage;
	oCatalog = request.requestState.oCatalog;
	
	eventName = request.requestState.eventName;
	eventHandler = request.requestState.eventHandler;
	
	aPages = oSite.getPages();
	owner = oSite.getOwner();
	title = oPage.getTitle();
	
	oAccounts = oSite.getAccount();
	stAccountInfo = oAccounts.getConfig();
	
	thisPageHREF = oPage.getHREF();	

	aModules = oPage.getModules();
	qryListeners = oPage.getEventHandlers();
	aAllEvents = ArrayNew(1);
	aAllEventHandlers = ArrayNew(1); 

	for(i=1;i lte arrayLen(aModules);i=i+1) {
		try {
			if(aModules[i].moduleType eq "module") {
				oModuleBean= oCatalog.getModuleByName(aModules[i].name);
	
				// create list of possible events on this page	
				aEvents = oModuleBean.getEvents();
				for(j=1;j lte arrayLen(aEvents);j=j+1) {
					ArrayAppend(aAllEvents, aModules[i].id & "." & aEvents[j].name);
				}
		
				// create list of available event handlers
				aMethods = oModuleBean.getMethods();
				for(j=1;j lte arrayLen(aMethods);j=j+1) {
					ArrayAppend(aAllEventHandlers, aModules[i].id & "." & aMethods[j].name);
				}
			}
		
		} catch (homePortals.catalog.resourceNotFound e) {
			// dont do anything		
		}
			
	}
	ArrayAppend(aAllEvents, "Framework.onPageLoaded");


	// sort account pages
	aPagesSorted = arrayNew(1);
	for(i=1;i lte arrayLen(aPages);i=i+1) {
		arrayAppend(aPagesSorted, aPages[i].href);
	}
	arraySort(aPagesSorted,"textnocase","asc");
	
</cfscript>


<script type="text/javascript">
function deleteEventHandler(index) {
	if(confirm('Delete event handler?')) {
		document.location = '?event=ehPage.doDeleteEventHandler&index='+index;
	}
}
</script>

<cfoutput>

<table style="width:100%;border:1px solid silver;background-color:##ebebeb;" cellpadding="8" cellspacing="0">
	<tr>
		<td nowrap="yes">
			<strong>Title:</strong> #title#
		</td>
		<td align="right">
			<strong>Page:</strong>
			<select name="page" style="width:180px;font-size:11px;" class="formField"  onchange="document.location='?event=ehPage.dspMain&page='+this.value">
				<cfloop from="1" to="#arrayLen(aPagesSorted)#" index="i">
					<option value="#aPagesSorted[i]#"
							<cfif aPagesSorted[i] eq getFileFromPath(thisPageHREF)>selected</cfif>>#aPagesSorted[i]#</option>
				</cfloop>
			</select>
		</td>
	</tr>
</table>


<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td>
			<div style="margin-top:10px;border:1px solid ##ccc;height:260px;overflow:auto;">	
				<table class="cp_dataTable">
					<tr>
						<th width="10">&nbsp;</th>
						<th>Event</th>
						<th>Action</th>
						<th width="10">&nbsp;</th>
					</tr>
					<cfloop query="qryListeners">
						<tr <cfif qryListeners.currentRow mod 2>style="background-color:##f3f3f3;"</cfif>>
							<td align="right"><b>#qryListeners.currentRow#.</b></td>
							<td>#qryListeners.objectName#.#qryListeners.eventName#</td>
							<td>#qryListeners.eventHandler#</td>
							<td align="right">
								<a href="javascript:deleteEventHandler(#qryListeners.currentRow#)"><img src="images/waste_small.gif" align="absmiddle" border="0"></a>
							</td>
						</tr>
					</cfloop>
					<cfif qryListeners.recordCount eq 0>
						<tr><td colspan="4"><em>No event handlers found.</em></td></tr>
					</cfif>
				</table>
			</div>	

			<form name="frm" method="post" action="index.cfm" style="margin:0px;padding:0px;">
				<fieldset style="margin-top:10px;border:1px solid ##ccc;background-color:##ebebeb;">
					<legend><strong>Add Event Handler:</strong></legend>
					<input type="hidden" name="event" value="ehPage.doAddEventHandler">
				
					<table cellspacing="0" cellpadding="2" style="width:440px;margin-bottom:5px;">
						<tr>
							<td>Select an Event:</td>
							<td>Select an Action:</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>
								<select name="eventName" style="width:200px;font-size:10px;">
									<option value=""></option>
									<cfloop from="1" to="#arrayLen(aAllEvents)#" index="i">
										<option value="#aAllEvents[i]#"
												<cfif eventName eq aAllEvents[i]>selected</cfif>>#aAllEvents[i]#</option>
									</cfloop>
								</select>
							</td>	
							<td>
								<select name="eventHandler" style="width:200px;font-size:10px;">
									<option value=""></option>
									<cfloop from="1" to="#arrayLen(aAllEventHandlers)#" index="i">
										<option value="#aAllEventHandlers[i]#"
												<cfif eventHandler eq aAllEventHandlers[i]>selected</cfif>>#aAllEventHandlers[i]#</option>
									</cfloop>
								</select>
							</td>
							<td>
								<input type="submit" name="btnSave" value="Add Event Handler">	
							</td>
						</tr>
					</table>
				</fieldset>
			</form>
		</td>
		
		<td width="200">
			<div class="cp_sectionBox helpBox"  style="margin:10px;margin-right:0px;margin-bottom:0px;height:350px;line-height:18px;">
				<div style="margin:10px;">
					<h2>Event Handlers</h2>
					<p>
						Event Handlers allow two or more modules to interact with each other. 
						Use the form below to add event handler declarations for this page. 
					</p>
					<p>
						Each event handler declaration consists on an event and a corresponding action. Events
						are raised by modules when certain conditions occurr (i.e. selecting a date on a calendar,
						a bookmark, etc). 
					</p>
					<p>
						See the documentation for each module to find out which events it raises.
					</p>
				</div>
			</div>
		</td>
		
	</tr>
</table>

<p>
	<input type="button" 
			name="btnCancel" 
			value="Return To Page Editor" 
			onClick="document.location='?event=ehPage.dspMain'">
</p>
</cfoutput>