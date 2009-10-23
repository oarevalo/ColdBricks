<cfparam name="request.requestState.event" default="">
<cfparam name="request.requestState.oContext" default="">
<cfparam name="request.requestState.oUser" default="">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.icon" default="">

<cfset event = request.requestState.event>
<cfset oContext = request.requestState.oContext>
<cfset oUser = request.requestState.oUser>

<cfset oSiteInfo = oContext.getSiteInfo()>
<cfset accountID = oContext.getAccountID()>
<cfset accountName = oContext.getAccountName()>

<cfset stAccessMap = oUser.getAccessMap()>

<cfset hasAccountsPlugin = oContext.getHomePortals().getPluginManager().hasPlugin("accounts")>

<cfscript>
	aOptions = arrayNew(1);

	st = structNew();
	st.label = "Dashboard";
	st.event = "site.ehSite.dspMain";
	st.selected = listFindNoCase("ehSite", listFirst(event,"."));
	st.hint = "Site Dashboard";
	st.icon = "images/house.png";
	st.titleIcon = "";
	st.hasAccess = true;
	arrayAppend(aOptions,st);

	st = structNew();
	st.label = "Pages";
	st.event = "pages.ehPages.dspMain";
	st.selected = listFindNoCase("ehPages", listFirst(event,"."));
	st.hint = "Page management";
	st.icon = "images/page_copy.png";
	st.titleIcon = "images/documents_48x48.png";
	st.hasAccess = stAccessMap.pages;
	arrayAppend(aOptions,st);
	
	st = structNew();
	st.label = "Accounts";
	st.event = "accounts.ehAccounts.dspMain";
	st.selected = listFindNoCase("ehAccounts,ehPage", listFirst(event,"."));
	st.hint = "Site and account management";
	st.icon = "images/users_24x24.png";
	st.titleIcon = "images/users_48x48.png";
	st.hasAccess = hasAccountsPlugin and stAccessMap.accounts;
	arrayAppend(aOptions,st);

	st = structNew();
	st.label = "Resources";
	st.event = "resources.ehResources.dspMain";
	st.selected = findnocase("ehResources.", event);
	st.hint = "Manage the site's resource library";
	st.icon = "images/folder2_yellow_32x32.png";
	st.titleicon = "images/folder2_yellow_48x48.png";
	st.hasAccess = stAccessMap.resources;
	arrayAppend(aOptions,st);

	st = structNew();
	st.label = "Settings";
	st.event = "config.ehSiteConfig.dspMain";
	st.selected = findnocase("ehSiteConfig.", event);
	st.hint = "View and edit configuration files";
	st.icon = "images/configure_22x22.png";
	st.titleicon = "images/configure_48x48.png";
	st.hasAccess = stAccessMap.siteSettings;
	arrayAppend(aOptions,st);

</cfscript>

<cfoutput>
	<h2>
		<div style="float:right;font-weight:normal;font-size:11px;">
			<cfloop from="1" to="#arrayLen(aOptions)#" index="i">
				<cfset st = aOptions[i]>
				<cfif st.selected>
					<cfset attributes.icon = st.titleicon>
				</cfif>
				<cfif st.hasAccess>
					[ 
						<img src="#st.icon#" align="absmiddle" title="#st.Hint#" alt="#st.Hint#">
						<a href="index.cfm?event=#st.event#" 
							<cfif st.selected>style="font-weight:bold;"</cfif>
							title="#st.Hint#" alt="#st.Hint#"
							>#st.label#</a> 
					]
					&nbsp;&nbsp;
				</cfif>
			</cfloop>	
		</div>
		
		<cfif attributes.icon neq "">
			<img src="#attributes.icon#" align="absmiddle">
		</cfif>
		
		#attributes.title#
	</h2>
	<div class="siteName" style="margin-bottom:15px;">
		&raquo; Site: <a href="index.cfm?event=site.ehSite.dspMain">#oSiteInfo.getSiteName()#</a>
		
		<cfif hasAccountsPlugin and oContext.hasAccountSite()>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<cfif stAccessMap.accounts>
				&raquo; Account: <a href="index.cfm?event=accounts.ehAccounts.dspMain&accountID=#accountID#&showAccount=true">#accountName#</a>
			<cfelse>
				&raquo; Account: #accountName#
			</cfif>
		</cfif>
		
		<cfif oContext.hasPage()>
			<cfset oPage = oContext.getPage()>
			<cfif oPage.getTitle() neq "">
				<cfset tmpTitle = oPage.getTitle()>
			<cfelse>
				<cfset tmpTitle = "<em>No Title</em>">
			</cfif>

			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<cfif stAccessMap.pages>
				&raquo; Page: <a href="index.cfm?event=page.ehPage.dspMain">#tmpTitle#</a>
			<cfelse>
				&raquo; Page: #tmpTitle#
			</cfif>
		</cfif>
	</div>
</cfoutput>

