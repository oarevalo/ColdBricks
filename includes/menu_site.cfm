<cfparam name="request.requestState.event" default="">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.icon" default="">
<cfparam name="attributes.oContext" default="">

<cfset event = request.requestState.event>
<cfset oContext = request.requestState.oContext>

<cfset oSiteInfo = oContext.getSiteInfo()>
<cfset accountID = oContext.getAccountID()>
<cfset accountName = oContext.getAccountName()>

<cfscript>
	aOptions = arrayNew(1);

	st = structNew();
	st.label = "Dashboard";
	st.event = "ehSite.dspMain";
	st.selected = listFindNoCase("ehSite", listFirst(event,"."));
	st.hint = "Site Dashboard";
	st.icon = "images/house.png";
	st.titleIcon = "";
	arrayAppend(aOptions,st);
	
	st = structNew();
	st.label = "Accounts";
	st.event = "ehAccounts.dspMain";
	st.selected = listFindNoCase("ehAccounts,ehPage", listFirst(event,"."));
	st.hint = "Site and account management";
	st.icon = "images/users_24x24.png";
	st.titleIcon = "images/users_48x48.png";
	arrayAppend(aOptions,st);

	st = structNew();
	st.label = "Resources";
	st.event = "ehResources.dspMain";
	st.selected = findnocase("ehResources.", event);
	st.hint = "Manage the site's resource library";
	st.icon = "images/folder2_yellow_32x32.png";
	st.titleicon = "images/folder2_yellow_48x48.png";
	arrayAppend(aOptions,st);

	st = structNew();
	st.label = "SiteMap";
	st.event = "ehSiteMap.dspMain";
	st.selected = findnocase("ehSiteMap.", event);
	st.hint = "SiteMap tool";
	st.icon = "images/Globe_22x22.png";
	st.titleicon = "images/Globe_48x48.png";
	arrayAppend(aOptions,st);

	st = structNew();
	st.label = "Settings";
	st.event = "ehSiteConfig.dspMain";
	st.selected = findnocase("ehSiteConfig.", event);
	st.hint = "View and edit configuration files";
	st.icon = "images/configure_22x22.png";
	st.titleicon = "images/configure_48x48.png";
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
				[ 
					<img src="#st.icon#" align="absmiddle" title="#st.Hint#" alt="#st.Hint#">
					<a href="index.cfm?event=#st.event#" 
						<cfif st.selected>style="font-weight:bold;"</cfif>
						title="#st.Hint#" alt="#st.Hint#"
						>#st.label#</a> 
				]
				&nbsp;&nbsp;
			</cfloop>	
		</div>
		
		<cfif attributes.icon neq "">
			<img src="#attributes.icon#" align="absmiddle">
		</cfif>
		
		#attributes.title#
	</h2>
	<div class="siteName" style="margin-bottom:15px;">
		&raquo; Site: <a href="index.cfm?event=ehSite.dspMain">#oSiteInfo.getSiteName()#</a>
		
		<cfif accountID neq "">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&raquo; Account: <a href="index.cfm?event=ehAccounts.dspMain&accountID=#accountID#&showAccount=true">#accountName#</a>
		</cfif>
		
		<cfif oContext.hasPage()>
			<cfset oPage = oContext.getPage().getPage()>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&raquo; Page: <a href="index.cfm?event=ehPage.dspMain">#oPage.getTitle()#</a>
		</cfif>
	</div>
</cfoutput>

