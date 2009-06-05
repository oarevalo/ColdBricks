<cfoutput>
	<table id="tblLayoutPreview" border="1" align="center" style="margin:0px;margin-top:30px;">
		
		<!--- display headers --->
		<cfif structKeyExists(stLocationsByType,"header")>
			<cfset aSections = stLocationsByType["header"]>
			<cf_displaySectionsAsRows numColumns="#numColumns#"
									sectionsArray="#aSections#"	
									modulesByRegionStruct="#stModulesByRegion#">
		</cfif>
		
		<!--- display columns --->
		<cfif structKeyExists(stLocationsByType,"column")>
			<cfset aSections = stLocationsByType["column"]>

			<cf_displaySectionsAsColumns columnWidth="#colWidth#"
											sectionsArray="#aSections#"	
											modulesByRegionStruct="#stModulesByRegion#">
		</cfif>
		
		<!--- display footers --->
		<cfif structKeyExists(stLocationsByType,"footer")>
			<cfset aSections = stLocationsByType["footer"]>

			<cf_displaySectionsAsRows numColumns="#numColumns#"
									sectionsArray="#aSections#"	
									modulesByRegionStruct="#stModulesByRegion#">

		</cfif>
		
		<!--- display any other regions as rows --->
		<cfloop collection="#stLocationsByType#" item="regionName">
			<cfif not listFindNoCase("header,column,footer",regionName)>
				<cfset aSections = stLocationsByType[regionName]>
	
				<cf_displaySectionsAsRows numColumns="#numColumns#"
										sectionsArray="#aSections#"	
										modulesByRegionStruct="#stModulesByRegion#">
			
			</cfif>
		</cfloop>
		
	</table>

</cfoutput>