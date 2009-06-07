<cfparam name="request.requestState.event" default="">
<cfparam name="request.requestState.hasAccountsPlugin" default="false">
<cfparam name="request.requestState.hasModulesPlugin" default="false">

<cfscript>
	hasAccountsPlugin = request.requestState.hasAccountsPlugin;
	hasModulesPlugin = request.requestState.hasModulesPlugin;	
	currentEvent = request.requestState.event;
	
	aOptions = [
					{ event = "config.ehSettings.dspMain", label = "General", enable = true},
					{ event = "config.ehSettings.dspAccounts", label = "Accounts", enable = hasAccountsPlugin},
					{ event = "config.ehSettings.dspModuleProperties", label = "Module Properties", enable = hasModulesPlugin},
					{ event = "config.ehSettings.dspEditXML", label = "Edit Config Files", enable = true}
					
				];
</cfscript>

<cfoutput>
	<div>
		<cfloop from="1" to="#arrayLen(aOptions)#" index="i">
			<cfif aOptions[i].enable>
				[ 
					<a href="index.cfm?event=#aOptions[i].event#"
						<cfif aOptions[i].event eq currentEvent>style="font-weight:bold;"</cfif>
						>#aOptions[i].label#</a>
				] 
				&nbsp;&nbsp;
			</cfif>
		</cfloop>
	</div>
</cfoutput>