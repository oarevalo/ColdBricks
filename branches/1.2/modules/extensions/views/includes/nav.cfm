<cfparam name="request.requestState.event" default="">

<cfscript>
	currentEvent = request.requestState.event;
	
	aOptions = [
					{ event = "extensions.ehGeneral.dspModules", label = "Modules" },
					{ event = "extensions.ehGeneral.dspSiteTemplates", label = "SiteTemplates" }
					
				];
</cfscript>

<cfoutput>
	<div>
		<cfloop from="1" to="#arrayLen(aOptions)#" index="i">
			[ 
				<a href="index.cfm?event=#aOptions[i].event#"
					<cfif aOptions[i].event eq currentEvent>style="font-weight:bold;"</cfif>
					>#aOptions[i].label#</a>
			] 
			&nbsp;&nbsp;
		</cfloop>
	</div>
</cfoutput>