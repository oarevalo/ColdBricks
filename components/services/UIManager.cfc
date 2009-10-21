<cfcomponent hint="This service is used to manage access permissions to resources">

	<cfset variables.instance = structNew()>
	<cfset variables.instance.aServerModules = arrayNew(1)>
	<cfset variables.instance.aSiteModules = arrayNew(1)>

	<cffunction name="init" access="public" returntype="UIManager" hint="constructor">
		<cfargument name="configHREF" type="string" required="true" hint="path to config file">
		<cfif configHREF neq "">
			<cfset loadConfig(expandPath(arguments.configHREF))>
		</cfif>
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
				st = { name = "", accessMapKey = "", alt = "", href = "", imgSrc = "", label = "", version = "", author = "", authorurl = "" };
				for(attr in aNodes[i].xmlAttributes) {
					st[attr] = aNodes[i].xmlAttributes[attr];
				}	
				st.description = aNodes[i].xmlText;
				st.core = true;
				registerServerModule(argumentCollection = st);
			}

			// get site modules
			aNodes = xmlSearch(xmlDoc,"//site/modules/module");
			for(i=1;i lte arrayLen(aNodes);i=i+1) {
				st = { name = "", accessMapKey = "", alt = "", href = "", imgSrc = "", label = "", bindToPlugin = "", version = "", author = "", authorurl = "" };
				for(attr in aNodes[i].xmlAttributes) {
					st[attr] = aNodes[i].xmlAttributes[attr];
				}	
				st.description = aNodes[i].xmlText;			
				st.core = true;
				registerSiteModule(argumentCollection = st);
			}			
		</cfscript>		
	</cffunction>
	
	<cffunction name="registerServerModule" access="public" returntype="void">
		<cfargument name="name" type="string" required="true" hint="Name of the module, must match the containing directory">
		<cfargument name="accessMapKey" type="string" required="false" default="">
		<cfargument name="alt" type="string" required="false" default="">
		<cfargument name="href" type="string" required="false" default="">
		<cfargument name="imgSrc" type="string" required="false" default="">
		<cfargument name="label" type="string" required="false" default="">
		<cfargument name="description" type="string" required="false" default="">
		<cfargument name="version" type="string" required="false" default="">
		<cfargument name="author" type="string" required="false" default="">
		<cfargument name="authorurl" type="string" required="false" default="">
		<cfset var st = arguments>
		<cfset st.uuid = createUUID()>
		<cfset arrayAppend(variables.instance.aServerModules, st)>
	</cffunction>

	<cffunction name="registerSiteModule" access="public" returntype="void">
		<cfargument name="name" type="string" required="true" hint="Name of the module, must match the containing directory">
		<cfargument name="accessMapKey" type="string" required="false" default="">
		<cfargument name="alt" type="string" required="false" default="">
		<cfargument name="href" type="string" required="false" default="">
		<cfargument name="imgSrc" type="string" required="false" default="">
		<cfargument name="label" type="string" required="false" default="">
		<cfargument name="bindToPlugin" type="string" required="false" default="">
		<cfargument name="description" type="string" required="false" default="">
		<cfargument name="version" type="string" required="false" default="">
		<cfargument name="author" type="string" required="false" default="">
		<cfargument name="authorurl" type="string" required="false" default="">
		<cfset var st = arguments>
		<cfset st.uuid = createUUID()>
		<cfset arrayAppend(variables.instance.aSiteModules, st)>
	</cffunction>
	
	<cffunction name="getServerModules" access="public" returntype="array" hint="returns the information about the modules available at the server level">
		<cfreturn duplicate(variables.instance.aServerModules)>
	</cffunction>

	<cffunction name="getSiteModules" access="public" returntype="array" hint="returns the information about the modules available at the site level">
		<cfreturn duplicate(variables.instance.aSiteModules)>
	</cffunction>

	<cffunction name="getModuleInfo" access="public" returntype="array" hint="returns information about a particular module">
		<cfargument name="name" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfset var aModules = 0>
		<cfset var i = 0>
	
		<cfif arguments.type eq "server">
			<cfset aModules = getServerModules()>
		<cfelseif type eq "site">
			<cfset aModules = getSiteModules()>
		<cfelse>
			<cfthrow message="invalid module type" type="coldbricks.invalidArgument">
		</cfif>
		
		<cfloop from="1" to="#arrayLen(aModules)#" index="i">
			<cfif aModules[i].name eq arguments.name>
				<cfreturn duplicate(aModules[i])>
			</cfif>
		</cfloop>

		<cfthrow message="Module not found!" type="coldbricks.moduleNotFound">
	</cffunction>

</cfcomponent>
