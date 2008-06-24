<cfcomponent extends="eventHandler">

	<cffunction name="dspMain">
		<cfscript>
			var page = getValue("page");
			var resType = getValue("resType");
			var pageHREF = "";
			var hp = 0;
			
			try {
				hp = session.context.hp;
			
				if(page neq "") {
					pageHREF = hp.getConfig().getAccountsRoot() & "/" & session.context.accountName & "/layouts/" & page;
					session.context.page = createObject("component","Home.Components.page").init( pageHREF );
				}			

				// get default resource type
				if(not structKeyExists(session.context,"pageResourceTypeView")) session.context.pageResourceTypeView = "module";
				if(resType neq "") session.context.pageResourceTypeView = resType;

				setValue("pageTitle", session.context.page.getPage().getTitle() );
				setValue("accountName", session.context.accountName);
				setValue("accountsRoot", hp.getConfig().getAccountsRoot() );
				setValue("appRoot", hp.getConfig().getAppRoot() );
				setValue("resType", session.context.pageResourceTypeView);
				
				setValue("oSite", session.context.accountSite);
				setValue("oPage", session.context.page);
				setValue("oCatalog", hp.getCatalog() );
				
				setView("site/accounts/vwPage");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehAccounts.dspMain");
			}			
		</cfscript>
	</cffunction>
	
	<cffunction name="dspModuleProperties" access="public" returntype="void">
		<cfscript>
			var oPage = 0;
			var moduleID = getValue("moduleID","");

			try {
				// remove prefixes added to avoid mixing with existing page elements
				moduleID = replace(moduleID,"ppm_","","ALL");

				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
				
				stModule = oPage.getModule(moduleID);
				
				setValue("stModule", stModule);
				setView("site/accounts/vwModuleProperties");
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
			var oSite = 0;
			var oCatalog = 0;
			var oResourceBean = 0;
			var moduleID = getValue("moduleID","");
			var moduleCatID = "";
			var hp = 0;
			var missingModuleBean = true;
			
			try {
				hp = session.context.hp;

				// remove prefixes added to avoid mixing with existing page elements
				moduleID = replace(moduleID,"ppm_","","ALL");
				
				// check if we have a site and page cfcs loaded 
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account.","coldBricks.validation");
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				
				// get site and page from session
				oSite = session.context.accountSite;
				oPage = session.context.page;

				oCatalog = hp.getCatalog();

				stModule = oPage.getModule(moduleID);
				
				try {
					if(stModule.moduleType eq "module")	{
						oResourceBean = oCatalog.getModuleByName(stModule.name);
						missingModuleBean = false;
						setValue("oResourceBean", oResourceBean);
					}

					if(stModule.moduleType eq "content" 
							and structKeyExists(stModule,"resourceID") 
							and structKeyExists(stModule,"resourceType") 
							and stModule.resourceID neq "" 
							and stModule.resourceType neq "") {
						oResourceBean = oCatalog.getResourceNode(stModule.resourceType, stModule.resourceID);
						missingModuleBean = false;
						setValue("oResourceBean", oResourceBean);
					}
				
				} catch(homePortals.catalog.resourceNotFound e) { 	}
	
				// pass values to view
				setValue("oSite", oSite );
				setValue("oPage", oPage );
				setValue("oCatalog", oCatalog );
				setValue("stModule", stModule);
				setValue("accountsRoot", hp.getConfig().getAccountsRoot() );
				setValue("missingModuleBean", missingModuleBean);
				
				setView("site/accounts/vwEditModuleProperties");

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
			var oSite = 0;
			var oCatalog = 0;
			
			try {
				hp = session.context.hp;
				
				// check if we have a site and page cfcs loaded 
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account.","coldBricks.validation");
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				
				// get site and page from session
				oSite = session.context.accountSite;
				oPage = session.context.page;
				oCatalog = hp.getCatalog();
				
				// pass values to view
				setValue("oSite", oSite );
				setValue("oPage", oPage );
				setValue("oCatalog", oCatalog );
				
				setView("site/accounts/vwEventHandlers");

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
			var oSite = 0;
			
			try {
				// check if we have a site and page cfcs loaded 
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account.","coldBricks.validation");
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				
				// get site and page from session
				oSite = session.context.accountSite;
				oPage = session.context.page;

				// pass values to view
				setValue("oSite", oSite );
				setValue("oPage", oPage );
				
				setView("site/accounts/vwEditXML");

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
			var oSite = 0;
			
			try {
				// check if we have a site and page cfcs loaded 
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account.","coldBricks.validation");
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				
				// get site and page from session
				oSite = session.context.accountSite;
				oPage = session.context.page;

				// pass values to view
				setValue("oSite", oSite );
				setValue("oPage", oPage );
				
				setView("site/accounts/vwEditCSS");

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
			
			try {
				hp = session.context.hp;
				oCatalog = hp.getCatalog();
				oResourceBean = oCatalog.getResourceNode(resType, resourceID);

				// pass values to view
				setValue("oResourceBean", oResourceBean);
				
				setView("site/accounts/vwResourceInfo");
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
			var oSite = 0;
			
			try {
				hp = session.context.hp;
				
				// check if we have a site and page cfcs loaded 
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account.","coldBricks.validation");
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				
				// get site and page from session
				oSite = session.context.accountSite;
				oPage = session.context.page;
				
				// pass values to view
				setValue("oSite", oSite );
				setValue("oPage", oPage );
				
				setView("site/accounts/vwMetaTags");

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

			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
				
				stModule = oPage.getModule(moduleID);
				
				setValue("stModule", stModule);
				setView("site/accounts/vwModuleCSS");
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
			var pageHREF = "";
			var hp = 0;
			
			try {
				setLayout("Layout.None");

				hp = session.context.hp;
			
				// get default resource type
				if(not structKeyExists(session.context,"pageResourceTypeView")) session.context.pageResourceTypeView = "module";
				if(resType neq "") session.context.pageResourceTypeView = resType;

				setValue("resType", session.context.pageResourceTypeView);
				
				setValue("oSite", session.context.accountSite);
				setValue("oPage", session.context.page);
				setValue("oCatalog", hp.getCatalog() );
				
				setView("site/accounts/vwResourceTree");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}			
		</cfscript>	
	</cffunction>

	<!-----  Module Actions  ---->			
	<cffunction name="doAddResource">
		<cfscript>
			var resourceID = getValue("resourceID","");
			var resType = getValue("resType","");
			var locationName = getValue("locationName","");
			var oPage = 0;
			var hp = 0;
			var moduleID = "";
			var	stAttributes = structNew();
			var moduleResType = "module";
			
			try {
				hp = session.context.hp;
				
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account.","coldBricks.validation");
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");

				oPage = session.context.page;
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
				oPage.addModule(resBean, locationName, stAttributes);
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
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				oPage.deleteModule(moduleID);
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
			var layout = getValue("layout","");
			var oPage = 0;
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				// remove prefixes added to avoid mixing with existing page elements
				layout = replaceList(layout,"ppm_,pps_",",");
		
				oPage.setModuleOrder(layout);
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
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				// create a structure with the module attributes
				lstAllAttribs = form["_allAttribs"];
				for(i=1;i lte listLen(lstAllAttribs);i=i+1) {
					fld = listGetAt(lstAllAttribs,i);
					if(structKeyExists(form,fld)) stAttribs[fld] = form[fld];
				}
		
				if(not StructKeyExists(form,"container")) stAttribs.container = false;

				if(getValue("moduleType") eq "content") {
					if(not StructKeyExists(form,"cache")) stAttribs["cache"] = false;
					if(getValue("resourceType") eq "content") stAttribs["resourceID"] = getValue("resourceID_content");
					if(getValue("resourceType") eq "html") stAttribs["resourceID"] = getValue("resourceID_html");
					if(getValue("resourceType") neq "") stAttribs["href"] = "";
					if(getValue("resourceType") eq "") structDelete(stAttribs,"resourceType");
					structDelete(stAttribs,"resourceID_content");
					structDelete(stAttribs,"resourceID_html");
					structDelete(stAttribs,"name");
					stAttribs.cacheTTL = val(stAttribs.cacheTTL);
				}
		
				oPage.saveModule(moduleID, stAttribs);
				
				setMessage("info", "Module attributes saved");
				
				// go to the page editor
				setNextEvent("ehPage.dspMain");

			} catch(coldBricks.validation e) {
				setMessage("warning",e.message);
				setNextEvent("ehPage.dspMain");
				
			} catch(any e) {
				setMessage("error", e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehPage.dspEditModuleProperties");
			}			
		</cfscript>
	</cffunction>		
	
	<cffunction name="doAddContentModule" access="public" returntype="void">
		<cfscript>
			var resType = getValue("resType","content");
			var locationName = getValue("locationName","");
			var oPage = 0;
			var hp = 0;
			var	stAttributes = structNew();

			try {
				hp = session.context.hp;
				
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account.","coldBricks.validation");
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");

				oPage = session.context.page;
				
				resBean = createObject("component","Home.Components.resourceBean").init();
				resBean.setID("contentModule");
				resBean.setName("contentModule");

				stAttributes["moduleType"] = "content";
				
				oPage.addModule(resBean, locationName, stAttributes);
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
		
		
		
	<!-----  Page Level Actions  ---->		
	<cffunction name="doRenamePage" access="public" returntype="void">
		<cfscript>
			var pageName = getValue("pageName","");
			var oPage = 0;
			var oSite = 0;
			var originalPageHREF = "";
			var newPageHREF = "";
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account.","coldBricks.validation");
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
				oSite = session.context.accountSite;
		
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
				originalPageHREF = oPage.getHREF();
		
				// rename the actual page 
				oPage.renamePage(pageName);
				newPageHREF = oPage.getHREF();
				
				// update the site definition
				oSite.setPageHREF(originalPageHREF, newPageHREF);
				
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
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				if(skinID eq "NONE") skinID = "";
		
				oPage.setSkinID(skinID);
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
			var resRoot = "";
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				// get resource root
				hp = session.context.hp;
				resRoot = hp.getConfig().getResourceLibraryPath();
		
				// get pagetemplate resource
				oCatalog = hp.getCatalog();
				oResourceBean = oCatalog.getResourceNode("pageTemplate", resourceID);
		
				// apply template
				oPage.applyPageTemplate(oResourceBean, resRoot);
				
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
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				if(not isXml(xmlContent)) {
					setMessage("warning", "The given content is not a valid XML document");
					dspEditXML();
					return;
				}

				writeFile( expandPath( oPage.getHREF() ), xmlContent);
				
				// go to the xml editor
				setMessage("info", "Page XML Changed");
				setNextEvent("ehPage.dspMain","page=#getFileFromPath( oPage.getHREF() )#");

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
			var oPage = 0;
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				oPage.savePageCSS(cssContent);
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
			var oSite = 0;
			var pageHREF = "";
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"accountSite")) throw("Please select an account.","coldBricks.validation");
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
				oSite = session.context.accountSite;
		
				if(pageTitle eq "") throw("The page title cannot be blank.","coldBricks.validation");

				// get the original location of the page
				pageHREF = oPage.getHREF();
							
				// change page title
				oPage.setPageTitle(pageTitle);
				oSite.setPageTitle(pageHREF, pageTitle);
				
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
			var oPage = 0;

			try {		
				hp = session.context.hp;

				// get the content of the css page
				oPage = session.context.page;
				body = oPage.getPageCSS();

				if(name eq "") throw("The skin name cannot be empty","coldBricks.validation"); 
				if(body eq "") throw("The skin body cannot be empty","coldBricks.validation"); 

				// Use a cleaned version fo the name for the ID
				id = replace(name," ","-","ALL");

				// create the bean for the new resource
				oResourceBean = createObject("component","Home.Components.resourceBean").init();	
				oResourceBean.setID(id);
				oResourceBean.setName(name);
				oResourceBean.setAccessType("general"); 
				oResourceBean.setPackage(id); 
				oResourceBean.setOwner(session.context.accountName);
				oResourceBean.setDescription("Skin created based on stylesheet from page #oPage.getHREF()#");
				oResourceBean.setType(resourceType); 
				resourceLibraryPath = hp.getConfig().getResourceLibraryPath();

				/// add the new resource to the library
				oResourceLibrary = createObject("component","Home.Components.resourceLibrary").init(resourceLibraryPath);
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
			var qryLocationsByType = 0;
			var bCanUseName = true;
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				// create a name for the new location
				qryLocationsByType = oPage.getLocationsByType(locationType);
				while(newLocationName eq "") {
					testLocationName = locationType & i;
					bCanUseName = true;
					for(j=1; j lte qryLocationsByType.recordCount; j=j+1) {
						if(qryLocationsByType.name[j] eq testLocationName) bCanUseName = false;
					}
					if(bCanUseName) newLocationName = testLocationName;
					i = i + 1;
				}
		
				oPage.addLocation(newLocationName, locationType);
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
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				oPage.saveLocation(locationOriginalName, locationNewName, locationType, locationClass);
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
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
				
				// delete location		
				oPage.deleteLocation(locationName);
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
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				// check data
				if(eventName eq "") throw("You must select an event from the list","coldBricks.validation");
				if(eventHandler eq "") throw("The event action cannot be empty. Available event actions are given by the existing modules on the page","coldBricks.validation");
		
				oPage.saveEventHandler(0, listFirst(eventName,"."), listLast(eventName,"."), eventHandler);
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
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				oPage.deleteEventHandler(index);
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
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				oPage.saveMetaTag(index, name, content);
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
			
			try {
				// check if we have a page cfc loaded 
				if(Not structKeyExists(session.context,"page")) throw("Please select a page.","coldBricks.validation");
				oPage = session.context.page;
		
				oPage.deleteMetaTag(index);
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
	
	<cffunction name="writeFile" access="private" returntype="void">
		<cfargument name="path" type="string" required="true">
		<cfargument name="content" type="string" required="true">
		<cffile action="write" file="#arguments.path#" output="#arguments.content#">
	</cffunction>
</cfcomponent>