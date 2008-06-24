<cfcomponent hint="This component contains wrappers to tags/features only available in Adobe CF8. ">
	<!---
		This component contains wrappers to tags/features only available in Adobe CF8. 
		The purpose is removing this particular tags from the event handlers so that other 
		CFML engines do not have any problems compiling the main code and only the particular 
		features will not work instead of the entire event handler
	--->
	
	<cffunction name="init" access="public" returntype="cf8extras" hint="a basic constructor">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="createZip" access="public" returntype="void" hint="wrapper for using cfzip to create an archive">
		<cfargument name="targetFilePath" type="string" required="true" hint="The complete path to the target zip file">
		<cfargument name="sourceFilePath" type="string" required="true" hint="The complete path to the source directory">

		<cfzip action="zip" file="#arguments.targetFilePath#" overwrite="yes"> 
			<cfzipparam source="#arguments.sourceFilePath#">
		</cfzip>
		
	</cffunction>
</cfcomponent>