<cfsetting enablecfoutputonly=true>

<cfparam name="cookie.message_type" default="">
<cfparam name="cookie.message_text" default="">

<cfset msgStruct.type = cookie.message_type>
<cfset msgStruct.text = cookie.message_text>

<!--- expire cookies instead of just deleting them because of bluedragon compatibility,
seems that deleting from the cookie struct in BD does not actually erase the cookie
5/12/08 - oarevalo. 
--->
<cfcookie name="message_type" expires="now" value="">
<cfcookie name="message_text" expires="now" value="">
	
		
<cfif msgStruct.text neq "">
	<!--- Get image to display --->
	<cfif CompareNocase(msgStruct.type, "error") eq 0>
		<cfset img = "images/emsg.gif">
	<cfelseif CompareNocase(msgStruct.type, "warning") eq 0>
		<cfset img = "images/wmsg.gif">
	<cfelse>
		<cfset img = "images/cmsg.gif">
	</cfif>
	
	<cfoutput>
		<!--- Message Box --->
		<div id="app_messagebox">
			<img src="#img#" align="absmiddle" alt="[#msgStruct.type#]">
			#msgStruct.text#
		</div>
		<script>
			setTimeout("hideMessageBox()",5000);
		</script>
	</cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false">

