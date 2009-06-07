<cfoutput>
	<div id="dsb_siteAccounts" style="margin-top:25px;">
		<div class="dsb_secTitle">Accounts Summary:</div>
		<div class="dsb_siteSection">
			<strong>No of Accounts:</strong> #qryAccounts.recordCount#<br><br>
			<strong>Default Account:</strong> #defaultAccount#<br><br>
			<img src="images/add.png" align="absmiddle"> <a href="index.cfm?event=accounts.ehAccounts.dspCreate"> Create Account</a>
		</div>
	</div>
</cfoutput>