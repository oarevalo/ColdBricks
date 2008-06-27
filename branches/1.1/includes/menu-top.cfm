
<cfparam name="request.requestState.event" default="">
<cfparam name="request.requestState.userInfo" default="">

<cfset userInfo = request.requestState.userInfo>
<cfset event = request.requestState.event>

<cfscript>
	aOptions = arrayNew(1);
	
	st = structNew();
	st.label = "Home";
	st.event = "ehGeneral.dspMain";
	st.selected = event eq "ehGeneral.dspMain";
	st.display = userInfo.administrator;
	st.hint = "Main administration dashboard";
	arrayAppend(aOptions,st);

	st = structNew();
	st.label = "My Sites";
	st.event = "ehSites.dspMain";
	st.selected = listFindNoCase("ehSites", listFirst(event,"."));
	st.display = not userInfo.administrator;
	st.hint = "Displays a list of existing sites for the current user";
	arrayAppend(aOptions,st);

	st = structNew();
	st.label = "Change Password";
	st.event = "ehGeneral.dspChangePassword";
	st.selected = event eq "ehGeneral.dspChangePassword";
	st.display = true;
	st.hint = "Change your password";
	arrayAppend(aOptions,st);
</cfscript>

<cfoutput>
	<img src="images/animLoading.gif" id="loadingImage" style="display:none;float:right;" align="Absmiddle">
	<cfloop from="1" to="#arrayLen(aOptions)#" index="i">
		<cfset st = aOptions[i]>
		<cfif st.display>
			<a href="index.cfm?event=#st.event#" 
				<cfif st.selected>class="mainMenuItemSelected"</cfif>
				title="#st.Hint#" alt="#st.Hint#"
				>#st.label#</a> 
		</cfif>
	</cfloop>
</cfoutput>
<br style="clear:both;" />