<cfparam name="request.requestState.aSites" default="">
<cfset aSites = request.requestState.aSites>

<cfoutput>
	
	<b>Select a site template by clicking on one of the icons below.</b><br><br>

	<cf_dashboardMenu id="dsb_selectTemplate">
		
		<cfloop from="1" to="#arrayLen(aSites)#" index="i">
			<cfif aSites[i].description eq "">
				<cfset tmpDesc = "Create a site using the '#asites[i].name#' template.">
			<cfelse>
				<cfset tmpDesc = aSites[i].description>
			</cfif>
		
			<cf_dashboardMenuItem href="javascript:selectSiteTemplate('#aSites[i].name#')" 
									imgSrc="#aSites[i].thumbHREF#"
									alt="#aSites[i].title#"
									label="#aSites[i].title#"
									help="#tmpDesc#">
		</cfloop>
<!--- 
		<cf_dashboardMenuItem href="index.cfm?event=ehSites.dspCreateCustom" 
								imgSrc="/ColdBricks/images/Globe_48x48.png"
								alt="Create custom site"
								label="Custom..."
								help="Create a customized site in which you can modify detailed settings"> --->
		
	</cf_dashboardMenu>

</cfoutput>