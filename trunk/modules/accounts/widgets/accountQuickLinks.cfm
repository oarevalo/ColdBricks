<cfset oContext = getService("sessionContext").getContext()>
<cfset hp = oContext.getHomePortals()>
<cfset stAccessMap = getValue("oUser").getAccessMap()>

<cfif not(hp.getPluginManager().hasPlugin("accounts") and stAccessMap.pages)>
	<cfexit method="exittemplate">
</cfif>

<cfscript>
	qlAccount = getValue("qlAccount");
	oAccService = getAccountsService();
	qryAccounts = oAccService.search();
	
	// if there is an account selected, get the account pages
	if(qlAccount neq "") {
		oAccountSite = oAccService.getSite(qlAccount);		
		aPages = oAccountSite.getPages();		
	
		// sort pages
		for(i=1;i lte arrayLen(aPages);i=i+1) {
			arrayAppend(aPagesSorted, aPages[i].href);
		}
		arraySort(aPagesSorted,"textnocase","asc");
	}
</cfscript>

<cfquery name="qryAccounts" dbtype="query">
	SELECT *, upper(accountName) as u_username
		FROM qryAccounts
		ORDER BY u_username
</cfquery>
	
<cfoutput>
	Use the following dropdowns to quckly access any
	page on this site.<br><br>
	<select name="account" style="width:130px;font-size:10px;border:1px solid silver;" 
			onchange="document.location='index.cfm?event=sites.ehSite.dspMain&qlAccount='+this.value">
		<option value="">-- Select Account --</option>
		<cfloop query="qryAccounts">
			<option value="#qryAccounts.accountname#" <cfif qlAccount eq qryAccounts.accountname>selected</cfif>>#qryAccounts.accountname#</option>
		</cfloop>
	</select>

	<cfif qlAccount neq "">
		<select name="page" style="width:130px;font-size:10px;border:1px solid silver;"
				onchange="document.location='index.cfm?event=sites.ehSite.doLoadAccountPage&account=#qlAccount#&page='+this.value">
				<option value="">-- Select Page --</option>
			<cfloop from="1" to="#arrayLen(aPages)#" index="i">
				<option value="#aPages[i]#">#aPages[i]#</option>
			</cfloop>
		</select>
	</cfif>
</cfoutput>
