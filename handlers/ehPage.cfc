<cfcomponent extends="ehColdBricks">

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var page = getValue("page");
			var account = getValue("account");
			var resType = getValue("resType");
			var pageHREF = "";
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			var oPage = 0;
			var cbPageTitle = "";
			
			try {
				hp = oContext.getHomePortals();
			
				if(page neq "") {
					if(oContext.hasAccountSite() and account neq "") {
						oPage = oContext.getAccountSite().getPage(page);
						pageHREF = oContext.getAccountSite().getPageHREF(page);
					} else {
						oPage = hp.getPageProvider().load(page);
						pageHREF = page;
					}
					oContext.setPage(oPage);
					oContext.setPageHREF(pageHREF);
				}			

				// get default resource type
				if(oContext.getPageResourceTypeView() eq "") oContext.setPageResourceTypeView("module");
				if(resType neq "") oContext.setPageResourceTypeView(resType);

				if(oContext.hasAccountSite())
					cbPageTitle = "Accounts > #oContext.getAccountName()# > ";
				else
					cbPageTitle = "Pages > ";

				if(oContext.getPage().getTitle() neq "")
					cbPageTitle = cbPageTitle & oContext.getPage().getTitle();
				else
					cbPageTitle = cbPageTitle & getFileFromPath(oContext.getPageHREF());

				
				setValue("pageTitle", oContext.getPage().getTitle() );
				setValue("accountName", oContext.getAccountName());
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("resType", oContext.getPageResourceTypeView);
				setValue("aLayoutSectionTypes", listToArray(hp.getConfig().getLayoutSections()));
				setValue("pageHREF", oContext.getPageHREF());
				
				setValue("oPage", oContext.getPage());
				setValue("oCatalog", hp.getCatalog() );

				setValue("cbPageTitle", cbPageTitle);
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				
				setView("site/page/vwMain");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehSite.dspMain");
			}			
		</cfscript>
	</cffunction>
	
	<cffunction name="dspModuleProperties" access="public" returntype="void">
		<cfscript>
			var oPage = 0;
			var moduleID = getValue("moduleID","");
			var oContext = getService("sessionContext").getContext();

			try {
				// remove prefixes added to avoid mixing with existing page elements
				moduleID = replace(moduleID,"ppm_","","ALL");

				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
				
				stModule = oPage.getModule(moduleID);

				objPath = oContext.getHomePortals().getConfig().getContentRenderer(stModule.moduleType);
				obj = createObject("component",objPath);
				tagInfo = getMetaData(obj);

				setValue("stModule", stModule);
				setValue("tagInfo", tagInfo);
				setView("site/page/vwModuleProperties");
				setLayout("Layout.None");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>
	</cffunction>	
	
	<cffunction name="dspEditModuleProperties" access="public" returntype="void">
		<cfscript>
			var oPage = 0;
			var oCatalog = 0;
			var oResourceBean = 0;
			var moduleID = getValue("moduleID","");
			var moduleCatID = "";
			var hp = 0;
			var missingModuleBean = true;
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();

				// remove prefixes added to avoid mixing with existing page elements
				moduleID = replace(moduleID,"ppm_","","ALL");
				
				// check if we have a site and page cfcs loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				if(moduleID eq "") throw("Please select a module to edit","coldBricks.validation");
				
				// get page from session
				oPage = oContext.getPage();
				oCatalog = hp.getCatalog();

				stModule = oPage.getModule(moduleID);

				objPath = oContext.getHomePortals().getConfig().getContentRenderer(stModule.moduleType);
				obj = createObject("component",objPath);
				tagInfo = getMetaData(obj);
				
				// pass values to view
				setValue("oPage", oPage );
				setValue("oCatalog", oCatalog );
				setValue("stModule", stModule);
				setValue("tagInfo", tagInfo);
				setValue("pageHREF", oContext.getPageHREF());
				setValue("tag", stModule.moduleType);

				if(oContext.hasAccountSite())
					setValue("cbPageTitle", "Accounts > #oContext.getAccountSite().getOwner()# > #oPage.getTitle()# > Edit Module");
				else
					setValue("cbPageTitle", "Pages > #oPage.getTitle()# > Edit Module");
				
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				setView("site/page/vwEditModuleProperties");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="dspEventHandlers" access="public" returntype="void">
		<cfscript>
			var oPage = 0;
			var oCatalog = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				
				// check if we have a page loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
				
				// pass values to view
				setValue("oPage", oPage );
				setValue("oCatalog", hp.getCatalog() );
				setValue("pageHREF", oContext.getPageHREF() );

				if(oContext.hasAccountSite())
					setValue("cbPageTitle", "Accounts > #oContext.getAccountSite().getOwner()# > #oPage.getTitle()# > Event Handlers");
				else
					setValue("cbPageTitle", "Pages > #oPage.getTitle()# > Event Handlers");

				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				setView("site/page/vwEventHandlers");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspEditXML" access="public" returntype="void">
		<cfscript>
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();

				// pass values to view
				setValue("oPage", oPage );
				setValue("pageHREF", oContext.getPageHREF() );

				if(oContext.hasAccountSite())
					setValue("cbPageTitle", "Accounts > #oContext.getAccountSite().getOwner()# > #oPage.getTitle()# > Page XML");
				else
					setValue("cbPageTitle", "Pages > #oPage.getTitle()# > Page XML");
					
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				setView("site/page/vwEditXML");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="dspEditCSS" access="public" returntype="void">
		<cfscript>
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			var oPageHelper = 0;
			
			try {
				// check if we have a page loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
				
				// get page helper
				oPageHelper = createObject("component","homePortals.components.pageHelper").init( oPage, oContext.getPageHREF() );

				// pass values to view
				setValue("oPage", oPage );
				setValue("pageHREF", oContext.getPageHREF() );
				setValue("pageCSSContent", oPageHelper.getPageCSS() );

				if(oContext.hasAccountSite())
					setValue("cbPageTitle", "Accounts > #oContext.getAccountSite().getOwner()# > #oPage.getTitle()# > Stylesheet");
				else
					setValue("cbPageTitle", "Pages > #oPage.getTitle()# > Stylesheet");
			
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				setView("site/page/vwEditCSS");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="dspResourceInfo" access="public" returntype="void">
		<cfscript>
			var oCatalog = 0;
			var oResourceBean = 0;
			var resourceID = getValue("resourceID","");
			var resType = getValue("resType","");
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();
				oResourceBean = oCatalog.getResourceNode(resType, resourceID);

				// pass values to view
				setValue("oResourceBean", oResourceBean);
				
				setView("site/page/vwResourceInfo");
				setLayout("Layout.None");
				
			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>
		
	<cffunction name="dspMeta" access="public" returntype="void">
		<cfscript>
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				
				// check if we have a page loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
				
				// pass values to view
				setValue("oPage", oPage );
				setValue("pageHREF", oContext.getPageHREF() );

				if(oContext.hasAccountSite())
					setValue("cbPageTitle", "Accounts > #oContext.getAccountSite().getOwner()# > #oPage.getTitle()# > User-Defined Meta Tags");
				else
					setValue("cbPageTitle", "Pages > #oPage.getTitle()# > User-Defined Meta Tags");
	
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				
				setView("site/page/vwMetaTags");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}
		</cfscript>
	</cffunction>	

	<cffunction name="dspModuleCSS" access="public" returntype="void">
		<cfscript>
			var oPage = 0;
			var moduleID = getValue("moduleID","");
			var oContext = getService("sessionContext").getContext();

			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
				
				stModule = oPage.getModule(moduleID);
				
				setValue("stModule", stModule);
				setView("site/page/vwModuleCSS");
				setLayout("Layout.None");

			} catch(coldBricks.validation e) {
				setLayout("Layout.None");
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setLayout("Layout.None");
			}			
		</cfscript>	
	</cffunction>

	<cffunction name="dspResourceTree" access="public" returntype="void">
		<cfscript>
			var resType = getValue("resType");
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
			
				// get default resource type
				if(oContext.getPageResourceTypeView() eq "") oContext.setPageResourceTypeView("module");
				if(resType neq "") oContext.setPageResourceTypeView(resType);

				setValue("resType", oContext.getPageResourceTypeView());
				setValue("oPage", oContext.getPage());
				setValue("oCatalog", hp.getCatalog() );
				
				setView("site/page/vwResourceTree");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>	
	</cffunction>

	<cffunction name="dspContentRenderersTree" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
			
				setValue("stTags", hp.getConfig().getContentRenderers());
				setValue("oPage", oContext.getPage());
				
				setView("site/page/vwContentRenderersTree");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>	
	</cffunction>

	<cffunction name="dspContentRenderersInfo" access="public" returntype="void">
		<cfscript>
			var tag = getValue("tag");
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			var tagInfo = "";
			
			try {
				hp = oContext.getHomePortals();
				objPath = oContext.getHomePortals().getConfig().getContentRenderer(tag);
				obj = createObject("component",objPath);
				tagInfo = getMetaData(obj);

				// pass values to view
				setValue("tagInfo", tagInfo);
				
				setView("site/page/vwContentTagInfo");
				setLayout("Layout.None");
				
			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>
	

	<!-----  Module Actions  ---->			
	<cffunction name="doAddResource" access="public" returntype="void">
		<cfscript>
			var resourceID = getValue("resourceID","");
			var resType = getValue("resType","");
			var locationName = getValue("locationName","");
			var oPage = 0;
			var oPageHelper = 0;
			var hp = 0;
			var moduleID = "";
			var	stAttributes = structNew();
			var moduleResType = "module";
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");

				oPage = oContext.getPage();
				oCatalog = hp.getCatalog();

				// build custom properties
				switch(resType) {
					
					case "feed":
						// the module that we will use to add the resource to the page
						moduleID = "rssReader";
				
						// get the resource info
						resBean = oCatalog.getResourceNode(resType, resourceID);
				
						// set default properties
						stAttributes["rss"] = resBean.getHREF();
						if( resBean.getName() neq "" )
							stAttributes["title"] = resBean.getName();
						stAttributes["maxItems"] = 10;

						break;
						
					case "module":
						moduleID = resourceID;
						break;
						
					case "content":
					case "html":
						moduleID = resourceID;
						moduleResType = resType;
						stAttributes["resourceID"] = resourceID;
						stAttributes["resourceType"] = resType;
						stAttributes["moduleType"] = "content";
						break;
						
					default:
						throw("The given resource type cannot be added directly to a page","coldBricks.invalidResourceType");
				}
				
				resBean = oCatalog.getResourceNode(moduleResType, moduleID);
				
				oPageHelper = createObject("component","homePortals.components.pageHelper").init( oPage );
				oPageHelper.addModule(resBean, locationName, stAttributes);
				savePage();
				
				setMessage("info", "Resource added to page");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}			
		</cfscript>		
	</cffunction>
	
	<cffunction name="doDeleteModule" access="public" returntype="void">
		<cfscript>
			var moduleID = getValue("moduleID","");
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				oPage.removeModule(moduleID);
				savePage();
				
				setMessage("info", "Module deleted");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}			
		</cfscript>
	</cffunction>
	
	<cffunction name="doUpdateModuleOrder" access="public" returntype="void">
		<cfscript>
			var layout = getValue("newlayout","");
			var oPage = 0;
			var oPageHelper = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				// remove prefixes added to avoid mixing with existing page elements
				layout = replaceList(layout,"ppm_,pps_",",");

				oPageHelper = createObject("component","homePortals.components.pageHelper").init( oPage );
				oPageHelper.setModuleOrder(layout);
				savePage();
				
				setMessage("info", "Modules layout changed");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}			
		</cfscript>
	</cffunction>	
	
	<cffunction name="doSaveModule" access="public" returntype="void">
		<cfscript>
			var moduleID = getValue("id","");
			var oPage = 0;
			var stAttribs = structNew();
			var lstAllAttribs = "";
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
				
				lstAttribs = getValue("_baseAttribs");
				for(i=1;i lte listLen(lstAttribs);i=i+1) {
					fld = listGetAt(lstAttribs,i);
					stAttribs[fld] = getValue(fld);
				}

				lstAttribs = getValue("_moduleAttribs");
				for(i=1;i lte listLen(lstAttribs);i=i+1) {
					fld = listGetAt(lstAttribs,i);
					if(getValue(fld) neq getValue(fld & "_default") 
						and getValue(fld) neq "_NOVALUE_") stAttribs[fld] = getValue(fld);
				}

				lstAttribs = getValue("_customAttribs");
				for(i=1;i lte listLen(lstAttribs);i=i+1) {
					fld = listGetAt(lstAttribs,i);
					if(not getValue(fld & "_delete",false)) {
						stAttribs[fld] = getValue(fld);
					}
				}

				if(getValue("newCustomProp_name") neq "") {
					stAttribs[ getValue("newCustomProp_name") ] = getValue("newCustomProp_value");
				}
				
				
				oPage.setModule(moduleID, getValue("location"), stAttribs);
				savePage();
				
				setMessage("info", "Module attributes saved");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspEditModuleProperties","moduleID=#moduleID#");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspEditModuleProperties","moduleID=#moduleID#");
			}			
		</cfscript>
	</cffunction>		
	
	<cffunction name="doAddContentModule" access="public" returntype="void">
		<cfscript>
			var resType = getValue("resType","content");
			var locationName = getValue("locationName","");
			var oPage = 0;
			var oPageHelper = 0;
			var hp = 0;
			var	stAttributes = structNew();
			var oContext = getService("sessionContext").getContext();

			try {
				hp = oContext.getHomePortals();
				
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");

				oPage = oContext.getPage();
				
				resBean = createObject("component","homePortals.components.resourceBean").init();
				resBean.setID("contentModule");
				resBean.setName("contentModule");

				stAttributes["moduleType"] = "content";
				
				oPageHelper = createObject("component","homePortals.components.pageHelper").init( oPage );
				oPageHelper.addModule(resBean, locationName, stAttributes);
				savePage();
				
				setMessage("info", "Empty content module added to page");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}				
		</cfscript>
	</cffunction>
		
	<cffunction name="doAddContentTag" access="public" returntype="void">
		<cfscript>
			var tag = getValue("tag");
			var locationName = getValue("locationName","");
			var oPage = 0;
			var hp = 0;
			var	stAttributes = structNew();
			var oContext = getService("sessionContext").getContext();

			try {
				hp = oContext.getHomePortals();
				
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");

				oPage = oContext.getPage();
				
				oPageHelper = createObject("component","homePortals.components.pageHelper").init( oPage );
				oPageHelper.addContentTag(tag, locationName, stAttributes);
				savePage();
				
				setMessage("info", "Empty content tag added to page");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}				
		</cfscript>
	</cffunction>	

	<cffunction name="dspContentTagInfo" access="public" returntype="void">
	</cffunction>	
		
		
	<!-----  Page Level Actions  ---->		
	<cffunction name="doRenamePage" access="public" returntype="void">
		<cfscript>
			var pageName = getValue("pageName","");
			var oPage = 0;
			var oSite = 0;
			var oPageProvider = 0;
			var originalPageHREF = "";
			var newPageHREF = "";
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				if(pageName eq "") throw("The page name cannot be blank.","coldBricks.validation");

				// if the pageName contains any spaces, then replace them with _
				pageName = replace(pageName," ","_","ALL");

				if(right(pageName,4) eq ".xml") {
					tmpFirstPart = left(pageName,len(pageName)-4);
			
					// check that the page name only contains simple characters
					if(reFind("[^A-Za-z0-9_]",tmpFirstPart)) 
						throw("Page names can only contain characters from the alphabet, digits and the underscore symbol","coldbricks.validation");
				}

				// get the original location of the page
				originalPageHREF = oContext.getPageHREF();
		
				// rename the page (handled differently if there page belongs to a site)
				if(oContext.hasAccountSite()) {
					oSite = oContext.getAccountSite();
					oSite.renamePage(getFileFromPath(originalPageHREF), pageName);
					newPageHREF = oSite.getPageHREF(pageName);
				} else {
					oPageProvider = oContext.getHomePortals().getPageProvider();
					newPageHREF = replaceNoCase(originalPageHREF, getFileFromPath(originalPageHREF), pageName);
					oPageProvider.move(originalPageHREF, newPageHREF);
				}

				// update context
				oContext.setPageHREF(newPageHREF);
				
				setMessage("info", "Page name changed.");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}			
		</cfscript>
	</cffunction>
		
	<cffunction name="doApplySkin" access="public" returntype="void">
		<cfscript>
			var skinID = getValue("skinID","");
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				if(skinID eq "NONE") skinID = "";
		
				oPage.setSkinID(skinID);
				savePage();
				
				if(skinID eq "") 
					setMessage("info", "Skin removed");
				else 
					setMessage("info", "Skin changed");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}			
		</cfscript>
	</cffunction>		

	<cffunction name="doApplyPageTemplate" access="public" returntype="void">
		<cfscript>
			var href = getValue("resourceID","");
			var oPage = 0; var oResourceBean = 0;
			var hp = 0; var oCatalog = 0;
			var resRoot = ""; var oPageHelper = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				// get resource root
				hp = oContext.getHomePortals();
				resRoot = hp.getConfig().getResourceLibraryPath();
		
				// get pagetemplate resource
				oCatalog = hp.getCatalog();
				oResourceBean = oCatalog.getResourceNode("pageTemplate", resourceID);
		
				// apply template
				oPageHelper = createObject("component","homePortals.components.pageHelper").init( oPage, oContext.getPageHREF() );
				oPageHelper.applyPageTemplate(oResourceBean, resRoot);
				savePage();
				
				setMessage("info", "The page template has been applied.");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}			
		</cfscript>
	</cffunction>
	
	<cffunction name="doSaveXML" access="public" returntype="void">
		<cfscript>
			var xmlContent = getValue("xmlContent","");
			var oPage = 0;
			var oPageCheck = 0;
			var oContext = getService("sessionContext").getContext();
			var pageHREF = oContext.getPageHREF();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				if(not isXml(xmlContent)) {
					setMessage("warning", "The given content is not a valid XML document");
					dspEditXML();
					return;
				}
				
				// validate xml
				try {
					oPageCheck =  createObject("component","homePortals.components.pageBean").init(xmlContent);
				} catch(any e) {
					// assume any error here as a parsing error
					throw("The XML provided is not a valid xml for a page. #e.message#","coldBricks.validation");
				}
				
				// update the page
				oPage.init(xmlContent);
				savePage();
				
				// go to the xml editor
				setMessage("info", "Page XML Changed");
				setNextEvent("ehPage.dspMain","page=#getFileFromPath( pageHREF )#");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspEditXML");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspEditXML");
			}			
		</cfscript>
	</cffunction>
	
	<cffunction name="doSaveCSS" access="public" returntype="void">
		<cfscript>
			var cssContent = getValue("cssContent","");
			var oContext = getService("sessionContext").getContext();
			var oPageHelper = 0;
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");

				// get page helper
				oPageHelper = createObject("component","homePortals.components.pageHelper").init( oContext.getPage(), oContext.getPageHREF() );
				oPageHelper.savePageCSS(cssContent);

				setMessage("info", "Page stylesheet saved.");
				
				// go to the page editor
				setNextEvent("ehPage.dspEditCSS");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspEditCSS");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspEditCSS");
			}			
		</cfscript>
	</cffunction>

	<cffunction name="doSetTitle" access="public" returntype="void">
		<cfscript>
			var pageTitle = getValue("pageTitle","");
			var oPage = 0;
			var pageHREF = "";
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				if(pageTitle eq "") throw("The page title cannot be blank.","coldBricks.validation");

				// get the original location of the page
				pageHREF = oContext.getPageHREF();
							
				// change page title
				oPage.setTitle(pageTitle);
				
				// if page belongs to a site, then update site too
				if( oContext.hasAccountSite() )
					oContext.getAccountSite().updatePageTitle(getFileFromPath(pageHREF), pageTitle);
				
				// save page
				savePage();
				
				setMessage("info", "Page title changed.");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}			
		</cfscript>	
	</cffunction>

	<cffunction name="doCreateSkinFromPageCSS" access="public" returntype="void">
		<cfscript>
			var hp = 0;
			var id = getValue("id","");
			var name = getValue("name","");
			var body = "";
			var oResourceBean = 0;
			var resourceLibraryPath = "";
			var oResourceLibrary = 0;
			var resourceType = "skin";
			var pageHREF = "";
			var oContext = getService("sessionContext").getContext();
			var oPageHelper = 0;

			try {		
				hp = oContext.getHomePortals();
				pageHREF = oContext.getPageHREF();

				// get the content of the css page
				oPageHelper = createObject("component","homePortals.components.pageHelper").init( oContext.getPage(), oContext.getPageHREF() );
				body = oPageHelper.getPageCSS();

				if(name eq "") throw("The skin name cannot be empty","coldBricks.validation"); 
				if(body eq "") throw("The skin body cannot be empty","coldBricks.validation"); 

				// Use a cleaned version fo the name for the ID
				id = replace(name," ","-","ALL");

				// create the bean for the new resource
				oResourceBean = createObject("component","homePortals.components.resourceBean").init();	
				oResourceBean.setID(id);
				oResourceBean.setName(name);
				oResourceBean.setAccessType("general"); 
				oResourceBean.setPackage(id); 
				oResourceBean.setOwner(oContext.getAccountName());
				oResourceBean.setDescription("Skin created based on stylesheet from page #pageHREF#");
				oResourceBean.setType(resourceType); 
				resourceLibraryPath = hp.getConfig().getResourceLibraryPath();

				/// add the new resource to the library
				oResourceLibrary = createObject("component","homePortals.components.resourceLibrary").init(resourceLibraryPath);
				oResourceLibrary.saveResource(oResourceBean, body);
			
				// update catalog
				hp.getCatalog().reloadPackage(resourceType,id);

				setMessage("info","New skin added to the resource library");
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("ehPage.dspEditCSS");
		</cfscript>	
	</cffunction>


	<!----  Page Layout Actions  ---->
	<cffunction name="doAddLayoutLocation" access="public" returntype="void">
		<cfscript>
			var locationType = getValue("locationType","");
			var oPage = 0;
			var newLocationName = "";
			var testLocationName = "";
			var i = 1;
			var j = 0;
			var aLayoutRegions = arrayNew(1);
			var bCanUseName = true;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				// create a name for the new location
				aLayoutRegions = oPage.getLayoutRegions();
				
				while(newLocationName eq "") {
					testLocationName = locationType & i;
					bCanUseName = true;
					for(j=1; j lte arrayLen(aLayoutRegions); j=j+1) {
						if(aLayoutRegions[j].type eq locationType and aLayoutRegions[j].name eq testLocationName) 
							bCanUseName = false;
					}
					if(bCanUseName) newLocationName = testLocationName;
					i = i + 1;
				}
		
				oPage.addLayoutRegion(newLocationName, locationType);
				savePage();
				
				setMessage("info", "Layout section created.");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");
					
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}			
		</cfscript>
	</cffunction>

	<cffunction name="doSaveLayoutLocation" access="public" returntype="void">
		<cfscript>
			var locationType = getValue("locationType","");
			var locationOriginalName = getValue("locationOriginalName","");
			var locationNewName = getValue("locationNewName","");
			var locationClass = getValue("locationClass","");
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				oPage.removeLayoutRegion(locationOriginalName);
				oPage.addLayoutRegion(locationNewName, locationType, locationClass);
				savePage();
				
				setMessage("info", "Layout section updated.");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}			
		</cfscript>
	</cffunction>
	
	<cffunction name="doDeleteLayoutLocation" access="public" returntype="void">
		<cfscript>
			var locationName = getValue("locationName","");
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
				
				// delete location		
				oPage.removeLayoutRegion(locationName);
				savePage();
				
				setMessage("info", "Layout section removed.");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMain");
			}			
		</cfscript>
	</cffunction>
	
	
	<!----  Event Handler Actions  ---->
	<cffunction name="doAddEventHandler" access="public" returntype="void">
		<cfscript>
			var eventName = getValue("eventName","");
			var eventHandler = getValue("eventHandler","");
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				// check data
				if(eventName eq "") throw("You must select an event from the list","coldBricks.validation");
				if(eventHandler eq "") throw("The event action cannot be empty. Available event actions are given by the existing modules on the page","coldBricks.validation");
		
				oPage.addEventListener(listFirst(eventName,"."), listLast(eventName,"."), eventHandler);
				savePage();
				
				setMessage("info", "Event handler saved.");
				
				// go to the event hander view
				setNextEvent("ehPage.dspEventHandlers");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspEventHandlers");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspEventHandlers");
			}			
		</cfscript>
	</cffunction>

	<cffunction name="doDeleteEventHandler" access="public" returntype="void">
		<cfscript>
			var index = getValue("index",0);
			var oPage = 0;
			var aListeners = arrayNew(1);
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				aListeners = oPage.getEventListeners();
				
				if(index lte arrayLen(aListeners)) {
					oPage.removeEventListener(aListeners[i].objectName,
												aListeners[i].eventName,
												aListeners[i].eventHandler);
					savePage();
				}
				
				setMessage("info", "Event handler deleted.");
				
				// go to the event hander view
				setNextEvent("ehPage.dspEventHandlers");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspEventHandlers");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspEventHandlers");
			}			
		</cfscript>
	</cffunction>
	
	
	<!----  Meta Tag Actions  ---->
	<cffunction name="doAddMetaTag" access="public" returntype="void">
		<cfscript>
			var index = getValue("index",0);
			var name = getValue("name","");
			var content = getValue("content","");
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				if(index gt 0) oPage.removeMetaTag(name);
				
				oPage.addMetaTag(name, content);
				savePage();

				setMessage("info", "User-defined meta tag saved.");
				
				// go to the event hander view
				setNextEvent("ehPage.dspMeta");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMeta");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMeta");
			}			
		</cfscript>
	</cffunction>

	<cffunction name="doDeleteMetaTag" access="public" returntype="void">
		<cfscript>
			var index = getValue("index",0);
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			var aMetaTags = 0;
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				aMetaTags = oPage.getMetaTags();
				
				if(index lte arrayLen(aMetaTags)) {
					oPage.removeMetaTag(aMetaTags[index].name);
					savePage();
				}

				setMessage("info", "User-defined meta tag deleted.");
				
				// go to the event hander view
				setNextEvent("ehPage.dspMeta");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMeta");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspMeta");
			}			
		</cfscript>
	</cffunction>


	<!----  Private Methods  ---->
	<cffunction name="savePage" access="private" returntype="void">
		<cfscript>
			var oContext = getService("sessionContext").getContext();
			var oPage = oContext.getPage();
			var pageHREF = oContext.getPageHREF();
			var oSite = 0;
			var oPageProvider = 0;
			
			if( oContext.hasAccountSite() ) {
				oSite = oContext.getAccountSite();
				oSite.savePage( getFileFromPath(pageHREF), oPage );
			} else {
				oPageProvider = oContext.getHomePortals().getPageProvider();
				oPageProvider.save( pageHREF, oPage );
			}
		</cfscript>
	</cffunction>
	
</cfcomponent>