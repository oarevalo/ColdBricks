<cfcomponent hint="This service is used to manage access permissions to resources">

	<cfset variables.instance = structNew()>
	<cfset variables.instance.aServerModules = arrayNew(1)>
	<cfset variables.instance.aSiteModules = arrayNew(1)>

	<cffunction name="init" access="public" returntype="UIManager" hint="constructor">
		<cfargument name="configHREF" type="string" required="true" hint="path to config file">
		<cfset loadConfig(expandPath(arguments.configHREF))>
		<cfreturn this>
	</cffunction>

	<cffunction name="loadConfig" access="private" returntype="void" hint="loads and parses the config file">
		<cfargument name="configPath" type="string" required="false">
		<cfscript>
			var xmlDoc = 0;
			var xmlNode = 0;
			var i = 0; 
			var aNodes = arrayNew(1);
			var st = structNew();
			var attr = "";
			
			if(not fileExists(configPath))
				throw("interface config file not found!");
				
			xmlDoc = xmlParse(configPath);
			
			if(xmlDoc.xmlRoot.xmlName neq "interface")
				throw("Invalid config file");
						
			// get server modules
			aNodes = xmlSearch(xmlDoc,"//server/modules/module");
			for(i=1;i lte arrayLen(aNodes);i=i+1) {
				st = { accessMapKey = "", alt = "", href = "", imgSrc = "", label = "" };
				for(attr in aNodes[i].xmlAttributes) {
					st[attr] = aNodes[i].xmlAttributes[attr];
				}	
				st.description = aNodes[i].xmlText;			
				arrayAppend(variables.instance.aServerModules, duplicate(st));
			}

			// get site modules
			aNodes = xmlSearch(xmlDoc,"//site/modules/module");
			for(i=1;i lte arrayLen(aNodes);i=i+1) {
				st = { accessMapKey = "", alt = "", href = "", imgSrc = "", label = "", bindToPlugin = "" };
				for(attr in aNodes[i].xmlAttributes) {
					st[attr] = aNodes[i].xmlAttributes[attr];
				}	
				st.description = aNodes[i].xmlText;			
				arrayAppend(variables.instance.aSiteModules, duplicate(st));
			}			
		</cfscript>		
	</cffunction>
	
	<cffunction name="getServerModules" access="public" returntype="array" hint="returns the information about the modules available at the server level">
		<cfreturn duplicate(variables.instance.aServerModules)>
	</cffunction>

	<cffunction name="getSiteModules" access="public" returntype="array" hint="returns the information about the modules available at the site level">
		<cfreturn duplicate(variables.instance.aSiteModules)>
	</cffunction>
		
</cfcomponent>
