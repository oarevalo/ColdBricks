<cfcomponent extends="ColdBricks.handlers.ehColdBricks">

	<cffunction name="dspMain" access="public" returntype="void">
		<cfscript>
			var page = getValue("page");
			var account = getValue("account");
			var resType = getValue("resType");
			var pageMode = getValue("pageMode");
			var pageHREF = "";
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			var oPage = 0;
			var cbPageTitle = "";
			var aLayoutSectionTypes = arrayNew(1);
			
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
				if(oContext.getPageViewMode() eq "") oContext.setPageViewMode("details");
				if(resType neq "") oContext.setPageResourceTypeView(resType);
				if(pageMode neq "") oContext.setPageViewMode(pageMode);

				if(oContext.hasAccountSite())
					cbPageTitle = "Accounts > #oContext.getAccountName()# > ";
				else
					cbPageTitle = "Pages > ";

				if(oContext.getPage().getTitle() neq "")
					cbPageTitle = cbPageTitle & oContext.getPage().getTitle();
				else
					cbPageTitle = cbPageTitle & getFileFromPath(oContext.getPageHREF());

				try {
					aLayoutSectionTypes = listToArray(hp.getTemplateManager().getLayoutSections(oContext.getPage().getPageTemplate()));
				} catch(any e) {
					// ignore error if cant find template
				}
				
				setValue("pageTitle", oContext.getPage().getTitle() );
				setValue("accountName", oContext.getAccountName());
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("resType", oContext.getPageResourceTypeView());
				setValue("pageMode", oContext.getPageViewMode());
				setValue("aLayoutSectionTypes", aLayoutSectionTypes);
				setValue("pageHREF", oContext.getPageHREF());
				setValue("stPageTemplates", hp.getTemplateManager().getTemplates("page"));
				
				setValue("oPage", oContext.getPage());
				setValue("oCatalog", hp.getCatalog() );

				setValue("cbPageTitle", cbPageTitle);
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				
				setView("vwMain");

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
				
				oModule = oPage.getModule(moduleID);

				objPath = oContext.getHomePortals().getConfig().getContentRenderer(oModule.getModuleType());
				obj = createObject("component",objPath);
				tagInfo = getMetaData(obj);

				setValue("oModule", oModule);
				setValue("tagInfo", tagInfo);
				setView("vwModuleProperties");
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

				oModule = oPage.getModule(moduleID);

				objPath = oContext.getHomePortals().getConfig().getContentRenderer(oModule.getModuleType());
				obj = createObject("component",objPath);
				tagInfo = getMetaData(obj);
				
				// pass values to view
				setValue("oPage", oPage );
				setValue("oCatalog", oCatalog );
				setValue("oModule", oModule);
				setValue("tagInfo", tagInfo);
				setValue("pageHREF", oContext.getPageHREF());
				setValue("tag", oModule.getModuleType());
				setValue("stModuleTemplates", hp.getTemplateManager().getTemplates("module"));

				if(oContext.hasAccountSite())
					setValue("cbPageTitle", "Accounts > #oContext.getAccountSite().getOwner()# > #oPage.getTitle()# > Edit Module");
				else
					setValue("cbPageTitle", "Pages > #oPage.getTitle()# > Edit Module");
				
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				setView("vwEditModuleProperties");

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
				setView("vwEventHandlers");

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
				setView("vwEditXML");

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
			var contentRoot = oContext.getHomePortals().getConfig().getContentRoot();
			var css = "";
			
			try {
				// check if we have a page loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
				
				// get page helper
				oPageHelper = createObject("component","homePortals.components.pageHelper").init( oPage, contentRoot & oContext.getPageHREF() );

				css = oPageHelper.getPageCSS();
				if(css eq "") css = getDefaultCSSContent();

				// pass values to view
				setValue("oPage", oPage );
				setValue("pageHREF", oContext.getPageHREF() );
				setValue("pageCSSContent", css );

				if(oContext.hasAccountSite())
					setValue("cbPageTitle", "Accounts > #oContext.getAccountSite().getOwner()# > #oPage.getTitle()# > Stylesheet");
				else
					setValue("cbPageTitle", "Pages > #oPage.getTitle()# > Stylesheet");
			
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				setView("vwEditCSS");

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
				
				setView("vwResourceInfo");
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
				
				setView("vwMetaTags");

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
				setView("vwModuleCSS");
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
			var aResTypes = arrayNew(1);
			var i = 0;
			
			try {
				setLayout("Layout.None");

				hp = oContext.getHomePortals();
			
				rlm = hp.getCatalog().getResourceLibraryManager();
				aAllResTypes = rlm.getResourceTypes();
				for(i=1;i lte arrayLen(aAllResTypes);i++) {
					aTags = getTagRenderersForResourceType(aAllResTypes[i]);
					if(arrayLen(aTags) gt 0) {
						arrayAppend(aResTypes, aAllResTypes[i]);
					}
				}

				// get default resource type
				if(oContext.getPageResourceTypeView() eq "" and arrayLen(aResTypes) gt 0) 
					oContext.setPageResourceTypeView(aResTypes[1]);
				if(resType neq "") oContext.setPageResourceTypeView(resType);
				
				setValue("resType", oContext.getPageResourceTypeView());
				setValue("aResTypes", aResTypes);
				setValue("oPage", oContext.getPage());
				setValue("oCatalog", hp.getCatalog() );
				
				setView("vwResourceTree");

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
				
				setView("vwContentRenderersTree");

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
				
				setView("vwContentTagInfo");
				setLayout("Layout.None");
				
			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		</cfscript>
	</cffunction>

	<cffunction name="dspPageProperties" access="public" returntype="void">
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
					setValue("cbPageTitle", "Accounts > #oContext.getAccountSite().getOwner()# > #oPage.getTitle()# > Custom Page Properties");
				else
					setValue("cbPageTitle", "Pages > #oPage.getTitle()# > Custom Page Properties");
	
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				
				setView("vwPageProperties");

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
	
	<cffunction name="dspPageResources" access="public" returntype="void">
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
					setValue("cbPageTitle", "Accounts > #oContext.getAccountSite().getOwner()# > #oPage.getTitle()# > Styles & Scripts");
				else
					setValue("cbPageTitle", "Pages > #oPage.getTitle()# > Styles & Scripts");
	
				setValue("cbPageIcon", "images/users_48x48.png");
				setValue("cbShowSiteMenu", true);
				
				setView("vwPageResources");

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

	<cffunction name="dspAddContentTag" access="public" returntype="void">
		<cfscript>
			var oPage = 0;
			var oCatalog = 0;
			var oResourceBean = 0;
			var tag = getValue("tag");
			var moduleCatID = "";
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				setLayout("Layout.Clean");

				// check if we have a site and page cfcs loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				if(tag eq "") throw("Please select a module type to add","coldBricks.validation");
				
				// get page from session
				oPage = oContext.getPage();
				oCatalog = hp.getCatalog();

				objPath = oContext.getHomePortals().getConfig().getContentRenderer(tag);
				obj = createObject("component",objPath);
				tagInfo = getMetaData(obj);
				
				// pass values to view
				setValue("oPage", oPage );
				setValue("oCatalog", oCatalog );
				setValue("tagInfo", tagInfo);
				setValue("pageHREF", oContext.getPageHREF());
				setValue("tag", tag);

				setView("vwAddContentTag");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
			
		</cfscript>
	</cffunction>	

	<cffunction name="dspAddResource" access="public" returntype="void">
		<cfscript>
			var oPage = 0;
			var oCatalog = 0;
			var oResourceBean = 0;
			var tag = getValue("tag");
			var resourceID = getValue("resourceID");
			var resType = getValue("resType");
			var moduleCatID = "";
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			var aTagNames = arrayNew(1);
			var stTags = structNew();
			var tagInfo = structNew();
			
			try {
				hp = oContext.getHomePortals();
				setLayout("Layout.Clean");

				// check if we have a site and page cfcs loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				if(resType eq "") throw("Please select a resource type to add","coldBricks.validation");
				if(resourceID eq "") throw("Please select a resource to add","coldBricks.validation");
				
				// get page from session
				oPage = oContext.getPage();
				oCatalog = hp.getCatalog();

				aTagNames = getTagRenderersForResourceType(resType);
				if(arrayLen(aTagNames) eq 1) tag = aTagNames[1];
				
				if(tag neq "") {
					objPath = oContext.getHomePortals().getConfig().getContentRenderer(tag);
					obj = createObject("component",objPath);
					tagInfo = getMetaData(obj);
				} else {
					for(i=1;i lte arrayLen(aTagNames);i++) {
						objPath = oContext.getHomePortals().getConfig().getContentRenderer(aTagNames[i]);
						obj = createObject("component",objPath);
						stTags[aTagNames[i]] = getMetaData(obj);
					}
				}
				
				// pass values to view
				setValue("oPage", oPage );
				setValue("oCatalog", oCatalog );
				setValue("tagInfo", tagInfo);
				setValue("pageHREF", oContext.getPageHREF());
				setValue("tag", tag);
				setValue("stTags", stTags);

				if(tag eq "")
					setView("vwAddResourceSelectTag");
				else
					setView("vwAddResource");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
			
		</cfscript>
	</cffunction>	

	<cffunction name="dspEditResource" access="public" returntype="void">
		<cfscript>
			var oPage = 0;
			var oCatalog = 0;
			var oResourceBean = 0;
			var type = getValue("type","info");
			var resourceID = getValue("resourceID");
			var resType = getValue("resType");
			var package = getValue("package");
			var hp = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				hp = oContext.getHomePortals();
				setLayout("Layout.Clean");

				// check if we have a site and page cfcs loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				if(resType eq "") throw("Please select a resource type to edit","coldBricks.validation");
				if(resourceID eq "") throw("Please select a resource to edit","coldBricks.validation");
				
				// get page from session
				oPage = oContext.getPage();
				oCatalog = hp.getCatalog();

				oResourceBean = oCatalog.getResourceNode(resType, resourceID, true);
				
				// read file
				if(oResourceBean.targetFileExists()) {
					fileContent = oResourceBean.readFile();
					setValue("fullhref", oResourceBean.getFullHREF());	
				}

				// pass values to view
				setValue("oPage", oPage );
				setValue("oCatalog", oCatalog );
				setValue("fileContent", fileContent);	
				setValue("pageHREF", oContext.getPageHREF());

				setView("vwEditResource");

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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
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
				
				oModuleBean = createObject("component","homePortals.components.moduleBean").init(stAttribs);
				oModuleBean.setID(moduleID);
				
				oPage.setModule(oModuleBean, getValue("location"));
				savePage();
				
				setMessage("info", "Module attributes saved");
				
				// go to the page editor
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspEditModuleProperties","moduleID=#moduleID#");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspEditModuleProperties","moduleID=#moduleID#");
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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
			}				
		</cfscript>
	</cffunction>
		
	<cffunction name="doAddContentTag" access="public" returntype="void">
		<cfscript>
			var tag = getValue("tag");
			var locationName = getValue("location","");
			var oPage = 0;
			var oCatalog = 0;
			var hp = 0;
			var lstAllAttribs = "";
			var	stAttribs = structNew();
			var oContext = getService("sessionContext").getContext();

			try {
				hp = oContext.getHomePortals();
				oCatalog = hp.getCatalog();
				
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();

				lstAttribs = getValue("_moduleAttribs");
				for(i=1;i lte listLen(lstAttribs);i=i+1) {
					fld = listGetAt(lstAttribs,i);
					if(getValue(fld) neq getValue(fld & "_default") 
						and getValue(fld) neq "_NOVALUE_") stAttribs[fld] = getValue(fld);
				}

				oPageHelper = createObject("component","homePortals.components.pageHelper").init( oPage );

				if(tag eq "module" and structKeyExists(stAttribs,"moduleID") and stAttribs.moduleID neq "") {
					resBean = oCatalog.getResourceNode(tag, stAttribs.moduleID);
					oPageHelper.addModule(resBean, locationName, stAttribs);
				} else {
					oPageHelper.addContentTag(tag, locationName, stAttribs);
				}

				savePage();
				
				setMessage("info", "Module added to page");
				setNextEvent("page.ehPage.dspAddContentTag","done=true&tag=#tag#");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspAddContentTag","tag=#tag#");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspAddContentTag","tag=#tag#");
			}				
		</cfscript>
	</cffunction>	

	<cffunction name="dspContentTagInfo" access="public" returntype="void">
	</cffunction>	

	<cffunction name="doSetModuleLocation" access="public" returntype="void">
		<cfscript>
			var moduleID = getValue("moduleID");
			var location = getValue("location");
			var oPage = 0;
			var oPageHelper = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				oModule = oPage.getModule(moduleID);
				oModule.setLocation(location);
				oPage.setModule(oModule);
		
				savePage();
				
				setMessage("info", "Modules location updated");
				
				// go to the page editor
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
			}			
		</cfscript>
	</cffunction>	

	<cffunction name="doMoveModule" access="public" returntype="void">
		<cfscript>
			var moduleID = getValue("moduleID");
			var direction = getValue("direction");
			var oPage = 0;
			var oPageHelper = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				aModules = oPage.getModules();
				
				index = 0;
				for(i=1;i lte arrayLen(aModules);i=i+1) {
					if(aModules[i].getID() eq moduleID) {
						index = i;
						break;
					}
				}
				
				if(index gt 0) {
					if(direction eq "up")
						arraySwap(aModules,index,index-1);
					else if(direction eq "down")
						arraySwap(aModules,index,index+1);
				}

				// clear all modules from page
				oPage.removeAllModules();
	
				// attach all modules again in the new order
				for(i=1;i lte arrayLen(aModules);i=i+1) {
					oPage.addModule(aModules[i]);
				}
		
				savePage();
				
				setMessage("info", "Modules position updated");
				
				// go to the page editor
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
			}			
		</cfscript>
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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
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
				setNextEvent("page.ehPage.dspMain","page=#getFileFromPath( pageHREF )#");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspEditXML");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspEditXML");
			}			
		</cfscript>
	</cffunction>
	
	<cffunction name="doSaveCSS" access="public" returntype="void">
		<cfscript>
			var cssContent = getValue("cssContent","");
			var oContext = getService("sessionContext").getContext();
			var oPageHelper = 0;
			var contentRoot = oContext.getHomePortals().getConfig().getContentRoot();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");

				// get page helper
				oPageHelper = createObject("component","homePortals.components.pageHelper").init( oContext.getPage(), contentRoot & oContext.getPageHREF() );
				oPageHelper.savePageCSS(cssContent);
				savePage();

				setMessage("info", "Page stylesheet saved.");
				
				// go to the page editor
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspEditCSS");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspEditCSS");
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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");

			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}
		
			setNextEvent("page.ehPage.dspEditCSS");
		</cfscript>	
	</cffunction>

	<cffunction name="doSetPageTemplate" access="public" returntype="void">
		<cfscript>
			var templateName = getValue("templateName","");
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				if(templateName eq 0) 
					setNextEvent("page.ehPage.dspMain");
		
				oPage.setPageTemplate(templateName);
				savePage();
				
				setMessage("info", "Page Template Applied");
				
				// go to the page editor
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
			}			
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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
					
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
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
				setNextEvent("page.ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMain");
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
				setNextEvent("page.ehPage.dspEventHandlers");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspEventHandlers");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspEventHandlers");
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
					oPage.removeEventListener(aListeners[index].objectName,
												aListeners[index].eventName,
												aListeners[index].eventHandler);
					savePage();
				}
				
				setMessage("info", "Event handler deleted.");
				
				// go to the event hander view
				setNextEvent("page.ehPage.dspEventHandlers");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspEventHandlers");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspEventHandlers");
			}			
		</cfscript>
	</cffunction>
	
	
	<!----  Meta Tag Actions  ---->
	<cffunction name="doAddMetaTag" access="public" returntype="void">
		<cfscript>
			var index = getValue("index",0);
			var name = getValue("name","");
			var nameOther = getValue("nameOther","");
			var content = getValue("content","");
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();

				if(name eq "__other__") name = nameOther;
				if(name eq "") throw("Please enter a meta tag name","coldBricks.validation");
		
				if(index gt 0) oPage.removeMetaTag(name);
				
				oPage.addMetaTag(name, content);
				savePage();

				setMessage("info", "User-defined meta tag saved.");
				
				// go to the event hander view
				setNextEvent("page.ehPage.dspMeta");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMeta");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMeta");
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
				setNextEvent("page.ehPage.dspMeta");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspMeta");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspMeta");
			}			
		</cfscript>
	</cffunction>


	<!----  Page Properties Actions  ---->
	<cffunction name="doSetPageProperty" access="public" returntype="void">
		<cfscript>
			var name = trim(getValue("propName"));
			var newname = trim(getValue("newName"));
			var value = trim(getValue("propValue"));
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();

				if(newName eq "") throw("Please enter a property name.","coldBricks.validation");
				oPage.setProperty(newName, value);
				if(name neq newname and name neq "")
					oPage.removeProperty(name);
				savePage();

				setMessage("info", "Custom page property saved.");
				
				// go to the event hander view
				setNextEvent("page.ehPage.dspPageProperties");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspPageProperties");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspPageProperties");
			}			
		</cfscript>
	</cffunction>

	<cffunction name="doRemovePageProperty" access="public" returntype="void">
		<cfscript>
			var name = trim(getValue("propName"));
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				if(name eq "") throw("Please enter a property name.","coldBricks.validation");
				oPage.removeProperty(name);
				savePage();
	
				setMessage("info", "Custom page property deleted.");
				
				// go to the event hander view
				setNextEvent("page.ehPage.dspPageProperties");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspPageProperties");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspPageProperties");
			}			
		</cfscript>
	</cffunction>


	<!----  Page Resources Actions  ---->
	<cffunction name="doSavePageResource" access="public" returntype="void">
		<cfscript>
			var index = getValue("index",0);
			var type = getValue("type");
			var href = getValue("href");
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				if(index gt 0) oPage.removeMetaTag(name);
				
				if(type eq "Stylesheet")
					oPage.addStylesheet(href);
				else if(type eq "JavaScript")
					oPage.addScript(href);

				savePage();

				setMessage("info", "Page resource saved.");
				
				// go to the event hander view
				setNextEvent("page.ehPage.dspPageResources");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspPageResources");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspPageResources");
			}			
		</cfscript>
	</cffunction>

	<cffunction name="doDeletePageResource" access="public" returntype="void">
		<cfscript>
			var index = getValue("index",0);
			var type = getValue("type");
			var oPage = 0;
			var oContext = getService("sessionContext").getContext();
			var aRes = 0;
			
			try {
				// check if we have a page cfc loaded 
				if(Not oContext.hasPage()) throw("Please select a page.","coldBricks.validation");
				oPage = oContext.getPage();
		
				if(type eq "Stylesheet")
					aRes = oPage.getStylesheets();
				else if(type eq "JavaScript")
					aRes = oPage.getScripts();
		
				if(index lte arrayLen(aRes)) {
					if(type eq "Stylesheet")
						aRes = oPage.removeStylesheet(aRes[index]);
					else if(type eq "JavaScript")
						aRes = oPage.removeScript(aRes[index]);
					savePage();
				}

				setMessage("info", "Page resource deleted.");
				
				// go to the event hander view
				setNextEvent("page.ehPage.dspPageResources");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("page.ehPage.dspPageResources");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("page.ehPage.dspPageResources");
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
	
	<cffunction name="getDefaultCSSContent" access="private" returntype="string">
		<cfset var oPage = getService("sessionContext").getContext().getPage()>
		<cfset var pageHREF = getService("sessionContext").getContext().getPageHREF()>
		<cfset var css = "">
		<cfset var tmp = 0>
		<cfset var crlf = chr(13) & chr(10)>
		<cfset var lstSeenClasses = "Section,SectionTitle,SectionBody">
		
		<cfset css = "/* CSS Stylesheet for page: '#pageHREF#' */" & crlf>
		<cfset css = css & "/* NOTE: Rules on this stylesheet only apply to the current page */" & crlf & crlf>	
		<cfset css = css & "/* *** This default stylesheet template has been autogenerated based on current page contents *** */" & crlf & crlf>	

		<cfset css = css & "/* Main body selector */" & crlf>	
		<cfset css = css & "body { }" & crlf & crlf>
		
		<cfset css = css & "/* Default module container selectors */" & crlf>	
		<cfset css = css & ".Section { }" & crlf>
		<cfset css = css & ".SectionTitle { }" & crlf>
		<cfset css = css & ".SectionBody { }" & crlf & crlf>

		<cfset css = css & "/* Page layout regions */" & crlf>
		<cfset tmp = oPage.getLayoutRegions()>
		<cfloop from="1" to="#arrayLen(tmp)#" index="i">
			<cfif tmp[i].id neq "">
				<cfset css = css & "###tmp[i].id# { }" & crlf>
			</cfif>
		</cfloop>
		<cfloop from="1" to="#arrayLen(tmp)#" index="i">
			<cfif tmp[i].class neq "">
				<cfif not listFindNoCase(lstSeenClasses,tmp[i].class)>
					<cfset css = css & ".#tmp[i].class# { }" & crlf>
					<cfset lstSeenClasses = listAppend(lstSeenClasses, tmp[i].class)>
				</cfif>
			</cfif>
		</cfloop>
		<cfset css = css & crlf> 

		<cfset css = css & "/* Page modules selectors */" & crlf>
		<cfset tmp = oPage.getModules()>
		<cfloop from="1" to="#arrayLen(tmp)#" index="i">
			<cfset css = css & "###tmp[i].getID()# { }" & crlf>
			<!---
			<cfset css = css & "###tmp[i].id#_Head { }" & crlf>
			<cfset css = css & "###tmp[i].id#_Body { }" & crlf>
			<cfset css = css & crlf> 
			--->
		</cfloop>
		<cfset css = css & crlf> 

		<cfreturn css>
	</cffunction>

	<cffunction name="getTagRenderersForResourceType" access="private" returntype="array">
		<cfargument name="resourceType" type="string" required="true">
		<cfscript>
			var aTags = arrayNew(1);
			var stCR = 0;
			var tag = "";
			var objPath = "";
			var obj = 0;
			var tagInfo = 0;
			var i = 0;
			var prop = "";
			var oContext = getService("sessionContext").getContext();
			
			stCR = oContext.getHomePortals().getConfig().getContentRenderers();
			for(tag in stCR) {
				try {
					objPath = oContext.getHomePortals().getConfig().getContentRenderer(tag);
					obj = createObject("component",objPath);
					tagInfo = getMetaData(obj);
					if(structKeyExists(tagInfo,"properties")) {
						for(i=1;i lte arrayLen(tagInfo.properties);i++) {
							prop = duplicate(tagInfo.properties[i]);
							if(structKeyExists(prop,"type") and listLen(prop.type,":") eq 2 and listfirst(prop.type,":") eq "resource") {
								if(arguments.resourceType eq listlast(prop.type,":")) arrayAppend(aTags, tag);
							}
						}
					}
				} catch(any e ) {
					// do nothing
				}
			}
			
			return aTags;
		</cfscript>
	</cffunction>
		
</cfcomponent>
