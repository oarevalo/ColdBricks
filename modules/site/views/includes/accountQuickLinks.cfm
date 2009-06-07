<cfoutput>
	<div id="dsb_quickLink" style="width:300px;margin-bottom:30px;">
		<div class="dsb_secTitle">Quick Links:</div>
		<div class="dsb_siteSection">
			Use the following dropdowns to quckly access any
			page on this site.<br><br>
			<select name="account" style="width:130px;font-size:10px;border:1px solid silver;" 
					onchange="document.location='index.cfm?event=site.ehSite.dspMain&qlAccount='+this.value">
				<option value="">-- Select Account --</option>
				<cfloop query="qryAccounts">
					<option value="#qryAccounts.accountname#" <cfif qlAccount eq qryAccounts.accountname>selected</cfif>>#qryAccounts.accountname#</option>
				</cfloop>
			</select>

			<cfif qlAccount neq "">
				<select name="page" style="width:130px;font-size:10px;border:1px solid silver;"
						onchange="document.location='index.cfm?event=site.ehSite.doLoadAccountPage&account=#qlAccount#&page='+this.value">
						<option value="">-- Select Page --</option>
					<cfloop from="1" to="#arrayLen(aPages)#" index="i">
						<option value="#aPages[i]#">#aPages[i]#</option>
					</cfloop>
				</select>
			</cfif>
		</div>
	</div>	
</cfoutput>
