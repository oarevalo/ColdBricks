<cfcomponent hint="This service is used to manage access permissions to resources">

	<cfset variables.instance = structNew()>
	<cfset variables.instance.module = structNew()>
	<cfset variables.instance.module.all = arrayNew(1)>
	<cfset variables.instance.feature = structNew()>
	<cfset variables.instance.feature.server = arrayNew(1)>
	<cfset variables.instance.feature.site = arrayNew(1)>
	<cfset variables.instance.widget = structNew()>
	<cfset variables.instance.widget.server = arrayNew(1)>
	<cfset variables.instance.widget.site = arrayNew(1)>

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
			var i = 0; var j = 0; var k = 0;
			var aNodes = arrayNew(1);
			var st = structNew();
			var moduleName = "";
			var thisNode = 0;
			var itemType = "";
			
			if(not fileExists(arguments.configPath))
				throwException("interface config file not found!");
				
			xmlDoc = xmlParse(arguments.configPath);
			
			if(xmlDoc.xmlRoot.xmlName neq "interface")
				throwException("Invalid config file");

			aNodes = xmlSearch(xmlDoc,"//modules/module");

			for(i=1;i lte arrayLen(aNodes);i=i+1) {
				
				st = structNew();
				st = aNodes[i].xmlAttributes;
				st.description = aNodes[i].xmlText;
				st.core = true;
				moduleName = st.name;
				registerModule(argumentCollection = st);
				
				for(j=1;j lte arrayLen(aNodes[i].xmlChildren);j++) {
				
					itemType = aNodes[i].xmlChildren[j].xmlAttributes.type;

					switch(aNodes[i].xmlChildren[j].xmlName) {
						
						case "features":
							for(k=1;k lte arrayLen(aNodes[i].xmlChildren[j].xmlChildren);k++) {
								st = structNew();
								thisNode = aNodes[i].xmlChildren[j].xmlChildren[k];
								
								if(itemType eq "server") {
									st = thisNode.xmlAttributes;
									st.description = thisNode.xmlText;
									st.module = moduleName;
									registerServerFeature(argumentCollection = st);
								
								} else if(itemType eq "site") {
									st = thisNode.xmlAttributes;
									st.description = thisNode.xmlText;
									st.module = moduleName;
									registerSiteFeature(argumentCollection = st);
								}
							}							
							break;
							
						case "widgets":
							for(k=1;k lte arrayLen(aNodes[i].xmlChildren[j].xmlChildren);k++) {
								st = structNew();
								thisNode = aNodes[i].xmlChildren[j].xmlChildren[k];

								if(itemType eq "server") {
									st = thisNode.xmlAttributes;
									st.module = moduleName;
									registerServerWidget(argumentCollection = st);
								
								} else if(itemType eq "site") {
									st = thisNode.xmlAttributes;
									st.module = moduleName;
									registerSiteWidget(argumentCollection = st);
								}
							}							
							break;
					}
				}
			}
		</cfscript>		
	</cffunction>
	
	<cffunction name="registerModule" access="public" returntype="void">
		<cfargument name="name" type="string" required="true" hint="Name of the module, must match the containing directory">
		<cfargument name="description" type="string" required="false" default="">
		<cfargument name="version" type="string" required="false" default="">
		<cfargument name="author" type="string" required="false" default="">
		<cfargument name="authorurl" type="string" required="false" default="">
		<cfset registerItem("module","all", arguments)>
	</cffunction>

	<cffunction name="registerServerFeature" access="public" returntype="void">
		<cfargument name="accessMapKey" type="string" required="false" default="">
		<cfargument name="alt" type="string" required="false" default="">
		<cfargument name="href" type="string" required="false" default="">
		<cfargument name="imgSrc" type="string" required="false" default="">
		<cfargument name="label" type="string" required="false" default="">
		<cfargument name="description" type="string" required="false" default="">
		<cfset registerItem("feature","server", arguments)>
	</cffunction>

	<cffunction name="registerSiteFeature" access="public" returntype="void">
		<cfargument name="accessMapKey" type="string" required="false" default="">
		<cfargument name="alt" type="string" required="false" default="">
		<cfargument name="href" type="string" required="false" default="">
		<cfargument name="imgSrc" type="string" required="false" default="">
		<cfargument name="label" type="string" required="false" default="">
		<cfargument name="bindToPlugin" type="string" required="false" default="">
		<cfargument name="description" type="string" required="false" default="">
		<cfset registerItem("feature","site", arguments)>
	</cffunction>
	
	<cffunction name="registerServerWidget" access="public" returntype="void">
		<cfargument name="href" type="string" required="false" default="">
		<cfargument name="title" type="string" required="false" default="">
		<cfargument name="position" type="string" required="false" default="">
		<cfset registerItem("widget","server", arguments)>
	</cffunction>

	<cffunction name="registerSiteWidget" access="public" returntype="void">
		<cfargument name="href" type="string" required="false" default="">
		<cfargument name="title" type="string" required="false" default="">
		<cfargument name="position" type="string" required="false" default="">
		<cfset registerItem("widget","site", arguments)>
	</cffunction>

	<cffunction name="getModules" access="public" returntype="array" hint="returns the information about all registered modules">
		<cfreturn getItems("module","all")>
	</cffunction>
	
	<cffunction name="getServerFeatures" access="public" returntype="array" hint="returns the information about the features available at the server level">
		<cfreturn getItems("feature","server")>
	</cffunction>

	<cffunction name="getSiteFeatures" access="public" returntype="array" hint="returns the information about the features available at the site level">
		<cfreturn getItems("feature","site")>
	</cffunction>

	<cffunction name="getServerWidgets" access="public" returntype="array" hint="returns the information about the widgets available for the server dashboard">
		<cfreturn getItems("widget","server")>
	</cffunction>

	<cffunction name="getSiteWidgets" access="public" returntype="array" hint="returns the information about the widgets available for the site dashboard">
		<cfreturn getItems("widget","site")>
	</cffunction>


	<cffunction name="getModuleInfo" access="public" returntype="array" hint="returns information about a particular module">
		<cfargument name="name" type="string" required="true">
		<cfset var aModules = getItems("module","all")>
		<cfset var i = 0>

		<cfloop from="1" to="#arrayLen(aModules)#" index="i">
			<cfif aModules[i].name eq arguments.name>
				<cfreturn duplicate(aModules[i])>
			</cfif>
		</cfloop>

		<cfthrow message="Module not found!" type="coldbricks.moduleNotFound">
	</cffunction>

	<cffunction name="hasModule" access="public" returntype="boolean" hint="Checks whether a given UI module exists or not">
		<cfargument name="name" type="string" required="true">
		<cfset var aModules = getItems("module","all")>
		<cfset var i = 0>

		<cfloop from="1" to="#arrayLen(aModules)#" index="i">
			<cfif aModules[i].name eq arguments.name>
				<cfreturn true>
			</cfif>
		</cfloop>

		<cfreturn false>
	</cffunction>


	<!--- private methods --->

	<cffunction name="getItems" access="private" returntype="array" hint="Returns all items of the given category and type">
		<cfargument name="category" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfif structKeyExists(variables.instance, arguments.category) and structKeyExists(variables.instance[arguments.category], arguments.type)>
			<cfreturn duplicate(variables.instance[arguments.category][arguments.type])>
		<cfelse>
			<cfthrow message="invalid category or type" type="coldbricks.invalidArgument">
		</cfif>
	</cffunction>

	<cffunction name="registerItem" access="private" returntype="void" hint="internal method to register an item">
		<cfargument name="category" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfargument name="propertiesMap" type="struct" required="true">
		<cfset var st = arguments.propertiesMap>
		<cfset st.uuid = createUUID()>
		<cfset arrayAppend(variables.instance[arguments.category][arguments.type], st)>
	</cffunction>

</cfcomponent>
