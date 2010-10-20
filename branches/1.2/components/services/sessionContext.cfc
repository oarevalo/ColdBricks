<cfcomponent hint="this component provides access to a contextBean stored in the session scope">

	<cfset variables.instance = structNew()>
	<cfset variables.instance.contextBeanClass = "">
	<cfset variables.instance.contextName = "">

	<cffunction name="init" access="public" returntype="sessionContext" hint="constructor">
		<cfargument name="contextBeanClass" type="string" required="true">
		<cfargument name="contextName" type="string" required="false" default="context">
		<cfset flushContext()>
		<cfset setContextBeanClass(arguments.contextBeanClass)>
		<cfset setContextName(arguments.contextName)>
		<cfreturn this>
	</cffunction>

	<cffunction name="getContext" returntype="any" access="public" hint="Returns the stored contextBean instance for the current session">
		<cfset cn = getContextName()>
		<cfif not structKeyExists(session, cn)>
			<cfset session[cn] = createObject("component", getContextBeanClass()).init()>
		</cfif>
		<cfreturn session[cn]>
	</cffunction>

	<cffunction name="flushContext" returntype="void" access="public" hint="Removes the stored context from the session">
		<cfset structDelete(session, getContextName(), false)>
	</cffunction>


	<cffunction name="getContextBeanClass" access="public" returntype="string">
		<cfreturn variables.instance.ContextBeanClass>
	</cffunction>

	<cffunction name="setContextBeanClass" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.ContextBeanClass = arguments.data>
	</cffunction>

	<cffunction name="getContextName" access="public" returntype="string">
		<cfreturn variables.instance.ContextName>
	</cffunction>

	<cffunction name="setContextName" access="public" returntype="void">
		<cfargument name="data" type="string" required="true">
		<cfset variables.instance.ContextName = arguments.data>
	</cffunction>


</cfcomponent>