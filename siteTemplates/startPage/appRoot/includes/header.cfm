<cfparam name="url._statusMessage" default="">

<cfsilent>
	<cfscript>
		oHP = application.homePortals;
		oAccountsService = oHP.getPluginManager().getPlugin("accounts").getAccountsService();
		
		currentPage = request.oPageRenderer.getPageHREF();

		// create page object
		request.oPage = request.oPageRenderer.getPage();

		// get page owner
		siteOwner = request.oPage.getOwner();
		pageAccess = request.oPage.getAccess();
		
		// create site object
		request.oSite = oAccountsService.getSite(siteOwner);

		// Get information on any currently logged-in user
		oUserRegistry = createObject("Component","homePortals.components.userRegistry").init();
		request.userInfo = oUserRegistry.getUserInfo();	// information about the logged-in user
		bUserLoggedIn = (request.userInfo.userName neq "");
		bIsOwner = (request.userInfo.userName eq siteOwner); 
		
		pageTitle = request.oPage.getTitle();
		aLayoutRegions = request.oPage.getLayoutRegions();
		siteTitle = request.oSite.getSiteTitle();	
		aPages = request.oSite.getPages();
	</cfscript>	
	
	<!--- make a js struct with page locations --->
	<cfset lstLocations = "">
	<cfloop from="1" to="#arrayLen(aLayoutRegions)#" index="i">
		<cfset tmp = "#aLayoutRegions[i].id#: { id:'#aLayoutRegions[i].id#', name:'#aLayoutRegions[i].name#', type:'#aLayoutRegions[i].type#', theClass:'#aLayoutRegions[i].class#' }">
		<cfset lstLocations = listAppend(lstLocations, tmp)>
	</cfloop>
</cfsilent>


<!--- display site map --->	
<cfoutput>
	<!--- include css and javascript --->
	<cfsavecontent variable="tmpHTML">
		<script type="text/javascript">
			// initialize control panel client
			stLocations = {#lstLocations#};
			_pageHREF = "#currentPage#";
			_pageFileName = "#getFileFromPath(currentPage)#";
			
			var controlPanel = new controlPanelClient();
			controlPanel.init(stLocations);
			
			<cfif bIsOwner>
			// setup UI
			addEvent(window, 'load', startDragDrop);
			addEvent(window, 'load', attachModuleIcons);
			addEvent(window, 'load', attachLayoutHolders);
			</cfif>
		</script>
	</cfsavecontent>
	<cfhtmlhead text="#tmpHTML#">

	<div id="navMenu" style="padding-top:5px;">
		<div id="anchorAddContent" style="float:right;padding-right:10px;padding-top:3px;">
			<cfif bIsOwner>
				<a href="##" onclick="navCmdAddPage()"><img src="images/btnAddPage.gif" align="absmiddle" style="margin-left:5px;" border="0" alt="Add Page" title="Add Page"></a>
				<a href="##" onclick="navCmdAddContent()"><img src="images/btnAddContent.gif" align="absmiddle" style="margin-left:5px;" alt="Add Content" title="Add Content" border="0"></a>
				<a href="includes/logOff.cfm"><img src="images/btnLogOff.gif" align="absmiddle" style="margin-left:5px;" alt="Log Off" border="0" title="Log Off"></a>
			<cfelse>
				<form name="frmLogin" action="includes/processLogin.cfm" method="post">
					User: <input type="text" name="username" value="" style="font-size:10px;width:100px;">
					Password: <input type="password" name="password" value="" style="font-size:10px;width:100px;">
					<input type="submit" value="Login" name="btnLogin" style="font-size:10px;">
				</form>
			</cfif>
		</div>
		<span id="siteMapTitle" <cfif bIsOwner>onclick="controlPanel.rename('siteMapTitle','#siteTitle#','Site')"</cfif> title="Click to rename site">#siteTitle#</span>
	</div>
	<div id="navMenuTitles">
		<cfif pageAccess eq "owner">
			<img src="images/lock.png" 
					alt="This is a private page" 
					title="This is a private page" 
					border="0" align="absbottom"
					style="padding-left:5px;padding-bottom:2px;">		
		</cfif>

		<div id="siteMapStatusBar"></div>
		
		<cfloop from="1" to="#arrayLen(aPages)#" index="i">
			<cfset thisPageHREF = request.appRoot & "/index.cfm?account=" & siteOwner & "&page=" & replace(aPages[i].href,".xml","")>
			<cfset thisPageHREF = replace(thisPageHREF, "//", "/", "ALL")> <!--- get rid of duplicate forward slash (will cause problems for sites at webroot)--->
			&nbsp;&nbsp;
			<cfif aPages[i].href eq getFileFromPath(currentPage)>
				<span id="pageTitle" 
						<cfif bIsOwner>onclick="controlPanel.rename('pageTitle','#pageTitle#','Page')"</cfif> 
						title="Click to rename or delete page">#pageTitle#</span>
			<cfelse>
				<a href="#thisPageHREF#" class="pageTitle">#aPages[i].title#</a>
			</cfif>
		</cfloop>
	</div>

	
	<cfif url._statusMessage neq "">
		<script>
			controlPanel.setStatusMessage("#jsstringformat(url._statusMessage)#");
			alert("#jsstringformat(url._statusMessage)#");
		</script>
	</cfif>
	
</cfoutput>

