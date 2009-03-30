<!--- dashboardMenu --->
<cfparam name="attributes.id" type="string" default="">  
<cfparam name="attributes.title" type="string" default="">  

<cfif thisTag.ExecutionMode eq "end">
	<cfparam name="thisTag.itemTags" type="array" default="#ArrayNew(1)#">
	<cfset hasAtLeastOneModule = false>

	<cfoutput>
		<cfsavecontent variable="tmpHTML">
			<script type="text/javascript">
				function showDBHelp_#attributes.id#(index) {
					var helpText = "";
					switch(index) {
						<cfloop from="1" to="#arrayLen(thisTag.itemTags)#" index="i">
							case #i#: helpText = "#jsStringFormat(thisTag.itemTags[i].help)#"; break;
						</cfloop>
					}
					$("helpTextDiv_#attributes.id#").style.display = "block";
					$("helpTextDiv_#attributes.id#").innerHTML = "<img src='images/help.png' align='absmiddle'> " + helpText;
				}
				function hideDBHelp_#attributes.id#() {
					$("helpTextDiv_#attributes.id#").style.display = "none";
				}
			</script>
		</cfsavecontent>
		<cfhtmlhead text="#tmpHTML#">

			<div>
				<div class="dsb_secTitle">#attributes.title#</div>

				<cfloop from="1" to="#arrayLen(thisTag.itemTags)#" index="i">
					<cfset item = thisTag.itemTags[i]>
					<cfif item.isAllowed>
						<div class="dsb_secBox">
							<a href="#item.href#" onmouseover="showDBHelp_#attributes.id#(#i#)" onmouseout="hideDBHelp_#attributes.id#()" onfocus="showDBHelp_#attributes.id#(#i#)" onblur="hideDBHelp_#attributes.id#()"><img src="#item.imgSrc#" border="0" alt="#item.alt#" title="#item.alt#"><br>
							<a href="#item.href#" onmouseover="showDBHelp_#attributes.id#(#i#)" onmouseout="hideDBHelp_#attributes.id#()" onfocus="showDBHelp_#attributes.id#(#i#)" onblur="hideDBHelp_#attributes.id#()" style="#item.labelStyle#">#item.label#</a>
						</div>
						<cfset hasAtLeastOneModule = true>
					</cfif>
				</cfloop>

				<cfif not hasAtLeastOneModule>
					<em>No allowed modules found.</em>
				</cfif>
				
				<br style="clear:both;" />
				
				<div style="height:60px;">
					<div class="helpTextDiv" id="helpTextDiv_#attributes.id#" style="display:none;"></div>
				</div>
			</div>	
	</cfoutput>

</cfif>