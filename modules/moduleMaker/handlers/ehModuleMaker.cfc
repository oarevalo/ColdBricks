<cfcomponent extends="ColdBricks.handlers.ehColdBricks">
	
	<cfset variables.homePortalsConfigPath = "/config/homePortals-config.xml">

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			try {
				
				
				stContRenders = getAppHomePortalsConfigBean().getContentRenderers();
				
				setView("vwMain");
				setValue("stContentRenderers",stContRenders);
				setValue("cbPageTitle", "Module Maker");
				setValue("cbPageIcon", "images/configure_48x48-2.png");
				setValue("cbShowSiteMenu", true);
			
			} catch(any e) {
				setMessage("error", e.message);
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspModule" access="public" returntype="void">
		<cfscript>
			var moduleType = getValue("moduleType");
			var oConfig = getAppHomePortalsConfigBean();
			
			try {
				setLayout("Layout.None");

				path = oConfig.getContentRenderer(moduleType);
				oCR = createObject("component",path);
					
				setValue("moduleType",moduleType);
				setValue("tagInfo",duplicate(getMetaData(oCR)));
				setValue("head",oCR.getHead());
				setValue("body",oCR.getBody());

				setView("vwModule");
							
			} catch(coldbricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}				
		</cfscript>
	</cffunction>

	<cffunction name="getAppHomePortalsConfigBean" access="private" returntype="homePortals.components.homePortalsConfigBean">
		<cfscript>
			var oContext = getService("sessionContext").getContext();
			var appRoot = oContext.getHomePortals().getConfig().getAppRoot();
			var oConfigBean = createObject("component","homePortals.components.homePortalsConfigBean").init( expandPath(appRoot & variables.homePortalsConfigPath) );
			return oConfigBean;
		</cfscript>
	</cffunction>
	
</cfcomponent>